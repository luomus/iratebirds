library(shiny)
library(httr)
library(jsonlite)
library(shinyalert)
library(waiter)
library(V8)
library(shinyjs)

library(promises)
library(future)
plan(multisession, workers = 4L)

content <- jsonlite::read_json("content/fi.json")

get_photo_link <- function() {
  metadata <- list()

  candidates <- FALSE

  while (!any(candidates)) {
    metadata$code <- httr::RETRY("GET", url = "http://taxon:8000/taxon")
    httr::stop_for_status(metadata$code)
    metadata$code <- httr::content(metadata$code, "text")
    metadata$code <-
      jsonlite::fromJSON(metadata$code, simplifyVector = FALSE)[[1L]]

    res <- httr::RETRY(
      "GET", url = "https://search.macaulaylibrary.org/api/v1/search",
      query = list(
        taxonCode = metadata$code, mediaType = "p", sort = "rating_rank_desc",
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

  metadata$photo_id        <- res[["catalogId"]]
  metadata$photo_rating    <- as.numeric(res[["rating"]])
  metadata$n_photo_ratings <- as.integer(res[["ratingCount"]])
  metadata$common_name     <- res[["commonName"]]
  metadata$sci_name        <- res[["sciName"]]
  metadata$sex             <- res[["sex"]]
  metadata$age             <- res[["age"]]
  metadata$lat             <- res[["latitude"]]
  metadata$lon             <- res[["longitude"]]

  output <- tags$iframe(
    src = sprintf(
      "https://macaulaylibrary.org/asset/%s/embed/320", metadata$photo_id
    ),
    frameborder = 0L,
    width       = 320L,
    height      = 380L
  )

  attr(output, "metadata") <- metadata

  output

}

splash_screen <- div(
  h2(content$landing_page$title[[1]]),
  h2(content$landing_page$title[[2]]),
  h2(content$landing_page$title[[3]]),
  h2(content$landing_page$title[[4]], class = "last-line"),
  actionLink("start", "\u2192"),
  class = "splash-main"
)

unrated <- div(
  span(content$main_page$this_bird, id = "unrated"),
  id = "unrated-container"
)

ui <- fluidPage(
  tags$script("
    Shiny.addCustomMessageHandler('rating', function(value) {
    Shiny.setInputValue('rating', value);
    });
  "),
  theme = "custom.css",
  shinyalert::useShinyalert(),
  tags$script(
    src = "https://cdn.jsdelivr.net/npm/js-cookie@rc/dist/js.cookie.min.js"
  ),
  shinyjs::useShinyjs(),
  shinyjs::extendShinyjs("www/custom.js"),
  waiter::use_waiter(include_js = FALSE),
  titlePanel(
    div(
      span(content$main_page$title, class = "title"),
      span(
        actionLink("about_link", content$landing_page$info_button),
        actionLink("faq_link", content$faq$title),
        class = "about-faq"
      ),
      class = "title-about-faq"
    ),
    content$main_page$window_title
  ),
  htmlOutput("new_bird"),
  ShinyRatingInput::ratingInput(
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
    value = 0L,
    dataFilled="fa fa-heart",
    dataEmpty="fa fa-heart-o",
    dataStart = 0L,
    dataStop  = 10L,
    dataFractions  = 1L,
  ),
  unrated,
  waiter_show_on_load(splash_screen, color = "#FFFFFF")
)

server <- function(input, output, session) {

  waiter::waiter_show(splash_screen, color = "#FFFFFF")

  observe(js$cookie(session$token))

  current_photo <- future::future(get_photo_link())
  output$new_bird <- renderUI(current_photo)

  observeEvent(
    input$start,
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
    input$about_link,
    {
      shinyalert::shinyalert(
        content$about$title,
        paste(content$about$body, collapse = "\n\n"),
        type = "info",
        confirmButtonText = "\u2192",
      )
    }
  )

  observeEvent(
    input$faq_link,
    {
      shinyalert::shinyalert(
        content$faq$title,
        paste(content$faq$question_1, collapse = "\n\n"),
        type = "info",
        confirmButtonText = "\u2192",
      )
    }
  )

  has_button <- FALSE

  observeEvent(
    input$rating,
    if (!has_button && as.integer(input$rating) > 0L) {
      removeUI("#unrated-container")
      insertUI(
        "#rating", "afterEnd",
        div(
          actionLink("rated", content$main_page$new_bird),
          id = "rated-container"
        )
      )
      has_button <<- TRUE
    },
    ignoreInit = TRUE
  )

  observeEvent(
    input$rated,
    {

      current_rating <- input$rating

      promises::then(
        current_photo,
        function(x) {
          submission         <- attr(x, "metadata")
          submission$rating  <- as.integer(current_rating)
          submission$time    <- as.integer(Sys.time())
          submission$session <- session$token
          submission$user    <- input$jscookie
          future::future(
            httr::RETRY(
              "GET",
              url   = "http://submit:8000/submit",
              query = submission
            )
          )
        }
      )

      removeUI("#rated-container")
      insertUI("#rating", "afterEnd", unrated)
      has_button <<- FALSE
      session$sendInputMessage("rating", list(value = 0L))
      js$reset_hearts(0L)
      current_photo <<- future::future(get_photo_link())
      output$new_bird <- renderUI(current_photo)

    },
    ignoreInit = TRUE
  )

}

shinyApp(ui = ui, server = server)
