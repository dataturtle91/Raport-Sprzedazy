library(config)
library(tidyverse)

params <- config::get()


# Pobierz zamowienia
source("R/api_shoper.R")

shoper_response <- shoper_get('orders')
response_df <- as.data.frame(shoper_response$list)



# Przygotuj ramke danych do zaladowania do bazy
source("R/df_transformation.R")
input_df <- prepare_df(response_df)

# Załaduj dane do bazy

source("R/load_to_sqlite.R")
load_to_sqlite(input_df)




