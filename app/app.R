library(shiny)
library(auk)
library(httr)
library(jsonlite)
library(RcppTOML)
library(RPostgres)
library(shinyalert)
library(waiter)

ratings_df <- data.frame(
  photo_id        = NA_character_,
  photo_rating    = NA_real_,
  n_photo_ratings = NA_integer_,
  code            = NA_character_,
  common_name     = NA_character_,
  sci_name        = NA_character_,
  sex             = NA_character_,
  age             = NA_character_,
  lat             = NA_real_,
  lon             = NA_real_,
  time            = NA_integer_,
  session         = NA_character_,
  rating          = NA_real_
)

codes <- subset(auk::ebird_taxonomy, category == "species")[["species_code"]]

content <- parseTOML("content.toml")

get_photo_link <- function(codes) {

  candidates <- FALSE

  while (!any(candidates)) {
    ratings_df$code <<- sample(codes, 1L)
    res <- httr::RETRY(
      "GET", url = "https://ebird.org/media/catalog.json",
      query = list(
        taxonCode = ratings_df$code, mediaType = "p", sort = "rating_rank_desc",
        count = 20L
      )
    )
    httr::stop_for_status(res)
    res <- httr::content(res, "text")
    res <- jsonlite::fromJSON(res, simplifyVector = FALSE)
    res <- res[["results"]]
    res <- res[["content"]]
    candidates <- vapply(
      res,
      function(x) {
        isTRUE(
          x[["height"]] / x[["width"]] < .75 && as.numeric(x[["rating"]]) > 3.5
        )
      },
      logical(1L)
    )
  }

  candidates <- which(candidates)
  if (length(candidates) > 1L) candidates <- sample(candidates, 1L)

  res <- res[[candidates]]

  ratings_df$photo_id        <<- res[["catalogId"]]
  ratings_df$photo_rating    <<- as.numeric(res[["rating"]])
  ratings_df$n_photo_ratings <<- as.integer(res[["ratingCount"]])
  ratings_df$common_name     <<- res[["commonName"]]
  ratings_df$sci_name        <<- res[["sciName"]]
  ratings_df$sex             <<- res[["sex"]]
  ratings_df$age             <<- res[["age"]]
  ratings_df$lat             <<- res[["latitude"]]
  ratings_df$lon             <<- res[["longitude"]]

  tags$iframe(
    src = sprintf(
      "https://macaulaylibrary.org/asset/%s/embed/320", ratings_df$photo_id
    ),
    frameborder = 0L,
    width       = 320L,
    height      = 380L
  )

}

save_data <- function(data) {

  db <- DBI::dbConnect(RPostgres::Postgres())

  if (!DBI::dbExistsTable(db, "ratings")) {

    DBI::dbCreateTable(db, "ratings", ratings_df)

  }
  
  DBI::dbAppendTable(db, "ratings", ratings_df)
  
  DBI::dbDisconnect(db)
}

splash_screen <- div(
  div(
    h2(content$landing_page$title[[1]]),
    h2(content$landing_page$title[[2]]),
    h2(content$landing_page$title[[3]]),
    h2(content$landing_page$title[[4]]),
    h2(content$landing_page$title[[5]], class = "last-line"),
    actionLink("start", "\u2192"),
    class = "splash-main"
  ),
  actionLink("info_button", content$landing_page$info_button)
)

ui <- fluidPage(
  theme = "custom.css",
  shinyalert::useShinyalert(),
  waiter::use_waiter(include_js = FALSE),
  titlePanel(content$main_page$title),
  htmlOutput("new_bird"),
  sliderInput(
    "rating",
    div(
      span(
        content$main_page$slider_labels[[1]],
        class = "left-slider-label"
      ),
      span(
        content$main_page$slider_labels[[2]],
        class = "right-slider-label"
      ),
      class = "slider-labels"
    ),
    width = "320px",
    min   = 0L,
    max   = 10L,
    value = 5,
    step  = 1,
    ticks = FALSE
  ),
  waiter_show_on_load(splash_screen, color = "#FFFFFF")
)

server <- function(input, output, session) {

  ratings_df$session <<- session$token

  waiter::waiter_show(splash_screen, color = "#FFFFFF")

  output$new_bird <- renderUI(get_photo_link(codes))

  observeEvent(
    input$info_button,
    {
      shinyalert::shinyalert(
        content$info_page$title,
        paste(content$info_page$body, collapse = "\n\n"),
        type = "info",
        confirmButtonText = "\u2192",
      )
      waiter::waiter_hide()
    },
    once = TRUE
  )

  observeEvent(
    input$start,
    waiter::waiter_hide(),
    once = TRUE
  )

  need_button      <- TRUE
  need_button_next <- FALSE

  observeEvent(
    input$rating,
    {
      if (need_button) {
        insertUI("#rating", "afterEnd", actionButton("rated", "next!"))
      }
      need_button <<- FALSE
      if (need_button_next) {
        need_button <<- TRUE
        need_button_next <<- FALSE
      }
    },
    ignoreInit = TRUE
  )

  observeEvent(
    input$rated,
    { 
      ratings_df$rating  <<- input$rating
      ratings_df$time    <<- as.integer(Sys.time())
      save_data(ratings_df)
      updateSliderInput(session, inputId = "rating", value = 5L)
      removeUI("#rated")
      need_button_next <<- TRUE
      output$new_bird <- renderUI(get_photo_link(codes))
    },
    ignoreInit = TRUE
  )

}

shinyApp(ui = ui, server = server)
