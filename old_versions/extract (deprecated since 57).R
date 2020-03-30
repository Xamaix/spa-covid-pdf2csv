#install.packages("tabulizer")
Sys.setenv(JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_241.jdk/Contents/Home")
library(tidyverse)
library(tabulizer)
library(lubridate)
# CONFIG ---------------------------------

# Càlcul del número d'informe
n_informe = 55 + floor(as.numeric(
  ymd_hms(paste0(today("GMT")," 16:00:00"),tz="GMT")
  - ymd_hms("2020-03-25 16:00:00", tz="GMT")))


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

# EDAT DONES -----------------------------
edat_dones <- taules[[2]][19:28,c(1:4,8)] %>% 
  separate(col="X.1", sep = " ", into = "X.1", remove = TRUE) %>%
  data.frame(row.names = NULL)
colnames(edat_dones) <- edat_cols

# EDAT HOMES -----------------------------
edat_homes <- taules[[2]][35:44,c(1:4,8)] %>% 
  separate(col="X.1", sep = " ", into = "X.1", remove = TRUE) %>%
  data.frame(row.names = NULL)
colnames(edat_homes) <- edat_cols

# AJUSTOS: DECIMALS, SEP.MILERS ----
sets <- list("ccaa" = ccaa,"edat_total"= edat_total,"edat_homes"= edat_homes,"edat_dones"= edat_dones)

# eliminar els '.' a tots els data.frames
for (i in names(sets)){
  sets[[i]] <- sapply(sets[[i]], function(v) {gsub("\\.","", as.character(v))}) %>%
    as.data.frame(row.names = 1)
}

# substituir ',' per '.' a `ccaa`
sets[[1]][,3] <- sapply(sets[[1]][,3], function(x) gsub(",",".",x)) %>% as.numeric()




# EXPORTAR CSVs --------------------------
for(i in names(sets)) {
  write_delim(
    sets[[i]], 
    paste0("./exports/",n_informe,"_",i,".csv"),
    delim = ",")
}

