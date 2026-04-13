# Header----

# Alessio Gallonetto
# Data Mining and Large Language Models (LLMs) for Political and Social Scienes
# Personal Capstone Project

# - The impact of "review bombings" 

# Scraper for steam reviews(webpage)

# Initialization ----------------------------------------------------------
# Installing packages, loading libraries and setting up the environment

library(tidyverse)
library(rvest)
library(httr)
library(jsonlite)
library(dplyr)
library(stringr)

# URL and GET Requests ----

## Define variables ----
appid <- "1938090" # Replace with the actual app ID, find the AppID from the steam webstore page URL
cursor <- "*" # Cursor is used for pagination, "*" means starting point, it will be updated in the loop to fetch next pages of reviews
has_more_reviews = TRUE # Flag to control the loop, it will be set to FALSE when there are no more reviews to fetch
all_reviews <- list() # Initialize an empty list to store all reviews

### Parameters for the URL:
### json=1: Return the response in JSON format.
### filter=all: Fetch all reviews, including those that are not recommended. 
### language=english: Fetch reviews in English.
### num_per_page=100: Fetch 100 reviews per page. This is the maximum allowed by the API, which helps to minimize the number of requests needed to fetch all reviews.
### day_range=365: Fetch reviews from the last 365 days. This limits the reviews to a specific time frame. It is recommended to define this parameter, since older reviews date back years.
### start_offset=0: Start fetching reviews from the beginning (offset 0). This is used for pagination.
### filter_offtopic_activity=0: Include reviews that are marked as off-topic, e.g. review bombing activities.

base_url <- paste0("https://store.steampowered.com/appreviews/", 
                   appid, 
                   "?json=1&filter=all&language=english&num_per_page=100&day_range=365&start_offset=0&filter_offtopic_activity=0")
print(base_url) # Print the base URL to check if it's correct

## Create Loop for extracting reviews ----

while(has_more_reviews) {
  
  #Construct the GET request URL with the current cursor for pagination
  url <- paste0(base_url, 
                "&cursor=",
                cursor)
  
  # Make the GET request to the Steam API
  response <- GET(url,
                  add_headers(
                    From = "alessio.gallonetto@stud.unilu.ch",
                    user_agent = R.version$version.string
                  ))
  data <- fromJSON(rawToChar(response$content)) 
  
  #Check if the reviews exist
  if (is.null(data$reviews) || length(data$reviews) == 0) {
    has_more_reviews <- FALSE
    break 
  }
  
  # Append reviews to the list
  all_reviews <- c(all_reviews, data$reviews)
  
  # Update the cursor for the next request
  cursor <- data$cursor
  
  # Check if there are more reviews
  if (is.null(cursor) || cursor == "") {
    has_more_reviews <- FALSE
  }
  
  Sys.sleep(2) # Sleep for 2 second to avoid hitting the API rate limit
}


### The cursor tends to not work for a second loop, which means that a lot
### of reviews are not fetched. Still this can be utilized as a baseline code
### for saving the reviews and filtering out sensitive information.

## Storing the reviews as a data frame
review <- as.data.frame.character(all_reviews[["review"]])

## Storing the timestamps
dummy_time <- as.data.frame(all_reviews[["timestamp_created"]])

## Merge the dfs
tidy_reviews <- cbind(review, dummy_time)

## Filter for launch day reviews

#UNIX Timeframe is 1763082000 - 1763168400 (14th and 15th Nov 2025)
start_time <- 1763082000
end_time <- 1763168400
launch_day_reviews <- tidy_reviews %>%
  filter(tidy_reviews[2] >= start_time & tidy_reviews[2] <= end_time)

# Save the data frame as a csv file
write.csv(launch_day_reviews, "data_preprocessed/launch_day_reviews.csv", row.names = FALSE)

## It returns a small data frame. Since the request was limited to only 20 reviews,
## there is little data to analyze. It might be tied to the cursor functioning only once,
## therefore this section needs to be improved.

