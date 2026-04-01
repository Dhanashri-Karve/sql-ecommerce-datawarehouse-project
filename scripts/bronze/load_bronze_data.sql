/* 
==================================================================
Procedure: bronze.load_bronze

Description:
    This procedure loads raw E-Commerce data into the 
    Bronze layer of the Data Warehouse.

How it works:
    - Records the start time of the load process.
    - For each bronze table:
        1. Truncates the table to remove existing data.
        2. Uses BULK INSERT to load data from CSV files.
        3. Prints the time taken to load the table.
    - Prints the total time taken to load all tables.

Error Handling:
   If an error occurs, the procedure captures the error details
   (time, procedure name, error number, message, and line number)
   and stores them in the logs.error_log table.

Usage:
    EXEC bronze.load_bronze;
==================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME , @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '========================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '========================================================';

        SET @start_time = GETDATE();

        PRINT '-- Truncating Table: bronze.olist_customers_dataset';
        TRUNCATE TABLE bronze.olist_customers_dataset;

        PRINT '-- Inserting Data into: bronze.olist_customers_dataset';
        BULK INSERT bronze.olist_customers_dataset
        FROM 'C:\Users\Dhanashri Karve\Desktop\Brazalian.Olist.Dataset\olist_customers_dataset.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A', 
            CODEPAGE = '65001'
        );

        SET @end_time = GETDATE();

        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        PRINT '--------------------';

        SET @start_time = GETDATE();

        PRINT '-- Truncating Table: bronze.olist_geolocation_dataset';
        TRUNCATE TABLE bronze.olist_geolocation_dataset;

        PRINT '-- Inserting Data into: bronze.olist_geolocation_dataset';
        BULK INSERT bronze.olist_geolocation_dataset
        FROM 'C:\Users\Dhanashri Karve\Desktop\Brazalian.Olist.Dataset\olist_geolocation_dataset.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A', 
            CODEPAGE = '65001'
        );

        SET @end_time = GETDATE();

        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        PRINT '--------------------';

        SET @start_time = GETDATE();

        PRINT '-- Truncating Table: bronze.olist_order_items_dataset';
        TRUNCATE TABLE bronze.olist_order_items_dataset;

        PRINT '-- Inserting Data into: bronze.olist_order_items_dataset';
        BULK INSERT bronze.olist_order_items_dataset
        FROM 'C:\Users\Dhanashri Karve\Desktop\Brazalian.Olist.Dataset\olist_order_items_dataset.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A', 
            CODEPAGE = '65001'
        );

        SET @end_time = GETDATE();

        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        PRINT '--------------------';

        SET @start_time = GETDATE();

        PRINT '-- Truncating Table: bronze.olist_order_payments_dataset';
        TRUNCATE TABLE bronze.olist_order_payments_dataset;

        PRINT '-- Inserting Data into: bronze.olist_order_payments_dataset';
        BULK INSERT bronze.olist_order_payments_dataset
        FROM 'C:\Users\Dhanashri Karve\Desktop\Brazalian.Olist.Dataset\olist_order_payments_dataset.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A', 
            CODEPAGE = '65001'
        );

        SET @end_time = GETDATE();

        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        PRINT '--------------------';

        SET @start_time = GETDATE();

        PRINT '-- Truncating Table: bronze.olist_order_reviews_dataset';
        TRUNCATE TABLE bronze.olist_order_reviews_dataset;
      
        PRINT '-- Inserting Data into: bronze.olist_order_reviews_dataset';
        BULK INSERT bronze.olist_order_reviews_dataset
        FROM 'C:\Users\Dhanashri Karve\Desktop\Brazalian.Olist.Dataset\olist_order_reviews_dataset.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0D0A', 
            CODEPAGE = '65001'
        );
        SET @end_time = GETDATE();

        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        PRINT '--------------------';

        SET @start_time = GETDATE();

        PRINT '-- Truncating Table: bronze.olist_orders_dataset';
        TRUNCATE TABLE bronze.olist_orders_dataset;

        PRINT '-- Inserting Data into: bronze.olist_orders_dataset';
        BULK INSERT bronze.olist_orders_dataset
        FROM 'C:\Users\Dhanashri Karve\Desktop\Brazalian.Olist.Dataset\olist_orders_dataset.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A', 
            CODEPAGE = '65001'
        );

        SET @end_time = GETDATE();

        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        PRINT '--------------------';

        SET @start_time = GETDATE();

        PRINT '-- Truncating Table: bronze.olist_product_category_name_translation';
        TRUNCATE TABLE bronze.olist_product_category_name_translation;

        PRINT '-- Inserting Data into: bronze.olist_product_category_name_translation';
        BULK INSERT bronze.olist_product_category_name_translation
        FROM 'C:\Users\Dhanashri Karve\Desktop\Brazalian.Olist.Dataset\product_category_name_translation.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A', 
            CODEPAGE = '65001'
        );
        SET @end_time = GETDATE();

        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        PRINT '--------------------';

        SET @start_time = GETDATE();

        PRINT '-- Truncating Table: bronze.olist_products_dataset';
        TRUNCATE TABLE bronze.olist_products_dataset;

        PRINT '-- Inserting Data into: bronze.olist_products_dataset';
        BULK INSERT bronze.olist_products_dataset
        FROM 'C:\Users\Dhanashri Karve\Desktop\Brazalian.Olist.Dataset\olist_products_dataset.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A', 
            CODEPAGE = '65001'
        );
        SET @end_time = GETDATE();

        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        PRINT '--------------------';

        SET @start_time = GETDATE();

        PRINT '-- Truncating Table: bronze.olist_sellers_dataset';
        TRUNCATE TABLE bronze.olist_sellers_dataset;

        PRINT '-- Inserting Data into: bronze.olist_sellers_dataset';
        BULK INSERT bronze.olist_sellers_dataset
        FROM 'C:\Users\Dhanashri Karve\Desktop\Brazalian.Olist.Dataset\olist_sellers_dataset.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A', 
            CODEPAGE = '65001'
        );
        SET @end_time = GETDATE();

        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        PRINT '--------------------';

        SET @batch_end_time = GETDATE();
        PRINT 'Total Duration For Loading: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';

        PRINT '========================================================';
        PRINT 'Bronze Layer Load Completed Successfully';
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
