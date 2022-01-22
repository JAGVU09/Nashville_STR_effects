library(httr)
library(tidyverse)
library(jsonlite)
library(sf)
library(leaflet)
library(geojsonio)
library(RColorBrewer)
library(shiny)
library(bslib)
library(shinythemes)
library(dplyr) # for data wrangling
library(tidytext) # for NLP
library(stringr) # to deal with strings
library(wordcloud) # to render wordclouds
library(knitr) # for tables
library(DT) # for dynamic tables
library(tidyr)
library(wordcloud2)

#API call for Code Violations
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
  mutate(council_district = as.integer(council_district))%>% 
  mutate(zip = as.numeric(zip))

#write_json(Violations, '../data/Violations.json')


#API call for Short Term Rentals
url = 'https://data.nashville.gov/resource/2z82-v8pm.json'

query = list(
  '$select'= 'permit, permit_status, parcel, address, council_dist, mapped_location,zip',
  '$limit' = 13000
)

response <- GET(url, query = query)

#clean up the columns
STRs <- content(response, as = 'text') %>% 
  fromJSON() %>% 
  unnest('mapped_location') %>% 
  mutate_at(.vars = c('latitude', 'longitude'), ~as.numeric(.)) %>% 
  mutate(council_dist = as.integer(council_dist)) %>% 
  rename(council_district = council_dist) %>% 
  mutate(zip = as.numeric(zip)) %>% 
  filter(permit_status == 'ISSUED')

#write_json(STRs, '../data/STRs.json')

#API call for geospatial data for council districts
url = 'https://data.nashville.gov/resource/iw7r-m8qr.geojson'

council_districts_geo<-geojson_read(url, what ='sp')

#Further cleaning
by_council_STRs<-STRs %>%
  group_by(council_district) %>% 
  tally() %>% 
  rename(STRs = n) %>% 
  arrange(desc(STRs)) %>% 
  drop_na()

by_council_viol<-Violations %>% 
  group_by(council_district) %>% 
  tally() %>% 
  rename(Violations = n) %>% 
  arrange(desc(Violations)) %>% 
  drop_na()

#Merge STRs and Code Violations data sets for maps. Work on a spatial merge for the council districts 
STRs_Viol_per_district<-merge(by_council_STRs, by_council_viol, by = 'council_district')

Districts_pivot<-pivot_longer(STRs_Viol_per_district, cols = 2:3, names_to ="STRs_Violations", values_to = "total")

#create a nuisance STRs dataframe for word cloud
nuisance_STRs<-left_join(STRs, Violations, by = c('address'="property_address")) %>% 
  drop_na(reported_problem) %>% 
  select(permit, parcel, address, date_received, reported_problem, property_apn, council_district.y) %>% 
  rename('council_district' = 'council_district.y') %>% 
  group_by(council_district) %>% 
  count(reported_problem) %>% 
  arrange(desc(n))

tidy_dat <- tidyr::gather(nuisance_STRs, key, word) %>% select(word)

tokens <- tidy_dat %>% 
  unnest_tokens(word, word) %>% 
  dplyr::count(word, sort = TRUE) %>% 
  ungroup() 

data("stop_words")
tokens_clean <- tokens %>%
  anti_join(stop_words)

nums <- tokens_clean %>% filter(str_detect(word, "^[0-9]")) %>% select(word) %>% unique()

tokens_clean <- tokens_clean %>% 
  anti_join(nums, by = "word")

uni_sw <- data.frame(word = c("ave", "dr", "hotline", "st", "https", "cir", "ln",
                              "hwy", "ct", "blvd", "rd", "pl" ,"description","comments",
                              "type","type","property","violations","short","term","rental","complaint", "description"))

tokens_clean <- tokens_clean %>% 
  anti_join(uni_sw, by = "word") %>% 
  top_n(50)

wordpal <- brewer.pal(8,"Dark2")



