
prepare_kpi_mov <- function(db_path = params$database) {
# 1. Nawiązanie połączenia z bazą danych
con <- dbConnect(RSQLite::SQLite(), db_path)

# Zamknięcie połączenia automatycznie po zakończeniu funkcji
on.exit(dbDisconnect(con))

# Oblicz KPI AOV

orders_value <- dbGetQuery(con,"
    SELECT sum FROM orders;
                  ")

median_of_value <- median(orders_value$sum)

return(median_of_value)
}