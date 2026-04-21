library(httr)
library(httr2)

#' Census Geocoder
#' 
#' Geocodes a single address using the US Census API.
#'
#' @param address A string containing the full address to geocode.
#' @param benchmark The benchmark to use, defaults to "_Census2020".
#' @param returntype The return type, defaults to "locations".
#' @return A parsed response from the Census API.
#' @export
census_geocoder <- function(address, benchmark = "_Census2020", returntype = "locations") {
  base_url <- "https://geocoding.geo.census.gov/geocoder/locations/onelineaddress"

  query_list <- list(address = address, benchmark = benchmark, returntype = returntype)
 
  response <- GET(url = base_url, query = query_list)

  if (response$status_code == 200) {
    return(content(response, "parsed"))
  } else {
    stop("Failed with Status Code ", response$status_code)
  }
}

#' Batch Census Geocoder
#'
#' Takes a dataframe with addresses, splits it into chunks, and sends them to the Census batch geocoding API.
#' Results are written out as CSV files.
#'
#' @param df Dataframe containing the address data. Must have a 'street_address' column.
#' @param chunk_size Number of rows to process in each batch. Defaults to 10000.
#' @param state_name State name to use for the missing city/state, defaults to 'New York'.
#' @param output_dir Directory to write the chunks to, defaults to current directory.
#' @export
batch_geocode_addresses <- function(df, chunk_size = 10000, state_name = 'New York', output_dir = ".") {
  url <- "https://geocoding.geo.census.gov/geocoder/locations/addressbatch"
  last_row_processed <- 0
  
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  while (last_row_processed < nrow(df)) {
    start_row <- last_row_processed + 1
    end_row <- min(last_row_processed + chunk_size, nrow(df))
    chunk <- df[start_row:end_row, ]

    new_df <- data.frame(
      Column1 = chunk[, 1],
      StreetAddress = chunk$street_address,
      NullColumn1 = state_name,
      State = state_name,
      NullColumn2 = "",
      stringsAsFactors = FALSE
    )

    chunk_index <- (last_row_processed / chunk_size) + 1
    chunk_file_name <- file.path(output_dir, paste0("Modified_Parking_Data_Chunk_", chunk_index, ".csv"))
    response_file_name <- file.path(output_dir, paste0("Geocode_Result_Chunk_", chunk_index, ".csv"))

    write.table(new_df, chunk_file_name, row.names = FALSE, col.names = FALSE, sep = ",")

    request <- request(url) %>% 
      req_body_multipart(
        addressFile = curl::form_file(chunk_file_name),
        benchmark = "Public_AR_Current"
      )

    resp <- req_perform(request)

    if (resp$status_code == 200) {
      message("File ", chunk_file_name, " sent successfully.")
      response_content <- resp_body_raw(resp)
      writeBin(response_content, response_file_name)
      message("Response saved as ", response_file_name, ".")
    } else {
      message("Failed to send file ", chunk_file_name, ". Status code: ", resp$status_code)
    }

    file.remove(chunk_file_name)
    last_row_processed <- end_row
  }
}
