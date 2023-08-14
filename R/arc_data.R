
pacman::p_load(dplyr,magrittr,purrr,tidyr,stringr, DT, httr, jsonlite)

###########################################################################
# Get max number of pages based on the number of rows present in the table
pages <- 2

###########################################################################
# Function to make an API request and extract the data
get_arc_data <- function(page, query) {
  base_url <- "https://dataportal.arc.gov.au/NCGP/API/grants?"

  api_url <- paste0(base_url,
                    "page[size]=",
                    1000,
                    "&page[number]=",
                    page,
                    "&filter=",
                    query)

  api_url <- URLencode(api_url)

  response <- GET(url = api_url)
  if (http_type(response) == "application/json") {
    data <- fromJSON(rawToChar(response$content))
    data <- data$data

  } else {
    stop("Unexpected response format.")
  }
  return(data)

}


table_arc_data <- function(start = 1, end = 1, query, raw = FALSE) {

  data_list <- purrr::map(start:end, ~get_arc_data(.x, query))

  result <- data_list %>%
    map(pluck, "results") %>%
    dplyr::bind_rows()

  if(raw) {
    path <- paste0("data/", table_id,".json")
    jsonlite::write_json(result, path)
  }

  return(result)

}



arc <- table_arc_data(1,2,"Artificial Intelligence")

arc1 <- get_arc_data(1, "Artificial Intelligence")
arc2 <- get_arc_data(2, "Artificial Intelligence")

arc <- dplyr::bind_rows(arc1,arc2)

rm(arc1,arc2)


arc <- arc %>%
  unnest(attributes) %>%
  janitor::clean_names()

# THis is a fairly crude approach (although the data doesn't make it super easy),
# Summary of funding where 'artificial intelligence' is anywhere in the metadata
# Then filter that to only occurrences in summary and NIT
#
# this is all grants ever

arc %>%
  mutate(FOR_two = stringr::str_sub(primary_field_of_research,1,2)) %>%
  filter(grepl("Artificial intelligence", paste0(grant_summary, national_interest_test_statement), ignore.case = T)) %>%
  group_by(primary_field_of_research) %>%
  select(announced_funding_amount) %>%
  summarise(mean = mean(announced_funding_amount),
            sd = sd(announced_funding_amount),
            total = sum(announced_funding_amount),
            count = n())


HASS <- c(12,13,14,15,16,17,18,19,20,21,22,33,35,36,38,39,43,44,45,47,48,50,52)

arc %>%
  mutate(FOR_two = stringr::str_sub(primary_field_of_research,1,2)) %>%
  filter(grepl("Artificial intelligence", paste0(grant_summary, national_interest_test_statement), ignore.case = T)) %>%
  group_by(FOR_two %in% HASS) %>%
  select(announced_funding_amount) %>%
  summarise(mean = mean(announced_funding_amount),
            sd = sd(announced_funding_amount),
            total = sum(announced_funding_amount),
            count = n())


