library(emayili)

send_kpi_email <- function(kpi_total_orders, kpi_aov, params){
    
    html_body <- paste0(
        "<h2>Raport sprzedaży</h2>",
        "<p>Liczba zamówień: ", kpi_total_orders, "</p>",
        "<p>Średnia wartość zamówienia: ", kpi_aov, "</p>"
    )
    
    email <- envelope() %>%
        from(params$user) %>%
        to(params$mail_to) %>%
        subject("Raport sprzedaży") %>%
        html(html_body)
    
    smtp <- server(
        host = params$host,
        port = 587,
        username = params$user,
        password = params$password,
        tls = TRUE
    )
    
    smtp(email)
    
}