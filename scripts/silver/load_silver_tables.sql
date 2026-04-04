/*
===============================================================================
Procedure: silver.load_silver

Description:
	- This stored procedure performs ETL process to load data from the 
	  Bronze layer into the Silver layer
	- It performs data cleansing,standardization, and validation 
	  before the data is used in the Gold layer

How it works:
	1. Truncates existing Silver tables and reloads them with transformed data.
	2. Cleans and standardizes the data
	3. Handle invalid and inconsistent data.
	4. Aggregates and validates logical relationships between tables.
	5. racks and prints load duration for each table and the full batch process.

Error Handling:
	Uses TRY–CATCH to capture errors and log them into logs.error_log for
	troubleshooting.

Usage:
	EXEC silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME , @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		 SET @batch_start_time = GETDATE();

		PRINT '========================================================';
		PRINT 'Loading Silver Layer';
		PRINT '========================================================';

		SET @start_time = GETDATE(); 

		PRINT '-- Truncating Table: silver.olist_customers_dataset';
		TRUNCATE TABLE silver.olist_customers_dataset;

		PRINT '-- Inserting Data into: silver.olist_customers_dataset';
		INSERT INTO silver.olist_customers_dataset
		(
			customer_id,
			customer_unique_id,
			customer_zip_code_prefix,
			customer_city,
			customer_state 
		)
		
		SELECT 
			customer_id,
			customer_unique_id,
			customer_zip_code_prefix,
			LOWER(TRIM(customer_city)) AS customer_city,
			UPPER(TRIM(customer_state)) AS customer_state
		FROM bronze.olist_customers_dataset

		SET @end_time = GETDATE();

		PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '--------------------';

		SET @start_time = GETDATE(); 

		PRINT '-- Truncating Table: silver.olist_geolocation_dataset';
		TRUNCATE TABLE silver.olist_geolocation_dataset;

		PRINT '-- Inserting Data into: silver.olist_geolocation_dataset';
		INSERT INTO silver.olist_geolocation_dataset
		(
			geolocation_zip_code_prefix,
			geolocation_lat,
			geolocation_lng,
			geolocation_city,
			geolocation_state   
		)

		SELECT
			geolocation_zip_code_prefix,
			AVG(geolocation_lat) AS geolocation_lat,
			AVG(geolocation_lng) AS geolocation_lng,
			MIN(LOWER(TRIM(geolocation_city))) AS geolocation_city,
			MIN(UPPER(TRIM(geolocation_state))) AS geolocation_state
		FROM bronze.olist_geolocation_dataset
		GROUP BY geolocation_zip_code_prefix 

		SET @end_time = GETDATE();

		PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '--------------------';
	  
		SET @start_time = GETDATE(); 
	
		PRINT '-- Truncating Table: silver.olist_order_items_dataset';
		TRUNCATE TABLE silver.olist_order_items_dataset;

		PRINT '-- Inserting Data into: silver.olist_order_items_dataset';
		INSERT INTO silver.olist_order_items_dataset
		(
			order_id,
			order_item_id,
			product_id,
			seller_id,
			shipping_limit_date,
			price,
			freight_value
		)

		SELECT 
		order_id,
		order_item_id,
		product_id,
		seller_id,
		shipping_limit_date,
		CASE WHEN price <= 0 THEN NULL
			 ELSE price
		END AS price,
		CASE WHEN freight_value < 0 THEN NULL
			 ELSE freight_value
		END AS freight_value
		FROM bronze.olist_order_items_dataset

		SET @end_time = GETDATE();

		PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '--------------------';

		SET @start_time = GETDATE(); 

		PRINT '-- Truncating Table: silver.olist_order_payments_dataset';
		TRUNCATE TABLE silver.olist_order_payments_dataset;

		PRINT '-- Inserting Data into: silver.olist_order_payments_dataset';
		INSERT INTO silver.olist_order_payments_dataset
		(
			 order_id,
			 payment_sequential,
			 payment_type,
			 payment_installments,
			 payment_value
		)

		SELECT
		order_id,
		payment_sequential,
		REPLACE(LOWER(payment_type),'_',' ') AS payment_type,
		CASE WHEN payment_installments <= 0 THEN 1
			 ELSE payment_installments
		END payment_installments,
		CASE WHEN payment_value < 0 THEN NULL
			 ELSE payment_value
		END payment_value
		FROM bronze.olist_order_payments_dataset

		SET @end_time = GETDATE();

		PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '--------------------';

		SET @start_time = GETDATE(); 

		PRINT '-- Truncating Table: silver.olist_order_reviews_dataset';
		TRUNCATE TABLE silver.olist_order_reviews_dataset;

		PRINT '-- Inserting Data into: silver.olist_order_reviews_dataset';
		INSERT INTO silver.olist_order_reviews_dataset
		(
			review_id,
			order_id,
			review_score,
			review_comment_title,
			review_comment_message,
			review_creation_date,
			review_answer_timestamp
		)

		SELECT
		review_id,
		order_id,
		CASE WHEN review_score BETWEEN 1 AND 5 THEN review_score
			 ELSE NULL
		END AS review_score,
		LOWER(NULLIF(TRIM(review_comment_title),'')) AS review_comment_title,
		LOWER(NULLIF(TRIM(review_comment_message),'')) AS review_comment_message,
		review_creation_date,
		CASE WHEN review_answer_timestamp < review_creation_date THEN NULL
			 ELSE review_answer_timestamp
		END AS review_answer_timestamp
		FROM bronze.olist_order_reviews_dataset

		SET @end_time = GETDATE();

		PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '--------------------';

		SET @start_time = GETDATE(); 

		PRINT '-- Truncating Table: silver.olist_orders_dataset';
		TRUNCATE TABLE silver.olist_orders_dataset;

		PRINT '-- Inserting Data into: silver.olist_orders_dataset';
		INSERT INTO silver.olist_orders_dataset
		(
			order_id,
			customer_id,
			order_status,
			order_purchase_timestamp,
			order_approved_at,
			order_delivered_carrier_date,
			order_delivered_customer_date,
			order_estimated_delivery_date
		)

		SELECT 
		order_id,
		customer_id,
		LOWER(TRIM(order_status)) AS order_status,
		order_purchase_timestamp,

		CASE WHEN order_approved_at < order_purchase_timestamp THEN NULL
			 ELSE order_approved_at
		END As order_approved_at,

		CASE WHEN order_delivered_carrier_date < order_approved_at THEN NULL
			 ELSE order_delivered_carrier_date
		END AS order_delivered_carrier_date,

		CASE WHEN order_delivered_customer_date < order_delivered_carrier_date THEN NULL
			 ELSE order_delivered_customer_date
		END AS order_delivered_customer_date,

		CASE WHEN order_estimated_delivery_date < order_purchase_timestamp THEN NULL
			 ELSE order_estimated_delivery_date
		END AS order_estimated_delivery_date

		FROM bronze.olist_orders_dataset

		SET @end_time = GETDATE();

		PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '--------------------';

		SET @start_time = GETDATE(); 

		PRINT '-- Truncating Table: silver.olist_product_category_name_translation';
		TRUNCATE TABLE silver.olist_product_category_name_translation;

		PRINT '-- Inserting Data into: silver.olist_product_category_name_translation';
		INSERT INTO silver.olist_product_category_name_translation
		(
			product_category_name,
			product_category_name_english
		)

		SELECT DISTINCT
			LOWER(TRIM(product_category_name)) AS product_category_name,
			LOWER(
					COALESCE(
					TRIM(product_category_name_english),
					TRIM(product_category_name)
				)
				) AS product_category_name_english
		FROM bronze.olist_product_category_name_translation
		WHERE product_category_name IS NOT NULL

		SET @end_time = GETDATE();

		PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '--------------------';

		SET @start_time = GETDATE(); 

		PRINT '-- Truncating Table: silver.olist_products_dataset';
		TRUNCATE TABLE silver.olist_products_dataset;

		PRINT '-- Inserting Data into: silver.olist_products_dataset';
		INSERT INTO silver.olist_products_dataset
		(
			product_id,
			product_category_name,
			product_name_lenght,
			product_description_lenght,
			product_photos_qty,
			product_weight_g,
			product_length_cm,
			product_height_cm,
			product_width_cm
		)

		SELECT
		p.product_id,

		CASE WHEN p.product_category_name IS NULL THEN 'n/a'
			 WHEN pc.product_category_name IS NULL THEN 'n/a'
			 ELSE LOWER(TRIM(p.product_category_name))
		END product_category_name,

		CASE WHEN p.product_name_lenght <= 0 THEN NULL
			 ELSE p.product_name_lenght
		END product_name_lenght,

		CASE WHEN p.product_description_lenght <= 0 THEN NULL
			 ELSE p.product_description_lenght
		END product_description_lenght,

		CASE WHEN p.product_photos_qty < 0 THEN 0
			 ELSE COALESCE(p.product_photos_qty,0)
		END product_photos_qty,

		CASE WHEN p.product_weight_g <= 0  THEN NULL
			 ELSE p.product_weight_g
		END product_weight_g,

		CASE WHEN p.product_length_cm <= 0  THEN NULL
			 ELSE p.product_length_cm
		END product_length_cm,

		CASE WHEN p.product_height_cm <= 0  THEN NULL
			 ELSE p.product_height_cm
		END product_height_cm,

		CASE WHEN p.product_width_cm <= 0  THEN NULL
			 ELSE p.product_width_cm
		END product_width_cm

		FROM bronze.olist_products_dataset as p
		LEFT JOIN silver.olist_product_category_name_translation as pc
		ON p.product_category_name = pc.product_category_name

		SET @end_time = GETDATE();

		PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '--------------------';

		SET @start_time = GETDATE(); 

		PRINT '-- Truncating Table: silver.olist_sellers_dataset';
		TRUNCATE TABLE silver.olist_sellers_dataset;

		PRINT '-- Inserting Data into: silver.olist_sellers_dataset';
		INSERT INTO silver.olist_sellers_dataset
		(
			seller_id,
			seller_zip_code_prefix,
			seller_city,
			seller_state
		)

		SELECT 
		s.seller_id,
		s.seller_zip_code_prefix,
		CASE WHEN LOWER(TRIM(s.seller_city)) LIKE '%[0-9]%' 
				THEN LOWER(COALESCE(g.geolocation_city,s.seller_city))

			 WHEN LOWER(TRIM(s.seller_city)) != LOWER(g.geolocation_city)
				THEN LOWER(COALESCE(g.geolocation_city,s.seller_city))

			 ELSE LOWER(TRIM(s.seller_city))
		END seller_city,

		CASE WHEN UPPER(TRIM(s.seller_state)) != UPPER(g.geolocation_state) 
				THEN UPPER(COALESCE(g.geolocation_state,s.seller_state))

			 ELSE UPPER(TRIM(s.seller_state))
		END seller_state
		FROM bronze.olist_sellers_dataset AS s
		LEFT JOIN silver.olist_geolocation_dataset AS g
		ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix

		SET @end_time = GETDATE();

		PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '--------------------';

		SET @batch_end_time = GETDATE();
		PRINT 'Total Duration For Loading: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';

		PRINT '========================================================';
		PRINT 'Silver Layer Load Completed Successfully';
		PRINT '========================================================';

END TRY
BEGIN CATCH
	PRINT 'Error occured during Data Load';
		INSERT INTO logs.error_log 
		(
			log_timestamp,
			procedure_name,
			error_code,
			error_description,
			error_line_number 
		)
		VALUES
		(
			GETDATE(),
			ERROR_PROCEDURE(),
			ERROR_NUMBER(),
			ERROR_MESSAGE(),
			ERROR_LINE()
		);
END CATCH
END
