library(httr)
library(tidyverse)
library(jsonlite)
library(sf)
library(leaflet)
library(geojsonio)
library(RColorBrewer)
library(shiny)
library(bslib)

url = 'https://data.nashville.gov/resource/479w-kw2x.json'

query = list(
  '$select'= 'request,date_received,property_apn,property_address,reported_problem,council_district,mapped_location, zip',
  '$limit' = 90000
)

response<- GET(url, query=query)

Violations <- content(response, as = 'text') %>% 
  fromJSON()%>%
  unnest('mapped_location') %>% 
  mutate_at(.vars = c('latitude', 'longitude'), ~as.numeric(.)) %>% 
  mutate(council_district = as.numeric(council_district))

#write_json(Violations, '../data/Violations.json')

url = 'https://data.nashville.gov/resource/2z82-v8pm.json'

query = list(
  '$select'= 'permit, permit_status, parcel, address, council_dist, mapped_location,zip',
  '$limit' = 13000
)

response <- GET(url, query = query)

STRs <- content(response, as = 'text') %>% 
  fromJSON() %>% 
  unnest('mapped_location') %>% 
  mutate_at(.vars = c('latitude', 'longitude'), ~as.numeric(.)) %>% 
  mutate(council_dist = as.numeric(council_dist)) %>% 
  rename(council_district = council_dist) 

#write_json(STRs, '../data/STRs.json')

url = 'https://data.nashville.gov/resource/iw7r-m8qr.geojson'

council_districts_geo<-geojson_read(url, what ='sp')

url = 'https://data.nashville.gov/resource/wv8u-vs37.geojson'

zipcodes_geo<-geojson_read(url, what='sp')


by_council_STRs<-STRs %>%
  group_by(council_district) %>% 
  tally() %>% 
  rename(STRs_per_dist = n) %>% 
  arrange(desc(STRs_per_dist)) %>% 
  drop_na()

by_council_viol<-Violations %>% 
  group_by(council_district) %>% 
  tally() %>% 
  rename(Violations_per_dist = n) %>% 
  arrange(desc(Violations_per_dist)) %>% 
  drop_na()

by_zipcode_STRs<-STRs %>%
  group_by(zip) %>% 
  tally() %>% 
  rename(STRs_per_zip = n) %>% 
  arrange(desc(STRs_per_zip)) %>% 
  drop_na()

by_zipcode_viol<-Violations %>% 
  group_by(zip) %>% 
  tally() %>% 
  rename(Violations_per_zip = n) %>% 
  arrange(desc(Violations_per_zip)) %>% 
  drop_na()

STRs_Viol_per_district<-merge(by_council_STRs, by_council_viol, by = 'council_district')

STRs_Viol_per_zip<-merge(by_zipcode_STRs, by_zipcode_viol, by = 'zip')


