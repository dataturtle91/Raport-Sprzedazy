library(config)
library(tidyverse)

params <- config::get()


# Pobierz zamowienia

source("R/api_shoper.R")

shoper_response <- shoper_get('orders')
response_df <- data.frame()

for (i in 1:shoper_response$pages){
  additional_page <- shoper_get('orders', 
                     query = list(page = i))
  additional_page_df <- as.data.frame(additional_page$list)
  response_df <- bind_rows(response_df, additional_page_df)
}


# Przygotuj ramke danych do zaladowania do bazy

source("R/df_transformation.R")
input_df <- prepare_df(response_df)

# Załaduj dane do bazy

source("R/load_to_sqlite.R")
load_to_sqlite(input_df)




