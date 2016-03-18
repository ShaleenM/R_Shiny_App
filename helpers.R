# Helper Functions

library(streamR)
library(ROAuth)
library(twitteR)

auth <- function(){
  if(!file.exists("my_oauth.Rdata")){
    requestURL <- "https://api.twitter.com/oauth/request_token"
    accessURL <- "https://api.twitter.com/oauth/access_token"
    authURL <- "https://api.twitter.com/oauth/authorize"
    consumerKey <- "udKUz3GIAvojr5UIWkpIQMfga"
    consumerSecret <- "WvY5pEy70oAJPhz6wsGkYEn6G4lSWdbBzuyj6lD2sIg1Gb700s"
    my_oauth <- OAuthFactory$new(consumerKey = consumerKey, consumerSecret = consumerSecret, 
                                 requestURL = requestURL, accessURL = accessURL, authURL = authURL)
    my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
    save(my_oauth, file = "my_oauth.Rdata")
  }
  else{
    load("my_oauth.Rdata")
  }
}

auth_rest <- function()
{
  api_key <- "hI5mBfAHzTTH7kzX34ro1BVTP"
  api_secret <- "1epLba0ebZWI82ZQVlDXDwMQyLUo5owFg8PQY0sBxVM1OK3hmo"
  access_token <- "3558615497-QaFfrL8NQfBPjhO8QCiR1evuhxKdZk2CamInoRQ"
  access_token_secret <- "Urymvq5PIFcQXtyKmYyI1wei25vFulLEdKZIEvKwfXTKu"
  setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
}
restTweets <- function(data){
  cat("Authorizing")
  auth_rest()
  qs<-paste(data,collapse="+")
  dm2_tweets = searchTwitter(qs,n=100, since="2016-01-01", until="2016-03-03")
  rest_data<-twListToDF(dm2_tweets)
  # #Read Json Files
  # cat("readingData")
  # rest_data <- fromJSON(paste(readLines('rental_27.JSON'),collapse=""))
}