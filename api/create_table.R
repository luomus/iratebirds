cnames <- c("sex", "catalogId", "age", "locationLine2", "location", "isInternalUser", 
"licenseType", "thumbnailUrl", "previewUrl", "largeUrl", "mediaUrl", 
"subjectData.speciesCode", "subjectData.sciName", "subjectData.comName", 
"subjectData.ageSexCounts.age", "subjectData.ageSexCounts.sex", 
"subjectData.ageSexCounts.count", "subjectData.ageSexCounts.localizedString", 
"subjectData.ageSexCounts.localizedAgeString", "subjectData.ageSexCounts.localizedSexString", 
"userId", "latitude", "longitude", "rating", "userDisplayName", 
"assetId", "sciName", "speciesCode", "exifData.mime_type", "exifData.width", 
"exifData.create_dt", "exifData.height", "reportAs", "mediaDownloadUrl", 
"eBirdChecklistId", "valid", "specimenUrl", "userProfileUrl", 
"ebirdSpeciesUrl", "assetState", "locationLine1", "obsDttm", 
"collected", "eBirdChecklistUrl", "ratingCount", "width", "height", 
"mediaType", "commonName", "source", "iratebirds_userId", "iratebirds_rating", "iratebirds_lang")

ratings_df <- as.data.frame(sapply(cnames, function(x) character()))

db <- DBI::dbConnect(RPostgreSQL::PostgreSQL())

if (!DBI::dbExistsTable(db, "ratings")) {

  DBI::dbWriteTable(db, "ratings", ratings_df, row.names = FALSE)

}

DBI::dbDisconnect(db)
