-- Check for Nulls
SELECT *
FROM silver.olist_geolocation_dataset
WHERE geolocation_zip_code_prefix IS NULL
   OR geolocation_lat IS NULL
   OR geolocation_lng IS NULL
   OR geolocation_city IS NULL
   OR geolocation_state IS NULL;

-- Check for duplicates 
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
    COUNT(*) AS duplicate_count
FROM silver.olist_geolocation_dataset
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
HAVING COUNT(*) > 1;

-- Compare total rows with unique zip codes
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT geolocation_zip_code_prefix) AS distinct_zip_prefix_count
FROM silver.olist_geolocation_dataset;

-- check for zipcode prefix length
SELECT geolocation_zip_code_prefix
FROM silver.olist_geolocation_dataset
WHERE LEN(geolocation_zip_code_prefix) != 5

-- Check for unwanted spaces
SELECT geolocation_city
FROM silver.olist_geolocation_dataset 
WHERE geolocation_city != TRIM(geolocation_city)

SELECT geolocation_state
FROM silver.olist_geolocation_dataset 
WHERE geolocation_state != TRIM(geolocation_state)

-- Check for state code format
SELECT geolocation_state 
FROM silver.olist_geolocation_dataset
WHERE LEN(geolocation_state) != 2

-- Check for city state consistency
SELECT geolocation_zip_code_prefix,
COUNT(DISTINCT geolocation_city) AS distinct_city_count
FROM silver.olist_geolocation_dataset 
GROUP BY geolocation_zip_code_prefix
HAVING COUNT(DISTINCT geolocation_city) > 1
