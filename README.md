## Brazilian Olist Ecommerce Data Warehouse (Project Overview)

This project implements a **SQL-based Data Warehouse** built using the Brazilian **Ecommerce dataset by Olist** using Microsoft SQL Server.  
The objective is to transform raw ecommerce data into a **structured analytical model** that supports reporting, analytics, and business intelligence.

The warehouse follows a **Medallion Architecture (Bronze → Silver → Gold)** where raw operational data is progressively cleaned, standardized, and transformed into a **star schema optimized for analytical workloads**.

This project demonstrates data ingestion, data quality validation, dimensional modeling, and warehouse design.

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

**Source:** [Brazilian E-Commerce Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

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
![Data Architecture!](https://github.com/Dhanashri-Karve/sql-ecommerce-datawarehouse-project/blob/main/docs/data_architecture.png)

---

## Bronze Layer – Raw Data

The Bronze layer stores **raw source data** with minimal transformation.

Characteristics:

- Raw dataset ingestion
- Original structure preserved
- Serves as the **source of truth**
- Enables traceability and recovery

---

## Silver Layer – Cleaned & Standardized Data

The Silver layer focuses on **data cleaning and quality improvements**.

Transformations include:

- Removing duplicate records
- Standardizing text formatting
- Handling null values
- Validating timestamps
- Correcting inconsistent records

This layer produces **clean and reliable datasets** ready for modeling.

---

## Gold Layer – Analytical Data Model

The Gold layer contains **business-ready views** designed for analytics and reporting.

A **Star Schema** is implemented consisting of:

**Fact Table**

- `fact_sales`

**Dimension Tables**

- `dim_customers`
- `dim_products`
- `dim_sellers`
- `dim_geolocation` (reference dimension)

These views are optimized for **analytical queries and BI tools**.

# Data Model (Star Schema)

The Gold layer implements a **Star Schema** where transactional data is stored in a fact table and descriptive attributes are stored in dimension tables.

![Star Schema](https://github.com/Dhanashri-Karve/sql-ecommerce-datawarehouse-project/blob/main/docs/data_model.png)

**Fact Table**

- `fact_sales` – transactional order item data

**Dimension Tables**

- `dim_customers`
- `dim_products`
- `dim_sellers`
- `dim_geolocation`

The schema enables analysis across key business dimensions such as **customers, products, sellers, geography

# Data Quality Checks

Data validation was implemented during the **Silver layer transformation process** to ensure reliability.

Key checks include:

- Removing duplicate records
- Standardizing text values
- Handling missing values
- Validating timestamp consistency
- Correcting invalid delivery dates
- Ensuring referential consistency between datasets

These steps ensure the **Gold layer contains clean and trusted analytical data**.

## Tools & Technologies

- SQL (T-SQL)
- Microsoft SQL Server
- Data Warehouse Design
- Dimensional Modeling
- Medallion Architecture (Bronze, Silver, Gold)
- Git
- GitHub

