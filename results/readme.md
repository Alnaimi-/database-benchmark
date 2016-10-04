#Acquired results

Following folder contains acquired results from the comparative benchmarks between [Vertica, SqlGraph and Neo4J]. The source code for respective benchmark may be found under the master branch. These results may either be browsed in raw text format or ran as part of a GUI style R-shinyapp.

##Script Structure
```html
GUI\app.R           : Main shinyapp script, containing both server and ui.
   \result_loader.R : Utiltiy script for loading and parsing the results.
   \results\        : Directory containing benchmark results in raw txt format.
```

##Quick Start
To setup the shinyapp server make sure that R base latest version is installed. Then simply cd into the script folder and run following command in terminal.

```bash
Rscript app.R
```

The above will create and setup a Shiny app server which may be accessible on 0.0.0.0:8737. To change default subnet mask and port number simply open up the file *app.R*, navigate to the bottom where the shiny object is created, and change the corresponding passed arguments.

Alternatively, you may also run the attached script files in Rstudio. Just make sure to set the working directory to that of the source file. This can be accessed under session settings.

##Observations

Due to the large number of combinations (queries, dataset, storage size, etc.) we believe that grouping and displaying the results as part of a graphical user interface would allow for a more organized display. As explained above, the result set have also been given in raw format. This is for anyone that wish to manipulate or display the result in the form that they wish.

It's worth noting that all query execution times are an acquired mean average, ignoring the first run (to allow for a fair comparison eliminating cache and warm up time). Additionally, any query result set with an execution time of 21600000 indicates a timeout. These queries are omitted from the dataframe and are chosen not to be displayed in the R script.

--------

* As a last note, any suggestions, improvement or contribution to the code base are sincerely welcome.
