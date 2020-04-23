use ist722_grblock_dw;
go

IF OBJECT_ID('northwind.SalesMart') IS NOT NULL
	DROP VIEW northwind.SalesMart;
go

CREATE VIEW northwind.SalesMart
AS
SELECT S.OrderID, S.Quantity, S.ExtendedPriceAmount, S.DiscountAmount,
		S.SoldAmount, C.CompanyName, C.ContactName, C.CustomerCity,
		C.CustomerCountry, C.CustomerRegion, C.CustomerPostalCode,
		E.EmployeeName, E.EmployeeTitle,
		P.ProductName, P.Discontinued, P.CategoryName,
		D.*
FROM	northwind.FactSales AS S
INNER	JOIN [northwind].DimCustomer AS C on S.CustomerKey = C.CustomerKey
INNER	JOIN [northwind].DimEmployee AS E ON E.EmployeeKey = S.EmployeeKey
INNER	JOIN [northwind].DimProduct AS P ON P.ProductKey = S.ProductKey
INNER	JOIN [northwind].DimDate AS D ON D.DateKey = S.OrderDateKey