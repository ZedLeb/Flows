library(shiny)          # for Shiny App
library(shinydashboard)
library(readxl)          # for data input
library(dplyr)           # for wrangling
library(stringr)
library(igraph)          # for graphing
library(googleVis)

source("FlowsFunctions.R", local = TRUE)
source("FlowsLoadData.R", local = TRUE, encoding = 'UTF-8')

shinyServer(function(input, output, session) {
  
  # Reactive inputs  
  site   <- reactive({input$selSite})
  forme  <- reactive({input$selForme})
  # finish <- reactive({input$selFinish})
  #sac    <- reactive({input$selSac})
  
  
  formeVar <- reactive({
    siteV <- input$selSite
    flux %>%
      filter(MldSite == siteV) %>%
      na.omit() %>%
      select(forme) %>%
      distinct() %>%
      arrange(forme)
      
  })
  
  observe({
    updateSelectInput(session, "selForme",
                      choices = formeVar()
    )})
  
  # finishVar <- reactive({
  #   formeV <- input$selForme
  #   flux %>%
  #     filter(forme == formeV) %>%
  #     na.omit() %>%
  #     select(finish) %>%
  #     distinct() %>%
  #     arrange(finish)
  # 
  # })
  # 
  # observe({
  #   updateSelectInput(session, "selFinish",
  #                     choices = finishVar()
  #   )})

  
  # Basic filter of site and form only
  form_site <- reactive({ 
    specified <- flux %>%
      filter(MldSite == site())%>%
      filter(forme == forme())
  })  
  
  # Reactive value for 'Flux' Sankey  (output$a)
  form_only <- reactive({
    spec <- form_site()
    createLinks(spec)
    
  })  
  
  # Filters based on all reactive inputs 
  filters <- reactive({ 
    specified <- flux %>%
      filter(MldSite == site())%>%
      filter(forme == forme()) #%>%
      #filter(finish == finishVar())# %>%
      #filter(str_detect(Description, sac()))
  })
  
  
  # Reactive value for 'Filtered' Sankey  (output$p)
  filtered <- reactive({
    spec <- filters()
    createLinks(spec)
    
  })
  
  
  
  # Output not currently used - considering a table of form_only
  # output$t <- renderTable({form_site()
  # 
  #   })
  
  
  
  output$a <- renderGvis({
    
    #Plot
    gvisSankey(form_only(), from="N1", to="N2", weight="freq",
               options=list(
                 width="100%",
                 height="100%",
                 sankey="{link:{colorMode: 'gradient',
                 color: { fill: ['#a6cee3', '#b2df8a', '#fb9a99', '#fdbf6f','#cab2d6', '#ffff99', '#1f78b4', '#cab2d6', '#ffff99', '#1f78b4', '#33a02c'],
                 fillOpacity: 0.8,
                 stroke: 'gray',
                 strokeWidth: 0.2}},
                 node:{nodePadding: 40,
                 width: 40,
                 color: { fill: '#a61d4c'},
                 label: { fontName: 'Calibri',
                 fontSize: 18,
                 color: '#871b47',
                 bold: true,
                 italic: false } }}"
               )
               )
    
    
    })# end render
  
  output$p <- renderGvis({
    
    #Plot
    gvisSankey(filtered(), from="N1", to="N2", weight="freq",
               options=list(
                 width=1500,
                 height=750,
                 sankey="{link:{colorMode: 'gradient',
                 color: { fill: ['#a6cee3', '#b2df8a', '#fb9a99', '#fdbf6f','#cab2d6', '#ffff99', '#1f78b4', '#cab2d6', '#ffff99', '#1f78b4', '#33a02c'],
                 fillOpacity: 0.8,
                 stroke: 'gray',
                 strokeWidth: 0.2}},
                 node:{nodePadding: 40,
                 width: 40,
                 color: { fill: '#a61d4c'},
                 label: { fontName: 'Calibri',
                 fontSize: 18,
                 color: '#871b47',
                 bold: true,
                 italic: false } }}"
               )
               )
    
    
    })# end render
  
  }) #end server



