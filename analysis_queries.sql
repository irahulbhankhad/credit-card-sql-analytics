--Query1 "Write a query to print top 5 cities with highest spends and their percentage contribution of total credit card Spends"
WITH city_spend AS
(
    SELECT city,
           SUM(Amount) AS Total_Spend
    FROM cc_transactions AS ct
    GROUP BY city
), Overall_spend AS
(
    SELECT
          SUM(Amount) AS Total_Amount
          FROM cc_transactions AS ct
)
SELECT city_spend.*,
      ROUND((Total_Spend/Total_Amount)*100,2) AS Percentage_Contribution
      FROM city_spend
      JOIN overall_spend
      ON 1=1
      ORDER BY Percentage_Contribution DESC
      LIMIT 5;

--Query2 "Write a query to print highest spend month and amount spent in that month for each card type"
WITH card_spend AS (
SELECT 
     ct.card_type,
     MONTHNAME(ct.transaction_date) AS Month_Name,
     SUM(ct.Amount) AS Total_Spend
FROM cc_transactions AS ct
GROUP BY card_type,Month_Name
),rnkofcard AS
(
SELECT *,
       RANK() OVER(
        PARTITION BY cs.card_type ORDER BY cs.Total_Spend)
       AS Rank_Number
FROM card_spend AS cs
)
SELECT roc.card_type,roc.Month_Name,roc.Total_Spend
FROM rnkofcard AS roc
WHERE roc.Rank_Number = 1;


/* Query 3- write a query to print the transaction details(all columns from the table) for each card type when
it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type) */
WITH run_sum AS 
(
SELECT *,
       SUM(ct.Amount) OVER(
                          PARTITION BY ct.card_type
                          ORDER BY ct.transaction_date,ct.id
       ) AS Running_Total
FROM cc_transactions AS ct
),rankofrun AS 
(
SELECT *,
      RANK() OVER(
                  PARTITION BY rs.card_type
                  ORDER BY rs.Running_Total
 ) AS Rank_Number
FROM run_sum AS rs
WHERE rs.Running_Total >= 1000000
)
SELECT ror.id
FROM rankofrun as ror
WHERE ror.Rank_Number=1;


--Query 4 "Write a query to find city which had lowest percentage spend for gold card type"
WITH gold_card AS
(
SELECT city,
SUM(Amount) AS Total_Spend,
SUM(CASE WHEN card_type='Gold' THEN Amount END) AS Gold_Spend
FROM cc_transactions
GROUP BY City
)
SELECT 
      gc.City,
      (gc.Gold_Spend/gc.Total_Spend)*100 AS Gold_Ratio
FROM gold_card AS gc
GROUP BY gc.city
HAVING COUNT (Gold_Ratio) > 0
ORDER BY Gold_Ratio ASC
LIMIT 1;

--Query5 "Write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)"
WITH city_expense AS (
    SELECT
        city,
        exp_type,
        SUM(amount) AS total_spend
    FROM cc_transactions
    GROUP BY city, exp_type
),
ranked_expense AS (
    SELECT
        city,
        exp_type,
        total_spend,
        RANK() OVER (
            PARTITION BY city
            ORDER BY total_spend DESC
        ) AS rnk_high,
        RANK() OVER (
            PARTITION BY city
            ORDER BY total_spend ASC
        ) AS rnk_low
    FROM city_expense
)
SELECT
    city,
    MAX(CASE WHEN rnk_high = 1 THEN exp_type END) AS highest_expense_type,
    MAX(CASE WHEN rnk_low = 1 THEN exp_type END)  AS lowest_expense_type
FROM ranked_expense
GROUP BY city
ORDER BY city;

--Query6 "Write a query to find percentage contribution of spends by females for each expense type"
SELECT
      exp_type,
      ROUND((SUM( CASE WHEN gender = 'F' THEN Amount ELSE 0 END)/SUM(Amount))*100,2)
               AS Percentage_Contribution
FROM cc_transactions
GROUP BY exp_type;

--Query7 "Which card and expense type combination saw highest month over month growth in Jan-2014"
WITH monthly_spend AS (
    SELECT
        card_type,
        exp_type,
        YEAR(transaction_date)  AS yr,
        MONTH(transaction_date) AS mn,
        SUM(amount) AS total_amount
    FROM cc_transactions
    GROUP BY
        card_type, exp_type, yr, mn
),
mom_calc AS (
    SELECT
        card_type,
        exp_type,
        yr,
        mn,
        total_amount,
        LAG(total_amount) OVER (
            PARTITION BY card_type, exp_type
            ORDER BY yr, mn
        ) AS prev_month_amount
    FROM monthly_spend
)
SELECT
    card_type,
    exp_type,
    ROUND(
        (total_amount - prev_month_amount) / prev_month_amount * 100,
        2
    ) AS mom_growth_pct
FROM mom_calc
WHERE yr = 2014
  AND mn = 1
  AND prev_month_amount IS NOT NULL
ORDER BY mom_growth_pct DESC
LIMIT 1;

  MIN(transaction_date) AS 1st_transaction_date,
      MAX(transaction_date) AS 2nd_transaction_date 

--Query9 "During weekends which city has highest total spend to total no of transcations ratio" 
 SELECT
       city,
       ROUND(SUM(Amount)/COUNT(*),0) AS Transactions_Ratio
FROM cc_transactions
WHERE DAYNAME(transaction_date) IN ('Saturday','Sunday')
GROUP BY city
ORDER BY Transactions_Ratio DESC
LIMIT 1;

--Query10 "10- which city took least number of days to reach its 500th transaction after the first transaction in that city"
WITH table1 AS
(
      SELECT *,
       ROW_NUMBER() OVER(
        PARTITION BY city 
        ORDER BY transaction_date,id
       ) AS rn
      FROM cc_transactions
)
SELECT city,
     ABS(DATEDIFF(MIN(transaction_date),MAX(transaction_date))) AS Difference_in_Days
FROM table1
WHERE rn=1 or rn = 500
GROUP BY city
HAVING MIN(transaction_date)!= MAX(transaction_date)
ORDER BY Difference_in_Days ASC
LIMIT 1;
