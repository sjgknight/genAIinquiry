#Sys.setenv(BASEROW_AJET_TOKEN = "TOKEN")
#api_url <- "https://api.baserow.io/api/database/rows/table/183319/?user_field_names=true&size=199"

pacman::p_load(dplyr,magrittr,purrr,tidyr,stringr, DT, httr, jsonlite)

###########################################################################
# Get max number of pages based on the number of rows present in the table
pages <- function(row_count){ceiling(row_count/100)}

###########################################################################
# Function to make an API request and extract the data
get_data <- function(page, table_id) {
  base_url <- "https://api.baserow.io/api/database/rows/table/"

  api_url <- paste0(base_url, table_id, "/?user_field_names=true&page=", page)
  response <- GET(url = api_url, add_headers(Authorization = paste("Token", Sys.getenv("BASEROW_AJET_TOKEN"))))
  if (http_type(response) == "application/json") {
    data <- fromJSON(rawToChar(response$content))
  } else {
    stop("Unexpected response format.")
  }
    return(data)

}

table_data <- function(start = 1, end = 1, table_id, raw = FALSE) {

  data_list <- purrr::map(start:end, ~get_data(.x, table_id))

    result <- data_list %>%
        map(pluck, "results") %>%
        dplyr::bind_rows()

    if(raw) {
      path <- paste0("data/", table_id,".json")
      jsonlite::write_json(result, path)
    }

    return(result)

}


#tibble_data <- purrr::map_dfr(1:pages, get_data)


