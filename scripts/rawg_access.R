
# Initialization ----------------------------------------------------------

library("tidyverse")
library("rvest")
library("jsonlite")
library("httr")
library("dplyr")

install.packages("RJSONIO")
library("RJSONIO")

# Reading the html ----
url_rawg <- "https://rawg.io/"

rawg_html <- read_html(url_rawg) 

print(rawg_html)
# Accessing RAWG ----------------------------------------------------------
api_key <-  Sys.getenv("RAWG_api_key") # Set API Key as variable from an env.
bearer <- stringr::str_c(api_key)
print(bearer)

bo7 <- GET(
  url = "https://api.rawg.io/api/games?search=call-of-duty-black-ops-7&search_precise=true?",#Precise search for the game, to avoid getting other games with similar names.
  add_headers("key=", Authorization = paste(api_key)) 
)
print(bo7)
games <-  GET("https://api.rawg.io/api/games?key=api_key")

print(api_key)
#Check if data is retrieved correctly
bo7_check <- read_json(bo7["status_code"])
if (bo7_check == 200) {
  print("Data retrieved successfully!")
} else {
  print(paste("Error retrieving data. Status code:", bo7_check))
}
 
bo7_json <- read_json(bo7)





# Trying documentation code ----

url <- "https://api.rawg.io/api/games"
new_url <- add_headers("?key=")
print(new_url)
queryString <- list( 
  search = "call%20of%20duty%20black%20ops%207",
  platforms = "4" #For PC
  )

response <- VERB("GET", url, query = queryString, content_type("application/octet-stream"), accept("application/json"))

content(response, "text")
response_json <- read_json(response, simplyfyVector = TRUE)
response_tibble <- as_tibble(response_json)
print(response_json)