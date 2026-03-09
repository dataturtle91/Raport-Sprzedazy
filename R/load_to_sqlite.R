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
      user_id INTEGER,
      date TEXT,
      sum REAL,
      is_paid TEXT
    );
  "
    dbExecute(con, create_query)
    
    # 3. Wykorzystanie zapytania INSERT OR IGNORE
    # Ta metoda sprawdzi każdy rekord: jeśli order_id istnieje, pominie go.
    query <- "INSERT OR IGNORE INTO orders (order_id,user_id,date, sum, is_paid) VALUES (?, ?, ?, ?, ?)"
    
    # Wykonanie zapytania dla całej ramki danych
    dbExecute(con, query, params = list(input_df$order_id,
                                        input_df$user_id,
                                        as.character(input_df$date), 
                                        input_df$sum,
                                        as.character(input_df$is_paid)))
    
    message("Proces ładowania zakończony.")
}