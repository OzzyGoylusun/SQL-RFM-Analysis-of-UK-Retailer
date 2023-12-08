WITH ULTIMATE_RFM_DATA AS(

	WITH CLEANED_UP_DATASET AS( 
	--This is where we first clean up our main dataset before conducting our RFM analysis
	
		SELECT *
		 
		FROM MAIN_DATASET
		WHERE "invoiceNo" NOT LIKE 'C%' --Records associated with cancellations are out
			AND "customerID" > 0 --Records associated with corrupted/missing customerIDs are out
			AND "unitPrice" > 0 --Records associated with negative/null dollar values are out
			AND "stockCode" != 'M' --Records associated with manuals are out
		 	AND "stockCode" != 'POST' --Records associated with postage fees are out
	), 
	 
	RECENCY AS(
	 
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
	
	), 
	
	FREQUENCY AS(
		
		SELECT "customerID",
				COUNT(DISTINCT "invoiceNo") AS FREQUENCY_VALUE
		
		FROM CLEANED_UP_DATASET
		GROUP BY 1
		
	), 
	
	MONETARY AS(
		
		SELECT "customerID",
				SUM("unitPrice" * "quantity") AS MONETARY_VALUE
		
		FROM CLEANED_UP_DATASET
		GROUP BY 1
	
	) 
	
	SELECT "customerID",
			RECENCY_VALUE,
			FREQUENCY_VALUE,
			ROUND(MONETARY_VALUE::numeric, 2) AS ROUNDED_MONETARY_VALUE,
			--By means of NTILE functions, we are assigning each customer a recency, frequency and monetary score from 1 to 5
			--based on their resulting recency, frequency and monetary values
			
			NTILE(5) OVER(ORDER BY RECENCY_VALUE DESC) AS RECENCY_SCORE,
			NTILE(5) OVER(ORDER BY FREQUENCY_VALUE ASC) AS FREQUENCY_SCORE,
			NTILE(5) OVER(ORDER BY MONETARY_VALUE ASC) AS MONETARY_SCORE
	 
	FROM RECENCY
	INNER JOIN FREQUENCY USING ("customerID")
	INNER JOIN MONETARY USING ("customerID")

)

SELECT *,
	RECENCY_SCORE * FREQUENCY_SCORE * MONETARY_SCORE AS ULTIMATE_RFM_SCORE 
	--We are obtaining a final RFM score for each customer by multiplying their recency, frequency and monetary scores to one another
	
FROM ULTIMATE_RFM_DATA
ORDER BY 8 DESC, 4 DESC, 3 DESC, 2 DESC 


--Coded by Ozzy Goylusun (OG)