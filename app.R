#
# ShinyDialogSearch by Bob Hollen (bobhollenstats@gmail.com)
# 
# This small R Shiny application will provide a web interface to 
# search the corpus of all the scripts to display the episodes 
# and the context in which the keyword(s) were used, e.g. 
# find all the episodes in The Big Bang Theory scripts where 
# "cigarette" was used.
#
# Requirement(s):
#
#  A. quanteda is required to process the corpus file that will be searched
#  B. stringr is also required to construct the result string in which the
#     keyword is found
#  C. The corpus files will be read from a directory named "data"
#  D. The CSS file for the Shiny page is stored in the directory "www" with the
#     name of app.css
#
# Note(s)/Limitation(s):
#
#  1. This first version does not scrape the web for the content
#     to define the corpus to be queried, but instead expects that
#     this has already been performed and stored into an R object
#     that will be loaded in this application
#  2. Ideally this could be extended to search multiple shows or 
#     movies as long as these corpus files have been created and 
#     are capable of being loaded in this application
#
# Potential Enhancement(s):
#
#  1. Expand it so that multiple shows can be searched.  Maybe a 
#     combo box to switch between the available corpus files 
#  2. Currently the application is hardcoded for a context 
#     window of fifteen (15) words.  This would also be nice to
#     be able to allow the user to specify, maybe a slider 
#     with values between 3 and 20?
#

library(shiny)
library(quanteda)
library(stringr)

# Load the corpus to be searched, by default the first in the list below
#load(file='data/BobsBurgers.corpus.RData', .GlobalEnv)
#theShow.corpus <- BobsBurgers.corpus
load(file='data/TBBT.corpus.RData', .GlobalEnv)
theShow.corpus <- TBBT.corpus

# Define UI for application that will prompt the user
# for the keyword to search and then display the results
ui <- fluidPage(
  tags$head(tags$link(rel="stylesheet", type="text/css", href="app.css")),
  selectInput(inputId="corpusToSearch", label="Select corpus to search:", choices=c("The Big Bang Theory","Bob's Burgers"), selected="The Big Bang Theory", multiple=FALSE, width="50%"),
  textInput(inputId="textToSearch", label="Keyword:", value="Spock"),
  tableOutput("tableResults")
)

# Define server logic required to detect the change of the input
# keyword to search and then to search with kwic() to rdeport the
# results back to the user
server <- function(input, output) {
  observeEvent(input$textToSearch, {
    try({result <- kwic(theShow.corpus,phrase(input$textToSearch),window=15)}, silent = TRUE)
    try({
      if (length(result)>1) {
        odf <- data.frame(Episode=result[[1]], KeywordInContext=str_c(result[[4]]," [",result[[5]],"] ",result[[6]]))
        output$tableResults <- renderTable({odf})
      } else {
        output$tableResults <- renderTable({data.frame(Episode="---", KeywordInContext="Nothing found")})
      }}, silent = TRUE)
  })
  observeEvent(input$corpusToSearch, {
    if (input$corpusToSearch == "The Big Bang Theory") {
      load(file='data/TBBT.corpus.RData', .GlobalEnv)
      theShow.corpus <- TBBT.corpus
    } else if (input$corpusToSearch == "Bob's Burgers") {
      load(file='data/BobsBurgers.corpus.RData', .GlobalEnv)
      theShow.corpus <- BobsBurgers.corpus
    } else {
      print("Undefined")
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

