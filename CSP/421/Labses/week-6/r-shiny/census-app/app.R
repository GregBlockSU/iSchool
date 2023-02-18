# IST 421 Week 6
# Dr. Gregory Block
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#install.packages('rsconnect')
#install.packages(c("maps", "mapproj"))
install.packages(c("htmltools"))

#this code will execute once when the program loads
library(shiny)
library(maps)
library(mapproj)

# helpers.R is a module that contains the code for rendering the map
source("helpers.R")

#loads tha counties data from a file
counties <- readRDS("data/counties.rds")


# the ui function defines the layout of the web page, including which
# controls are displayed on the page
ui <- fluidPage(
  titlePanel("censusVis"),
  
  # sidebarLayout creates a vertical panel where you can place controls;
  # here we are adding a drop-down combobox to allow the user to
  # make a selection, as well as a slider so the user can choose a range'
  # of values between 0 and 100s
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
        information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    # the main panel appears to the right of the sidebar panel - this
    # is where a map of the US is displayed
    mainPanel(plotOutput("map"))
  )
)

# the server function runs each time a new session is initiated by a user
# visiting the web site
server <- function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    
    color <- switch(input$var, 
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")
    
    legend <- switch(input$var, 
                     "Percent White" = "% White",
                     "Percent Black" = "% Black",
                     "Percent Hispanic" = "% Hispanic",
                     "Percent Asian" = "% Asian")
    
    # redraws the map according to the selected settings
    percent_map(data, color, legend, input$range[1], input$range[2])
  })
}

# Run the application. This statement is executed once, when the web site is launched
shinyApp(ui = ui, server = server)
