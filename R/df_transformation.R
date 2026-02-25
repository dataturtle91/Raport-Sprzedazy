
prepare_df <- function(df) {
   df <-  df %>% select(order_id, date, sum)
}
