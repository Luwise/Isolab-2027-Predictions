This repository contains an interactive Isolab's 2025-2026 Sales Dashboard built using Power BI by Kim Louis Alfatah.
It provides deep insights into Isolab Sales, demand, trend analysis, model evaluation, and recommendations through Power BI visuals and R Studios Forecasting.
<img width="1210" height="696" alt="Screenshot 2026-09-12 021438" src="https://github.com/user-attachments/assets/e21e42d3-6f2d-4ef3-b0a7-23ffa9595b3c" />
<img width="1207" height="696" alt="Screenshot 2026-09-12 021601" src="https://github.com/user-attachments/assets/b75d1f75-ed6a-47dc-875f-9fd2b1a8d591" />
<img width="1212" height="699" alt="Screenshot 2026-09-12 021612" src="https://github.com/user-attachments/assets/caf1285b-a21b-430f-9e4e-ec0d272cdfc2" />
<img width="1205" height="695" alt="Screenshot 2026-09-12 021620" src="https://github.com/user-attachments/assets/634cbef1-5943-49a2-bbae-5f2f48d1e4bf" />

###📁 Files Included
| File Name | Description |
|:----------|:------------|
|Isolab2027Forecast.pbix|Dashboard for Isolab's Analysis and Forecast results|
|Isolab_2027_Prediction.R|R Script containing forecasting models|
|ISOLAB2025-2026.xlsx|Main data for analysis|
|3MA_Model.csv|Prediction result with 3 Month Moving Average|
|ETS_Model.csv|Prediction result with ETS Model|
|ARIMA_Model.csv|Prediction result with ARIMA Model|
|Ensemble_Model.csv|Prediction result with ensembling ETS and ARIMA|

 Key Features
📌 KPI Tiles:
🔹 Total Revenue: RM892K
🔹 Total Quantity SOld: 979
🔹 Avg Monthly Revenue: RM42.48K
🔹 Avg Quantity Sold monthly: 46.62

📊 Visual Insights:
🔹Top 8 best selling and revenue making Items
🔹2025 and 2026 side by side Revenue Comparison per month
🔹Revenue Progression
🔹Revenue and Quantity sold per Category
🔹Low in stock and 0 stock (Active Sale) Bar Chart
🔹Table with Quantity, 2026 demand per month, and month of supply left

🎯 2027 Forecast:
Creatinng 3 different models to compare their forecasting ability on Isolab's Sale for 2027, Calculate their Min and Max forecast to obtain the forecast spread %, which ensures that all the models result agrees closely. Compared their
Quantity and Revenue by end of 2027, as well as the monthly predicted quantity and revenue made.

🎯 2027 Operational Recommendations:
Each model serves a purpose, ETS serves as the upper bound ceiling, 3MA as the control benchmark using naive heuristic (assuming recent sales repeats indefinitely),ARIMA as the lower bound floor, and Ensemble model as the Primary Operational Target.

We use Ensemble Model as the operational target is because relying on a single model have several risks, ETS risk on over purchasing, while ARIMA risks on stockouts when demand is high. Hence, the Ensemble model provides a mathematically center point. On the other hand, 3MA acts a neutral control line to evaluate the model accuracy over time, while without it, it may inflate our target quantity.

📈 R Integration:
R is used as the base for forecasting models, which their forecast data will be integrated in Power BI

🛠️ Tools & Technologies
Power BI Desktop
CSV and Excel Dataset
DAX Measures
Data Transformation & Modeling

📐 DAX Columns & Measures – Pizza Sales Dashboard
The following calculated columns and measures were created in Power BI using DAX:

<pre>2025 Revenue = CALCULATE(SUM('2025-2026 Sales'[Amount_MYR]), YEAR('2025-2026 Sales'[Date]) = 2025)
2026 Revenue = CALCULATE(SUM('2025-2026 Sales'[Amount_MYR]), YEAR('2025-2026 Sales'[Date]) = 2026)
ASP = DIVIDE(SUM('2025-2026 Sales'[Amount_MYR]), SUM('2025-2026 Sales'[Quantity]))
machine_quantity = CALCULATE(SUM('2025-2026 Sales'[Quantity]), '2025-2026 Sales'[Type] = "Machine") 
monthly_avg = AVERAGEX(VALUES('2025-2026 Sales'[Date]), CALCULATE(SUM('2025-2026 Sales'[Amount_MYR])))
monthly_avg_qty = AVERAGEX(VALUES('2025-2026 Sales'[Date]), CALCULATE(SUM('2025-2026 Sales'[Quantity])))
Reagent_quantity = CALCULATE(SUM('2025-2026 Sales'[Quantity]), '2025-2026 Sales'[Type] = "Control & Reagent")
YoY Growth % = DIVIDE([2026 Revenue] - [2025 Revenue], [2025 Revenue])
3MMA Forcasted Quantity = ROUND(CALCULATE(SUM('3MA_Model (2)'[Forecast_Value]),'3MA_Model (2)'[Metric] == "Quantity"),2)
3MMA Forcasted Revenue = ROUND(CALCULATE(SUM('3MA_Model (2)'[Forecast_Value]),'3MA_Model (2)'[Metric] == "Revenue"),2)
ARIMA Forecasted Quantity = ROUND(CALCULATE(SUM(ARIMA_Model[Forecast_Value]), ARIMA_Model[Metric] = "Quantity"),2)
ARIMA Forecasted Revenue = ROUND(CALCULATE(SUM(ARIMA_Model[Forecast_Value]), ARIMA_Model[Metric] = "Revenue"),2)
Ensemble Forecasted Quantity = ROUND(CALCULATE(SUM(Ensemble_Model[Forecast_Value]), Ensemble_Model[Metric] = "Quantity"),2)
Ensemble Forecasted Revenue = ROUND(CALCULATE(SUM(Ensemble_Model[Forecast_Value]), Ensemble_Model[Metric] = "Quantity"),2)
ETS Forcasted Quantity = ROUND(CALCULATE(SUM('ETS_Model'[Forecast_Value]),'ETS_Model'[Metric] == "Quantity"),2)
ETS Forcasted Revenue = ROUND(CALCULATE(SUM('ETS_Model'[Forecast_Value]),ETS_Model[Metric] == "Revenue"),2)
2026 Monthly Demand = DIVIDE(CALCULATE(SUM('2025-2026 Sales'[Quantity]), YEAR('2025-2026 Sales'[Date])= 2026), 9, 0)
Forecast Spread % = DIVIDE([Max Forecast Quantity] - [Min Forecast Quantity],[Ensemble Forecasted Quantity],0)
Max Forecast Quantity = MAX([ETS Forcasted Quantity], [ARIMA Forecasted Quantity])
Min Forecast Quantity = MIN([ETS Forcasted Quantity], [ARIMA Forecasted Quantity])
Months of Supply = 
IF(
    [2026 Monthly Demand] > 0,
    DIVIDE(SUM('Stock Data'[Book Qty]), [2026 Monthly Demand], 0),
    BLANK()
)
</pre>
