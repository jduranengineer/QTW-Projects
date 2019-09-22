
library(rvest)
library(tidyverse)
library(mosaic)

uri = "http://www.cballtimeresults.org/performances?utf8=%E2%9C%93&section=10M&&division=Overall+Men&year="

getResults <- function(uri, year = 1999) 
{
  page = 1
  url <- paste0(uri, '&year=',year,'&page=',page);
  s <- rvest::html_session(url);
  
  while( page < 500 )
  {
    result <- as.data.frame( read_html(url) %>%
                              html_nodes(xpath='//*[@id="performances-index"]/div/table') %>%
                              html_table());

    if (nrow(result) == 0){
      return (results);
    }    
    results <- rbind(results, result);
    url <- paste0(uri, '&year=',year,'&page=',page);
    print.default(url,quote = FALSE)
    page = page + 1;
  }
  return (results);
}


getAll = function () {

  for (year in 1999:2014) {
    mensResults = getResults(uri,year)
    fileName = paste0("MensResults",year,".csv")
    write.csv(mensResults, file = fileName)
  }

  write.csv(mensResults, file = "MensResults.csv")
}

