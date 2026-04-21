2010 Decennial Census boundary data for New York at the Census Tract level (shapefile)

##Redistricting Data Hub (RDH) Retrieval Date
12/17/20

##Sources
Census data retrieved using the Census API: https://api.census.gov/data/2010/dec/sf1
Boundary shapefile retrieved from the Census Cartographic Boundary File website: https://www2.census.gov/geo/tiger/GENZ2010

##Fields
  Field Name                               Description
0      GEOID                         Unique identifier
1       NAME  Full Geographic Name of the Census Tract
2      STATE                         Name of the State
3     COUNTY                        Name of the County
4   TOTPOP10                Total Population (P001001)
5    STATEFP                           State FIPS Code
6   COUNTYFP                          County FIPS Code
7    TRACTCE                                Tract Code

##Processing
Census population data for New York was retrieved with a python script from the Census API. 
The population data is available at the county level. Data was extracted for all counties in New York. 
The fields were renamed to fit character length requirements. 
The shapefile was zipped into a folder with supporting geospatial files and this README. 
Processing was primarily completed using the pandas library.
The population data for New York was joined with geospatial data from Census TIGER files on the unique identifier field (GEOID) and extracted as a shapefile. 
Processing for the join used pandas and geopandas libraries.

##Additional Notes
For more information on the 2010 Census API see: https://api.census.gov/data/2010/dec/sf1/variables.html.
For more information on the geospatial data, please refer to the Census Cartographic Boundary link above. 
The Census shapefile for New York is available in NAD83 projection.