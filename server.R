#server.R

load('MovieDB.rda')
titles <- colnames(MovieDB)
ratings <- colMeans(MovieDB)

api_key <- "a04e44ac390066ec3937aefdd23be749"
config <- configuration(api_key)

getPoster <- function(title) {
  paste0(
    config$images$secure_base_url,
    "w185",
    search_movie(api_key, query = unlist(strsplit(title, "\\("))[1])$results$poster_path[1]
  )
}

shinyServer(function(input, output) {
  # Text for the 3 boxes showing average scores
  formulaText1 <- reactive({
    paste(input$select)
  })
  formulaText2 <- reactive({
    paste(input$select2)
  })
  formulaText3 <- reactive({
    paste(input$select3)
  })

  output$movie1 <- renderText({
    formulaText1()
  })
  output$movie2 <- renderText({
    formulaText2()
  })
  output$movie3 <- renderText({
    formulaText3()
  })


  # Table containing recommendations
  output$table <- renderTable({
    movie_recommendation <- function(input, input2, input3) {
      row_num <- which(titles == input)
      row_num2 <- which(titles == input2)
      row_num3 <- which(titles == input3)
      userSelect <- matrix(NA, length(titles))

      userSelect <- MovieDB[100, ]
      mat <- as(userSelect, "matrix")
      mat[1, 1:ncol(mat)] <- NA
      mat[row_num] <- 5 #hard code first selection to rating 5
      mat[row_num2] <- 4 #hard code second selection to rating 4
      mat[row_num3] <- 4 #hard code third selection to rating 4
      userSelect <- as(mat, "realRatingMatrix")

      #Create Recommender Model
      recommender_model <- Recommender(MovieDB, method = "UBCF")
      recom <- predict(recommender_model, userSelect, n = 10)
      recom_list <- as(recom, "list")
      recom_result <- data.frame(recom_list)
      colnames(recom_result) <-
        "User-Based Collaborative Filtering Recommended Titles"
      return(recom_result)
    }

    recommends <-
      movie_recommendation(input$select, input$select2, input$select3)
    recommends
  })

  output$tableRatings1 <- renderValueBox({
    movie.avg1 <- ratings[input$select]

    valueBox(
      value = format(movie.avg1, digits = 3),
      subtitle = input$select,
      icon = if (movie.avg1 >= 3)
        icon("thumbs-up")
      else
        icon("thumbs-down"),
      color = if (movie.avg1 >= 3)
        "aqua"
      else
        "red"
    )

  })

  output$tableRatings2 <- renderValueBox({
    movie.avg2 <- ratings[input$select2]

    valueBox(
      value = format(movie.avg2, digits = 3),
      subtitle = input$select2,
      icon = if (movie.avg2 >= 3)
        icon("thumbs-up")
      else
        icon("thumbs-down"),
      color = if (movie.avg2 >= 3)
        "aqua"
      else
        "red"
    )
  })

  output$tableRatings3 <- renderValueBox({
    movie.avg3 <- ratings[input$select3]

    valueBox(
      value = format(movie.avg3, digits = 3),
      subtitle = input$select3,
      icon = if (movie.avg3 >= 3)
        icon("thumbs-up")
      else
        icon("thumbs-down"),
      color = if (movie.avg3 >= 3)
        "aqua"
      else
        "red"
    )
  })

  output$ui <- renderUI({
    poster1 <- paste0(
      config$images$secure_base_url,
      "w185",
      search_movie(api_key, query = unlist(strsplit(
        input$select, "\\("
      ))[1])$results$poster_path[1]
    )

    poster2 <- paste0(
      config$images$secure_base_url,
      "w185",
      search_movie(api_key, query = unlist(strsplit(
        input$select2, "\\("
      ))[1])$results$poster_path[1]
    )

    poster3 <- paste0(
      config$images$secure_base_url,
      "w185",
      search_movie(api_key, query = unlist(strsplit(
        input$select3, "\\("
      ))[1])$results$poster_path[1]
    )

    htmlTemplate(
      "component.html",
      name = "component1",
      movie.image1 = poster1,
      movie.image2 = poster2,
      movie.image3 = poster3
    )
  })

  # Generate a table summarizing each players stats
  output$myTable <- renderDataTable({
    movies[c("title", "genres")]
  })

})
