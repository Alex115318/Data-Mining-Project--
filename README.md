# Data Mining Project: The Effect of Review Bombing

This repository contains the code for a small data mining project developed as part of the course:

**Data Access and Data Mining for Social Sciences**

University of Lucerne

Alessio Gallonetto  
Course: Data Mining for the Social Sciences using R
Term: Spring 2026

## Project Goal

The goal of this project is to lay a foundation for data mining informations relevant to the "review bombing" phenomenon,
which refers to the practice of users leaving negative reviews for a product, service, or content as a form of protest or expression of dissatisfaction.

This project highlights:

- Suitable data sources acquiring the needed data
- Automated data collection (API or scraping)
- Data cleaning and preparation
- Reproducible analysis


## Research Question

My research topic focuses on the influence of online sentiment and online social polarisation on games sales, 
analyzing the user behavior during and after the so called “review bombings”.



## Data Source

-API: https://api.rawg.io/
 Documentation: https://api.rawg.io/docs/
 Access Method: HTTP GET requests using an API key, provided by the website after creating an account(free access)
  Note: To access the API, the key should be added to the URL, but in order to not expose the api key, 
  storing it as an env. variable is recommended. 
 
-SteamDB: https://steamdb.info/
 Specifically, https://steamdb.info/app/1938090/charts/, to download the CCU and the number of User reviews

-Steam Appreviews: https://partner.steamgames.com/doc/store/getreviews?l=english
 Public Steam API accessible through simple GET requests. Fetches data on user reviews, 
 including the time of the review and the text.


## Repository Structure

/scripts             scripts used to collect/process data
/data_raw            data obtained from downloading or API calls
/data_preprocessed   cleaned and processed data ready for analysis
/plots               visualizations generated from the data
/capstone_report     written report summarizing the findings and the workflow
README.md   project description


## Reproducibility

To reproduce this project:

1. Clone the repository
2. Install required R packages
3. Run the scripts in the `scripts/` folder

All data should be generated automatically by the scripts.


## Good Practices

Please follow these guidelines:

- Do **not upload raw datasets** to GitHub.
- Store **API keys outside the repository** (e.g., environment variables).
- Write scripts that run **from start to finish**.
- Commit your work **frequently**.
- Use **clear commit messages**.

Example commit messages:
added API request
cleaned dataset structure
added visualization
fixed JSON parsing


## Notes

Large datasets should not be pushed to GitHub.  
If necessary, provide instructions for downloading the data instead.
