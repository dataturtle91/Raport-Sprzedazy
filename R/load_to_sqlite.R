library(DBI)
library(RSQLite)

load_to_sqlite <- function(input_df, db_path = params$database) {
    
    # 1. Nawiązanie połączenia z bazą danych
    con <- dbConnect(RSQLite::SQLite(), db_path)
    
    # Zamknięcie połączenia automatycznie po zakończeniu funkcji
    on.exit(dbDisconnect(con))
    
    # 2. Tworzenie tabeli, jeśli jeszcze nie istnieje
    # Dodajemy PRIMARY KEY na order_id, co uniemożliwi duplikację
    create_query <- "
    CREATE TABLE IF NOT EXISTS orders (
      order_id INTEGER PRIMARY KEY,
      date TEXT,
      sum REAL
    );
  "
    dbExecute(con, create_query)
    
    # 3. Wykorzystanie zapytania INSERT OR IGNORE
    # Ta metoda sprawdzi każdy rekord: jeśli order_id istnieje, pominie go.
    query <- "INSERT OR IGNORE INTO orders (order_id, date, sum) VALUES (?, ?, ?)"
    
    # Wykonanie zapytania dla całej ramki danych
    dbExecute(con, query, params = list(input_df$order_id, 
                                        as.character(input_df$date), 
                                        input_df$sum))
    
    message("Proces ładowania zakończony.")
    
    
    # 4. Pobranie liczby dodanych rekordów
    # Funkcja changes() zwraca liczbę wierszy wstawionych w ostatnim kroku
    added_count <- dbGetQuery(con, "SELECT changes()")[[1]]
    
    # Obliczenie pominiętych rekordów
    total_input <- nrow(input_df)
    ignored_count <- total_input - added_count
    
    # Komunikat dla użytkownika
    message(sprintf("Operacja zakończona sukcesem!"))
    message(sprintf("- Przekazano do przetworzenia: %d", total_input))
    message(sprintf("- Nowo dodanych rekordów: %d", added_count))
    message(sprintf("- Pominiętych duplikatów: %d", ignored_count))
    
    return(invisible(added_count)) # Zwraca liczbę dodanych wierszy po cichu
}