-- Check for Duplicates or Nulls in Primary Key
SELECT
seller_id,
COUNT(*) AS duplicate_count
FROM silver.olist_sellers_dataset
GROUP BY seller_id
HAVING COUNT(*) > 1 OR seller_id IS NULL;

-- check for Nulls in Columns
SELECT *
FROM silver.olist_sellers_dataset
WHERE seller_zip_code_prefix IS NULL
   OR seller_city IS NULL
   OR seller_state IS NULL;
	 
-- Check for Unwanted Spaces 
SELECT seller_city
FROM silver.olist_sellers_dataset
WHERE seller_city != TRIM(seller_city);

SELECT seller_state
FROM silver.olist_sellers_dataset
WHERE seller_state != TRIM(seller_state);

SELECT seller_id
FROM silver.olist_sellers_dataset
WHERE seller_id != TRIM(seller_id);

-- Validate length
SELECT seller_zip_code_prefix
FROM silver.olist_sellers_dataset
WHERE LEN(seller_zip_code_prefix) != 5;

SELECT seller_state
FROM silver.olist_sellers_dataset
WHERE LEN(seller_state) != 2;

-- Check for order items with no sellers
SELECT o.seller_id
FROM silver.olist_order_items_dataset AS o
LEFT JOIN silver.olist_sellers_dataset AS s
ON o.seller_id = s.seller_id
WHERE s.seller_id IS NULL

-- Check for sellers zipcode missing in geolocation table
SELECT s.seller_zip_code_prefix
FROM silver.olist_sellers_dataset AS s
LEFT JOIN silver.olist_geolocation_dataset AS g
ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix
WHERE g.geolocation_zip_code_prefix IS NULL

-- Check for invalid values
SELECT seller_city 
FROM silver.olist_sellers_dataset
WHERE seller_city LIKE '%[0-9]%' -- invalid(numeric) city name

SELECT 
s.seller_zip_code_prefix AS seller_zipcode, 
g.geolocation_zip_code_prefix AS location_zipcode,
s.seller_city , 
g.geolocation_city
FROM silver.olist_sellers_dataset AS s
LEFT JOIN silver.olist_geolocation_dataset AS g
ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix
WHERE s.seller_city != g.geolocation_city -- seller city mismatch

SELECT
s.seller_zip_code_prefix AS seller_zipcode,
g.geolocation_zip_code_prefix AS location_zipcode,
s.seller_state,
g.geolocation_state
FROM silver.olist_sellers_dataset AS s
LEFT JOIN silver.olist_geolocation_dataset AS g
ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix
WHERE s.seller_state !=  g.geolocation_state; -- seller state mismatch
