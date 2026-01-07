# Comparing ECB and Federal Reserve Rate Policies using the FRED Database

## Overview
This project compares the monetary policy rates of the **European Central Bank (ECB)** and the **US Federal Reserve**. It serves as a practical demonstration of how to programmatically fetch, clean, and visualize economic data using the [FRED API](https://fred.stlouisfed.org/) and the `fredr` package.

## Features
* **FRED API Integration:** Shows how to search for series and fetch data using `fredr`.
* **Data Wrangling:** Filters data to focus on the post-2008 financial crisis era.
* **Analysis:** Identifies and highlights the specific timeline of the ECB's negative interest rate policy.
* **Visualization:** Produces a publication-ready `ggplot2` visualization (`rate_policies.pdf`) comparing the federal funds rate against the ECB's rates.

## Dependencies
* R
* `tidyverse` (Data manipulation & plotting)
* `fredr` (FRED API Client)

## Setup & Usage
1.  **Get an API Key:** Request a free API key from [fred.stlouisfed.org](https://fred.stlouisfed.org/docs/api/api_key.html).
2.  **Configure:** Uncomment the setup line in the script and insert your key:
    ```r
    # fredr::fredr_set_key("YOUR_API_KEY_HERE")
    ```
3.  **Run:** Execute the script to fetch the latest data and generate the plot.
