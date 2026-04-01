/*
========================================================================================================
-- Central error logging table used to capture and store errors generated during ETL execution.
-- Records details such as the timestamp, procedure name, error code, error message, and line number to
   support troubleshooting, monitoring, and debugging of the Bronze, Silver, and Gold data layers
========================================================================================================
*/

-- Create logs schema if not exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'logs')
BEGIN
    EXEC('CREATE SCHEMA logs');
END;

-- Create error logging table
IF OBJECT_ID('logs.error_log', 'U') IS NULL
BEGIN
    CREATE TABLE logs.error_log
    (
        log_id INT IDENTITY(1,1) PRIMARY KEY,
        log_timestamp DATETIME,
        procedure_name NVARCHAR(100),
        error_code INT,
        error_description NVARCHAR(MAX),
        error_line_number INT
    );
END;
