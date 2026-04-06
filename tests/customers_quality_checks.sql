-- Check for Duplicate customer_id
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM silver.olist_customers_dataset
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- count of customer per unique id
SELECT
    customer_unique_id,
    COUNT(*) AS customer_id_count
FROM silver.olist_customers_dataset
GROUP BY customer_unique_id
HAVING COUNT(*) > 1;

-- Check for Nulls
SELECT *
FROM silver.olist_customers_dataset
WHERE customer_id IS NULL
   OR customer_unique_id IS NULL
   OR customer_zip_code_prefix IS NULL
   OR customer_city IS NULL
   OR customer_state IS NULL;

-- Check for unwanted spaces 
SELECT customer_city
FROM silver.olist_customers_dataset
WHERE customer_city != TRIM(customer_city);

SELECT customer_state
FROM silver.olist_customers_dataset
WHERE customer_state != TRIM(customer_state);

SELECT customer_unique_id
FROM silver.olist_customers_dataset
WHERE customer_unique_id != TRIM(customer_unique_id);

SELECT customer_id
FROM silver.olist_customers_dataset
WHERE customer_id != TRIM(customer_id);

SELECT customer_zip_code_prefix
FROM silver.olist_customers_dataset
WHERE customer_zip_code_prefix != TRIM(customer_zip_code_prefix);

-- Data Standardization and Consistency
SELECT DISTINCT customer_state
FROM silver.olist_customers_dataset;

SELECT customer_state
FROM silver.olist_customers_dataset
WHERE LEN(customer_state) != 2;  -- length of customer state must be 2

SELECT customer_zip_code_prefix
FROM silver.olist_customers_dataset
WHERE LEN(customer_zip_code_prefix) != 5 -- length of zip_codes must by 5

SELECT customer_state
FROM silver.olist_customers_dataset
WHERE customer_state != UPPER(customer_state); -- customer state must be in uppercase

-- Orders existing with no customers
SELECT o.customer_id
FROM silver.olist_orders_dataset AS o
LEFT JOIN silver.olist_customers_dataset AS c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Customers zipcodes not existing in geolocation dataset
SELECT c.*
FROM silver.olist_customers_dataset AS c
LEFT JOIN silver.olist_geolocation_dataset AS g
ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
WHERE g.geolocation_zip_code_prefix IS NULL;
