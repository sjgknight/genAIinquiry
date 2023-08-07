#pacman::p_load(readxl)
#inquiry <- readxl::read_xlsx("data/genAIInquiry.xlsm")
#usethis::edit_r_profile("user")
#Sys.setenv(BASEROW_AJET_TOKEN = "TOKEN")
#api_url <- "https://api.baserow.io/api/database/rows/table/183319/?user_field_names=true&size=199"
#response <- GET(url = api_url, add_headers(Authorization = paste("Token", Sys.getenv("BASEROW_AJET_TOKEN"))))
#183319 is recommendations table


pacman::p_load(dplyr,magrittr,purrr,tidyr,stringr, DT, httr, jsonlite)

row_count <- 508
pages <- ceiling(row_count/100)

# Function to make an API request and extract the data
get_data <- function(page) {
  base_url <- "https://api.baserow.io/api/database/rows/table/"
  table_id <- "183319"
  api_url <- paste0(base_url, table_id, "/?user_field_names=true&page=", page)
  response <- GET(url = api_url, add_headers(Authorization = paste("Token", Sys.getenv("BASEROW_AJET_TOKEN"))))
  if (http_type(response) == "application/json") {
    data <- fromJSON(rawToChar(response$content))
  } else {
    stop("Unexpected response format.")
  }
  return(data$results)
}

tibble_data <- purrr::map_dfr(1:pages, get_data)


tibble_data <- tibble_data %>%
  unnest(cols = c(Sources, Lookup, Tags, Tags_lookup),
         names_sep = "_", names_repair = "minimal") %>%
  select(-contains("_id")) %>%
  group_by(id) %>%
  summarise(across(c(Recommendation, paste0(c("Sources", "Lookup", "Tags", "Tags_lookup"),"_value")),
                   ~paste(., collapse = ", "), .names = "{col}"), .groups = "drop")

#                   ~paste(., collapse = ", "), .names = "{col}_collapsed"), .groups = "drop")

inquiry <- tibble_data %>%
  rename_with(~str_remove(., "_value"), contains("_value"))

#thing for DT
headerCallback <- c(
  "function(thead, data, start, end, display){",
  "  var $ths = $(thead).find('th');",
  "  $ths.css({'vertical-align': 'bottom', 'white-space': 'nowrap'});",
  "  var betterCells = [];",
  "  $ths.each(function(){",
  "    var cell = $(this);",
  "    var newDiv = $('<div>', {height: 'auto', width: cell.height()});",
  "    var newInnerDiv = $('<div>', {text: cell.text()});",
  "    newDiv.css({margin: 'auto'});",
  "    newInnerDiv.css({",
  "      transform: 'rotate(180deg)',",
  "      'writing-mode': 'tb-rl',",
  "      'white-space': 'normal',",
  "      'word-wrap': 'break-word'",
  "    });",
  "    newDiv.append(newInnerDiv);",
  "    betterCells.push(newDiv);",
  "  });",
  "  $ths.each(function(i){",
  "    $(this).html(betterCells[i]);",
  "  });",
  "}"
)


# Create a selectInput for filtering the tags
tag_filter <- unique(unlist(strsplit(inquiry$Tags_lookup, ",")))

table(unlist(strsplit(inquiry$Tags_lookup, ","))) %>% huxtable::as_hux() %>% huxtable::quick_html()


inquiry %>%
  DT::datatable(escape=FALSE,
                extensions = 'Buttons',
                filter = 'top',
                options = list(
                  dom = 'Bfrtip',
                  buttons = c(I('colvis'), c('copy', 'csv', 'excel')),
                  lengthMenu = c(10,100),
                  pageLength = 187,
                  scrollX = TRUE,
                  searchHighlight = TRUE,
                  autoWidth = TRUE
                  #columnDefs=list(list(width="200px",targets=c(1,1,1,6,6,6))
                )
  ) %>%
  DT::formatStyle(
    1,
    width = '50px !important'
  ) %>%
  DT::saveWidget(selfcontained = T, "R/inquiry.html")

