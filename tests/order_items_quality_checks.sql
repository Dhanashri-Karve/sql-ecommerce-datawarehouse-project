-- Check for Nulls
SELECT *
FROM silver.olist_order_items_dataset
WHERE order_id IS NULL
OR order_item_id IS NULL
OR product_id IS NULL
OR seller_id IS NULL
OR shipping_limit_date IS NULL

-- Check for Duplicates 
SELECT order_id, order_item_id, COUNT(*) AS total_count
FROM silver.olist_order_items_dataset
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

-- Check for order id's not present in orders table
SELECT oi.order_id
FROM bronze.olist_order_items_dataset AS oi
LEFT JOIN silver.olist_orders_dataset AS o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL

-- Check for product id's not present in products table
SELECT oi.product_id
FROM silver.olist_order_items_dataset AS oi
LEFT JOIN silver.olist_products_dataset AS p
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL

-- Check for seller id's not present in sellers table
SELECT oi.seller_id
FROM silver.olist_order_items_dataset AS oi
LEFT JOIN silver.olist_sellers_dataset AS s
ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL

-- Check for invalid values
SELECT shipping_limit_date
FROM silver.olist_order_items_dataset
WHERE shipping_limit_date > GETDATE()

SELECT *
FROM silver.olist_order_items_dataset
WHERE price <= 0

SELECT *
FROM silver.olist_order_items_dataset
WHERE freight_value < 0

SELECT *
FROM silver.olist_order_items_dataset
WHERE price IS NULL
OR freight_value IS NULL
