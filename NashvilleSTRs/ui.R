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
  
  # Application title
  titlePanel("Short Term Rentals and Code Violations"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      
      selectInput("strscodes","Short Term Rentals & Codes Violations",
                  choices = c('STRs_per_dist', 'Violations_per_dist'),
                  width='150px'
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      fluidRow(
        column(width = 7,          
               plotOutput("column", height = "350px")
        ),
        column(width = 5,
               fluidRow(
                 plotOutput("scatter", height = "300px")
               ),
               fluidRow(
                 style = "disp lay:flex; justify-content: right; align-items: right; height: 50px;",
                 htmlOutput("correlation")
               ),
               fluidRow(
                 style = "disp lay:flex; justify-content: left; align-items: left; height: 50px;",
                 htmlOutput("nuisance")
               )
        )
      ),
      fluidRow(
        leafletOutput("map", height = '400px', width = '1000px')
      )
      
    )
  )
))


