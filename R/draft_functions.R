
###########################################################################
###########################################################################
# Sketching function to update link to tag_table based on the tags
# Rationale is it's easier to update tags than table-links manually
# But more useful to have table-links than manual tags for programmatic use
# (And for other things)
###########################################################################

update_tags_lookup <- function(recommendations_table_id = table_id,
                               recommendations_df = recommendations,
                               tags_field_name = "Tags",
                               tags_lookup_field_name = "Tags_lookup",
                               tag_table_id = "184385",
                               baserow_token = Sys.getenv("BASEROW_AJET_TOKEN")) {
  # Step 1: Read the Tag_table
  tag_table_url <- paste0("https://api.baserow.io/api/database/rows/table/", tag_table_id, "/")
  tag_table <- GET(url = tag_table_url, add_headers(Authorization = paste("Token", baserow_token)))
  tag_table <- table_data(1, 1, table_id = tag_table_id)

  # Function to fill Tags_lookup column based on Tags column
  fill_tags_lookup <- function(tag_table, recommendations) {
    updated_rec_df <- recommendations %>%
      mutate(
        Tags_lookup = Tags %>%
          map(function(tag_list) {
            tag_table$Name %>%
              filter(value %in% tag_list) %>%
              select(id, value)
          })
      )
    return(updated_rec_df)
  }

  # Prepare batch update payload
  update_payload <- fill_tags_lookup(tag_table, recommendations)

  # Perform batch update
  batch_update_url <- paste0("https://api.baserow.io/api/database/rows/table/", recommendations_table_id, "/batch/?user_field_names=true")
  batch_response <- POST(
    url = batch_update_url,
    body = toJSON(update_payload$Tags_lookup),
    add_headers(Authorization = paste("Token", baserow_token)),
    content_type("application/json")
  )

  if (http_type(batch_response) == "application/json") {
    message("Tags_lookup updated successfully.")
  } else {
    stop("Unexpected response format.")
  }
}
