-- Create a new database for Project 5
CREATE DATABASE IF NOT EXISTS fintrack;
USE fintrack;
-- ================================================
-- Task 12 — Create and populate transactions table
-- ================================================

CREATE TABLE IF NOT EXISTS transactions (
    transaction_id      VARCHAR(20),
    user_id             VARCHAR(20),
    transaction_date    DATE,
    month               VARCHAR(15),
    year                INT,
    transaction_type    VARCHAR(10),
    category            VARCHAR(50),
    amount_ngn          DECIMAL(12,2),
    description         VARCHAR(200),
    payment_method      VARCHAR(50),
    bank                VARCHAR(50),
    savings_goal_met    VARCHAR(5),
    budget_category     VARCHAR(50),
    notes               VARCHAR(50)
);
-- Confirm successful import
SELECT COUNT(*) AS total_rows 
FROM transactions;
-- Disable strict mode to avoid GROUP BY errors
SET sql_mode = '';

-- Select database
USE fintrack;

-- ================================================
-- Task 13 — Total income vs total expense per user
-- Net position shows if user is saving or losing
-- ================================================

SELECT 
    user_id,
    SUM(CASE WHEN transaction_type = 'Income' 
        THEN amount_ngn ELSE 0 END)          AS total_income,
    SUM(CASE WHEN transaction_type = 'Expense' 
        THEN amount_ngn ELSE 0 END)          AS total_expense,
    SUM(CASE WHEN transaction_type = 'Income' 
        THEN amount_ngn ELSE 0 END) -
    SUM(CASE WHEN transaction_type = 'Expense' 
        THEN amount_ngn ELSE 0 END)          AS net_position
FROM transactions
GROUP BY user_id
ORDER BY net_position DESC;

-- ================================================
-- Task 13a — Check users with lowest net position
-- ================================================

SELECT 
    user_id,
    SUM(CASE WHEN transaction_type = 'Income' 
        THEN amount_ngn ELSE 0 END)          AS total_income,
    SUM(CASE WHEN transaction_type = 'Expense' 
        THEN amount_ngn ELSE 0 END)          AS total_expense,
    SUM(CASE WHEN transaction_type = 'Income' 
        THEN amount_ngn ELSE 0 END) -
    SUM(CASE WHEN transaction_type = 'Expense' 
        THEN amount_ngn ELSE 0 END)          AS net_position
FROM transactions
GROUP BY user_id
ORDER BY net_position ASC
LIMIT 10;

-- ================================================
-- Task 14 — Average monthly spending by category
-- Shows typical monthly spend per category
-- ================================================

SELECT 
    category,
    ROUND(AVG(amount_ngn), 2)            AS avg_transaction,
    ROUND(SUM(amount_ngn), 2)            AS total_spent,
    COUNT(transaction_id)                AS total_transactions,
    ROUND(SUM(amount_ngn) / 
          COUNT(DISTINCT 
          CONCAT(year, month)), 2)       AS avg_monthly_spend
FROM transactions
WHERE transaction_type = 'Expense'
GROUP BY category
ORDER BY avg_monthly_spend DESC;

-- ================================================
-- Task 15 — Users with savings rate above 20%
-- Savings rate = (income - expenses) / income
-- ================================================

WITH user_totals AS (
    SELECT 
        user_id,
        SUM(CASE WHEN transaction_type = 'Income' 
            THEN amount_ngn ELSE 0 END)     AS total_income,
        SUM(CASE WHEN transaction_type = 'Expense' 
            THEN amount_ngn ELSE 0 END)     AS total_expense
    FROM transactions
    GROUP BY user_id
)
SELECT 
    user_id,
    total_income,
    total_expense,
    ROUND(total_income - total_expense, 2)  AS net_savings,
    ROUND((total_income - total_expense) 
          * 100.0 / 
          NULLIF(total_income, 0), 2)       AS savings_rate_pct
FROM user_totals
WHERE (total_income - total_expense) * 100.0 
      / NULLIF(total_income, 0) > 20
ORDER BY savings_rate_pct DESC;

-- ================================================
-- Task 15a — Count users with savings rate > 20%
-- ================================================

WITH user_totals AS (
    SELECT 
        user_id,
        SUM(CASE WHEN transaction_type = 'Income' 
            THEN amount_ngn ELSE 0 END)     AS total_income,
        SUM(CASE WHEN transaction_type = 'Expense' 
            THEN amount_ngn ELSE 0 END)     AS total_expense
    FROM transactions
    GROUP BY user_id
)
SELECT 
    COUNT(*)                                AS users_above_20pct,
    ROUND(AVG((total_income - total_expense) 
          * 100.0 / 
          NULLIF(total_income, 0)), 2)      AS avg_savings_rate
FROM user_totals
WHERE (total_income - total_expense) * 100.0 
      / NULLIF(total_income, 0) > 20;
      
      -- ================================================
-- Task 16 — Top spending category per month
-- using window function
-- ================================================

WITH monthly_category AS (
    SELECT 
        year,
        month,
        category,
        SUM(amount_ngn)                     AS total_spent,
        RANK() OVER (
            PARTITION BY year, month 
            ORDER BY SUM(amount_ngn) DESC
        )                                   AS category_rank
    FROM transactions
    WHERE transaction_type = 'Expense'
    GROUP BY year, month, category
)
SELECT 
    year,
    month,
    category                                AS top_category,
    ROUND(total_spent, 2)                   AS total_spent
FROM monthly_category
WHERE category_rank = 1
ORDER BY year, 
    FIELD(month, 'January','February',
          'March','April','May','June',
          'July','August','September',
          'October','November','December');
          
          -- ================================================
-- Task 17 — Bank popularity: transaction count 
-- and volume by bank
-- ================================================

SELECT 
    bank,
    COUNT(transaction_id)               AS transaction_count,
    ROUND(SUM(amount_ngn), 2)           AS total_volume,
    ROUND(AVG(amount_ngn), 2)           AS avg_transaction,
    ROUND(COUNT(transaction_id) * 100.0 
          / (SELECT COUNT(*) 
             FROM transactions), 2)     AS pct_of_total
FROM transactions
GROUP BY bank
ORDER BY transaction_count DESC;

-- ================================================
-- Task 18 — Monthly net savings trend
-- all users combined
-- ================================================

SELECT 
    year,
    month,
    ROUND(SUM(CASE WHEN transaction_type = 'Income' 
              THEN amount_ngn ELSE 0 END), 2)    AS total_income,
    ROUND(SUM(CASE WHEN transaction_type = 'Expense' 
              THEN amount_ngn ELSE 0 END), 2)    AS total_expense,
    ROUND(SUM(CASE WHEN transaction_type = 'Income' 
              THEN amount_ngn ELSE 0 END) -
          SUM(CASE WHEN transaction_type = 'Expense' 
              THEN amount_ngn ELSE 0 END), 2)    AS net_savings
FROM transactions
GROUP BY year, month
ORDER BY year,
    FIELD(month, 'January','February',
          'March','April','May','June',
          'July','August','September',
          'October','November','December');
          
          -- ================================================
-- Task 19 — Users who have never saved
-- No transaction with category = 'Savings'
-- ================================================

SELECT 
    user_id,
    COUNT(transaction_id)           AS total_transactions,
    ROUND(SUM(amount_ngn), 2)       AS total_spent
FROM transactions
WHERE transaction_type = 'Expense'
AND user_id NOT IN (
    SELECT DISTINCT user_id 
    FROM transactions 
    WHERE category = 'Savings'
)
GROUP BY user_id
ORDER BY total_spent DESC;

-- ================================================
-- Task 19a — Count users who have never saved
-- ================================================

SELECT 
    COUNT(DISTINCT user_id)     AS users_never_saved
FROM transactions
WHERE transaction_type = 'Expense'
AND user_id NOT IN (
    SELECT DISTINCT user_id 
    FROM transactions 
    WHERE category = 'Savings'
);

-- ================================================
-- Task 20 — Cumulative spending per user
-- using SUM() OVER window function
-- ================================================

SELECT 
    user_id,
    transaction_date,
    category,
    amount_ngn,
    ROUND(SUM(amount_ngn) OVER (
        PARTITION BY user_id 
        ORDER BY transaction_date
        ROWS BETWEEN UNBOUNDED PRECEDING 
        AND CURRENT ROW
    ), 2)                           AS cumulative_spending
FROM transactions
WHERE transaction_type = 'Expense'
ORDER BY user_id, transaction_date
LIMIT 50;

-- ================================================
-- Task 21 — Month with highest average expense
-- per user across all years
-- ================================================

SELECT 
    month,
    ROUND(AVG(monthly_expense), 2)      AS avg_expense_per_user,
    ROUND(SUM(monthly_expense), 2)      AS total_expense,
    COUNT(DISTINCT user_id)             AS active_users
FROM (
    SELECT 
        user_id,
        month,
        year,
        SUM(amount_ngn)                 AS monthly_expense
    FROM transactions
    WHERE transaction_type = 'Expense'
    GROUP BY user_id, month, year
) monthly_data
GROUP BY month
ORDER BY avg_expense_per_user DESC
LIMIT 1;

-- ================================================
-- Task 22 — CTE: Identify users in top 10% 
-- of spenders
-- ================================================

WITH user_spending AS (
    SELECT 
        user_id,
        ROUND(SUM(amount_ngn), 2)       AS total_spent
    FROM transactions
    WHERE transaction_type = 'Expense'
    GROUP BY user_id
),
spending_percentile AS (
    SELECT 
        user_id,
        total_spent,
        NTILE(10) OVER (
            ORDER BY total_spent DESC
        )                               AS spending_decile
    FROM user_spending
)
SELECT 
    user_id,
    total_spent,
    spending_decile
FROM spending_percentile
WHERE spending_decile = 1
ORDER BY total_spent DESC;

-- ================================================
-- Task 22a — Count of top 10% spenders
-- ================================================

WITH user_spending AS (
    SELECT 
        user_id,
        ROUND(SUM(amount_ngn), 2)       AS total_spent
    FROM transactions
    WHERE transaction_type = 'Expense'
    GROUP BY user_id
),
spending_percentile AS (
    SELECT 
        user_id,
        total_spent,
        NTILE(10) OVER (
            ORDER BY total_spent DESC
        )                               AS spending_decile
    FROM user_spending
)
SELECT 
    COUNT(*)                            AS top_10pct_users,
    ROUND(AVG(total_spent), 2)          AS avg_spending,
    ROUND(MIN(total_spent), 2)          AS min_spending,
    ROUND(MAX(total_spent), 2)          AS max_spending
FROM spending_percentile
WHERE spending_decile = 1;

-- ================================================
-- PROJECT 5 — SQL FINDINGS & INSIGHTS SUMMARY
-- ================================================

/*
INSIGHT 1 — Severe Overspending Problem
Some users have zero recorded income with entirely
negative net positions up to -₦2,925,950. Combined
with 99.6% overspending rate this validates FinTrack's
core product need for budget management tools.

INSIGHT 2 — Savings Leads Monthly Spending
Savings is the top spending category per month in
7 out of 36 months confirming users actively prioritise
saving when they can. FinTrack should reinforce this
positive behaviour with savings milestone rewards.

INSIGHT 3 — All Banks Equally Popular
All 8 banks share transactions at roughly 12.5% each.
GTBank leads narrowly at 12.66%. FinTrack should
integrate all 8 banks equally for maximum user coverage.

INSIGHT 4 — 1,655 Users Never Saved
33.1% of users have never recorded a savings transaction
despite actively spending. These users need immediate
savings nudges and automated savings features.

INSIGHT 5 — March Highest Individual Spending
March records the highest average expense per user
at ₦69,142 while August has highest total volume.
FinTrack should send budget warnings in both months.

INSIGHT 6 — Top 10% Drive Premium Spending
500 users spend between ₦1.76M and ₦4.15M on average.
These high-value users need premium budget features
and personalised financial coaching in the app.

INSIGHT 7 — 2,245 Users Have Healthy Savings Rate
44.9% of users maintain savings rate above 20% with
average of 48.79% among this group. FinTrack should
celebrate and gamify this behaviour to encourage others.
*/

