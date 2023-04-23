
# Load required libraries

library(shiny)
library(bs4Dash) # this is for specific themeing, but is interchangeable with shinydashboard
library(tidyverse)
library(plotly)
library(bslib)
library(fresh)

#' The ui.R file is used to structure the arrangement of the input and output
#' elements of the Shiny app. Generally my workflow is to build the global
#' functions first (and check they don't break when I run them in console).
#' I then like to build up the UI where I will name all of my input and output
#' fields. Finally, I can populate those fields using the server.R file.

bs4DashPage(
  #' it's not necessary to do this but I am also running a custom bootstrap
  #' theme (the default shinydashboard one is just fine, but any default seen
  #' enough times starts to look awful) using the fresh package
  freshTheme = create_theme(theme = "flatly",
                            bs4dash_status(primary = "turquoise"),
                            fresh::bs4dash_sidebar_light(active_color = "turquoise"),
                            fresh::bs4dash_sidebar_dark(active_color = "turquoise")),
  # turn off dark mode option
  dark = NULL,
  # The header contains the title
  title = "BREfualiser", 
  header = dashboardHeader(title = "BREfualiser"),
  sidebar = bs4DashSidebar(
    skin = "light",
    # the sidebar contains different dashboard pages - I like to split 
    # at most 2-3 visualisations between each page as this makes the app feel
    # more responsive. Here we just have one, but I might make multiple, for 
    # example, one sidebar page per random effect caterpillar plot - or one
    # page for residual residual caterpillar REs and effects, one page for
    # slope-slope, and one for intercept-intercept
    bs4SidebarMenu(
      bs4SidebarMenuItem("Dashboard", tabName = "dashboard", icon = icon("cog"), selected = TRUE)
    )
    ),
  body = bs4DashBody(
    bs4TabItems(
      bs4TabItem(tabName = "dashboard",
        # Dashboard bodies are usually split into rows and boxes, split into
        # widths of 12 equal parts (so a width of 12 would be the entire space)
        fluidRow(
          column(width = 1), # I like to centre things using some empty columns
          column(width = 10,
                 # Title of the page
                 HTML('<h2><br><p align="center">Explore variation in the effectiveness of preventative children\'s services spending across local authorities</p></h2><br>')
                 ),
          column(width = 1)
          ),
        # This row is where I'm going to put my LA selection input box. The result of the
        # value the user puts in this box is stored in the session as input$la_selectize,
        # which can then be used in the server.R file.
        fluidRow(
          column(width = 1), 
          column(width = 10,
                 box(
                   selectizeInput("la_selectize", 
                                  "Select one or more local authorities:",
                                  choices = NULL,
                                  options = list(multiple = TRUE, maxOptions = 1000),
                                  multiple = TRUE, 
                                  width = "100%"), 
                   width = 12
                 )
          ),
          column(width = 1)
          ),
        # In this row I am going to specify my plot output. In this case, I am rending the
        # plot using plotly, which uses client side processing so is often faster. However,
        # I have found it to be less flexible than ggplot. Generally, ggplotly does a very
        # good job of transforming ggplot plots into plotly plots
        fluidRow(
          column(width = 1), 
          column(width = 10,
                 box(id = "plotlybox",
                   # The caterpillar_plot object will need to be created in the server.R
                   # file
                   plotlyOutput("caterpillar_plot", height = "600px"), 
                   width = 12, height = "650px", maximizable = FALSE,
                   footer = HTML('<p align="right">Results from work in progress, Webb C. 2023</p><br>')
                 )
          ),
          column(width = 1)
          )
        )
      )
    ),
  footer = dashboardFooter(left = "", right = "Bayesian Random Effects Visualiser (BREfualiser) Concept, Calum Webb 2023")
  )

