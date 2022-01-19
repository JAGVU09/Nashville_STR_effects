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
  '$select'= 'request,date_received,property_apn,property_address,reported_problem,council_district,mapped_location',
  '$limit' = 90000
)

response<- GET(url, query=query)

Violations <- content(response, as = 'text') %>% 
  fromJSON()%>%
  unnest('mapped_location') %>% 
  mutate_at(.vars = c('latitude', 'longitude'), ~as.numeric(.))

#write_json(Violations, '../data/Violations.json')

url = 'https://data.nashville.gov/resource/2z82-v8pm.json'

query = list(
  '$select'= 'permit, permit_status, parcel, address, council_dist, mapped_location',
  '$limit' = 13000
)

response <- GET(url, query = query)

STRs <- content(response, as = 'text') %>% 
  fromJSON() %>% 
  unnest('mapped_location') %>% 
  mutate_at(.vars = c('latitude', 'longitude'), ~as.numeric(.))

#write_json(STRs, '../data/STRs.json')

url = 'https://data.nashville.gov/resource/iw7r-m8qr.geojson'

council_districts<-geojson_read(url, what ='sp')


grouped_STRs<-STRs %>%
  group_by(council_dist) %>% 
  tally() %>% 
  rename(STRs_per_dist = n, council_district = council_dist) %>% 
  arrange(desc(STRs_per_dist)) %>% 
  drop_na()

grouped_viol<-Violations %>% 
  group_by(council_district) %>% 
  tally() %>% 
  rename(Violations_per_dist = n) %>% 
  arrange(desc(Violations_per_dist)) %>% 
  drop_na()

STRs_Viol_per_district<-merge(grouped_STRs, grouped_viol, by = 'council_district') %>% 
  mutate(council_district = as.numeric(council_district))

STRbins <- c(0,10,20,100,200,400,700,1100,1600,2200,2900,3700,4600, 5600, 6700)
STRbinpal <- colorBin(heat.colors(15), domain = STRs_Viol_per_district$STRs_per_dist, bins = STRbins, reverse = TRUE)

STRlabels <- sprintf(
  "<strong>%s</strong><br/>%g STRs / mi<sup>2</sup>",
  STRs_Viol_per_district$council_dist, STRs_Viol_per_district$STRs_per_dist
) %>% lapply(htmltools::HTML)

Violbins <- c(0,100,200,400,700,1100,1600,2200,2900,3700,4600, 5600, 6700)
Violbinpal <- colorBin(heat.colors(12), domain = STRs_Viol_per_district$Violations_per_dist, bins = Violbins)

Viollabels <- sprintf(
  "<strong>%s</strong><br/>%g Violations / mi<sup>2</sup>",
  grouped_viol$council_dist, grouped_viol$Violations_per_dist
) %>% lapply(htmltools::HTML)
