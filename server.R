#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    
    output$sin_plot <- renderPlot({
        plot_basique(input)
    })
    output$fourier <- renderPlot({
        plot_fourier(input)
    })
    output$inv_fourier <- renderPlot({
        plot_inv_fourier(input)
    })    
    output$harmonique <- renderPlot({
        plot_harmonique(input)
    })
    output$sin_mult_plot <- renderPlot({
        plot_sinus(input)
    })
    output$four_2 <- renderPlot({
        plot_fourier_2(input)
    })

})
