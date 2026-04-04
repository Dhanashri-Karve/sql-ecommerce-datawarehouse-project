/*
==================================================================================
Silver Layer : Create Table Script

This script prepares the Silver layer tables for the E-Commerce Data Warehouse
using the Brazilian Olist dataset.

For each dataset table:
1.Existing Silver tables are dropped and recreated to ensure a clean load.
2.Tables maintain a structure close to the source datasets.
3.A metadata column `dwh_creation_date` is added to each table to track
  when the record was inserted into the data warehouse

At this stage, data quality checks, transformations, and normalization rules 
are applied before the data is used for analytical modeling in the Gold layer
===================================================================================
*/

IF OBJECT_ID ('silver.olist_customers_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_customers_dataset;
GO

CREATE TABLE silver.olist_customers_dataset 
(
	customer_id NVARCHAR(50),
	customer_unique_id NVARCHAR(50),
	customer_zip_code_prefix NVARCHAR(10),
	customer_city NVARCHAR(50),
	customer_state NVARCHAR(10),
    dwh_creation_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.olist_geolocation_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_geolocation_dataset;
GO

CREATE TABLE silver.olist_geolocation_dataset 
(
    geolocation_zip_code_prefix NVARCHAR(10),
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city NVARCHAR(50),
    geolocation_state NVARCHAR(10),
    dwh_creation_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.olist_order_items_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_order_items_dataset;
GO

CREATE TABLE silver.olist_order_items_dataset
(
    order_id NVARCHAR(50),
    order_item_id INT,
    product_id NVARCHAR(50),
    seller_id NVARCHAR(50),
    shipping_limit_date DATETIME2,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    dwh_creation_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.olist_order_payments_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_order_payments_dataset;
GO

CREATE TABLE silver.olist_order_payments_dataset 
(
    order_id NVARCHAR(50),
    payment_sequential INT,
    payment_type NVARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    dwh_creation_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.olist_order_reviews_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_order_reviews_dataset;
GO

CREATE TABLE silver.olist_order_reviews_dataset 
(
    review_id NVARCHAR(50),
    order_id NVARCHAR(50),
    review_score INT,
    review_comment_title NVARCHAR(255),
    review_comment_message NVARCHAR(1000),
    review_creation_date DATETIME2,
    review_answer_timestamp DATETIME2,
    dwh_creation_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.olist_orders_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_orders_dataset;
GO

CREATE TABLE silver.olist_orders_dataset 
(
    order_id NVARCHAR(50),
    customer_id NVARCHAR(50),
    order_status NVARCHAR(20),
    order_purchase_timestamp DATETIME2,
    order_approved_at DATETIME2,
    order_delivered_carrier_date DATETIME2,
    order_delivered_customer_date DATETIME2,
    order_estimated_delivery_date DATETIME2,
    dwh_creation_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.olist_products_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_products_dataset;
GO

CREATE TABLE silver.olist_products_dataset 
(
    product_id NVARCHAR(50),
    product_category_name NVARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT,
    dwh_creation_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.olist_sellers_dataset', 'U') IS NOT NULL
    DROP TABLE silver.olist_sellers_dataset;
GO

CREATE TABLE silver.olist_sellers_dataset 
(
    seller_id NVARCHAR(50),
    seller_zip_code_prefix NVARCHAR(10),
    seller_city NVARCHAR(100),
    seller_state NVARCHAR(10),
    dwh_creation_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.olist_product_category_name_translation', 'U') IS NOT NULL
    DROP TABLE silver.olist_product_category_name_translation;
GO

CREATE TABLE silver.olist_product_category_name_translation 
(
    product_category_name NVARCHAR(100),
    product_category_name_english NVARCHAR(100),
    dwh_creation_date DATETIME2 DEFAULT GETDATE()
);
GO
