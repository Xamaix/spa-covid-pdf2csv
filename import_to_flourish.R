# ------------------------------------------------
# https://docs.google.com/spreadsheets/d/1k6bdBFv2GRGzkMrYiO733AJ7F_PSNa8RDT9mjpbMQss/edit#gid=361639649
# 
# tqx=out:html
# https://docs.google.com/spreadsheets/d/1k6bdBFv2GRGzkMrYiO733AJ7F_PSNa8RDT9mjpbMQss/gviz/tq?tqx=out:csv&sheet=ca_ho_al_uc_fa_long
# 
# Response Format: Options include tqx=out:csv (CSV format), tqx=out:html (HTML table), and tqx=out:json (JSON data).
# -----
library(tidyverse)
library(RSelenium)
library(httr)
# CAPTEM LES DADES D'UN GOOGLE SHEETS -----------
    csv_url <- "https://docs.google.com/spreadsheets/d/1k6bdBFv2GRGzkMrYiO733AJ7F_PSNa8RDT9mjpbMQss/gviz/tq?tqx=out:csv&sheet=ca_ho_al_uc_fa_long"
    csv <- read_csv(csv_url) 
    write_delim(csv, path = "/Users/xavier/Desktop/digitalShift/covidSPApdf2csv/.venv/data.csv", delim = ",")
    csv_path = "/Users/xavier/Desktop/digitalShift/covidSPApdf2csv/.venv/data.csv"
# HEADLESS BROWSER -------------------------------
    rd  <- rsDriver(port = 4445L, browser="firefox")
    remDr <- rd[['client']]
    
# LOGIN    
    u <- "santsfogons@gmail.com"
    p <- "Santsfogons1."
    login_url <- "https://app.flourish.studio/login"
    remDr$navigate(url = login_url)
    
    ## Omplim usuari
    webElem <- remDr$findElement("name","email")
    webElem$sendKeysToElement(list(u))
    
    ## Omplim clau
    webElem <- remDr$findElement("name","password")
    webElem$sendKeysToElement(list(p))
    
    ## Cliquem login
    webElem <- remDr$findElement("xpath","//input[@value='Log in']")
    webElem$clickElement()
    Sys.sleep(5)
    remDr$getAllCookies()
    
    ## Confirmem login correcte
    webElem <- remDr$findElement("id","projects-header")
    webElem$getElementText()
    }
    
# NAVEGUEM AL CONTINGUT --------------------------
    
  
    csv_upload_test <- csv_upload(remDr = remDr, csv_path = csv_path)
    
    url <- "https://app.flourish.studio/visualisation/1770186/edit"
    remDr$navigate(url = url)
    
    clickToData <- "//button[@name='show-pane'][2]"
    webElem <- remDr$findElement("xpath",clickToData)
    webElem$clickElement()
    
    
# PUJAR EL FITXER
    authenticate(u,p)
    set_cookies(str(cookies))
    
    POST("https://app.flourish.studio/api/data_table/2722632/csv",
         set_config(config, override = FALSE))
    
    # csv_upload <- function(remDr, csv_path){
    #   tmpfile <- tempfile(fileext = ".zip")
    #   # zip file
    #   zip(tmpfile, csv_path)
    #   # base64 encode
    #   zz <- file(tmpfile, "rb")
    #   ar <- readBin(tmpfile, "raw", file.info(tmpfile)$size)
    #   encFile <- caTools::base64encode(ar)
    #   close(zz)
    #   qpath <- sprintf("%s/session/%s/file", remDr$serverURL, 
    #                    remDr$sessionInfo[["id"]])
    #   remDr$queryRD(qpath, "POST", qdata = list(file = encFile))
    #   # return result from server
    #   remDr$value
    # }
    # 
    # uploadData <- "//div[@id='spreadsheet-container']/div/span/span"
    # webElem <- remDr$findElement("xpath",uploadData)
    # webElem$sendKeysToElement(csv_upload_test)
    # webElem$clickElement()
    # remDr$refresh()    
    # 
    # 
    # 
    # testCsv <- tempfile(fileext = ".csv")
    # x <- data.frame(a = 1:4, b = 5:8, c = letters[1:4])
    # write.csv(x, testCsv, row.names = FALSE)
    # 
    # # post the file to the app
    # webElem$sendKeysToElement(list(testCsv))
    
    
    
    