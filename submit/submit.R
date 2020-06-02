#* Send data to the database
#* @param photo_id
#* @param photo_rating
#* @param n_photo_ratings
#* @param code
#* @param common_name
#* @param sci_name
#* @param sex
#* @param age
#* @param lat
#* @param lon
#* @param time
#* @param session
#* @param rating
#* @get /submit

function(
  photo_id, photo_rating, n_photo_ratings, code, common_name, sci_name, sex,
  age, lat, lon, time, session, rating
) {

  ratings_df <- data.frame(
    photo_id, photo_rating, n_photo_ratings, code, common_name, sci_name, sex,
    age, lat, lon, time, session, rating
  )

  db <- DBI::dbConnect(RPostgreSQL::PostgreSQL())

  DBI::dbWriteTable(db, "ratings", ratings_df, append = TRUE, row.names = FALSE)

  DBI::dbDisconnect(db)

}
