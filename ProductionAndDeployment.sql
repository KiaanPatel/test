USE master;
GO

BEGIN TRY
    -- Create database if not exists
    IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'AutoTestKiaan')
    BEGIN
        CREATE DATABASE AutoTestKiaan;
        PRINT 'Database AutoTestKiaan created successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Database AutoTestKiaan already exists.';
    END
END TRY
BEGIN CATCH
    PRINT 'Error creating database: ' + ERROR_MESSAGE();
END CATCH
GO

USE AutoTestKiaan;
GO

BEGIN TRY
    -- Create the user table if not exists
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user]') AND type IN (N'U'))
    BEGIN
        CREATE TABLE [dbo].[user] (
            Name VARCHAR(50) NOT NULL,
            Surname VARCHAR(50) NOT NULL,
            Email VARCHAR(100) NOT NULL
        );
        PRINT 'Table user created successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Table user already exists.';
    END
END TRY
BEGIN CATCH
    PRINT 'Error creating table: ' + ERROR_MESSAGE();
END CATCH
GO

BEGIN TRY
    -- Create the InsertUser stored procedure if not exists
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InsertUser]') AND type IN (N'P', N'PC'))
    BEGIN
        EXEC(' 
        CREATE PROCEDURE [dbo].[InsertUser] 
            @Name VARCHAR(50), 
            @Surname VARCHAR(50), 
            @Email VARCHAR(100) 
        AS 
        BEGIN 
            BEGIN TRY
                INSERT INTO [dbo].[user] (Name, Surname, Email) 
                VALUES (@Name, @Surname, @Email);
            END TRY
            BEGIN CATCH
                PRINT ''Error inserting user: '' + ERROR_MESSAGE();
            END CATCH
        END');
        PRINT 'Stored procedure InsertUser created successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Stored procedure InsertUser already exists.';
    END
END TRY
BEGIN CATCH
    PRINT 'Error creating stored procedure: ' + ERROR_MESSAGE();
END CATCH
GO

BEGIN TRY
    -- Insert sample data using the stored procedure
    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[user]') AND type IN (N'U'))
    BEGIN
        -- Clear the table first to avoid duplicates
        TRUNCATE TABLE [dbo].[user];
        PRINT 'Table user truncated successfully.';

        -- Insert the sample data
        EXEC [dbo].[InsertUser] 'Jack', 'Doe', 'jack.doe@example.com';
        EXEC [dbo].[InsertUser] 'Jeff', 'Smith', 'jeff.smith@example.com';
        EXEC [dbo].[InsertUser] 'Alan', 'Walker', 'alan.walker@example.com';
        PRINT 'Sample data inserted successfully.';
    END
END TRY
BEGIN CATCH
    PRINT 'Error inserting sample data: ' + ERROR_MESSAGE();
END CATCH
GO

-- Verify the data (optional, for confirmation)
SELECT * FROM [dbo].[user];
GO

