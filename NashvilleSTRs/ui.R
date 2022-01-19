#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

fluidPage(
  titlePanel("Short Term Rentals and Code Violations"),
  leafletOutput("map", height = '600px'),
  absolutePanel(top = 10, right = 10,
                selectInput("strscodes","Short Term Rentals & Codes Violations",
                            choices = colnames(STRs_Viol_per_district)
                )
  ),
 
    fluidRow(
      column(width = 6,
             fluidRow(
               plotOutput("scatter", height = "350px")
             ),
             fluidRow(
               column(
                 width = 12, offest = 12,
               
               htmlOutput("correlation")
               )
             )
      )
    )
    
)


