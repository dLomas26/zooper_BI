-- TABLES

CREATE TABLE IF NOT EXISTS policy_sales (
    Customer_ID         TEXT,
    Vehicle_ID          TEXT,
    Vehicle_Value       INTEGER,
    Premium             INTEGER,
    Policy_Purchase_Date DATE,
    Policy_Start_Date   DATE,
    Policy_End_Date     DATE,
    Policy_Tenure       INTEGER
);

CREATE TABLE IF NOT EXISTS claims (
    Claim_ID     TEXT,
    Customer_ID  TEXT,
    Vehicle_ID   TEXT,
    Claim_Amount INTEGER,
    Claim_Date   DATE,
    Claim_Type   INTEGER   -- 1 = First Claim, 2 = Second Claim
);


-- Q1. Total premium collected during the year 2024

SELECT 
    SUM(Premium)  AS Total_Premium_2024
FROM policy_sales
WHERE strftime('%Y', Policy_Purchase_Date) = '2024';


-- Q2. Total claim cost for 2025 and 2026 with monthly breakdown

SELECT 
    strftime('%Y', Claim_Date)          AS Year,
    strftime('%m', Claim_Date)          AS Month,
    COUNT(*)                            AS Total_Claims,
    SUM(Claim_Amount)                   AS Total_Claim_Cost
FROM claims
GROUP BY Year, Month
ORDER BY Year, Month;


-- Q3. Claim cost to premium ratio by policy tenure

SELECT 
    p.Policy_Tenure,
    SUM(p.Premium)                                          AS Total_Premium,
    COALESCE(SUM(c.Claim_Amount), 0)                        AS Total_Claim_Cost,
    COUNT(DISTINCT c.Claim_ID)                              AS Total_Claims,
    ROUND(
        COALESCE(SUM(c.Claim_Amount), 0) * 1.0 
        / SUM(p.Premium), 
    4)                                                      AS Claim_to_Premium_Ratio
FROM policy_sales p
LEFT JOIN claims c ON p.Vehicle_ID = c.Vehicle_ID
GROUP BY p.Policy_Tenure
ORDER BY p.Policy_Tenure;


-- Q4. Claim cost to premium ratio by month of policy sale (Jan–Dec 2024)


SELECT 
    strftime('%m', p.Policy_Purchase_Date)      AS Sale_Month,
    SUM(p.Premium)                              AS Total_Premium,
    COALESCE(SUM(c.Claim_Amount), 0)            AS Total_Claim_Cost,
    ROUND(
        COALESCE(SUM(c.Claim_Amount), 0) * 1.0 
        / SUM(p.Premium), 
    4)                                          AS Claim_to_Premium_Ratio
FROM policy_sales p
LEFT JOIN claims c ON p.Vehicle_ID = c.Vehicle_ID
GROUP BY Sale_Month
ORDER BY Sale_Month;



-- Q5. Potential claim liability for vehicles that have NOT yet claimed


SELECT 
    COUNT(*)            AS Vehicles_Without_Any_Claim,
    COUNT(*) * 10000    AS Total_Potential_Liability
FROM policy_sales
WHERE Vehicle_ID NOT IN (
    SELECT DISTINCT Vehicle_ID FROM claims
);



-- Q6A. Premium already earned by the company up to February 28, 2026
-- (Daily premium = Total Premium / Total Policy Tenure Days)


SELECT
    ROUND(SUM(
        CASE
            -- Policy hasn't started yet as of Feb 28, 2026 → 0 earned
            WHEN '2026-02-28' < Policy_Start_Date 
                THEN 0

            -- Policy fully ended before Feb 28, 2026 → full premium earned
            WHEN '2026-02-28' >= Policy_End_Date  
                THEN Premium

            -- Policy is still active on Feb 28, 2026 → earn proportionally
            ELSE Premium 
                * (julianday('2026-02-28') - julianday(Policy_Start_Date))
                / (julianday(Policy_End_Date)  - julianday(Policy_Start_Date))
        END
    ), 2) AS Premium_Earned_Upto_Feb28_2026
FROM policy_sales;


-- Q6B. Estimated monthly premium for the remaining 46 months


SELECT
    ROUND(SUM(
        CASE
            -- Policy already fully expired → nothing remaining
            WHEN '2026-02-28' >= Policy_End_Date  
                THEN 0

            -- Policy hasn't started yet → full premium still to be earned
            WHEN '2026-02-28' < Policy_Start_Date 
                THEN Premium

            -- Active policy → remaining (unearned) premium
            ELSE Premium * (
                1 - (julianday('2026-02-28') - julianday(Policy_Start_Date))
                  / (julianday(Policy_End_Date)  - julianday(Policy_Start_Date))
            )
        END
    ) / 46, 2) AS Estimated_Monthly_Premium_Next_46_Months
FROM policy_sales;


-- BONUS Q1: Most Profitable Tenure Analysis and why


SELECT
    p.Policy_Tenure,
    SUM(p.Premium)                            AS Total_Premium_Collected,
    COALESCE(SUM(c.Claim_Amount), 0)          AS Total_Claims_Paid,
    SUM(p.Premium) - COALESCE(SUM(c.Claim_Amount), 0)
                                              AS Net_Profit,
    ROUND(COALESCE(SUM(c.Claim_Amount), 0)
        / NULLIF(SUM(p.Premium), 0) * 100, 2) AS Loss_Ratio_Pct,
    ROUND((SUM(p.Premium) - COALESCE(SUM(c.Claim_Amount), 0))
        / NULLIF(SUM(p.Premium), 0) * 100, 2) AS Profit_Margin_Pct,
    RANK() OVER (
        ORDER BY COALESCE(SUM(c.Claim_Amount), 0) / NULLIF(SUM(p.Premium), 0)
    )                                         AS Profitability_Rank
FROM policy_sales p
LEFT JOIN claims c ON p.Customer_ID = c.Customer_ID
GROUP BY p.Policy_Tenure
ORDER BY Profitability_Rank;


-- Why: Longer premium collection period (₹300 per policy) dilutes claim impact compared to 1-year (only ₹100 collected against same ₹10,000 claim risk)
-- However: ALL tenures are still unprofitable (ratio > 1.0)



-- BONUS Q2: Build a simple dashboard or visualization showing claim trends by month. 

-- Find dashboard on Github repository



-- BONUS Q3: Overall loss ratio (Claims ÷ Premium) for the full portfolio


SELECT
    SUM(Premium)                                        AS Total_Premium,
    (SELECT SUM(Claim_Amount) FROM claims)              AS Total_Claims,
    ROUND(
        (SELECT SUM(Claim_Amount) FROM claims) * 1.0 
        / SUM(Premium), 
    4)                                                  AS Overall_Loss_Ratio
FROM policy_sales;



-- BONUS Q4: Impact of 5% annual increase in claim frequency on profitability


-- Current baseline claims: ₹49,40,70,000
-- If claim frequency increases 5% per year:

SELECT
    'Current (2025-26)'         AS Period,
    494070000                   AS Total_Claims,
    240110800                   AS Total_Premium,
    ROUND(494070000.0 
        / 240110800, 4)         AS Loss_Ratio

UNION ALL SELECT
    'Year +1 (5% increase)',
    ROUND(494070000 * 1.05),
    240110800,
    ROUND(494070000 * 1.05 
        / 240110800, 4)

UNION ALL SELECT
    'Year +2 (10% increase)',
    ROUND(494070000 * 1.10),
    240110800,
    ROUND(494070000 * 1.10 
        / 240110800, 4)

UNION ALL SELECT
    'Year +3 (15% increase)',
    ROUND(494070000 * 1.15),
    240110800,
    ROUND(494070000 * 1.15 
        / 240110800, 4);
