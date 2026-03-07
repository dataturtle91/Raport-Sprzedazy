
clean_memory <- function() {

# Usuń zbędne obiekty
rm(
    shoper_response,
    response_df,
    input_df,
    additional_page,
    additional_page_df,
    envir = .GlobalEnv
)
# Uruchom garbage collection
gc()

}
