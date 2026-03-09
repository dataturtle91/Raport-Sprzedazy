
prepare_kpi_aov <- function(db_path = params$database) {
# 1. Nawiązanie połączenia z bazą danych
con <- dbConnect(RSQLite::SQLite(), db_path)

# Zamknięcie połączenia automatycznie po zakończeniu funkcji
on.exit(dbDisconnect(con))

# Oblicz KPI AOV

aov <- dbGetQuery(con,"
    SELECT ROUND(AVG(sum),2) AS total_aov FROM orders;
                  ")

aov <- as.double(aov)

return(aov)
}