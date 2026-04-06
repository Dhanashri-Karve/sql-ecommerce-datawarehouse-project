## Brazilian Olist Ecommerce Data Warehouse (Project Overview)

This project implements a **SQL-based Data Warehouse** built using the Brazilian **Olist Ecommerce dataset** using Microsoft SQL Server.  
The objective is to transform raw ecommerce data into a **structured analytical model** that supports reporting, analytics, and business intelligence.

The warehouse follows a **Medallion Architecture (Bronze → Silver → Gold)** where raw operational data is progressively cleaned, standardized, and transformed into a **star schema optimized for analytical workloads**.

This project demonstrates core **data engineering concepts** including data ingestion, data quality validation, dimensional modeling, and warehouse design.

# Project Requirements

The data warehouse was designed to achieve the following objectives:

- Ingest raw ecommerce datasets into a centralized warehouse
- Clean and validate inconsistent data
- Standardize formats across multiple datasets
- Handle missing or invalid values
- Transform normalized transactional data into an **analytics-friendly dimensional model**
- Implement a **star schema** for efficient querying
- Create **business-ready views** for reporting and BI tools

# Dataset

**Source:** Brazilian Olist Ecommerce Dataset

The dataset contains information about:

- Customers
- Orders
- Order Items
- Payments
- Reviews
- Products
- Products Category Translation
- Sellers
- Geolocation

# Data Warehouse Architecture

The warehouse follows a **Medallion Architecture** that organizes data into three layers.









