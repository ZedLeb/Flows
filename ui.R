library(shiny)          # for Shiny App
library(shinydashboard)
library(readxl)          # for data input
library(dplyr)           # for wrangling
library(stringr)
library(igraph)          # for graphing
library(googleVis)

source("FlowsFunctions.R", local = TRUE)
source("FlowsLoadData.R", local = TRUE, encoding = 'UTF-8')

shinyUI(dashboardPage(skin = "black",
                    dashboardHeader(),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Flux", tabName = "flux", icon = icon("dashboard")),
                        radioButtons("selSite", "Site : ", choices = list("GV", "BR"), selected = NULL),
                        selectInput("selForme", "Forme : ",
                                     choices = "",
                                     multiple = FALSE)
                        # selectInput("selFinish", "Finish : ",
                        #              choices = "",
                        #              multiple = FALSE, selected = NULL)
                        # selectInput("selSac", "Sac : ", 
                        #            choices = sacs$sac, 
                        #            multiple = FALSE, selected = NULL)
                      )
                    ),
                    dashboardBody(
                      box(
                        tags$style(type = "text/css", "#a {height: calc(80vh - 50px) !important;}"),
                        width = 12,
                        title = "Flux",  status = "warning", solidHeader = TRUE, collapsible = TRUE,
                        fillPage(htmlOutput("a"))
                   
                      ),
                      box(
                        tags$style(type = "text/css", "#a {height: calc(80vh - 50px) !important;}"),
                        width = 12,
                        title = "Filtered",  status = "warning", solidHeader = TRUE, collapsible = TRUE,
                        fillPage(htmlOutput("p"))                    
                      )
                      # box(
                      #   tags$style(type = "text/css", "#a {height: calc(40vh - 30px) !important;}"),
                      #   width = 12,
                      #   title = "Table",  status = "warning", solidHeader = TRUE, collapsible = TRUE,
                      #   div(style = 'overflow-y: scroll', tableOutput('t'))   
                      # )

                    )
))
