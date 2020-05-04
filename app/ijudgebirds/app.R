library(shiny)
library(auk)
library(emo)
library(httr)
library(jsonlite)
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

info_page <- paste0(
  "Good question. Well... Basically this is the place to come ",
  "to judge the appearence of birds guilt free!\n\nHow so? It's like this",
  "see... As we all know, many birds are under threat from the illegal",
  "wildlife trade. But it isn't clear to what extent some birds might be more ",
  "threatened than others and why? What is it that makes a bird appealing? ",
  "Part of the equation is obviously the birds appearence. But what is it ",
  "about how a bird looks that makes it appealing?\n\nHard to say, right? And ",
  "darn hard to quantify! Now that's where you come in. Time to look at some ",
  "birds and tell us what you think of them on a scale of ", emo::ji("fear"),
  " to ", emo::ji("smiling_face_with_heart_eyes"),". Come on, you know ",
  "want to. And it's for a good cause!!"
)

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


  ind <-
    if (length(candidates) > 1L) sample(which(candidates), 1L) else candidates

  res <- res[[ind]]

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
    h2("how"),
    h2(emo::ji("fire")),
    h2("that"),
    h2(paste0(emo::ji("bird"), "?")),
    h2(emo::ji("shrug"), class = "last-line"),
    actionLink("start", "\u2192"),
    class = "splash-main"
  ),
  actionLink("info_button", emo::ji("information"))
)

ui <- fluidPage(
  theme = "custom.css",
  shinyalert::useShinyalert(),
  waiter::use_waiter(include_js = FALSE),
  titlePanel(paste0("how ", emo::ji("fire"), " this ", emo::ji("bird"), "?")),
  htmlOutput("new_bird"),
  sliderInput(
    "rating",
    div(
      span(
        paste0(emo::ji("vomit")), "ugly ",
        class = "left-slider-label"
      ),
      span(
        paste0(c("smokin' ", rep(emo::ji("pepper"), 3)), collapse = ""),
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
        "what is this?",
        info_page,
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
