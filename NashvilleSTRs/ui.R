#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


shinyUI(fluidPage(
  theme = bs_theme(bootswatch = 'superhero'),
  titlePanel("Short Term Rental and Code Violations"),
  sidebarLayout(
    sidebarPanel(
      selectInput("strscodes","Short Term Rentals & Codes Violations",
                  choices = c('STRs', 'Violations'),
                  width='150px'
      )
    ),
    mainPanel(
      tabsetPanel(type = 'tabs',
                  tabPanel("Map", leafletOutput("map", width = '900px', height = '600px')),
                  tabPanel('Column', plotOutput("column", height = "600px")),
                  tabPanel("Scatter", plotOutput("scatter", height = "600px"),
                           fluidRow(
                             style = "display:flex;
                             justify-content: right;
                             align-items: right;
                             height: 50px;",
                             htmlOutput("correlation")
                           ),
                  ),
                  tabPanel("Word Cloud", wordcloud2Output("wordcloud", width = '600px', height = "600px")))
      
    )
  )
)
)