library(config)
library(tidyverse)

params <- config::get()

#-------------------
# I. ŁADOWANIE ZAMÓWIEŃ

## Pobierz zamówienia

source("R/api_shoper.R")

shoper_response <- shoper_get('orders')
response_df <- data.frame()

for (i in 1:shoper_response$pages){
  additional_page <- shoper_get('orders',
                     query = list(page = i))
  additional_page_df <- as.data.frame(additional_page$list)
  response_df <- bind_rows(response_df, additional_page_df)
}


## Przygotuj ramkę danych do załadowania do bazy

source("R/df_transformation.R")
input_df <- prepare_df(response_df)

## Załaduj dane do bazy

source("R/load_to_sqlite.R")
load_to_sqlite(input_df)

## Usuń zbędne obiekty po załadowaniu danych i uruchom garbage collector

# source("R/clean_memory.R")
# clean_memory()



#---------------

# II. OBLICZANIE KPI I TWORZENIE WYKRESÓW

## Oblicz KPI na podstawie danych z bazy

### AOV

source("R/prepare_kpi_aov.R")
kpi_aov <- prepare_kpi_aov()


### MEDIAN OF VALUE

source("R/prepare_kpi_median_of_value.R")
kpi_mov <- prepare_kpi_mov()

### TOTAL ORDERS
source("R/prepare_kpi_total_orders.R")
kpi_total_orders <- prepare_kpi_total_orders()






#----------------
# III.  WYSYŁKA RAPORTU

library(emayili)


## HTML maila
html_body <- paste0(
    "<h2>Raport sprzedaży</h2>",
    "<p> Liczba zamówień ",kpi_total_orders,"</p>",
    "<p> Średnia wartość zamówienia: ",kpi_aov, "</p>",
    "<p> Mediana wartości zamówienia: ",kpi_mov, "</p>"
)


## Email
email <- envelope() %>%
    from(params$user) %>%
    to(params$mail_to) %>%
    subject("Raport sprzedaży") %>%
    html(html_body)



## Konfiguracja SMTP

smtp <- server(
    host = params$host,
    port = 587,
    username = params$user,
    password = params$password
)

## Wysyłka 

smtp(email)







