use ist722_grblock_dw;
go

-- load DimEmployee
INSERT INTO northwind.DimEmployee (EmployeeID, EmployeeName, EmployeeTitle)
SELECT EmployeeID, FirstName + ' ' + LastName as EmployeeName, Title
FROM ist722_grblock_stage.dbo.stgNorthwindEmployees
go

-- load DimCustomer
insert into northwind.DimCustomer
	(CustomerID, CompanyName, ContactName, ContactTitle,
	CustomerCountry, CustomerRegion, CustomerCity, CustomerPostalCode)
select
	CustomerID,
	CompanyName,
	ContactName,
	ContactTitle,
	Country,
	case when Region is null then 'N/A' else [Region] end,
	City,
	case when PostalCode is null then 'N/A' else [PostalCode] end
from ist722_grblock_stage.dbo.stgNorthwindCustomers
go

-- load DimProduct
insert into northwind.DimProduct
	(ProductID, ProductName, Discontinued, SupplierName, CategoryName)
select
	ProductID,
	ProductName,
	Discontinued,
	CompanyName,
	CategoryName
from ist722_grblock_stage.dbo.stgNorthwindProducts
go

-- load DimDate
INSERT INTO northwind.DimDate
	([DateKey], [Date], [FullDateUSA], [DayOfWeek], [DayName], [DayOfMonth], [DayOfYear], [WeekOfYear], [MonthName], [MonthOfYear], [Quarter],
	[QuarterName], [Year], [IsWeekday])
select
	[DateKey],
	[Date],
	[FullDateUSA],
	[DayofWeekUSA],
	[DayName],
	[DayOfMonth],
	[DayOfYear],
	[WeekOfYear],
	[MonthName],
	[Month],
	[Quarter],
	[QuarterName],
	[Year],
	[IsWeekday]
from ist722_grblock_stage.dbo.stgNorthwindDates
go

-- load FactSales
insert into northwind.FactSales
	([ProductKey], [CustomerKey], [EmployeeKey], [OrderDateKey], [ShippedDateKey],
	[OrderID], [Quantity], [ExtendedPriceAmount], [DiscountAmount], [SoldAmount])
SELECT	p.ProductKey, c.CustomerKey, e.EmployeeKey,
		[ExternalSources2].[dbo].[getDateKey](s.OrderDate) as OrderDateKey,
		case when [ExternalSources2].[dbo].[getDateKey](s.ShippedDate) is null then -1
			else [ExternalSources2].[dbo].[getDateKey](s.ShippedDate) end as ShippedDateKey,
		s.OrderID,
		Quantity,
		Quantity * UnitPrice as ExtendedPriceAmount,
		Quantity * UnitPrice * Discount as DiscountAmount,
		Quantity * UnitPrice *(1-Discount) as SoldAmount
FROM	ist722_grblock_stage.dbo.stgNorthwindSales AS s
INNER	JOIN northwind.DimCustomer AS c on s.CustomerID = c.CustomerID
INNER	JOIN northwind.DimEmployee AS e on s.EmployeeID = e.EmployeeID
INNER	JOIN northwind.DimProduct p on s.ProductID = p.ProductID
go

	