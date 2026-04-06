## Gold Layer Schema Documentation

The Gold layer contains **business-ready dimensional models** built from the cleaned Silver layer.  
It follows a **star schema design** consisting of fact and dimension tables optimized for analytics, reporting, and business intelligence workloads.

---

## gold.dim_customers

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| customer_key | INT | Surrogate key uniquely identifying each customer in the dimension. |
| customer_uid | VARCHAR | Unique identifier representing a real customer across multiple orders. |
| zip_code_prefix | INT | Customer ZIP code prefix used for geographic analysis. |
| city | VARCHAR | City where the customer is located. |
| state | VARCHAR | Brazilian state where the customer resides. |

---

## gold.dim_products

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| product_key | INT | Surrogate key uniquely identifying each product. |
| product_id | VARCHAR | Unique identifier of the product in the source system. |
| category_name | VARCHAR | Product category name in Portuguese. |
| english_category_name | VARCHAR | Translated product category name in English. |
| name_length | INT | Length of the product name text. |
| description_length | INT | Length of the product description text. |
| photos_quantity | INT | Number of product photos available. |
| weight_g | INT | Product weight in grams. |
| length_cm | INT | Product length in centimeters. |
| width_cm | INT | Product width in centimeters. |

---

## gold.dim_sellers

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| seller_key | INT | Surrogate key uniquely identifying each seller. |
| seller_id | VARCHAR | Unique identifier of the seller in the source system. |
| zip_code_prefix | INT | Seller ZIP code prefix used for geographic analysis. |
| city | VARCHAR | City where the seller operates. |
| state | VARCHAR | Brazilian state where the seller is located. |

---

## gold.dim_geolocation (Reference Dimension)

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| geolocation_key | INT | Surrogate key uniquely identifying each geolocation record. |
| zip_code_prefix | INT | ZIP code prefix used to link geographic information. |
| latitude | DECIMAL | Latitude coordinate of the location. |
| longitude | DECIMAL | Longitude coordinate of the location. |
| city | VARCHAR | City associated with the ZIP code prefix. |
| state | VARCHAR | Brazilian state associated with the ZIP code prefix. |

---

## gold.fact_sales

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| order_line_key | INT | Surrogate key representing each order line transaction. |
| order_id | VARCHAR | Unique identifier for each order. |
| order_item_id | INT | Sequential number identifying the item within an order. |
| customer_key | INT | Foreign key referencing the customer dimension. |
| product_key | INT | Foreign key referencing the product dimension. |
| seller_key | INT | Foreign key referencing the seller dimension. |
| order_status | VARCHAR | Current status of the order (delivered, shipped, etc.). |
| order_purchase_datetime | DATETIME | Timestamp when the order was placed. |
| order_approval_datetime | DATETIME | Timestamp when the order payment was approved. |
| carrier_pickup_datetime | DATETIME | Timestamp when the carrier picked up the order. |
| delivery_datetime | DATETIME | Timestamp when the order was delivered to the customer. |
| estimated_delivery_datetime | DATETIME | Estimated delivery date provided at purchase time. |
| product_price | DECIMAL | Price of the product in the order line. |
| shipping_cost | DECIMAL | Shipping cost associated with the order item. |
| order_payment_value | DECIMAL | Total payment value for the order. |
| average_review_score | DECIMAL | Average customer review score for the order. |
