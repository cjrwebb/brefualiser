
# Load required libraries

library(shiny)
library(bs4Dash)
library(tidyverse)
library(plotly)
library(shinyjs)

# The server.R file contains all of the operations the server will need
# to perform in response to the user's input. In this very simple example,
# the server will need to do two things:

# 1. Initialise the selection box for users and update the selected local
#    authority variable vector when the user selects them
# 2. Generate, and regenerate based on user inputs, the caterpillar plot 
#    I wrote a function to generate in the global.R file


shinyServer(function(input, output, session){
  
  useAutoColor()
  
  # It's much faster to update the selectize input from the 
  # server using a vector set up in the global.R file. I don't 
  # know why, it just is.
  updateSelectizeInput(session, 
                       "la_selectize",
                       choices = la_select,
                       options = list(maxOptions = 1000),
                       server = TRUE)
  
  # In order for the UI to find and display the output, the 
  # result from the renderPlotly function needs to be stored
  # in the output object that Shiny apps use (to communicate
  # between the UI and server). Handily, this output object
  # is already pre-populated with the names of the UI elements
  # so you can find them easily without jumping between the files.
  
  output$caterpillar_plot <- renderPlotly({
  
    # Note the curly braces {} after the renderPlotly
    # function.
    # Then it's just a case of using the function and 
    # tying one of its arguments (la_select) to the 
    # variable input that the user selects. 
    draw_spend_res(la_select = input$la_selectize)
    
  })

  
    
  
} )