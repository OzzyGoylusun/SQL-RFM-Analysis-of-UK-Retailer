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
  --As the dataset is somewhat old, we consider our last booking date the last processed invoice of a customer in the dataset

FROM LAST_BOOKING_DATE_CALCS_TABLE
)
```

In addition, I also found it very effective to assign a recency score to each customer from 1 to 5, using the **NTILE() window function**, as follows:

```sql

SELECT "customerID",
        RECENCY_VALUE,
        ...,
        ...,
	--By means of NTILE functions, we are assigning each customer a recency, frequency and monetary score
	--from 1 to 5 based on their resulting recency, frequency and monetary values
        NTILE(5) OVER(ORDER BY RECENCY_VALUE DESC) AS RECENCY_SCORE,
        ...,
        ...,

FROM RECENCY
INNER JOIN FREQUENCY USING ("customerID")
INNER JOIN MONETARY USING ("customerID")

```

### Findings

The analysis discrete results are summarised as follows:

1. Approx. 15% of all customers have achieved a total Ultimate RFM Score of 125 or 100, considered **Champions**.
2. 96 customers out of 4335 have achieved 4 points on Recency, 3 points on Frequency and 4 points on Monetary, considered **Potential Loyalists**
3. There are nearly 200 valuable customers who scored less than 3 points on Recency, but scored 4 or 5 points on Frequency and Monetary, considered **At Risk Customers**

Please note that there were no repetititons/crossovers of customers amongst each customer segment analysed.

### Recommendations

Based on the analysis, I recommend the following actions:

- Consider further rewarding your champions as they could very well become early adopters for new products and assist with the promotion of the retailer's brand.
- Offer membership/loyalty  programs to the **Potential Loyalists** in an attempt to upgrade them to the **Champions** segment
- Reconnect with your **At Risk Customers** via personalised reactivation communications which include coupons and/or other incentives.

### Limitations: 

The following records needed to be removed from the RFM analysis in order to protect the integrity of the actual data and to ensure the accuracy of my conclusions:

- Cancelled invoices
- Missing/Corrupted customerIDs
- Prices lower than $0
- Records associated with manuals and postage fees


### References:

1. [Dataset from Kaggle](https://www.kaggle.com/datasets/carrie1/ecommerce-data/)
