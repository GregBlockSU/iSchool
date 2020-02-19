use ist722_grblock_stage;
go

IF OBJECT_ID('stgNorthwindProducts') IS NOT NULL
	DROP TABLE stgNorthwindProducts;
IF OBJECT_ID('stgNorthwindEmployees') IS NOT NULL
DROP TABLE stgNorthwindEmployees;
IF OBJECT_ID('stgNorthwindCustomers') IS NOT NULL
DROP TABLE stgNorthwindCustomers;
IF OBJECT_ID('stgNorthwindSales') IS NOT NULL
DROP TABLE stgNorthwindSales;
IF OBJECT_ID('stgNorthwindDates') IS NOT NULL
DROP TABLE stgNorthwindDates
go

--stage Customers
SELECT 
	[CustomerID],
	[CompanyName],
	[ContactName],
	[ContactTitle],
	[Address],
	[City],
	[Region],
	[PostalCode],
	[Country]
INTO [dbo].[stgNorthwindCustomers]
FROM [Northwind].[dbo].[Customers]
GO

--stage Employees
SELECT
	[EmployeeID],
	[FirstName],
	[LastName],
	[Title]
INTO [dbo].[stgNorthwindEmployees]
FROM [Northwind].[dbo].[Employees]
GO

-- Staging Products
SELECT
	[ProductID],
	[ProductName],
	[Discontinued],
	[CompanyName],
	[CategoryName]
INTO dbo.stgNorthwindProducts
FROM [Northwind].[dbo].[Products] p
	join [Northwind].[dbo].Suppliers s
		on p.[SupplierID] = s.[SupplierID]
	join [Northwind].[dbo].Categories c
		on c.[CategoryID] = p.[CategoryID]
GO

-- Staging Date
SELECT *
INTO dbo.stgNorthwindDates
FROM [ExternalSources2].[dbo].[date_dimension]
WHERE [Year] between 1996 and 1998;
GO

-- Stage Fact
SELECT
	ProductID,
	d.OrderID,
	CustomerID,
	EmployeeID,
	OrderDate,
	ShippedDate,
	UnitPrice,
	Quantity,
	Discount
INTO dbo.stgNorthwindSales
FROM Northwind.dbo.[Order Details] d
	join Northwind.dbo.Orders o
		on o.OrderID = d.OrderID
go