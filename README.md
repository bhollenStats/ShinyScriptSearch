## ShinyScriptSearch

This small R Shiny application will provide a web interface to search the corpus of all the scripts to display the episodes and the context in which the keyword(s) were used, e.g. find all the episodes in The Big Bang Theory scripts where "cigarette" was used.

# Packages Required:

|shiny|quanteda|stringr|

# Notes and/or Limitations:

|1.|This first version does not scrape the web for the content to define the corpus to be queried, but instead expects that this has already been performed and stored into an R object that will be loaded in this application|
|2.|Ideally this could be extended to search multiple shows or movies as long as these corpus files have been created and are capable of being loaded in this application|


