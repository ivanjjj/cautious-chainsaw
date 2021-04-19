#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(plotly)
house_price_table <- read.csv("house_price_table.csv", row.names = 1)
fit <- readRDS("fit.rds")

shinyServer(function(input, output) {
    output$house_plot <- renderPlotly({
        output_table <- filter(house_price_table, Regionname == as.factor(input$regionname))

        x <- list(
            title = "House Price",
            categoryarray = ~Price,
            categoryorder = "array"
        )
        y <- list(
            title = "Frequency"
        )

        fig <- plot_ly(output_table, x=~Price, y=~Freq, type = "bar")
        fig <- fig %>% layout(xaxis = x, yaxis = y, title="Distribution of House Price by Selected Region")
        fig
        })

    output$prediction <- renderText({

        Regionname <- as.factor(c(input$regionname))
        Type <- as.factor(c(input$type))
        Distance <- c(input$distance)
        new_value <- data.frame(Regionname, Type, Distance)
        prediction <- predict(fit, newdata = new_value)

        paste("The estimated value of this house is", prediction)

    })
    output$linebreak <- renderUI({
        HTML("<br/>")
    })

})
