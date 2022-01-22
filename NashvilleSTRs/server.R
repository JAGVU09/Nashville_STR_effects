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
  
 
  
  labels<-reactive({
    sprintf(
      "<strong>Council District: %s</strong><br/> Number of STRs: %s <br/>  Number of Violations: %s",
      STRs_Viol_per_district$council_dist, STRs_Viol_per_district$STRs, STRs_Viol_per_district$Violations
    ) %>% lapply(htmltools::HTML) 
  }) 
  
  output$map<-renderLeaflet({
    colors<- colorBin(heat.colors(14), domain = STRs_Viol_per_district[[input$strscodes]], reverse = TRUE)
    STRmap<-STRs_Viol_per_district %>% 
      select(input$strscodes) %>% 
      leaflet(options = leafletOptions(minZoom = 0, maxZoom = 20)) %>% 
      addTiles() %>% addProviderTiles(providers$Stamen.TonerLite,
                                      options = providerTileOptions(noWrap = TRUE)) %>%
      addPolygons(data = council_districts_geo,
                  fillColor = ~colors(STRs_Viol_per_district[[input$strscodes]]),
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
                    
    
  )})
  output$scatter <- renderPlot({
    STRs_Viol_per_district %>% 
      ggplot(aes(x= Violations, y = STRs))+
      geom_point()+
      geom_smooth(method = 'lm')+
      labs(title = 'Violations vs Short Term Rentals', x = "Violations", y = "Short Term Rentals" )
  })
  output$correlation <- renderText({
    correlation <- cor(STRs_Viol_per_district$STRs, STRs_Viol_per_district$Violations)%>% round(2)
    paste0('<b>Correlation of STRs and Code Violations:</b> ', correlation)
  })
  output$column <- renderPlot({
    Districts_pivot %>% 
      mutate(council_district = reorder(council_district, -total)) %>% 
      ggplot(aes(y = total, x = council_district, fill = STRs_Violations))+
      geom_col(position = 'dodge')+
      scale_x_discrete(breaks = Districts_pivot$council_district)+
      theme(legend.position = c(0.9,0.9),
            legend.title = element_blank(),
            axis.text.x = element_text(angle = 45))+
      labs(x = 'Council District',
           y = 'Total',
           title = "Number of STRs and Code Violations by District",
      )
  })
    output$wordcloud <- renderWordcloud2({
      wordcloud2(tokens_clean)
    
  })
})
