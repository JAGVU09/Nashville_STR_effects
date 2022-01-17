library(httr)
library(tidyverse)
library(jsonlite)
library(sf)
library(leaflet)
library(geojsonio)
library(RColorBrewer)


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

STRs_Viol_per_district<-merge(grouped_STRs, grouped_viol, by = 'council_district')

STRbins <- c(0,10,20,50,100,200,500,1000,2000,3000)
STRbinpal <- colorBin(heat.colors(9), domain = grouped_STRs$STRs_per_dist, bins = STRbins, reverse = TRUE)

STRlabels <- sprintf(
  "<strong>%s</strong><br/>%g STRs / mi<sup>2</sup>",
  grouped_STRs$council_dist, grouped_STRs$STRs_per_dist
) %>% lapply(htmltools::HTML)

