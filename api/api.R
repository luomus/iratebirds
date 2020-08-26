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

#* Send data to the database
#* @post /submit
function(req) {

  new_data <- jsonlite::fromJSON(req$postBody, simplifyVector = FALSE)

  new_data$catalogId         <- as.integer(new_data$catalogId)
  new_data$latitude          <- as.numeric(new_data$latitude)
  new_data$longitude         <- as.numeric(new_data$longitude)
  new_data$rating            <- as.numeric(new_data$rating)
  new_data$ratingCount       <- as.integer(new_data$ratingCount)
  new_data$width             <- as.integer(new_data$width)
  new_data$height            <- as.integer(new_data$height)
  new_data$iratebirds_rating <- as.integer(new_data$iratebirds_rating)

  new_data$iratebirds_timestamp <- Sys.time()

  new_data <- new_data[cnames]
  names(new_data) <- cnames

  class(new_data) <- "data.frame"
  attr(new_data, "row.names") <- .set_row_names(1L)


  db <- DBI::dbConnect(RPostgreSQL::PostgreSQL())

  DBI::dbWriteTable(db, "ratings", new_data, append = TRUE, row.names = FALSE)

  DBI::dbDisconnect(db)

}
