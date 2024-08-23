CREATE DATABASE taskDB;
USE taskDB;

CREATE TABLE SourceTable (
    ID INT PRIMARY KEY IDENTITY(1,1),   
    ProductName VARCHAR(100),    
    Quantity INT,                  
    CreatedAt DATETIME DEFAULT GETDATE()   
);

CREATE TABLE DestinationTable (
    ID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT,                   
    ProductName VARCHAR(100),    
    Quantity INT,                 
    SourceCreatedAt DATETIME,     
    IsDeleted BIT DEFAULT 0       
);

CREATE PROC SyncOrders
AS
BEGIN
    INSERT INTO DestinationTable (ProductID, ProductName, Quantity, SourceCreatedAt)
    SELECT s.ID, s.ProductName, s.Quantity, s.CreatedAt
    FROM SourceTable s
    LEFT JOIN DestinationTable d ON s.ID = d.ProductID
    WHERE d.ProductID IS NULL;

    UPDATE d
    SET d.IsDeleted = 1
    FROM DestinationTable d
    LEFT JOIN SourceTable s ON d.ProductID = s.ID
    WHERE s.ID IS NULL AND d.IsDeleted = 0;
END;

INSERT INTO SourceTable (ProductName, Quantity)
VALUES 
('Laptop', 1),
('Smartphone', 2),
('Headphones', 3);


SELECT * FROM SourceTable;
DELETE FROM SourceTable WHERE ID = 2;
SELECT * FROM DestinationTable;
