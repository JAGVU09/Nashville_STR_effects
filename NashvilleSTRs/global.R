library(httr)
library(tidyverse)
library(jsonlite)
library(sf)
library(leaflet)
library(geojsonio)


url = 'https://data.nashville.gov/resource/479w-kw2x.json'

query = list(
  '$select'= 'request,date_received,property_apn,property_address,reported_problem,council_district,mapped_location',
  '$limit' = 90000
)

response <- GET(url, query=query )

Violations <- content(response, as = 'text') %>% 
  fromJSON()

Violations<-Violations %>% unnest(mapped_location) %>% 
  mutate_at(.vars = c('latitude', 'longitude'), ~as.numeric(.))

url = 'https://data.nashville.gov/resource/2z82-v8pm.json'

query = list(
  '$select'= 'permit, permit_status, parcel, address, council_dist, mapped_location',
  '$limit' = 13000
)

response <- GET(url, query = query)

STRs <- content(response, as = 'text') %>% 
  fromJSON()

STRs<-STRs %>% unnest(mapped_location) %>% 
  mutate_at(.vars = c('latitude', 'longitude'), ~as.numeric(.))