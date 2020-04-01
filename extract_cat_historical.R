install.packages("RSelenium")
library(RSelenium)
library(tidyverse)
library(rvest)
library(httr)
# ----- PER CONFIGURAR L'ENTORN DE SELENIUM -----
# Cal que s'executi un procés en servidor amb els binaris del 'webdriver' del navegador a utilitzar. 
# Des de R ens connectem al servidor i executem les comandes des de les llibreries de RSelenium per realitzar accions al navegador
# 
# `rsDriver` crea un servidor propi i executa un navegador del teu sistema //no requereix Docker

# `remoteDriver` es connecta a un servidor virtual (docker-machine) amb una imatge docker amb el navegador que escullis
#     brew install docker-machine docker   -- només el 1r cop 
#     docker pull {imatge}   -- només el 1r cop 
#     docker run -p 4444:4445 {imatge} 

# si s'executa el servidor des de rsDriver cal assignar-ho a una sub-variable des de la qual seleccionem que n'és el 'client' 
#     rd <- rsDriver(port = 4445L, browser = "firefox")
#     remDr <- rsDriver[['client']]
# --> És important tenir instal·lat el navegador definit en la última versió
# 
# si ho fem des de docker: 
# remDr <- remoteDriver(remoteServerAddr= "localhost" , port = 4430L, browser="phantomjs")
# -----------------------------------------------
headers = c("Host:wabi-north-europe-api.analysis.windows.net"
            ,"User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:74.0) Gecko/20100101 Firefox/74.0"
            ,"Accept: application/json, text/plain, */*"
            ,"Accept-Language: ca,en-US;q=0.7,en;q=0.3"
            ,"Accept-Encoding: gzip, deflate, br"
            ,"ActivityId: 7c744f75-1ab4-4a77-8963-1c1f7137a5b8"
            ,"RequestId: 6bbb5615-ddd6-1f67-4740-7a05ba9a23d0"
            ,"X-PowerBI-ResourceKey: e9257068-548b-4e84-9597-737da35a8921"
            ,"Content-Type: application/json;charset=UTF-8"
            ,"Content-Length: 1057"
            ,"Origin: https://app.powerbi.com"
            ,"Connection: keep-alive"
            ,"Referer: https://app.powerbi.com/view?r=eyJrIjoiZTkyNTcwNjgtNTQ4Yi00ZTg0LTk1OTctNzM3ZGEzNWE4OTIxIiwidCI6IjNiOTQyN2RjLWQzMGUtNDNiYy04YzA2LWZmNzI1MzY3NmZlYyIsImMiOjh9")

data$content<- GET(url, add_headers(headers))

# SERVIDOR: START -------------------------------
# Utilitzem la instància que té incorporada RSelenium, obre una finestra Firefox
    rd  <- rsDriver(port = 4444L, browser="firefox")
    remDr <- rd[['client']]

# NAVEGUEM AL CONTINGUT
    url <- "https://app.powerbi.com/view?r=eyJrIjoiZTkyNTcwNjgtNTQ4Yi00ZTg0LTk1OTctNzM3ZGEzNWE4OTIxIiwidCI6IjNiOTQyN2RjLWQzMGUtNDNiYy04YzA2LWZmNzI1MzY3NmZlYyIsImMiOjh9"
    remDr$navigate(url = url)
    Sys.sleep(5)
    
    
    # Per regió sanitària
    webElemMunicipi <- remDr$findElement("xpath","//exploration-host[@id='pvExplorationHost']/div/div/exploration/div/explore-canvas-modern/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container-modern/transform/div/div[3]/visual-modern/div/button")
    webElemMunicipi$clickElement()
    webElem <- remDr$findElement("css", ".bodyCells > div:nth-child(1) > div:nth-child(1) > div:nth-child(2)")
    municipi <- webElem$getElementText()
    
    
    chk <- FALSE
    while(!chk){
      webElem <- remDr$findElements("css", ".js-infinite-marker")
      if(length(webElem) > 0L){
        tryCatch(
          remDr$executeScript("elem = arguments[0]; 
                      elem.scrollIntoView(); 
                        return true;", list(webElem[[1]])), 
          error = function(e){}
        )
        Sys.sleep(1L),
      }else{
        chk <- TRUE
      }
    }
    
    
    
    webElemRegioSanitaria <- remDr$findElement("xpath","//exploration-host[@id='pvExplorationHost']/div/div/exploration/div/explore-canvas-modern/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container-modern/transform/div/div[3]/visual-modern/div/button")
    webElemRegioSanitaria$clickElement()
    readHTMLTable(doc)

