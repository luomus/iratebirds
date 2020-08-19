cnames <- c(
  "sex", "catalogId", "age", "location", "userId", "latitude",
  "longitude", "rating", "userDisplayName","sciName", "speciesCode",
  "eBirdChecklistId", "obsDttm",  "ratingCount", "width", "height",
  "commonName", "source", "iratebirds_userId", "iratebirds_rating",
  "iratebirds_lang", "iratebirds_timestamp"
)

ratings_df <- as.data.frame(sapply(cnames, function(x) character()))

ratings_df$catalogId            <- integer()
ratings_df$latitude             <- double()
ratings_df$longitude            <- double()
ratings_df$rating               <- double()
ratings_df$ratingCount          <- integer()
ratings_df$width                <- integer()
ratings_df$height               <- integer()
ratings_df$iratebirds_rating    <- integer()
ratings_df$iratebirds_timestamp <- as.POSIXct(integer(), origin = "1970-01-01")

db <- DBI::dbConnect(RPostgreSQL::PostgreSQL())

if (!DBI::dbExistsTable(db, "ratings")) {

  DBI::dbWriteTable(db, "ratings", ratings_df, row.names = FALSE)

}

DBI::dbDisconnect(db)
