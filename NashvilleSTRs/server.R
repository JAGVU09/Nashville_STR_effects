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
  output$map<-renderLeaflet({
    leaflet(data = STRs_Viol_per_district, options = leafletOptions(minZoom = 0, maxZoom = 20)) %>% 
      addTiles() %>% addProviderTiles(providers$Stamen.TonerLite,
                                      options = providerTileOptions(noWrap = TRUE)) %>% 
      addPolygons(data = council_districts
                  
                  )

  })
})


