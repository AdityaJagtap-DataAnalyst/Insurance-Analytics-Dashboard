# 🏥 Insurance Analytics Dashboard using Power BI

## 📊 Overview / Description
The **Insurance Analytics Dashboard** provides a complete analytical view of insurance revenue, client distribution, account executive performance, and policy insights.  
It is designed to help insurance teams track sales, monitor retention, understand business type performance, and identify opportunities for growth.

This dashboard converts raw insurance data into actionable insights for decision-making across **Revenue**, **Clients**, **Policies**, and **Account Executive Performance**.

---

## 🚀 Features of the Dashboard
- Total revenue, client count, policies, and client retention metrics.  
- Monthly revenue trend analysis.  
- Revenue contribution by account executives.  
- Top 10 clients by revenue.  
- Policy performance by business type (Inception, Renewal, Endorsement, Lapse).  
- Revenue segmentation by income class.  
- Achievement analysis for Cross Sell, New Business, and Renewal.  
- Meetings and opportunity pipeline insights.  
- Product group-wise revenue distribution.  
- Interactive slicers for Employee, Year, Policy Status, Product Group, and more.  
- One-click **Reset All Slicers** for better usability.

---

## 🔗 Live Dashboard Preview
👉 **[Click here to view the Power BI Report](https://app.powerbi.com/view?r=eyJrIjoiYTYxZjE2YjQtOGVhNC00YTVmLTk0OTItZDQ5YmM1ZTlhYmM5IiwidCI6IjdjNjZkNGIyLTVmY2QtNGRlYi1hMDQ4LTg1NGQ4ZWEyNDM3MSJ9)**  

---

## 📂 Data Used
- Insurance dataset containing:  
  - Policy numbers  
  - Revenue details  
  - Business type (New, Renewal, Cross Sell, Endorsement, Lapse)  
  - Account executive information  
  - Client revenue segmentation  
  - Product groups (Fire, Liability, Marine, etc.)  
  - Meetings and opportunity pipeline data  
  - Income class segmentation  

Data cleaned & transformed using **SQL + Power Query**, then modeled in Power BI.

---

## 🔄 ETL Process

### 1️⃣ Data Extraction  
Source data includes:  
- Client information  
- Policy performance  
- Revenue logs  
- Account executive and team activity  
- Product group mappings  
- Yearly business performance  

### 2️⃣ Data Transformation (SQL + Power Query)  
Performed:  
- Cleaned & standardized policy and client fields  
- Mapped account executives to revenue contribution  
- Created business type dimensions  
- Calculated revenue metrics, retention %, and achievements  
- Created monthly & yearly trend attributes  
- Feature engineering for:  
  - `policy_performance_score`  
  - `retention_flag`  
  - `target_achievement_ratio`  

### 3️⃣ Data Loading  
Final cleaned tables were structured using a **Star Schema**:

- **Fact Tables:** revenue_fact, policy_fact, opportunity_fact  
- **Dimension Tables:** employee_dim, client_dim, product_group_dim, date_dim, business_type_dim  

Optimized modeling ensures smoother DAX calculations and high dashboard performance.

---

## 📊 Dashboard Features

### 📁 1. Overview Dashboard

**Key Metrics:**  
- Total Revenue: **35.08M**  
- Total Clients: **106**  
- Total Policies: **521**  
- Client Retention %: **0.72**  

**Insights:**  
- Monthly revenue trend  
- Revenue by account executive  
- Top 10 clients by revenue  
- Performance by business type  
- Revenue by income class  

---

### 📁 2. Branch Dashboard

**Achievement KPIs:**  
- Cross Sell Placed Achievement %: **64.94%**  
- Cross Sell Invoice Achievement %: **14.15%**  
- New Placed Achievement %: **17.95%**  
- New Invoice Achievement %: **3.78%**  
- Renewal Placed Achievement %: **150.23%**  
- Renewal Invoice Achievement %: **63.91%**  

**Insights:**  
- Achievement comparison for Cross Sell, New, and Renewal  
- Meetings conducted by account executives  
- Performance by business type  
- Product group-wise revenue share  
- Opportunity pipeline by stages  
- Opportunity revenue distribution  

---

## 🧠 Smart Work & Value Addition
✔ End-to-end pipeline (ETL → SQL → Data Model → Power BI)  
✔ Feature engineering for income class, retention %, business performance  
✔ Clear KPIs for achievement performance  
✔ Segmentation by employee, product group, business type, and year  
✔ Clean & interactive slicers for advanced filtering  
✔ Professional UI with intuitive navigation  
✔ Strong storytelling using revenue, client, and policy insights  
✔ Enterprise-level analysis structure across two dashboards  



