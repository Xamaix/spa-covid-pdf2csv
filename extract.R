#install.packages("tabulizer")
#install.packages("googlesheets4")

library(tidyverse)
library(tabulizer)
library(googlesheets4)
library(lubridate)

# CONFIG ---------------------------------

    # Càlcul del número d'informe
    n_informe = 56 + as.numeric(today("GMT") - ymd("2020-03-26"))

    # Url del número d'informe
    url <- paste0("https://www.mscbs.gob.es/profesionales/saludPublica/ccayes/alertasActual/nCov-China/documentos/Actualizacion_",n_informe,"_COVID-19.pdf")

    # Conversió de PDF a taules
    taules <- extract_tables(url, guess= TRUE, output = "data.frame", method = "stream")

# COMUNITATS AUTÒNOMES -------------------
    ccaa_cols <- c("ccaa","total", "incidencia_acum14d","hospital","uci", "morts","recuperats","nous")
    ccaa <- taules[[1]][-c(1:4), ] %>% data.frame(row.names = NULL) 
    colnames(ccaa) <- ccaa_cols

# EDAT TOTAL -----------------------------
    edat_cols <- c("edat","confirmats","hospitalitzats","uci", "morts")
    edat_total <- taules[[2]][3:12,c(1:4,8)] %>% 
      separate(col="X.1", sep = " ", into = "X.1", remove = TRUE) %>%
      data.frame(row.names = NULL)
    colnames(edat_total) <- edat_cols

# EDAT HOMES -----------------------------
    edat_homes <- taules[[2]][19:28,c(1:4,8)] %>% 
      separate(col="X.1", sep = " ", into = "X.1", remove = TRUE) %>%
      data.frame(row.names = NULL)
    colnames(edat_homes) <- edat_cols

# EDAT DONES -----------------------------
    edat_dones <- taules[[2]][35:44,c(1:4,8)] %>% 
      separate(col="X.1", sep = " ", into = "X.1", remove = TRUE) %>%
      data.frame(row.names = NULL)
    colnames(edat_dones) <- edat_cols

    
# EXPORTAR CSVs
    # CCAA with<
    sets <- list("ccaa" = ccaa,"edat_total"= edat_total,"edat_homes"= edat_homes,"edat_dones"= edat_dones)
    for(i in names(sets)) {
      write_delim(
        sets[[i]], 
        paste0("./exports/",i,"_",n_informe,".csv"),
        delim = ";")
      }

