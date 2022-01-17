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
  observeEvent(input$debug, {
    browser()
  })
  map_filtered <- reactive({
    STRs_Viol_per_district %>% 
      filter(between(STRs_per_dist, Violations_per_dist))
  })
  output$map<-renderLeaflet({
    leaflet(data = STRs, options = leafletOptions(minZoom = 0, maxZoom = 20)) %>% 
      addTiles() %>% addProviderTiles(providers$Stamen.TonerLite,
                                      options = providerTileOptions(noWrap = TRUE)) %>% 
      addPolygons(data = council_districts,
                  fillColor = ~STRbinpal(grouped_STRs$STRs_per_dist),
                  opacity = 0.2,
                  dashArray = "3",
                  fillOpacity = 0.9,
                  highlightOptions = highlightOptions(
                    weight = 5,
                    color = '#666',
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  label = STRlabels,
                  labelOptions = labelOptions(
                    style = list('font-weight' = 'normal', padding = '3px 8px'),
                    textsize = '15px',
                    direction = 'auto'
                  )
      )
  })
})


