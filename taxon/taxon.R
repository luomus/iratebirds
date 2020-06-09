#* @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}

#* Return a random taxon code
#* @get /taxon
function() sample(taxa, 1L)
