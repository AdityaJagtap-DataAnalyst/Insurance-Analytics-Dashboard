Create DATABASE Insurance;

Use Insurance ;

CREATE TABLE brokerage (
    client_name VARCHAR(255),
    policy_number VARCHAR(255),
    policy_status VARCHAR(50),
    policy_start_date DATE,
    policy_end_date DATE,
    product_group VARCHAR(255),
    Account_Exe_ID INT,
    Exe_Name VARCHAR(255),
    branch_name VARCHAR(255),
    solution_group VARCHAR(255),
    income_class VARCHAR(50),
    Amount DECIMAL(15, 2),
    income_due_date DATE,
    revenue_transaction_type VARCHAR(50),
    renewal_status VARCHAR(50),
    lapse_reason VARCHAR(255),
    last_updated_date DATE
);


CREATE TABLE fees (
    client_name VARCHAR(255),
    branch_name VARCHAR(255),
    solution_group VARCHAR(255),
    Account_Exe_ID INT,
    Account_Executive VARCHAR(255),
    income_class VARCHAR(50),
    Amount DECIMAL(15, 2),
    income_due_date DATE,
    revenue_transaction_type VARCHAR(50)
);

CREATE TABLE individual_budgets (
    Branch VARCHAR(255),
    Account_Exe_ID INT,
    Employee_Name VARCHAR(255),
    New_Role2 VARCHAR(255),
    New_Budget DECIMAL(15, 2),
    Cross_Sell_Budget DECIMAL(15, 2),
    Renewal_Budget DECIMAL(15, 2)
);


CREATE TABLE invoice (
    invoice_number VARCHAR(255),
    invoice_date DATE,
    revenue_transaction_type VARCHAR(50),
    branch_name VARCHAR(255),
    solution_group VARCHAR(255),
    Account_Exe_ID INT,
    Account_Executive VARCHAR(255),
    income_class VARCHAR(50),
    Client_Name VARCHAR(255),
    policy_number VARCHAR(255),
    Amount DECIMAL(15, 2),
    income_due_date DATE
);


CREATE TABLE meeting (
    Account_Exe_ID INT,
    Account_Executive VARCHAR(255),
    branch_name VARCHAR(255),
    global_attendees VARCHAR(255),
    meeting_date DATE
);


CREATE TABLE opportunity (
    opportunity_name VARCHAR(255),
    opportunity_id VARCHAR(255),
    Account_Exe_Id INT,
    Account_Executive VARCHAR(255),
    premium_amount DECIMAL(15, 2),
    revenue_amount DECIMAL(15, 2),
    closing_date DATE,
    stage VARCHAR(50),
    branch VARCHAR(255),
    specialty VARCHAR(255),
    product_group VARCHAR(255),
    product_sub_group VARCHAR(255),
    risk_details VARCHAR(255)
);

/* Total Policy */
SELECT COUNT(policy_number) AS Total_Policies FROM brokerage;

/*Total Customers*/
SELECT COUNT(DISTINCT client_name) AS Total_Customers FROM brokerage;

-- Total Revenue
SELECT SUM(t.Amount) AS Total_Revenue
FROM (
    SELECT Amount FROM brokerage
    UNION ALL
    SELECT Amount FROM fees
    UNION ALL
    SELECT Amount FROM invoice
) AS t;

-- Total Allocated Budget
SELECT
    COALESCE(SUM(New_Budget), 0)
    + COALESCE(SUM(Cross_Sell_Budget), 0)
    + COALESCE(SUM(Renewal_Budget), 0) AS Total_Allocated_Budget
FROM individual_budgets;


-- Total Policies Count
SELECT COUNT(DISTINCT policy_number) AS Total_Policies
FROM brokerage
WHERE policy_number IS NOT NULL
  AND TRIM(policy_number) <> '';
  
  -- Revenue vs Budget by Account Executive
  WITH CombinedRevenue AS (
    SELECT Account_Exe_ID, Amount FROM brokerage
    UNION ALL
    SELECT Account_Exe_ID, Amount FROM fees
    UNION ALL
    SELECT Account_Exe_ID, Amount FROM invoice
)
SELECT
    b.Employee_Name,
    COALESCE(SUM(r.Amount), 0) AS Total_Revenue,
    (COALESCE(b.New_Budget, 0) + COALESCE(b.Cross_Sell_Budget, 0) + COALESCE(b.Renewal_Budget, 0)) AS Total_Budget
FROM individual_budgets AS b
LEFT JOIN CombinedRevenue AS r
    ON b.Account_Exe_ID = r.Account_Exe_ID
GROUP BY
    b.Employee_Name, b.New_Budget, b.Cross_Sell_Budget, b.Renewal_Budget
ORDER BY
    Total_Revenue DESC;
    
    
    -- Revenue by Transaction Type
    
    SELECT
    t.revenue_transaction_type,
    COALESCE(SUM(t.Amount), 0) AS Total_Revenue
FROM (
    SELECT Amount, revenue_transaction_type FROM brokerage
    UNION ALL
    SELECT Amount, revenue_transaction_type FROM fees
    UNION ALL
    SELECT Amount, revenue_transaction_type FROM invoice
) AS t
GROUP BY
    t.revenue_transaction_type
ORDER BY
    Total_Revenue DESC;
    
    -- Monthly Revenue Trend
    SELECT
    DATE_FORMAT(income_due_date, '%Y-%m') AS Due_Year_Month,
    COALESCE(SUM(Amount), 0) AS Monthly_Revenue
FROM (
    SELECT Amount, income_due_date FROM brokerage WHERE income_due_date IS NOT NULL
    UNION ALL
    SELECT Amount, income_due_date FROM fees WHERE income_due_date IS NOT NULL
    UNION ALL
    SELECT Amount, income_due_date FROM invoice WHERE income_due_date IS NOT NULL
) AS t
GROUP BY
    DATE_FORMAT(income_due_date, '%Y-%m')
ORDER BY
    Due_Year_Month;
    
    -- Opportunity Stage Count
    SELECT
    stage,
    COUNT(opportunity_id) AS Opportunity_Count
FROM opportunity
GROUP BY
    stage
ORDER BY
    Opportunity_Count DESC;
    
-- Meeting Count by Account Executive
SELECT
    b.Employee_Name AS Account_Executive,
    COUNT(m.Account_Exe_ID) AS Total_Meetings
FROM individual_budgets AS b
LEFT JOIN meeting AS m
    ON b.Account_Exe_ID = m.Account_Exe_ID
GROUP BY
    b.Employee_Name
ORDER BY
    Total_Meetings DESC;
    
-- Policies by Policy Status
SELECT
    policy_status,
    COUNT(policy_number) AS Policy_Count
FROM brokerage
GROUP BY
    policy_status
ORDER BY
    Policy_Count DESC;
    
-- Revenue by Solution Group
SELECT
    solution_group,
    COALESCE(SUM(Amount), 0) AS Total_Revenue
FROM (
    SELECT solution_group, Amount FROM brokerage
    UNION ALL
    SELECT solution_group, Amount FROM fees
    UNION ALL
    SELECT solution_group, Amount FROM invoice
) AS t
GROUP BY solution_group
ORDER BY Total_Revenue DESC;

-- Top 10 Clients by Revenue

SELECT
    client_name,
    COALESCE(SUM(Amount), 0) AS Total_Revenue
FROM (
    SELECT client_name, Amount FROM brokerage
    UNION ALL
    SELECT client_name, Amount FROM fees
    UNION ALL
    SELECT Client_Name AS client_name, Amount FROM invoice
) AS t
GROUP BY client_name
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Yearly Revenue Growth
SELECT
    YEAR(income_due_date) AS Revenue_Year,
    COALESCE(SUM(Amount), 0) AS Total_Revenue
FROM (
    SELECT Amount, income_due_date FROM brokerage
    UNION ALL
    SELECT Amount, income_due_date FROM fees
    UNION ALL
    SELECT Amount, income_due_date FROM invoice
) AS t
WHERE income_due_date IS NOT NULL
GROUP BY YEAR(income_due_date)
ORDER BY Revenue_Year;

-- Average Policy Value
SELECT
    ROUND(AVG(Amount), 2) AS Avg_Policy_Value
FROM brokerage
WHERE Amount IS NOT NULL;

-- Top 5 Account Executives by Total Revenue
WITH CombinedRevenue AS (
    SELECT Account_Exe_ID, Amount FROM brokerage
    UNION ALL
    SELECT Account_Exe_ID, Amount FROM fees
    UNION ALL
    SELECT Account_Exe_ID, Amount FROM invoice
)
SELECT
    b.Employee_Name,
    COALESCE(SUM(r.Amount), 0) AS Total_Revenue
FROM individual_budgets AS b
LEFT JOIN CombinedRevenue AS r
    ON b.Account_Exe_ID = r.Account_Exe_ID
GROUP BY b.Employee_Name
ORDER BY Total_Revenue DESC
LIMIT 5;


-- Budget Utilization % by Executive
WITH CombinedRevenue AS (
    SELECT Account_Exe_ID, Amount FROM brokerage
    UNION ALL
    SELECT Account_Exe_ID, Amount FROM fees
    UNION ALL
    SELECT Account_Exe_ID, Amount FROM invoice
)
SELECT
    b.Employee_Name,
    ROUND((COALESCE(SUM(r.Amount), 0) / 
          NULLIF((COALESCE(b.New_Budget,0) + COALESCE(b.Cross_Sell_Budget,0) + COALESCE(b.Renewal_Budget,0)),0)) * 100, 2) AS Budget_Utilization_Percentage
FROM individual_budgets AS b
LEFT JOIN CombinedRevenue AS r
    ON b.Account_Exe_ID = r.Account_Exe_ID
GROUP BY b.Employee_Name, b.New_Budget, b.Cross_Sell_Budget, b.Renewal_Budget
ORDER BY Budget_Utilization_Percentage DESC;

-- Meetings per Executive per Month
SELECT
    Account_Executive,
    DATE_FORMAT(meeting_date, '%Y-%m') AS Meeting_Month,
    COUNT(*) AS Total_Meetings
FROM meeting
WHERE meeting_date IS NOT NULL
GROUP BY Account_Executive, DATE_FORMAT(meeting_date, '%Y-%m')
ORDER BY Meeting_Month, Total_Meetings DESC;

-- Policy Count by Product Group
SELECT
    product_group,
    COUNT(policy_number) AS Total_Policies
FROM brokerage
GROUP BY product_group
ORDER BY Total_Policies DESC;

-- Active vs Lapsed Policies
SELECT
    CASE 
        WHEN policy_status = 'Active' THEN 'Active Policies'
        WHEN policy_status = 'Lapsed' THEN 'Lapsed Policies'
        ELSE 'Other'
    END AS Policy_Category,
    COUNT(*) AS Policy_Count
FROM brokerage
GROUP BY Policy_Category;

-- Renewal Status Count
SELECT
    renewal_status,
    COUNT(policy_number) AS Policy_Count
FROM brokerage
GROUP BY renewal_status
ORDER BY Policy_Count DESC;


-- Top Lapse Reasons
SELECT
    lapse_reason,
    COUNT(policy_number) AS Lapse_Count
FROM brokerage
WHERE lapse_reason IS NOT NULL AND TRIM(lapse_reason) <> ''
GROUP BY lapse_reason
ORDER BY Lapse_Count DESC
LIMIT 10;

-- Total Opportunity Revenue by Stage
SELECT
    stage,
    COALESCE(SUM(revenue_amount), 0) AS Total_Revenue
FROM opportunity
GROUP BY stage
ORDER BY Total_Revenue DESC;

-- Opportunities by Closing Month
SELECT
    DATE_FORMAT(closing_date, '%Y-%m') AS Closing_Month,
    COUNT(opportunity_id) AS Total_Opportunities
FROM opportunity
WHERE closing_date IS NOT NULL
GROUP BY DATE_FORMAT(closing_date, '%Y-%m')
ORDER BY Closing_Month;

