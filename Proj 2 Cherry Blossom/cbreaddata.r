library(rvest)

# Default the URI to the URI of the mens overall results
uri = "http://www.cballtimeresults.org/performances?utf8=%E2%9C%93&section=10M&&division=Overall+Men&year="

# Loops over every page with data for the selected year
#   uri - Web address of data source
#   year - Sets the query string parameter to the specified year
getResults <- function(uri, year = 1999) 
{
  page = 1
  url <- paste0(uri, '&year=',year,'&page=',page);
  
  results <- as.data.frame( read_html(url) %>%
                             html_nodes(xpath='//*[@id="performances-index"]/div/table') %>%
                             html_table());
  
  while( page < 500 )
  {
    page = page + 1;
    result <- as.data.frame( read_html(url) %>%
                              html_nodes(xpath='//*[@id="performances-index"]/div/table') %>%
                              html_table());

    if (nrow(result) == 0) return (results);
        
    results <- rbind(results, result);
    url <- paste0(uri, '&year=',year,'&page=',page);
    print.default(url,quote = FALSE)
  }
  return (results);
}

# Loops over the selected years and preserves each year's data in a csv file named MensResults{`year'}.csv
#   startyear : year to start at
#   endyear   : year to end at
getAll = function (startyear = 1999, endyear = 2012) {

  for (year in startyear:endyear) {
    mensResults = getResults(uri,year)
    fileName = paste0("MensResults",year,".csv")
    write.csv(mensResults, file = fileName)
  }

  write.csv(mensResults, file = "MensResults.csv")
}

