#* @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  if (req$REQUEST_METHOD == "OPTIONS") {
    res$setHeader("Access-Control-Allow-Methods", "*")
    res$setHeader(
      "Access-Control-Allow-Headers",
      req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS
    )
    res$status <- 200L
    return(list())
  } else {
    plumber::forward()
  }
}

#* Return a random taxon code
#* @get /taxon
function() sample(taxa, 1L)

#* Send data to the database
#* @post /submit
function(req) {

  new_data <- jsonlite::fromJSON(req$postBody, simplifyVector = FALSE)
  new_data <- as.data.frame(rbind(unlist(new_data)))
  new_data <- new_data[intersect(names(new_data), names(ratings_df))]

  new_data$catalogId            <- as.integer(new_data$catalogId)
  new_data$latitude             <- as.numeric(new_data$latitude)
  new_data$longitude            <- as.numeric(new_data$longitude)
  new_data$rating               <- as.numeric(new_data$rating)
  new_data$assetId              <- as.integer(new_data$assetId)
  new_data$ratingCount          <- as.integer(new_data$ratingCount)
  new_data$width                <- as.integer(new_data$width)
  new_data$height               <- as.integer(new_data$height)
  new_data$iratebirds_rating    <- as.integer(new_data$iratebirds_rating)
  new_data$iratebirds_timestamp <- Sys.time()

  new_data <- merge(ratings_df, new_data, all.y = TRUE)

  db <- DBI::dbConnect(RPostgreSQL::PostgreSQL())

  DBI::dbWriteTable(db, "ratings", new_data, append = TRUE, row.names = FALSE)

  DBI::dbDisconnect(db)

}
