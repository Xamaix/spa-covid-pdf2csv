install.packages("streamograph")
library(dplyr)
library(streamgraph)

csv %>%
  filter(grepl("An", CCAA)) %>%
  group_by(fecha, CCAA) %>%
  streamgraph("name", "n", "year")
