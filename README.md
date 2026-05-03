# UPI Fraud Risk Monitoring & Analysis

## Project Description

This project focuses on analyzing UPI transaction data to detect fraud patterns, monitor risk, and evaluate system performance.

Using SQL, Python, Excel, and Power BI, I built an end-to-end analytical pipeline covering data cleaning, feature engineering, statistical analysis, and interactive dashboards for fraud monitoring.

---

## Table of Contents

* Project Description
* Table of Contents
* Overview
* Business Problem
* Tools & Technologies
* Datasets
* Dashboard Pages
* Key Insights
* Final Recommendations
* Author & Contact

---

## Overview

With the rapid growth of digital payments, fraud detection and risk monitoring have become critical for financial systems.

This project simulates a real-world fraud monitoring system by analyzing transaction behavior, customer risk, and operational performance to generate actionable insights.

---

## Business Problem

* Identify fraud patterns and risk indicators across transactions
* Evaluate failure rates and operational inefficiencies
* Analyze customer, device, and merchant-level risk
* Monitor fraud resolution efficiency
* Support better fraud detection strategies

---

## Tools & Technologies

* SQL: Data modeling, joins, and analytical queries
* Python: Data cleaning, EDA, feature engineering, statistical analysis
* Power BI: Interactive dashboards and KPI tracking
* Excel: Initial data handling

---

## Datasets

### Tables Used

* customer_master
* device_info
* upi_account_details
* merchant_info
* upi_transaction_history
* customer_feedback_surveys
* fraud_alert_history

### Data Summary

The dataset simulates a relational UPI ecosystem:

* ~100,000 transactions
* ~10,000 customers
* ~12,000 devices
* ~2,000 fraud alerts

### Key Data Components

**Customer Data**
Demographics, risk score, onboarding details

**Device Data**
Device type, rooted status, activity tracking

**Transaction Data (Core Table)**
Transaction amount, timestamp, channel, fraud flag, status

**Fraud Alerts**
Alert types, detection timestamps, resolution tracking

---

## 🧩 Data Model

The data model represents relationships between customers, transactions, devices, merchants, and fraud alerts.

<img width="1268" height="811" alt="Image" src="https://github.com/user-attachments/assets/c15a4532-cd6b-4f6b-a9c2-f56bcefadebc" />
---

## Dashboard Pages

### 1️⃣ Executive Overview

* Total Transactions: 100K
* Fraud Rate: ~2%
* Failure Rate: ~5.87%
* Avg Transaction Amount: ₹42.42

Tracks overall system performance and trends.

### Executive Overview

<img width="1323" height="744" alt="Image" src="https://github.com/user-attachments/assets/ee42e558-577c-4349-8d95-7806d6eaa9e0" />
---


### Fraud Analysis

<img width="1322" height="747" alt="Image" src="https://github.com/user-attachments/assets/ae8c920a-06a5-4ed9-860c-f11a34302045" />


### 2️⃣ Transaction & Regional Analysis

* Monthly transaction trends
* Regional distribution of transactions
* Merchant-level transaction insights

---

### 3️⃣ Fraud & Risk Analysis

* Fraud rate by device type
* Risk score vs fraud patterns
* High-risk customer identification

---

### 4️⃣ Fraud Monitoring Dashboard

* Total Fraud Transactions: ~2K
* Avg Resolution Time: ~35 hours
* Alert type distribution
* Resolved vs unresolved fraud alerts

---

## Key Insights

* Fraud rate remains stable (~2%) despite increasing transaction volume
* Fraud is evenly distributed → rule-based detection is not sufficient
* High-risk customers show fraud ratios up to 50%+
* Failure rate (~5.87%) highlights operational inefficiencies
* Fraud resolution time (~35 hours) indicates delayed response systems
* Device type and region have minimal impact on fraud occurrence
* Night transactions (~33%) indicate potential behavioral risk window

---

## Final Recommendations

* Implement anomaly-based fraud detection models
* Prioritize monitoring of high-risk customers and merchants
* Reduce fraud resolution time using automated alert systems
* Investigate failure patterns to improve transaction success rates
* Use behavioral signals (time, frequency, patterns) for better fraud detection

---

## Author & Contact

👩‍💻 Author: Divya Shaw

📧 Email: [divyashaw144@gmail.com](mailto:divyashaw144@gmail.com)

🔗 LinkedIn: https://www.linkedin.com/in/divya-shaw144/

---
