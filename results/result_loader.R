# define the set of data we have
queries <- c(2,6,8,"9multihop1","9multihop2","9multihop3","9multihop4","9multihop5",11)
dataset <- c("1G", "3G", "10G", "30G", "100G")
databas <- c("neo4j", "vertica", "sqlgraph")
tuneset <- c("untuned", "tuned")

# Function to load migraiton time for respective db
load_mdata <- function() {
  # Create a Progress object
  progress <- shiny::Progress$new()
  # Make sure it closes when we exit this reactive, even if there's an error
  on.exit(progress$close())
  progress$set(message = "Loading migration data", value = 0)

  data <- list() # list to return

  m.times <- data.frame(time=integer(), size=character(), database=character())
  m.sizes <- data.frame(store=integer(), size=factor(), database=character())
  count <- 0

  for(db in seq_along(databas)) {
    file <- paste(c("raw/", databas[db], "/migration_time.csv"), collapse = "")
    times <- read.table(file, sep = ",")

    # Melt the migraiton times together
    m.times <- rbind(m.times, data.frame(time = times[[2]], database = rep(databas[db], length(times[[1]])), size = times[[1]]))

    file <- paste(c("raw/", databas[db], "/migration_size.csv"), collapse = "")
    sizes <- read.table(file, sep = ",")
    sizes[[2]] <- sizes[[2]]/(1024*1024*1024)

    # Melth the migration size togethe
    m.sizes <- rbind(m.sizes, data.frame(store = sizes[[2]], database = rep(databas[db], length(sizes[[1]])), size = sizes[[1]]))

    # Increment the progress bar, and update the detail text.
    count <- count + 1
    progress$inc(1/(db), detail = paste("part", count, "/", db))
  }

  data[["time"]] <- m.times
  data[["size"]] <- m.sizes
  data
}

# Function to load execution times for queries
load_qtimes <- function() {
  progress <- shiny::Progress$new()
  on.exit(progress$close())
  progress$set(message = "Loading execution data", value = 0)
  
  q.times <- list()
  count <- 0
  
  for(quer in seq_along(queries)) {
    # Create an empty dataframe containing the execution times
    df.times <- data.frame(time=integer(), size=character(), database=character(), tune=character())
    
    for(size in seq_along(dataset)) {
      for(db in seq_along(databas)) {
        for(tu in seq_along(tuneset)) {
          # Remove if else and follow folder structure if Vertica / SQL is tuned.
          if((databas[db] == "sqlgraph" || databas[db] == "vertica") && tuneset[tu] == "tuned") { break; }
          else {
            file <- paste(c("raw/", databas[db], "/", tuneset[tu], "/", dataset[size], "/result_query", queries[quer]), collapse = '')
            times <- mean(read.csv(file, header = F, skip = 2)[, 2]) # opt to use log10 scale to dampen the values and get the mean average
            #times <- times[!(times >= 20000000)]
            
            sx <- as.numeric(gsub("G", "", dataset[size]))
            df.times <- rbind(df.times, data.frame(time = times, database = databas[db], size = sx, tun = tuneset[tu]))
          }
          # Increment the progress bar, and update the progess text
          count <- count + 1
          progress$inc(1/(quer*size*db*tu), detail = paste("part", count, "/", 9*5*3*2))
        }
      }
    }
    
    q.times[[queries[quer]]] <- df.times
  }
  
  q.times
}

# Returns the independent migration time from csv to database
# The fastest available method was utilised for respective framework
migr_times <- function(df) {
  gg <- ggplot(df, aes(x = factor(size), y = time, color = database)) +
    geom_point(size = 1.5, alpha = 0.8) + # set point size and transparency
    facet_wrap(~database) + 
    scale_x_discrete(limits=paste(dataset, "B", sep = '')) + # reorder by size discrete
    ggtitle("Database migration time") +
    ylab("\nMigration time in sec") + xlab("LDBC dataset size")

  ggplotly(gg)
}


# Returns the independent migration time from csv to database
# The fastest available method was utilised for respective framework
data_size <- function(df) {
  gg <- ggplot(df, aes(x = factor(size), y = store, color = database)) +
    geom_point(size = 1.5, alpha = 0.8) + # set point size and transparency
    facet_wrap(~database) + 
    scale_x_discrete(limits=paste(dataset, "B", sep = '')) + # reorder by size discrete
    ggtitle("Stored databse size") +
    ylab("\nDatabase size in GB") + xlab("LDBC dataset size")
  
  ggplotly(gg)
}

# Returns the independent execution times for each query across to 
# compare across multiple databases
exec_times <- function(df, fit) {
  # Omit any rows that timedout
  df$time[df$time >= 21600000] <- NA
  df <- na.omit(df)
  
  # Scale the values accordingly
  if(min(df$time > 4500)) {
    df$time <- df$time / 1000
    ylab <- "sec"
  } else { ylab <- "msec" }
  
  gg <- ggplot(df, aes(x=size, y=time, color=tun)) +
    geom_point(size = 1.5, alpha = 0.8) + # set point size and transparency
    facet_wrap(~database) +
    ggtitle("Query execution times") +
    ylab(paste("Execution time in ", ylab, sep='')) + xlab("Dataset size") +
    scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) 
  
  if(fit != 1) {
    gg <- gg +
      # Use loess fit without confidence region, i.e. se = F
      stat_smooth(method = if(fit == 2) lm else loess, size = 0.5, se = F)
  }

  ggplotly(gg)
}