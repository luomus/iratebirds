#* @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  if (req$REQUEST_METHOD == "OPTIONS") {
    res$setHeader("Access-Control-Allow-Methods","*")
    res$setHeader("Access-Control-Allow-Headers", req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS)
    res$status <- 200
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
  new_data <- merge(ratings_df, new_data, all.y = TRUE)

  db <- DBI::dbConnect(RPostgreSQL::PostgreSQL())

  DBI::dbWriteTable(db, "ratings", new_data, append = TRUE, row.names = FALSE)

  DBI::dbDisconnect(db)

}
