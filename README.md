# SQL RFM Data Analysis of UK Retail Company

## Table of Contents

- [Data Analysis](#data_analysis)
- [Findings](#findings)
- [Recommendations](#recommendations)


### RFM Data Analysis Overview
---

This RFM data analysis work focusses on assisting a UK retailer with re-adjusting its customer segmentation strategy by quantitatively ranking and grouping its customers 
based on the recency, frequency and monetary value of its proprietary transactions.

In return, this data-driven approach is expected to enable the firm to continuously identify its best customers and undertake targeted marketing campaigns.



### Data Sources

Sales Data: The primary dataset used for this analysis is the "data.csv" file, containing detailed information about each transaction made by the company's customers

### Tools

- PostgreSQL Server - Data Analysis
  - [Download Here](https://www.postgresql.org/download/)
  

### Data Cleaning/Preparation

In the initial data preparation phase, I performed the following tasks:

1. Data loading and inspection.
2. Handling missing values.
3. Data cleaning and formatting. (HAVE WE?)

### Exploratory Data Analysis (EDA)

EDA involved exploring the complex transaction data to answer the following key questions:

- What percentage of all customers have achieved an ultimate RFM score of 125 out of 125?
  
  - For your information, customers receive a score from 1 to 5 from each category based on how recently, frequently and monetarily they transact with the retailer, benchmarked against other customers:
 
      |Recency|Frequency|Monetary|
      |--------|--------|--------|
      |5*|5*|5|
      | | |=125|

- What percentage of all customers have scored at least 5 points out of one category while scoring 4 points out of the others?


### Data_Analysis

Compared to my *Frequency* and *Monetary* tables, I found the calculations with the **Recency** table a bit more complex due to the natural need to also have to calculate the customers' last booking date beforehand.

```sql
WITH RECENCY AS(

  WITH LAST_BOOKING_DATE_CALCS_TABLE AS(

      SELECT "customerID",
          MAX("invoiceDate") AS LAST_BOOKING_DATE
      FROM CLEANED_UP_DATASET
      GROUP BY 1
  ) 
	 
SELECT "customerID",
      EXTRACT(DAY FROM ('2011-12-09 12:50:00'::timestamp - LAST_BOOKING_DATE)) AS RECENCY_VALUE
  --Yukarıda da bahsettiğim gibi veri setimizde bulunan en son sipariş tarihini önceden hesaplatıp burada o şekilde kullanıyorum.

FROM LAST_BOOKING_DATE_CALCS_TABLE
)
```

In addition, I also found it very effective to assign a recency score to each customer from 1 to 5, using the **NTILE() window function**, as follows:

```sql

SELECT "customerID",
        RECENCY_VALUE,
        ...,
        ...,
        --Her bir müşteriye ait Recency, Frequency ve Monetary Skorunu aşağıda atıyorum.
        NTILE(5) OVER(ORDER BY RECENCY_VALUE DESC) AS RECENCY_SCORE,
        ...,
        ...,

FROM RECENCY
INNER JOIN FREQUENCY USING ("customerID")
INNER JOIN MONETARY USING ("customerID")

```



### Findings

The analysis results are summarised as follows:
1. The company's sales have been steadily increasing over the past year, with a noticeable peak during the holiday season.
2. Product Category A is the best-performing category in terms of sales and revenue.
3. Customer segments with high lifetime value (LTV) should be targeted for marketing efforts.

### Recommendations

This part actually empowers data analysts to provide value to the firms for which they are undertaking work.

Based on the analysis, we recommend the following actions:

- Invest in marketing and promotions during peak sales seasons to maximize revenue.
- Focus on expanding and promoting products in Category A.
- Implement a customer segmentation strategy to target high-LTV customers effectively.

### Limitations: Records that you have been compelled to take out of your analysis (e.g., outliers, NaNs etc.). This can help you work as your Disclaimer.

I had to remove all zero values from budget and revenue columns because they would have affected the accuracy of my conclusions from the analysis. There are still a
few outliers even after the omissions but even then we can still see that there is a positive correlatation between both budget and number of votes with revenue.

### References: Let's say you checked something online, Googled, or simply source of your data and case study content etc.

1. SQL for Businesses by Werty. (Book Name)
2. [PostgreSQL: TimeSeries](https://www.postgresql.org/docs/current/functions-datetime.html#FUNCTIONS-DATETIME-TABLE)

3. https://www.kaggle.com/datasets/carrie1/ecommerce-data (DataSet)
