
library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("Simple Game APP: Guess the Correlation"),
  sidebarPanel(
    p(strong('Game Instruction:')),
    helpText('Step 1: check the scatter plot on the right;'),
    helpText('Step 2: Enter your guess of the correlation coefficient of X and Y [-1, 1];'),
    helpText('Step 3: Check your guess by clicking \'Check guess\''),
    br(),
    br(),
    numericInput('guess', 'Enter your guess:', 0.01, step = 0.03),
    actionButton('submit', 'Check Guess'),
    br(),
    br(),
    actionButton('NewPlot', 'New Plot'),
    checkboxInput('bestfit', 'Show the linear fitting line', value = FALSE)
  ),
  
  mainPanel(
    verbatimTextOutput('coreff'),
    plotOutput('plot', width = "512px",height = '512px')
  )  
)  
)
