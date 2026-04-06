/*
===============================================================================
Gold Layer : Create Views

Description:
The Gold Layer contains business-ready views built on the cleaned Silver Layer. 
It includes fact tables for transactional data and dimension tables 
for descriptive context, following a star schema.

These views are optimized for analytics, reporting, and BI consumption
===============================================================================
*/

--  ----------------------------------------------------------------------
--  Create gold.dim_customers
--  ----------------------------------------------------------------------

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
	DROP VIEW gold.dim_customers
GO

CREATE VIEW gold.dim_customers AS

WITH customer_rank AS 
(
	SELECT
		c.customer_unique_id,
		c.customer_zip_code_prefix,
		c.customer_city,
		c.customer_state,
		ROW_NUMBER() OVER(PARTITION BY c.customer_unique_id ORDER BY o.order_purchase_timestamp DESC,c.customer_id) c_rank
	FROM silver.olist_customers_dataset AS c
	LEFT JOIN silver.olist_orders_dataset AS o
	ON c.customer_id = o.customer_id
)

SELECT
	ROW_NUMBER() OVER(ORDER BY customer_unique_id) AS customer_key,-- surrogate key
	customer_unique_id AS customer_uid,
	customer_zip_code_prefix AS zip_code_prefix,
	customer_city AS city,
	customer_state AS state
FROM customer_rank
WHERE c_rank = 1;
GO

--  ----------------------------------------------------------------------
--  Create gold.dim_products
--  ----------------------------------------------------------------------

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
	DROP VIEW gold.dim_products
GO

CREATE VIEW gold.dim_products AS

SELECT
	ROW_NUMBER() OVER(ORDER BY p.product_id) AS product_key, -- surrogate key
	p.product_id,
	p.product_category_name AS category_name,
	COALESCE(pt.product_category_name_english,'n/a') AS english_category_name,
	p.product_name_lenght AS name_length,
	p.product_description_lenght AS description_length,
	p.product_photos_qty AS photos_quantity,
	p.product_weight_g AS weight_g,
	p.product_length_cm AS length_cm,
	p.product_width_cm AS width_cm
FROM silver.olist_products_dataset AS p
LEFT JOIN silver.olist_product_category_name_translation AS pt
ON p.product_category_name = pt.product_category_name
GO

--  ----------------------------------------------------------------------
--  Create gold.dim_sellers
--  ----------------------------------------------------------------------

IF OBJECT_ID('gold.dim_sellers', 'V') IS NOT NULL
	DROP VIEW gold.dim_sellers
GO

CREATE VIEW gold.dim_sellers AS

SELECT 
	ROW_NUMBER() OVER(ORDER BY seller_id) AS seller_key,-- surrogate key
	seller_id,
	seller_zip_code_prefix AS zip_code_prefix,
	seller_city AS city,
	seller_state AS state
FROM silver.olist_sellers_dataset
GO

--  ----------------------------------------------------------------------
--  Create gold.dim_geolocation (Reference Dimension)
--  ----------------------------------------------------------------------

IF OBJECT_ID('gold.dim_geolocation', 'V') IS NOT NULL
	DROP VIEW gold.dim_geolocation
GO

CREATE VIEW gold.dim_geolocation AS

SELECT
	ROW_NUMBER() OVER(ORDER BY geolocation_zip_code_prefix) AS geolocation_key,-- surrogate key
	geolocation_zip_code_prefix AS zip_code_prefix,
	geolocation_lat AS latitude,
	geolocation_lng AS longitude,
	geolocation_city AS city,
	geolocation_state AS state
FROM silver.olist_geolocation_dataset
GO

--  ----------------------------------------------------------------------
--  Create gold.fact_sales
--  ----------------------------------------------------------------------

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales
GO

CREATE VIEW gold.fact_sales AS

WITH order_payments AS (
	Select
		order_id,
		SUM(payment_value) AS total_payment_value
	FROM silver.olist_order_payments_dataset
	GROUP BY order_id
),

order_reviews AS (
	SELECT
		order_id,
		AVG(review_score) AS avg_review_score
	FROM silver.olist_order_reviews_dataset
	GROUP BY order_id
),

order_summary AS (
SELECT 
	oi.order_id,
	oi.order_item_id,
	o.customer_id,
	oi.product_id,
	oi.seller_id,
	o.order_status,
	o.order_purchase_timestamp,
	o.order_approved_at,
	o.order_delivered_carrier_date,
	o.order_delivered_customer_date,
	o.order_estimated_delivery_date,
	oi.price,
	oi.freight_value,
	op.total_payment_value,
	ro.avg_review_score
FROM silver.olist_order_items_dataset AS oi
LEFT JOIN silver.olist_orders_dataset AS o
ON oi.order_id = o.order_id
LEFT JOIN order_payments AS op
ON oi.order_id = op.order_id
LEFT JOIN order_reviews AS ro
ON oi.order_id = ro.order_id
) 

Select
	ROW_NUMBER() OVER(ORDER BY os.order_id, os.order_item_id) AS order_line_key, -- surrogate key
	os.order_id,
	os.order_item_id,
	dc.customer_key,
	dp.product_key,
	ds.seller_key,
	os.order_status,
	os.order_purchase_timestamp AS order_purchase_datetime,
	os.order_approved_at AS order_approval_datetime,
	os.order_delivered_carrier_date AS carrier_pickup_datetime,
	os.order_delivered_customer_date AS delivery_datetime,
	os.order_estimated_delivery_date AS estimated_delivery_datetime,
	os.price AS product_price,
	os.freight_value AS shipping_cost,
	os.total_payment_value AS order_payment_value,
	os.avg_review_score AS average_review_score
FROM order_summary AS os
LEFT JOIN silver.olist_customers_dataset AS sc
ON os.customer_id = sc.customer_id
LEFT JOIN gold.dim_customers AS dc
on sc.customer_unique_id = dc.customer_uid
LEFT JOIN gold.dim_products AS dp
ON os.product_id = dp.product_id
LEFT JOIN gold.dim_sellers AS ds
ON os.seller_id = ds.seller_id
GO
