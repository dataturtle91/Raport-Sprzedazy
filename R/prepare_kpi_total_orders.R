
prepare_kpi_total_orders <- function(db_path = params$database) {
# 1. Nawiązanie połączenia z bazą danych
con <- dbConnect(RSQLite::SQLite(), db_path)

# Zamknięcie połączenia automatycznie po zakończeniu funkcji
on.exit(dbDisconnect(con))

# Oblicz KPI total_orders

total_orders <- dbGetQuery(con,"
    SELECT COUNT (DISTINCT order_id) AS total_orders FROM orders
                  ")

total_orders <- as.integer(total_orders)

return(total_orders)

}