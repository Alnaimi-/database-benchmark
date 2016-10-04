ipak <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE, repos='http://cran.us.r-project.org')
  sapply(pkg, require, character.only = TRUE)
}

# list of packages needed, apssed to ipak
packages <- c("shiny", "ggplot2", "devtools", "plotly")
ipak(packages)

# Define server logic required to plot various variables against mpg
server <- function(input, output) {
  # load class functions
  source("result_loader.R")
  
  # load result data from dir
  m.data <- load_mdata()    
  q.times <- load_qtimes()
  
  sliderValues <- reactive({
    values <- list()
    
    values$sele <- input$select
    values$migr <- input$migr
    values$qnum <- input$qnum
    values$fit  <- input$fit
    
    values
  })
  
  output$plot <- renderPlotly({
    val <- sliderValues()
    
    # Check selected list item
    if (val$sele == 1) { # data migration
      if(val$migr == 1) { # migration time
        p <- migr_times(m.data[["time"]])
      }
      if(val$migr == 2) { # database size
        p <- data_size(m.data[["size"]])
      }
    }
    
    if (val$sele == 2) { # query execution
      df <- q.times[[val$qnum]]
      fi <- val$fit
      p <- exec_times(df, fi)
    }
    
    # p$x$layout$annotations[[6]]$text <- ""
    m = list(l = 70, r = 80, b = 40, t = 80)
    p %>% layout(margin = m)
  })
  
  output$text <- renderText({
    val <- sliderValues()

    if(val $sele == 2) { # query execution
      "Note that missing graphs/points indiciate a timeout ( > 6 hours)."
    }
  })
}


# Define UI for miles per gallon application
ui <- shinyUI(fluidPage(
  title = "Execution times",
  plotlyOutput("plot"),
  textOutput("text"),
  
  # Sidebar with controls to select the variable to plot against mpg
  # and to specify whether outliers should be included
  fluidRow(
    column(3,
      h4("Benchmark Metrics"),
      selectInput("select", label = "Show results for", choices = list("Data migration" = 1, "Query execution" = 2), selected = 1),
      
      conditionalPanel(
        condition = "input.select == 1",
        selectInput("migr", label = "Option", choices = list("Migration time" = 1, "Database size" = 2), selected = 1)
      ),
      
      conditionalPanel(
        condition = "input.select == 2",
        selectInput("qnum", label = "Query", choices = list('2' = 2, '6' = 6, '8' = 8, '9 hop 1' = "9multihop1",
          '9 hop 2' = "9multihop2", '9 hop 3' = "9multihop3", '9 hop 4' = "9multihop4", '9 hop 5' = "9multihop5",
          '11' = 11), selected = 2),
        selectInput("fit", label = "Fit model", choices = list('None' = 1, 'Linear' = 2, 'Loess' = 3), selected = 1)
      )
    )
  )
))

# Running the Shiny app object with conf
app <- shinyApp(ui = ui, server = server)
runApp(appDir = app, port = getOption("shiny.port", 7831), host = getOption("shiny.host", "0.0.0.0"))
