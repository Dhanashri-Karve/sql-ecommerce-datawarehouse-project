/* 
===============================================================================
Script: Create Data Warehouse Database and Schemas

Description:
This script initializes the data warehouse environment by recreating the 
'Ecommerce_DWH' database and creating the required schemas based on the 
Medallion Architecture.

Process Overview:
1. Checks if the database 'Ecommerce_DWH' already exists.
2. If it exists, the database is forced into SINGLE_USER mode and dropped.
3. Creates a new database named 'Ecommerce_DWH'.
4. Sets the database as the active context.
5. Creates schemas within the database : 'bronze', 'silver' and 'gold'
        
WARNING:
Running this script will permanently delete the existing 'Ecommerce_DWH'
database and all its contents. Execute only in development or when a full
database reset is required.

===============================================================================
*/

USE master;

-- Drop and recreate Database 'Ecommerce_DWH'
IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'Ecommerce_DWH')
BEGIN
	ALTER DATABASE Ecommerce_DWH SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE Ecommerce_DWH;
END;
GO

-- Create Database 'Ecommerce_DWH'
CREATE DATABASE Ecommerce_DWH;
GO

USE Ecommerce_DWH;
GO

-- Create Schema
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

