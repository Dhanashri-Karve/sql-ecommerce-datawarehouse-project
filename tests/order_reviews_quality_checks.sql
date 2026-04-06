-- check for Nulls
SELECT * FROM silver.olist_order_reviews_dataset
WHERE review_id IS NULL
	OR order_id IS NULL
	OR review_score IS NULL
	OR review_creation_date IS NULL
	OR review_answer_timestamp IS NULL

-- Check for duplicates 
SELECT
review_id,
order_id,
COUNT(*) AS duplicate_count
FROM silver.olist_order_reviews_dataset
GROUP BY review_id, order_id
HAVING COUNT(*) > 1;

SELECT
review_id,
COUNT(*) AS duplicate_count
FROM silver.olist_order_reviews_dataset
GROUP BY review_id
HAVING COUNT(*) > 1;

-- Check for order id's not present in orders table
SELECT r.order_id
FROM silver.olist_order_reviews_dataset AS r
LEFT JOIN silver.olist_orders_dataset AS o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Validate Review score
SELECT *
FROM silver.olist_order_reviews_dataset
WHERE review_score NOT BETWEEN 1 AND 5
AND review_score IS NOT NULL;

-- Check for invalid dates (future dates) in creation date
SELECT review_creation_date
FROM silver.olist_order_reviews_dataset
WHERE review_creation_date > GETDATE();

-- Check for invalid answer timestamps 
SELECT review_answer_timestamp
FROM silver.olist_order_reviews_dataset
WHERE review_answer_timestamp < review_creation_date;

-- Check for whitespaces
SELECT review_comment_message
FROM silver.olist_order_reviews_dataset
WHERE review_comment_message != TRIM(review_comment_message);

SELECT review_comment_title
FROM silver.olist_order_reviews_dataset
WHERE review_comment_title != TRIM(review_comment_title);

-- Check for empty strings
SELECT *
FROM silver.olist_order_reviews_dataset
WHERE review_comment_message = '';

SELECT *
FROM silver.olist_order_reviews_dataset
WHERE review_comment_title = '';
