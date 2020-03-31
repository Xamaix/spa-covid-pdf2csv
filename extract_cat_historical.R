install.packages("RSelenium")
library(RSelenium)
library(tidyverse)

# PER CONFIGURAR L'ENTORN DE SELENIUM
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


# SERVIDOR: START
# Utilitzem la instància que té incorporada RSelenium, obre una finestra Firefox
rd  <- rsDriver(port = 4444L, browser="firefox")
  remDr <- rd[['client']]
remDr$open() 

# LLEGIM I FILTREM CONTINGUT I RETENIM EN OBJECTE
url <- "https://app.powerbi.com/view?r=eyJrIjoiZTkyNTcwNjgtNTQ4Yi00ZTg0LTk1OTctNzM3ZGEzNWE4OTIxIiwidCI6IjNiOTQyN2RjLWQzMGUtNDNiYy04YzA2LWZmNzI1MzY3NmZlYyIsImMiOjh9"
remDr$navigate(url = url)
webElemMunicipi <- remDr$findElement("xpath","//exploration-host[@id='pvExplorationHost']/div/div/exploration/div/explore-canvas-modern/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container-modern/transform/div/div[3]/visual-modern/div/button")
webElemMunicipi$clickElement()
Municipi <- remDr$getPageSource()
webElemRegioSanitaria <- remDr$findElement("xpath","//exploration-host[@id='pvExplorationHost']/div/div/exploration/div/explore-canvas-modern/div/div[2]/div/div[2]/div[2]/visual-container-repeat/visual-container-modern/transform/div/div[3]/visual-modern/div/button")
webElemRegioSanitaria$clickElement()

