IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='lab_Test')
    BEGIN
        DROP TABLE lab_Test
    END
    GO

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='lab_Log')
    BEGIN
        DROP TABLE lab_Log
    END
    GO

-----Creating the lab_Test table

    CREATE TABLE lab_Test (
        --Columns for the lab_Test table
        lab_TestID int identity PRIMARY KEY,
        lab_TestText varchar(20) not null CONSTRAINT U1_lab_Test UNIQUE (lab_TestText)
    )
    GO






-----Creating the lab_Log table
    ---- This table will keep a log of created lab_Test records.
    ---- We dont want to add new records if thier insert fails into lab_Test table.
  CREATE TABLE lab_Log (
        --Columns for the lab_Log table
        lab_LogID int identity PRIMARY KEY,
        lab_TestInt int not null CONSTRAINT U1_lab_Log UNIQUE (lab_TestInt)
    )
GO
----Adding Data to lab_Test & lab_Log tables
    INSERT INTO lab_Test(lab_TestText)
        VALUES
            ('One'),('Two'),('Three')
    GO
    INSERT INTO lab_Log(lab_TestInt)
    SELECT lab_TestID
    From dbo.lab_Test 
    GO
    
BEGIN TRY
    BEGIN TRANSACTION
            Declare @rc int
            SET @rc = @@ROWCOUNT 

            IF  NOT EXISTS ( Select count(*) from dbo.lab_Test where lab_TestText ='srajendi' )
                BEGIN
                SET @rc = @@ROWCOUNT +1
                END
            INSERT into dbo.lab_Test(lab_TestText) VALUES('srajendi')
            
            ----Step 4: Check the new state of things
            IF ( @rc = @@ROWCOUNT) ---If @@ROWCOUNT was not changed , fail
                BEGIN
                    SELECT 'Bail out! It Failed!'
                    ROLLBACK
                END
            ELSE ----Success! Continue.
                BEGIN
                    ----Step 5, if Succeeded    
                    SELECT 'Yay! It Worked!'
                    INSERT INTO lab_Log(lab_TestInt) VALUES (@@identity)
                    COMMIT
                END
END TRY

BEGIN CATCH
    ROLLBACK TRANSACTION
    SELECT 'Bail out! It Failed!'
END CATCH

    SELECT * FROM lab_Log go;
    SELECT * FROM lab_Test go;
