####################################################################################
#	Project:       Forecasting Isolab Sales from Oct 2026 - Dec 2027
#
# Purpose:  	   Intership Task
####################################################################################
library(tidyverse)
library(tsibble)
library(fable)
library(feasts)
library(forecast)
library(readxl)
library(caret)

#Data
sales_data <- read_excel('Data/ISOLAB2025-2026.xlsx', sheet = '2025-2026 Sales') %>%
  mutate(Month = yearmonth(Date)) %>%
  group_by(Item_Code, Type,Month) %>%
  summarise(
    Quantity = sum(Quantity, na.rm = TRUE),
    Revenue  = sum(Amount_MYR, na.rm = TRUE),
    .groups  = "drop"
  ) %>%
  pivot_longer(
    cols = c(Quantity, Revenue),
    names_to = 'Metric',
    values_to = 'Values'
  )%>%
  as_tsibble(key = c(Item_Code, Type, Metric), index = Month) %>%
  fill_gaps(Values = 0)

#ETS
ETS_fits <- sales_data %>%
  model(
    ETS = ETS(Values ~ season("N"))
  )

ETS_forecasts <- ETS_fits %>% 
  forecast(h = "15 months")

ETS_forecast_export <- ETS_forecasts %>%
  as_tibble() %>%
  transmute(
    Item_Code = Item_Code,
    Type = Type,
    ForecastDate = as.Date(Month),
    Metric = Metric,
    Model_type = .model, 
    Forecast_Value = pmax(0, .mean)
  )

#ARIMA Model
arima_fits <-sales_data %>%
  model(
    arima = ARIMA(Values ~ pdq() + PDQ(0,0,0)))

arima_forecasts <- arima_fits %>% 
  forecast(h = "15 months")

arima_forecast_export <- arima_forecasts %>%
  as_tibble() %>%
  transmute(
    Item_Code = Item_Code,
    Type = Type,
    ForecastDate = as.Date(Month),
    Metric = Metric,
    Model_type = .model, 
    Forecast_Value = pmax(0, .mean)
  )

#3M MA
ma_fits <- sales_data %>%
  model(MA_3M = MEAN(Values ~ window(size = 3)))

ma_fc <- ma_fits %>% 
  forecast(h = "15 months")

ma_forecast_export <- ma_fc %>%
  as_tibble() %>%
  transmute(
    Item_Code, Type, ForecastDate = as.Date(Month), Metric,
    Model_type = "3M_MA",
    Forecast_Value = pmax(0, .mean)
  )
  

#Ensemble Model
Ensemble <- bind_rows(ETS_forecast_export, arima_forecast_export)

Ensemble_Model_Export <- Ensemble %>%
  group_by(Item_Code, Type, Metric, ForecastDate) %>%
  summarise(
    Model_type = "Ensemble",
    Forecast_Value = mean(Forecast_Value, na.rm = TRUE),
    .groups = "drop"
  )

Final_Ensemble<- bind_rows(Ensemble, Ensemble_Model_Export)

write_csv(Final_Ensemble, "Ensemble_Model.csv")
