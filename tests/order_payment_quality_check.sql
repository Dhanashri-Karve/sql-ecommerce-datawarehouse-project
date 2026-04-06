-- check for Nulls
SELECT *
FROM silver.olist_order_payments_dataset
WHERE order_id IS NULL
OR payment_sequential IS NULL
OR payment_type IS NULL
OR payment_installments IS NULL
OR payment_value IS NULL

-- Check for order id not present in orders table
SELECT DISTINCT op.order_id
FROM silver.olist_order_payments_dataset AS op
LEFT JOIN silver.olist_orders_dataset AS o
ON op.order_id = o.order_id
WHERE o.order_id IS NULL

-- Duplicates check
SELECT order_id,payment_sequential,COUNT(*)
FROM silver.olist_order_payments_dataset
GROUP BY order_id,payment_sequential
HAVING COUNT(*) > 1;

-- Data validation
SELECT DISTINCT payment_type
FROM SILVER.olist_order_payments_dataset

SELECT * FROM SILVER.olist_order_payments_dataset
WHERE payment_type = 'not defined'

-- Check for unwanted spaces
SELECT payment_type
FROM silver.olist_order_payments_dataset
WHERE payment_type != TRIM(payment_type)

-- Invalid Values
SELECT * FROM silver.olist_order_payments_dataset
WHERE payment_installments <= 0

SELECT * FROM silver.olist_order_payments_dataset
WHERE payment_value <= 0

SELECT * FROM silver.olist_order_payments_dataset
WHERE payment_sequential <= 0
