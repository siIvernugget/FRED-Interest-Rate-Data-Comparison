# Comparing ECB Rates with the Federal Funds Rate

library(fredr)
library(tidyverse)

# Set the API key: Remove "#" and insert key obtained from fred.stlouisfed.org
# to set the key for the CURRENT session:

# fredr::fredr_set_key("YOUR_API_KEY_HERE")

# Searching fed funds rate in the FRED database
ffr_search <- fredr::fredr_series_search_text(
  search_text = "federal funds rate",
  order_by = "popularity",
  sort_order = "desc",
  limit = 10
)

# Pull the data
ffr <- fredr::fredr(
  series_id = "DFF"
)



# Searching the ECB data via FRED
mror_search <- fredr::fredr_series_search_text(
  search_text = "ECB main refinancing operating rate",
  order_by = "popularity",
  sort_order = "desc",
  limit = 10
)

dfr_search <- fredr::fredr_series_search_text(
  search_text = "ecb deposit facility",
  order_by = "popularity",
  sort_order = "desc",
  limit = 10
)

mlfr_search <- fredr::fredr_series_search_text(
  search_text = "ecb marginal lending facility",
  order_by = "popularity",
  sort_order = "desc",
  limit = 10
)


# Pulling the data from the database
mlfr <- fredr::fredr(
  series_id = "ECBMLFR"
)

mror <- fredr::fredr(
  series_id = "ECBMRRFR"
)

dfr <- fredr::fredr(
  series_id = "ECBDFR"
)

# Filter for data >= 2008-10-15

ffr_filtered <- ffr |> 
  filter(date >= c("2008-10-15"))

mror_filtered <- mror |> 
  filter(date >= c("2008-10-15"))

mlfr_filtered <- mlfr |> 
  filter(date >= c("2008-10-15"))

dfr_filtered <- dfr |> 
  filter(date >= c("2008-10-15"))

View(ffr_filtered)
View(mror_filtered)


# Finding the time period during which the ECB's DFR was negative:
dfr |> 
  filter(value < 0) |> 
  summarise(
    start = min(as.Date(date)),
    end = max(as.Date(date))
   )

negative_dates <- data.frame(
  date = as.Date(c("2014-06-11", "2022-07-26"))
)


# Plot

ecb_fed <- ggplot() +
  geom_line(data = ffr_filtered, aes(x = as.Date(date), y = value,
                                     color = series_id)) +
  geom_line(data = mror_filtered, aes(x = as.Date(date), y = value,
                                      color = series_id)) +
  geom_line(data = mlfr_filtered, aes(x = as.Date(date), y = value,
                                      color = series_id)) +
  geom_line(data = dfr_filtered, aes(x = as.Date(date), y = value,
                                     color = series_id)) +
  geom_vline(data = negative_dates, aes(xintercept = date),
             linetype = "dashed") +
  annotate("rect",
      xmin = as.Date("2014-06-11"),
      xmax = as.Date("2022-07-26"),
      ymin = -Inf,
      ymax = 0,
      fill = "#03DFFC",
      alpha = 0.05
  ) +
  annotate("text",
           x = as.Date("2018-07-01"),
           y = -0.6,
           label = "Negative Deposit Facility Rate Period",
           size = 3) +
  scale_x_date(
    date_breaks = "1 year",
    date_labels = "%Y"
  ) +
  scale_y_continuous(
    breaks = seq(-1, 5, by = 0.5)
  ) +
  labs(
    x = "Date",
    y = "Rate (%)",
    title = "Rate Policy: ECB and Federal Reserve",
    subtitle = "A comprehensive comparison between both major Central Banks' Rate Policies",
    caption = "source: FRED"
  ) +
  scale_color_manual(
    values = c(
      "DFF" = "red",
      "ECBMRRFR" = "blue",
      "ECBDFR" = "#03DFFC",
      "ECBMLFR" = "#5C9DFF"
    ),
    name = "Rates",
    labels = c(
      "DFF" = "Federal Funds Rate",
      "ECBMRRFR" = "ECB Main Refinancing Operations Rate\n(MRO)",
      "ECBDFR" = "ECB Deposit Facility Rate\n(DFR)",
      "ECBMLFR" = "ECB Marginal Lending Facility Rate\n(MLFR)"
    )
  ) +
  theme(
    legend.text = element_text(margin = margin(b = 6))
  )

ecb_fed


width <- 20
height <- width * 9/16

ggsave("rate_policies.pdf", plot = ecb_fed, width = width, height = height, dpi = 300)

