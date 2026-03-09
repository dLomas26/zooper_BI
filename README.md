# 🚗 Zopper Insurance BI Analytics Project

![Python](https://img.shields.io/badge/Python-3.10-blue)
![SQL](https://img.shields.io/badge/SQL-Analytics-green)
![Data](https://img.shields.io/badge/Dataset-1M%20Records-orange)
![BI](https://img.shields.io/badge/Business%20Intelligence-Analysis-purple)

A **Business Intelligence & Data Analytics project** that simulates large-scale insurance policy sales and claims activity to analyze **portfolio profitability, risk exposure, and claim patterns**.

The project demonstrates **data simulation, SQL analytics, and business insights generation** using **1,000,000 simulated insurance policies**.

---

# 📌 Project Overview

Insurance companies rely on historical policy and claims data to evaluate risk and pricing strategies.  
Since real datasets are not publicly available, this project **simulates realistic insurance data** based on business rules.

The generated dataset is analyzed to answer important business questions such as:

- Total premium collected
- Monthly claim trends
- Loss ratio by policy tenure
- Portfolio profitability
- Future claim liability estimation
- Earned premium calculations

---

# 📊 Dataset Summary

## Policy Sales Dataset (2024)

Total simulated policies:

**1,000,000**

| Column | Description |
|------|-------------|
Customer_ID | Unique customer identifier |
Vehicle_ID | Unique vehicle identifier |
Vehicle_Value | ₹100,000 |
Premium | ₹100 per policy year |
Policy_Purchase_Date | Vehicle purchase date |
Policy_Start_Date | Purchase Date + 365 days |
Policy_End_Date | Start Date + policy tenure |
Policy_Tenure | 1, 2, 3, or 4 years |

### Tenure Distribution

| Tenure | Share |
|------|------|
1 Year | 20%
2 Years | 30%
3 Years | 40%
4 Years | 10%

Policies were **distributed evenly across all days of 2024**.

---

# 💰 Claims Dataset (2025–2026)

### Claim Amount Formula

Claim Amount = 10% of vehicle value
Claim Amount = ₹10,000

---

## Claims Rules – 2025

Vehicles purchased on:
7th
14th
21st
28th

were eligible for claims.

Rules applied:

- **30% of eligible vehicles filed claims**
- Claim date = **Policy Start Date**
- Only **one claim per vehicle per year**

---

## Claims Rules – 2026

- Only **4-year tenure policies** eligible
- **10% of those policies filed claims**
- Claims distributed evenly between Jan 1 2026 – Feb 28 2026

Vehicles that claimed in **2025 could claim again in 2026** if eligible.

---

# ⚙️ Project Workflow

## 1️⃣ Data Simulation

Synthetic datasets were generated using:

- Python
- Pandas
- NumPy

Generated files:

policy_sales_data.csv
claims_data.csv

---

## 2️⃣ Data Analysis

The datasets were imported into SQL for analytics.

Main analyses performed:

- Total premium collected
- Monthly claim trends
- Claim-to-premium ratios
- Policy tenure profitability
- Earned premium estimation
- Future liability projection

---

# 📈 Key Results

| Metric | Value |
|------|------|
Total Policies | 1,000,000
Total Premium Collected | ₹24.01 Cr
Total Claims (2025) | ₹39.38 Cr
Total Claims (2026 Jan–Feb) | ₹9.89 Cr
Portfolio Loss Ratio | **205%**
Potential Claim Liability | ₹951 Cr

---

# 🔍 Key Insights

- The insurance portfolio is **structurally unprofitable**.
- Claims exceed premiums significantly (**loss ratio 205%**).
- **3-year policies perform best** relative to premium collected.
- **1-year and 4-year policies are highest risk segments**.
- Pricing structure is **significantly underpriced relative to claim severity**.

---

# 🛠 Tools & Technologies

- Python
- Pandas
- NumPy
- SQL
- Excel / BI Tools

---

# 📊 Business Impact

This project demonstrates how **data simulation and analytics can support insurance portfolio decision-making**, including:

- premium pricing strategy
- risk segmentation
- loss ratio monitoring
- long-term liability forecasting

---

# 👨‍💻 Author

**Deepanshu Lomas**

Business Intelligence / Data Analytics Project
