#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

shinyServer(function(input, output) {
  filteredData<-reactive({
    STRs_Viol_per_district %>% 
      filter(between(., STRs_per_dist, Violations_per_dist))
  })
  
  output$map<-renderLeaflet({
    leaflet(data = STRs_Viol_per_district, options = leafletOptions(minZoom = 0, maxZoom = 20)) %>% 
      addTiles() %>% addProviderTiles(providers$Stamen.TonerLite,
                                      options = providerTileOptions(noWrap = TRUE)) %>% 
      addPolygons(data = council_districts,
                  fillColor = heat.colors(12),
                  opacity = 0.2,
                  dashArray = "3",
                  fillOpacity = 0.9,
                  highlightOptions = highlightOptions(
                    weight = 5,
                    color = '#666',
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  )
                  
                  
  })
})
  
  
  