-- Check for Nulls and duplicates in order_id(PK)
SELECT
order_id,
COUNT(*) AS duplicate_count
FROM silver.olist_orders_dataset
GROUP BY order_id
HAVING COUNT(*) > 1 OR order_id IS NULL;

-- Check for nulls in other required columns
SELECT *
FROM silver.olist_orders_dataset
WHERE customer_id IS NULL
OR order_status IS NULL
OR order_purchase_timestamp IS NULL;

-- Check for customer id not present in customer table
SELECT o.customer_id
FROM silver.olist_orders_dataset AS o
LEFT JOIN silver.olist_customers_dataset AS c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Validate order status
SELECT order_status
FROM silver.olist_orders_dataset
WHERE order_status !=  TRIM(order_status);

SELECT DISTINCT order_status
FROM silver.olist_orders_dataset
ORDER BY order_status;

-- Validate Timestamps
SELECT *
FROM silver.olist_orders_dataset
WHERE order_approved_at < order_purchase_timestamp; --purchase timestamp should be earlier than approved at

SELECT *
FROM silver.olist_orders_dataset
WHERE order_delivered_carrier_date < order_approved_at;-- approved date should be earlier than delivery carrier date

SELECT *
FROM silver.olist_orders_dataset
WHERE order_delivered_customer_date < order_delivered_carrier_date; --delivery carrier date should be earlier than delivered to customer date

SELECT *
FROM silver.olist_orders_dataset
WHERE order_estimated_delivery_date < order_purchase_timestamp; --purchase timestamp should be earlier than estimated delivery date
