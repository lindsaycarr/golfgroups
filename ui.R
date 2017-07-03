library(shiny)
library(shinythemes)

# Define UI for dataset viewer application
shinyUI(fluidPage(
  
  theme = shinytheme("darkly"),
  
  # Application title
  headerPanel("Golf Groups"),
  
  # Sidebar with controls to select a dataset and specify the number
  # of observations to view
  sidebarPanel(
    numericInput("numgolfers", "Number of golfers:", 16),
    numericInput("numdays", "Number of days:", 3),
    numericInput("groupsize", "Number of people in each group:", 4),
    actionButton("go", "Go")
  ),
  
  # Show a summary of the dataset and an HTML table with the requested
  # number of observations
  mainPanel(
    textOutput("title"),
    tableOutput("view")
  )
))
