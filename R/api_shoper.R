library(httr2)
library(jsonlite)

shoper_get <- function(endpoint, query = list()) {
    
    req <- request(paste0(params$shop_url, endpoint)) %>%
        req_headers(
            Authorization = paste("Bearer",params$token),
            Accept = "application/json"
        ) %>%
        req_url_query(!!!query)
    
    resp  <- req_perform(req)
    
    resp_body_json(resp,simplifyVector = TRUE)
}
