
prepare_df <- function(df) {
   df <-  df %>% select(order_id,user_id, date, sum, is_paid)
}
