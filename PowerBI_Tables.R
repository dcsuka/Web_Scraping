library(wdman)
library(RSelenium)

selServ <- selenium(
  port = 4444L,
  version = 'latest',
  chromever = '103.0.5060.134', # set to available
)

remDr <- remoteDriver(
  remoteServerAddr = 'localhost',
  port = 4444L,
  browserName = 'chrome'
)

scrape_powerbi_table <- function(container_number) {
  table_xpath <- paste("//*[@id='pvExplorationHost']/div/div/exploration/div/explore-canvas/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container[",
                       container_number, "]/transform/div/div[3]/div/visual-modern", sep = "")
  Sys.sleep(1)
  try({scroll_button <- remDr$findElement("xpath", paste(table_xpath, "/div/div/div[2]/div[4]/div[2]", sep = ""))
    remDr$mouseMoveToLocation(webElement = scroll_button)}, silent = TRUE)
  col_names <- remDr$findElements("xpath", paste(table_xpath, "/div/div/div[2]/div[1]/div[2]/div[2]/div/div", sep = ""))
  col_names <- vapply(col_names, function(x) stringr::str_split(x$getElementAttribute('innerHTML')[[1]], "<")[[1]][1], character(1))
  df <- data.frame(matrix(ncol = length(col_names), nrow = 0))
  colnames(df) <- col_names
  more_rows_left <- TRUE
  row_count <- 2
  while (more_rows_left == TRUE) {
    data <- remDr$findElements("xpath", paste(table_xpath, "/div/div/div[2]/div[1]/div[4]/div/div[@aria-rowindex='", row_count, "']/div", sep = ""))
    current_row <- vapply(data, function(x) x$getElementAttribute('innerHTML')[[1]], character(1))
    current_row <- current_row[2:length(current_row)]
    if (length(current_row) == 0 | all(is.na(current_row))) {
      tryCatch({for (i in seq(10)) scroll_button$click()
        data <- remDr$findElements("xpath", paste(table_xpath, "/div/div/div[2]/div[1]/div[4]/div/div[@aria-rowindex='", row_count, "']/div", sep = ""))
        current_row <- vapply(data, function(x) x$getElementAttribute('innerHTML')[[1]], character(1))
        current_row <- current_row[2:length(current_row)]
        }, error = function (e) break)
    }
    if (length(current_row) == 0 | all(is.na(current_row))) {break}
    df[nrow(df) + 1,] <- current_row
    row_count <- row_count + 1
  }
  df
}

remDr$open()

remDr$navigate("https://app.powerbi.com/view?r=eyJrIjoiOGI5Yzg2MGYtZmNkNy00ZjA5LTlhYTYtZTJjNjg2NTY2YTlmIiwidCI6ImI1NDE0YTdiLTcwYTYtNGUyYi05Yzc0LTM1Yjk0MDkyMjk3MCJ9")
Sys.sleep(15)
next_button <- remDr$findElement("xpath", "//*[@id='embedWrapperID']/div[2]/logo-bar/div/div/div/logo-bar-navigation/span/button[2]")

df1 <- scrape_powerbi_table(8)
remDr$mouseMoveToLocation(webElement = next_button)
next_button$click()
df2 <- scrape_powerbi_table(8)
df3 <- scrape_powerbi_table(9)
remDr$mouseMoveToLocation(webElement = next_button)
next_button$click()
next_button$click()
df4 <- scrape_powerbi_table(5)
df5 <- scrape_powerbi_table(7)
remDr$mouseMoveToLocation(webElement = next_button)
next_button$click()
df6 <- scrape_powerbi_table(9)
df7 <- scrape_powerbi_table(10)
remDr$mouseMoveToLocation(webElement = next_button)
next_button$click()
next_button$click()
df8 <- scrape_powerbi_table(2)
remDr$mouseMoveToLocation(webElement = next_button)
next_button$click()
df9 <- scrape_powerbi_table(5)
df10 <- scrape_powerbi_table(6)

# > df9
#      Zona                      Provincia Total Establecimientos
# 1  ZONA 1                         CARCHI                      8
# 2  ZONA 1                     ESMERALDAS                      6
# 3  ZONA 1                       IMBABURA                     32
# 4  ZONA 1                      SUCUMBIOS                     27
# 5  ZONA 2                           NAPO                      9
# 6  ZONA 2                       ORELLANA                     30
# 7  ZONA 2                      PICHINCHA                     63
# 8  ZONA 3                     CHIMBORAZO                     56
# 9  ZONA 3                       COTOPAXI                     54
# 10 ZONA 3                        PASTAZA                     13
# 11 ZONA 3                     TUNGURAHUA                    122
# 12 ZONA 4                         MANABI                    127
# 13 ZONA 4 SANTO DOMINGO DE LOS TSACHILAS                     49
# 14 ZONA 5                        BOLIVAR                     24
# 15 ZONA 5                      GALAPAGOS                      5
# 16 ZONA 5                         GUAYAS                     27
# 17 ZONA 5                       LOS RIOS                     53
# 18 ZONA 5                    SANTA ELENA                     18
# 19 ZONA 6                          AZUAY                    182
# 20 ZONA 6                          CAÑAR                     35
# 21 ZONA 6                MORONA SANTIAGO                     23
# 22 ZONA 7                         EL ORO                     65
# 23 ZONA 7                           LOJA                     48
# 24 ZONA 7               ZAMORA CHINCHIPE                     16
# 25 ZONA 8                         GUAYAS                     86
# 26 ZONA 9                      PICHINCHA                    309