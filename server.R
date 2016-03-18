# server.R

library(jsonlite)
library(quantmod)
library(ggplot2)
library(maps)
source("helpers.R")

auth()
# auth_rest()

stream_data<-data.frame()
rest_data <- data.frame()

file.remove("streamtweets.json")
file.create("streamtweets.json")


shinyServer(function(input, output) {
  streamTweets <- function(data, duration){
    observe({
      if(file.info("streamtweets.json")$size != 0){
        stream_data <- parseTweets("streamtweets.json", verbose = TRUE)
        }
      searchTerms <- strsplit(data , " ")
      load("my_oauth.Rdata")
      filterStream("streamtweets.json", track = searchTerms, timeout = duration, oauth = my_oauth)
      output$plotstream_stream1 <- renderPlot({map("state", fill=TRUE, col="white", bg="white",mar=c(0,0,0,0))
                                                  points(stream_data$longitude,stream_data$latitude, col="red", pch=8)})
      output$plotstream_stream2 <- renderPlot({ggplot(stream_data, aes(x=stream_data$lang))+geom_bar() +xlab("Language")+ ylab("count")})
      output$plotstream_stream3 <- renderPlot({ggplot(stream_data, aes(x=stream_data$created))+geom_bar() +theme(axis.text.x = element_text(angle = 90, hjust = 1))+ylab("No of Tweets")+ xlab("Created At")})
      invalidateLater(0,session = getDefaultReactiveDomain())
    })
  }
  #Collect Data
  rest_data <<- jsonlite::fromJSON(paste(readLines("/Volumes/Transcend/R_Working_Dir/Project1_DIC/StockApp/election.JSON"),collapse=","))
  rest_data$created1 <- as.Date(rest_data$created)
  rest_tweeet_count <- sqldf("select created1 , count(*) from rest_data group by created1")
  retweet_count <- sqldf("select created1, isRetweet, count(*) from rest_data group by created1, isRetweet")
  retweet_count<- subset(retweet_count, retweet_count$isRetweet==TRUE)
  rest_data$latitude1 <- as.numeric(rest_data$latitude)
  rest_data$longitude1 <- as.numeric(rest_data$longitude)
  
  # candidate_tweets <- rbind(cbind(candidate = "Trump",rest_data[which(grepl("Trump",rest_data$text)),]),
  #                           cbind(candidate = "cruz",rest_data[which(grepl("cruz",rest_data$text)),]),
  #                           cbind(candidate = "kasich",rest_data[which(grepl("kasich",rest_data$text)),]),
  #                           cbind(candidate = "rubio",rest_data[which(grepl("rubio",rest_data$text)),]),
  #                           cbind(candidate = "clinton",rest_data[which(grepl("clinton",rest_data$text)),]),
  #                           cbind(candidate = "sanders",rest_data[which(grepl("sanders",rest_data$text)),]),
  #                           cbind(candidate = "donald",rest_data[which(grepl("donald",rest_data$text)),]),
  #                           cbind(candidate = "ted",rest_data[which(grepl("ted",rest_data$text)),]),
  #                           cbind(candidate = "john",rest_data[which(grepl("john",rest_data$text)),]),
  #                           cbind(candidate = "marko",rest_data[which(grepl("marko",rest_data$text)),]),
  #                           cbind(candidate = "hillary",rest_data[which(grepl("hillary",rest_data$text)),]),
  #                           cbind(candidate = "bernie",rest_data[which(grepl("bernie",rest_data$text)),]))
  # 
  
  dataInput <- observeEvent(input$streambutton,{
    streamTweets(input$q, 5)
    })
  
  dataInput1 <- observeEvent(input$restbutton,{
    output$plotrest_daily1 <- renderPlot({map("state", fill=TRUE, col="white", bg="white",mar=c(0,0,0,0))
      points(rest_data$longitude,rest_data$latitude, col="red", pch=8)})
    output$plotrest_daily2 <- renderPlot({barplot(rest_tweeet_count[,2],names.arg = rest_tweeet_count[,1], col=rainbow(length(rest_tweeet_count[,1]))) })
    output$plotrest_daily3 <- renderPlot({barplot(retweet_count[,3],names.arg = retweet_count[,1], col=rainbow(length(rest_tweeet_count[,1]))) })
    })
  # Generate a summary of the dataset
  output$summary <- renderPrint({
    # dataset <- datasetInput()
    summary(rest_data)
  })
})

