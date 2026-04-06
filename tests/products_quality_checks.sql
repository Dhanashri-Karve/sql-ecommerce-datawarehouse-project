-- Check for Nulls and duplicates
SELECT product_id,
COUNT(*) total_count
FROM silver.olist_products_dataset
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL;

-- check for unwanted space 
SELECT product_id
FROM silver.olist_products_dataset
WHERE product_id != TRIM(product_id)

SELECT product_category_name
FROM silver.olist_products_dataset
WHERE product_category_name != TRIM(product_category_name)

-- Check for Nulls in other columns
SELECT 
product_category_name,
product_name_lenght,
product_description_lenght,
product_photos_qty,
product_weight_g,
product_length_cm,
product_height_cm,
product_width_cm
FROM silver.olist_products_dataset
WHERE product_category_name IS NULL OR
product_name_lenght IS NULL OR 
product_description_lenght IS NULL OR
product_photos_qty IS NULL OR
product_weight_g IS NULL OR
product_length_cm IS NULL OR
product_height_cm IS NULL OR
product_width_cm IS NULL 

-- Key consistency
Select distinct o.product_id
from silver.olist_order_items_dataset as o
left join silver.olist_products_dataset as p
on o.product_id = p.product_id
where p.product_id is null

SELECT DISTINCT p.product_category_name
FROM silver.olist_products_dataset p
LEFT JOIN silver.olist_product_category_name_translation t
ON p.product_category_name = t.product_category_name
WHERE t.product_category_name IS NULL
AND p.product_category_name IS NOT NULL;

-- Check for invalid values
SELECT *
FROM silver.olist_products_dataset
WHERE product_weight_g <= 0
OR product_length_cm <= 0
OR product_height_cm <= 0
OR product_width_cm <= 0;

SELECT * FROM silver.olist_products_dataset
WHERE product_name_lenght <= 0
OR product_description_lenght <= 0
OR product_photos_qty < 0
