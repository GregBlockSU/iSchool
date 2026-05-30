USE fudgemart_v3;
go

SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
   QUOTED_IDENTIFIER, ANSI_NULLS ON;
go

DROP VIEW IF EXISTS dbo.v_orders;
go

CREATE OR ALTER VIEW dbo.v_orders
WITH SCHEMABINDING
AS
SELECT c.customer_state, C.customer_firstname + ' ' + c.customer_lastname AS customer_name,
		DATEPART(year, order_date) AS order_year, o.order_id, o.ship_via, 
		od.order_qty AS order_detail_qty, od.order_qty * p.product_retail_price AS order_detail_exted_price,  
		p.product_id, p.product_name, p.product_department 
FROM	dbo.fm_orders AS O
INNER	JOIN dbo.fm_customers C ON O.customer_id = C.customer_id
INNER	JOIN dbo.fm_order_details AS OD on O.order_id = OD.order_id 
INNER	JOIN dbo.fm_products AS P ON P.product_id = OD.product_id ;
go

CREATE UNIQUE CLUSTERED INDEX ix_orders
   ON dbo.v_orders (order_id, product_id);

select product_name, sum(order_detail_qty) 
from v_orders with (noexpand) 
group by product_name;
go

select distinct customer_name, product_department 
from v_orders with (noexpand); 
go

CREATE NONCLUSTERED COLUMNSTORE INDEX cci_orders ON dbo.v_orders
(
	[customer_state], [customer_name], [order_year], [order_id], [ship_via], [order_detail_qty], 
	[order_detail_exted_price], [product_id], [product_name], [product_department]
)
