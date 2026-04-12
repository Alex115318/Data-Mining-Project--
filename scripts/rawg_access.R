# Header----

# Alessio Gallonetto
# Data Mining and Large Language Models (LLMs) for Political and Social Scienes
# Personal Capstone Project

# - The impact of "review bombings" 

# RAWG.io Database and general information about a product

# Initialization ----------------------------------------------------------
install.packages("RJSONIO")
install.packages("stringr")

library("tidyverse")
library("rvest")
library("jsonlite")
library("httr")
library("dplyr")
library("RJSONIO")
library("stringr")




# Accessing RAWG ----------------------------------------------------------

#To access this API, the parameters have to be included in the URL,
#which means that the API key has to be explicitly shown in the URL.
#For that, we store the key in an environmental variable and add it to the URL as string

api_key <-  Sys.getenv("RAWG_api_key") # Set API Key as variable from an env.

url <- paste0("https://api.rawg.io/api/games?key=",
              api_key,
              "&search=call-of-duty-black-ops-7&search_exact=TRUE&platforms=4") 
print(url) #Check for the correct URL structure

#In order to search for other review bombed games, change the search parameter to the
#title of the game subject of the project

# GET Request ----

bo7 <- GET(url,
           add_headers(
             From = "alessio.gallonetto@stud.unilu.ch",
             user_agent = R.version$version.string
           ))

#Check if data is retrieved correctly

http_status(bo7)
 
# Parse the JSON response into a data frame ----
raw <- content(bo7, "text")
print(raw) #Check the raw JSON response


parsed_data <- content(bo7, "parsed", simplifyVector = TRUE)
print(parsed_data) #Check the parsed data structure

## Check Metacritic score ----

if (!is.null(parsed_data$results$metacritic) && !is.na(parsed_data$results$metacritic)) {
    print(paste("Metacritic score:", parsed_data$results$metacritic))
} else {
    # If Metacritic is missing, check for logical content (e.g., "tbd", "N/A", or a description)
    if (!is.null(parsed_data$results$rating) && parsed_data$results$rating != 0) {
      print(paste("No Metacritic score. RAWG rating:", parsed_data$results$rating, "(out of 5)"))
  } else if (!is.null(parsed_data$results$ratings)) {
      # Check for any available ratings in the ratings list
      ratings <- parsed_data$results$ratings
      if (length(ratings) > 0) {
        print("No Metacritic score. Available ratings:")
        print(ratings)
      } else {
        print("No Metacritic score or ratings found.")
      }
  } else {
      print("No Metacritic score or alternative ratings available.")
    }
}

##Check release date ----

if (!is.null(parsed_data$results$released) && !is.na(parsed_data$results$released)) {
    print(paste("Release date:", parsed_data$results$released))
} else {
    print("Release date is missing.")
}


