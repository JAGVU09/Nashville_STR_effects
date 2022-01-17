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
  leafletOutput("map"),
  absolutePanel(top = 10, right = 10,
                selectInput("Short Term Rentals", "Codes Violations",
                            choices = c("Short Term Rentals", "Codes Violations"))
))

