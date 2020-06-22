library(future)
library(httr)
library(jsonlite)
library(promises)
library(shiny)
library(shinyalert)
library(shinyjs)
library(ShinyRatingInput)
library(waiter)

future::plan(multisession, workers = 4L)

default_lang   <- "fi"
available_lang <- list(Suomi = "fi", English = "en")

content <- function(x) {
  if (is.null(x)) x <- default_lang
  jsonlite::read_json(sprintf("content/%s.json", x[[1L]]))
}

get_photo_link <- function() {
  metadata <- list()

  candidates <- FALSE

  while (!any(candidates)) {
    metadata$code <- httr::RETRY("GET", url = "http://taxon:8000/taxon")
    httr::stop_for_status(metadata$code)
    metadata$code <-
      httr::content(metadata$code, "text", encoding = "UTF-8")
    metadata$code <-
      jsonlite::fromJSON(metadata$code, simplifyVector = FALSE)[[1L]]

    res <- httr::RETRY(
      "GET", url = "https://search.macaulaylibrary.org/api/v1/search",
      query = list(
        taxonCode = metadata$code, mediaType = "p", sort = "rating_rank_desc",
        count = 20L, clientapp = "BAR"
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
  shinyjs::extendShinyjs(
    "www/custom.js",
    functions = c(
      "cookie", "set_lang_cookie", "get_lang_cookie", "reset_hearts"
    )
  ),
  waiter::use_waiter(include_js = FALSE),
  titlePanel(htmlOutput("go_title"), "iratebirds"),
  htmlOutput("new_bird"),
  ShinyRatingInput::ratingInput(
    "rating",
    htmlOutput("rating_labels"),
    value = 0L,
    dataFilled="fa fa-heart",
    dataEmpty="fa fa-heart-o",
    dataStart = 0L,
    dataStop  = 10L,
    dataFractions  = 1L,
  ),
  div(id = "rating_space"),
  htmlOutput("unrated"),
  waiter::waiter_show_on_load(htmlOutput("splash"), color = "#FFFFFF")
)

server <- function(input, output, session) {

  observe(js$get_lang_cookie(default_lang))
  observe(js$cookie(session$token))

  chosen_lang <- reactive(content(input$jslang_cookie))

  output$splash <- renderUI(
    div(
      div(id = "splash-position"),
      div(id = "splash-main"),
      class = "splash-container"
    )
  )

  observeEvent(
    input$jslang_cookie,
    if (!is.null(input$jslang_cookie) && input$jslang_cookie != "") {
      removeUI("#splash-main")
      insertUI(
        "#splash-position", "afterEnd",
        {
          splash <- content(input$jslang_cookie)$landing$title
          div(
            h2(splash[[1L]], id = "splash-line1"),
            h2(splash[[2L]], id = "splash-line2"),
            h2(splash[[3L]], id = "splash-line3"),
            h2(splash[[4L]], id = "splash-line4"),
            actionLink("start", splash[[5L]]),
            div(
              selectInput(
                "lang_selector", "🌍", available_lang,
                selected = input$jslang_cookie, width = "120px"
              ),
              id = "lang-select"
            ),
          id = "splash-main"
          )
        }
      )
      observeEvent(
        input$lang_selector,
        if (!is.null(input$lang_selector) && input$lang_selector != "") {
          removeUI("#splash-line2")
          insertUI(
            "#splash-line1", "afterEnd",
            h2(content(input$lang_selector)$landing$title[[2L]], id = "splash-line2")
          )
        }
      )
      observeEvent(
        input$start,
        {
          shinyalert::shinyalert(
            content(input$lang_selector)$what$title,
            paste(content(input$lang_selector)$what$body, collapse = "\n\n"),
            type = "info",
            confirmButtonText = content(input$lang_selector)$what$go,
          )
          js$set_lang_cookie(input$lang_selector)
          waiter::waiter_hide()
        },
        ignoreInit = TRUE,
        once = TRUE
      )
    },
    ignoreInit = TRUE,
    once = TRUE
  )


  output$go_title <- renderUI(
    div(
      span(chosen_lang()$go$title[[1L]], class = "title"),
      span(
        actionLink("about_link", chosen_lang()$about$icon),
        actionLink("faq_link", chosen_lang()$faq$title),
        class = "about-faq"
      ),
      class = "title-about-faq"
    )
  )

  output$rating_labels <- renderUI(
    div(
      span(chosen_lang()$go$labels[[1L]], class = "left-rating-label"),
      span(chosen_lang()$go$labels[[2L]], class = "right-rating-label"),
      class = "rating-labels"
    )
  )

  unrated <- function() {
    div(
      span(chosen_lang()$go$this_bird, id = "unrated"), id = "unrated-container"
    )
  }

  output$unrated <- renderUI(unrated())

  current_photo <- future::future(get_photo_link())
  output$new_bird <- renderUI(current_photo)

  observeEvent(
    input$about_link,
    {
      shinyalert::shinyalert(
        chosen_lang()$about$title,
        paste(
          paste0(chosen_lang()$about$body, collapse = "<br><br>"),
          paste0(
            '<a class="survey-prompt-link", href="',
            chosen_lang()$survey$url, input$jscookie,
            '" target="_blank">',
            chosen_lang()$about$survey_request,
            '</a>'
          ),
          sep = "<br><br>"
        ),
        "info",
        html = TRUE,
        confirmButtonText = chosen_lang()$about$return
      )
    }
  )

  observeEvent(
    input$faq_link,
    {
      shinyalert::shinyalert(
        chosen_lang()$faq$title,
        paste(unlist(chosen_lang()$faq$questions), collapse = "\n\n"),
        type = "info",
        confirmButtonText = chosen_lang()$faq$return
      )
    }
  )

  has_button <- FALSE
  cntr <- 0L
  survey_prompt_happened <- FALSE

  observeEvent(
    input$rating,
    if (!has_button && as.integer(input$rating) > 0L) {
      removeUI("#unrated-container")
      insertUI(
        "#rating_space", "afterEnd",
        div(
          actionLink("rated", chosen_lang()$go$new_bird),
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
      insertUI("#rating_space", "afterEnd", unrated())
      has_button <<- FALSE
      session$sendInputMessage("rating", list(value = 0L))
      js$reset_hearts(0L)
      current_photo <<- future::future(get_photo_link())
      output$new_bird <- renderUI(current_photo)

      cntr <<- cntr + 1L

      if (!survey_prompt_happened && cntr > 1L && runif(1L) < 1L) {
        shinyalert::shinyalert(
          paste0(
            '<span id="survey-prompt-title">', chosen_lang()$survey$title,
            '</span>'
          ),
          paste0(
            '<span id="survey-prompt-request">', chosen_lang()$survey$request,
            '</span>'
          ),
          type = "info",
          html = TRUE,
          showCancelButton = TRUE,
          confirmButtonText = chosen_lang()$survey$confirm,
          cancelButtonText = chosen_lang()$survey$cancel,
          className = "survey-prompt",
          callbackJS = sprintf(
            "function(x) { if (x) { window.open('%s%s'); } }",
            chosen_lang()$survey$url, input$jscookie
          )
        )

        survey_prompt_happened <<- TRUE
      }

    },
    ignoreInit = TRUE
  )

}

shinyApp(ui = ui, server = server)
