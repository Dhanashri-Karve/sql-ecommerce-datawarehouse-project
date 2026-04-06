-- Check for Nulls
SELECT * FROM silver.olist_product_category_name_translation
WHERE product_category_name IS NULL OR
product_category_name_english IS NULL;

-- Check for duplicate rows in the key 
SELECT product_category_name,
COUNT(*) AS total_count
FROM silver.olist_product_category_name_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;

-- Check: If one product_category has more than one english translation
SELECT product_category_name,
COUNT(DISTINCT product_category_name_english) AS distinct_count
FROM silver.olist_product_category_name_translation
GROUP BY product_category_name
HAVING COUNT(DISTINCT product_category_name_english)>1

-- Check for unwanted spaces
SELECT product_category_name
FROM silver.olist_product_category_name_translation
WHERE product_category_name != TRIM(product_category_name)

SELECT product_category_name_english
FROM silver.olist_product_category_name_translation
WHERE product_category_name_english != TRIM(product_category_name_english)

-- Check for Case standardization
SELECT product_category_name
FROM silver.olist_product_category_name_translation
WHERE product_category_name != LOWER(product_category_name)

SELECT product_category_name_english
FROM silver.olist_product_category_name_translation
WHERE product_category_name_english != LOWER(product_category_name_english)

-- Check for key consistency
SELECT DISTINCT p.product_category_name
FROM silver.olist_products_dataset p
LEFT JOIN silver.olist_product_category_name_translation t
ON p.product_category_name = t.product_category_name
WHERE t.product_category_name IS NULL;
