#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

type_choices <- read.csv("type_choices.csv")
Regionname_choices <- read.csv("Regionname_choices.csv")

shinyUI(fluidPage(

    titlePanel("Melbourne House Price Predictor"),

    sidebarLayout(
        sidebarPanel(
            selectInput("type", "Select House Type:", type_choices$x),
            selectInput("regionname", "Select House Region Name:", Regionname_choices$x),
            sliderInput("distance", "Select House Distance from CBD (in km):",
                        min = 0, max = 48, value = 4),

        ),
        mainPanel(
            textOutput("prediction"),
            htmlOutput("linebreak"),
            plotlyOutput("house_plot"),
            includeMarkdown("documentation.md")
        )
    )
))
