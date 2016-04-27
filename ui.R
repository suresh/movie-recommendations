###################################################################################
## ui.R
# Team 10 - SS & HM
# Data Mining and Business Intelligence - 5671 Course
#
# Contains the user interface for movie recommendations
#
###################################################################################
library(shiny)
library(shinydashboard)
library(recommenderlab)
library(dplyr)
library(TMDb)

# Load the movie & ratings data
load('MovieDB.rda')
titles <- colnames(MovieDB)

shinyUI(dashboardPage(
  skin = "red",
  dashboardHeader(title = "Movie Recos"),
  dashboardSidebar(sidebarMenu(
    menuItem("Movies", tabName = "movies", icon = icon("star-o")),
    menuItem(
      "About",
      tabName = "about",
      icon = icon("question-circle")
    ),
    menuItem(
      "Source code",
      icon = icon("file-code-o"),
      href = "https://github.com/suresh/movie-recommendations"
    ),
    menuItem(list(
      selectInput(
        "select",
        label = h5("Select 3 Movies That You Like"),
        choices = as.character(titles[order(titles)]),
        selectize = FALSE,
        selected = "Shawshank Redemption, The (1994)"
      ),
      selectInput(
        "select2",
        label = NA,
        choices = as.character(titles[order(titles)]),
        selectize = FALSE,
        selected = "Forrest Gump (1994)"
      ),
      selectInput(
        "select3",
        label = NA,
        choices = as.character(titles[order(titles)]),
        selectize = FALSE,
        selected = "Silence of the Lambs, The (1991)"
      ),
      submitButton("Submit")
    ))
  )),


  dashboardBody(
    tags$head(
      tags$style(type = "text/css", "select { max-width: 360px; }"),
      tags$style(type = "text/css", ".span4 { max-width: 360px; }"),
      tags$style(type = "text/css",  ".well { max-width: 360px; }")
    ),

    tabItems(
      tabItem(tabName = "about",
              h2("About this App"),
              HTML('<br/>'),
              fluidRow(
                box(
                  title = "Author: Suresh Shanmugam",
                  background = "black",
                  width = 7,
                  collapsible = TRUE,
                  helpText(p(
                    strong(
                      "This application a movie recommender using the movielens dataset."
                    )
                  )),

                  helpText(
                    p(
                      "Please contact",
                      a(href = "https://twitter.com/suresh_p", "Suresh on twitter", target = "_blank"),
                      " or at my",
                      a(href = "http://sureshshanmugam.com/", "personal page", target = "_blank"),
                      ", for more information, to suggest improvements or report errors."
                    )
                  ),

                  helpText(
                    p(
                      "All code and data is available at ",
                      a(href = "https://github.com/suresh/", "my GitHub page", target = "_blank"),
                      "or click the 'source code' link on the sidebar on the left."
                    )
                  )
                )
              )),
      tabItem(
        tabName = "movies",
        fluidRow(uiOutput("ui")),
        fluidRow(
          valueBoxOutput("tableRatings1"),
          valueBoxOutput("tableRatings2"),
          valueBoxOutput("tableRatings3"),
          HTML('<br/>')
        ),
        fluidRow(
          box(
            width = 6,
            status = "info",
            solidHead = TRUE,
            title = "Other Movies You Might Like",
            fluidRow(uiOutput("ui2")),
            tableOutput("table")
          )
        )
      )
    )
  )
))
