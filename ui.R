library(shiny)

shinyUI(fluidPage(
  titlePanel("Twitter Analysis"),
  sidebarLayout(
    sidebarPanel(
      helpText("Select the topic to stream Tweets. 
               Information will be collected in real time."),
      
      textInput("q", "Search", "Trump"),
      # numericInput("duration", "Stream Duraion in seconds:", 10),
      
      br(),
      
      actionButton("streambutton", "Stream") , br(),br(),
      actionButton("restbutton", "Election Data Analysis")
      ),
    mainPanel(
      tabsetPanel(type = "tab",
                  tabPanel("Stream Analysis", 
                           plotOutput("plotstream_stream1"),
                           plotOutput("plotstream_stream2"),
                           plotOutput("plotstream_stream3")) ,
                  tabPanel("Election Data Analysis",
                            plotOutput("plotrest_daily1"), 
                            br(),
                            plotOutput("plotrest_daily2"),
                           br(),
                           plotOutput("plotrest_daily3")),
                  tabPanel("Summary", 
                           h4("Summary"),
                           verbatimTextOutput("summary"))
      )
    )
  )
))