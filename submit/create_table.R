db <- DBI::dbConnect(RPostgreSQL::PostgreSQL())

if (!DBI::dbExistsTable(db, "ratings")) {

  ratings_df <- data.frame(
    photo_id        = character(0L),
    photo_rating    = numeric(0L),
    n_photo_ratings = integer(0L),
    code            = character(0L),
    common_name     = character(0L),
    sci_name        = character(0L),
    sex             = character(0L),
    age             = character(0L),
    lat             = numeric(0L),
    lon             = numeric(0L),
    time            = integer(0L),
    session         = character(0L),
    rating          = numeric(0L)
  )

  DBI::dbWriteTable(db, "ratings", ratings_df, row.names = FALSE)

}

DBI::dbDisconnect(db)
