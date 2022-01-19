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
  
  filteredData<- reactive({
    STRs_Viol_per_district 
  })  
  colorpal<-reactive({
    colorBin(heat.colors(14), domain = input$strscodes, reverse = TRUE)
  })
  labels<-reactive({
    sprintf(
      "<strong>%s</strong><br/>%s STRs / mi<sup>2</sup>",
      STRs_Viol_per_district$council_dist, input$strscodes
    ) %>% lapply(htmltools::HTML) 
  }) 
  
  output$map<-renderLeaflet({
    STRmap<- leaflet(data = filteredData(), options = leafletOptions(minZoom = 0, maxZoom = 20)) %>% 
      addTiles() %>% addProviderTiles(providers$Stamen.TonerLite,
                                      options = providerTileOptions(noWrap = TRUE)) %>% 
      addPolygons(data = council_districts,
                  fillColor = colorpal(),
                  opacity = 0.2,
                  dashArray = "3",
                  fillOpacity = 0.9,
                  highlightOptions = highlightOptions(
                    weight = 5,
                    color = '#666',
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  label = labels(),
                  labelOptions = labelOptions(
                    style = list('font-weight' = 'normal', padding = '3px 8px'),
                    textsize = '15px',
                    direction = 'auto'
                  )
      )
    
    
  })
  output$scatter <- renderPlot({
    STRs_Viol_per_district %>% 
      ggplot(aes(x= Violations_per_dist, y = STRs_per_dist))+
      geom_point()+
      geom_smooth(method = 'lm')+
      labs(title = 'Violations vs Short Term Rentals', x = "Violations", y = "Short Term Rentals" )
  })
  output$correlation <- renderText({
    correlation <- cor(STRs_Viol_per_district$STRs_per_dist, STRs_Viol_per_district$Violations_per_dist)%>% round(2)
    paste0('<b>Correlation between Short Term Rentals and Code Violations:</b> ', correlation)
  })
})

