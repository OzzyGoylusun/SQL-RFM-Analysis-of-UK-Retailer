# SQL RFM Data Analysis of a UK Retail Company

## Table of Contents (EXAMPLE)

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
3. Data cleaning and formatting.

### Exploratory Data Analysis (EDA)

EDA involved exploring the sales data to answer key questions, such as:

- What is the overall sales trend?
- Which products are top sellers?
- What are the peak sales periods?


### Data_Analysis

Include some interesting code/features worked with

```sql
SELECT * FROM table1
WHERE cond = 2
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
