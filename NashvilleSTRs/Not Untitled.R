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
response<- GET(url, query=query)
Violations <- content(response, as = 'text') %>% 
  fromJSON()

#write_json(Violations, '../data/Violations.json')
url = 'https://data.nashville.gov/resource/2z82-v8pm.json'
query = list(
  '$select'= 'permit, permit_status, parcel, address, council_dist, mapped_location',
  '$limit' = 13000
)
response <- GET(url, query = query)
STRs <- content(response, as = 'text') %>% 
  fromJSON()
#write_json(STRs, '../data/STRs.json')

url = 'https://data.nashville.gov/resource/iw7r-m8qr.geojson'

council_districts<-geojson_read(url, what ='sp')

STRs<-STRs %>% unnest(mapped_location) %>% 
  mutate_at(.vars = c('latitude', 'longitude'), ~as.numeric(.))
Violations<-Violations %>% unnest(mapped_location) %>% 
  mutate_at(.vars = c('latitude', 'longitude'), ~as.numeric(.))
```



```{r}
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
  rename(STRs_per_dist = n) %>% 
  arrange(desc(STRs_per_dist))

grouped_viol<-Violations %>% 
  group_by(council_district) %>% 
  tally() %>% 
  rename(Violations_per_dist = n) %>% 
  arrange(desc(Violations_per_dist))

leaflet(data = STRs, options = leafletOptions(minZoom = 0, maxZoom = 20)) %>% 
  addTiles() %>% addProviderTiles(providers$Stamen.TonerLite,
                                  options = providerTileOptions(noWrap = TRUE)) %>% 
  addMarkers(~longitude, ~latitude, clusterOptions = markerClusterOptions()) %>% 
  addPolygons(data = council_districts)

STRbins <- c(0,10,20,50,100,200,500,1000,2000,3000)
STRbinpal <- colorBin(heat.colors(9), domain = grouped_STRs$STRs_per_dist, bins = STRbins)


STRmap<- leaflet(data = STRs, options = leafletOptions(minZoom = 0, maxZoom = 20)) %>% 
  addTiles() %>% addProviderTiles(providers$Stamen.TonerLite,
                                  options = providerTileOptions(noWrap = TRUE)) %>% 
  addPolygons(data = council_districts,
              fillColor = ~STRbinpal(grouped_STRs$STRs_per_dist),
              opacity = 0.2,
              dashArray = "3",
              fillOpacity = 0.9
              
  )

STRmap

Violbins <- c(0,100,200,400,700,1100,1600,2200,2900,3700,4600, 5600,6700)
Violbinpal <- colorBin(heat.colors(12), domain = grouped_viol$Violations_per_dist, bins = Violbins)

#labels <- sprintf()


Violmap<- leaflet(data = Violations, options = leafletOptions(minZoom = 0, maxZoom = 20)) %>% 
  addTiles() %>% addProviderTiles(providers$Stamen.TonerLite,
                                  options = providerTileOptions(noWrap = TRUE)) %>% 
  addPolygons(data = council_districts,
              fillColor = ~Violbinpal(grouped_viol$Violations_per_dist),
              opacity = 0.2,
              dashArray = "3",
              fillOpacity = 0.9
              
  )

Violmap
