# Traffic Citations Analysis

This repository contains R scripts, R Markdown notebooks, and helper functions to analyze, geocode, and map traffic citation data in New York City (specifically Manhattan) using US Census API data.

## Project Structure

The project has been organized into standard data science directories for clarity:

- **`analysis/`**: Contains all R Markdown (`.Rmd`) notebooks for data exploration, mapping, regression analysis, and the final writeup.
- **`R/`**: Contains reusable R functions (like geocoding helpers) that can be sourced into notebooks.
- **`data/`**: (Ignored by git due to size) Contains the raw and processed data.
  - `data/raw/`: Place your raw CSVs and shapefiles here (e.g., `Parking_Fiscal_Year_2021.csv`, Census shapefiles).
  - `data/processed/`: Place geocoded outputs and intermediate `.rds` files here.

## Setup and Installation

### 1. Requirements

You will need R installed along with the following packages. You can install them by running:

```R
install.packages(c("tidyverse", "sf", "censusapi", "httr2", "easycensus", "moderndive", "leaflet", "xml2"))
```

### 2. Getting the Data

Since the raw datasets are very large (e.g., the 32MB parking citations CSV and shapefiles), they are not included in this GitHub repository. 
You will need to place your data files into `data/raw/`. 

Required files:
- `Parking_Fiscal_Year_2021.csv`
- 2010 and 2020 Census Shapefiles for New York (`nycb2020wi.shp`, `ny_2010_t_bound.shp`, `nyct2020wi.shp`, etc.)

### 3. API Keys

You will need a US Census API key to run some of the `censusapi` and `easycensus` queries. Get one at:
https://api.census.gov/data/key_signup.html

Once you have it, set it in your R environment:
```R
Sys.setenv(CENSUS_KEY="your_api_key_here")
```

## Usage

### Using the Geocoding Helpers

If you want to geocode a new batch of data using the Census Batch Geocoder API, you can use the helper script provided in `R/geocoding_helpers.R`.

```R
# Source the helper functions
source("R/geocoding_helpers.R")

# Example: Geocode a single address
result <- census_geocoder(address = "125 NY-340, Sparkill, NY 10976")

# Example: Batch geocode a dataframe
# Note: df must have a column named 'street_address'
batch_geocode_addresses(df, chunk_size = 10000, output_dir = "data/processed")
```

### Running the Analysis Notebooks

Navigate to the `analysis/` folder and open the `.Rmd` files in RStudio. You can knit them to HTML or PDF. They include scripts for:
- Mapping traffic citations by census tract
- Joining income and demographic data (like English proficiency) to geographic boundaries
- Running regression analysis to identify relationships between citations and demographics
- Producing interactive leaflet maps

## Authors
- Originally written for the Traffic Citation project.
- Data sourced from the NYC Open Data and US Census Bureau.
