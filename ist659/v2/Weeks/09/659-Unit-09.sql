/*
1.	Using the payroll database, write an index to improve the performance of the following query:
*/

-- Q1
USE payroll;
GO

DROP INDEX IF EXISTS ix_employees_jobtitle ON dbo.employees
go
CREATE INDEX ix_employees_jobtitle ON dbo.employees (employee_jobtitle) include (
    employee_id
    , employee_firstname
    , employee_lastname
    )
go
/*
2.	Your screen shot should include the created index SQL code and the query plan demonstrating the index is being used.
*/
SELECT employee_id
    , employee_firstname
    , employee_lastname
    , employee_jobtitle
FROM employees
WHERE employee_jobtitle = 'Store Manager'
    OR employee_jobtitle = 'Owner';
GO

/*
3.	Write another query using GROUP BY, which also uses the index you created in the first question.
*/

SELECT count(*)
FROM employees
WHERE employee_jobtitle = 'Store Manager'
    OR employee_jobtitle = 'Owner'
GROUP BY employee_jobtitle;
GO

/*
4.	For the following query from a previous assignment, which provides a rank of each bid on an item:
*/
--Q4
USE vbay;
GO

SELECT item_id
    , item_name
    , dense_rank() OVER (
        PARTITION BY item_name ORDER BY bid_datetime
        ) AS bid_order
    , bid_amount
    , lag(user_firstname + ' ' + user_lastname) OVER (
        PARTITION BY item_name ORDER BY bid_datetime
        ) AS prev_bidder
    , user_firstname + ' ' + user_lastname AS bidder
    , lead(user_firstname + ' ' + user_lastname) OVER (
        PARTITION BY item_name ORDER BY bid_datetime
        ) AS next_bidder
FROM dbo.vb_items 
INNER JOIN dbo.vb_bids
    ON item_id = bid_item_id
INNER JOIN dbo.vb_users
    ON bid_user_id = user_id
WHERE bid_status = 'ok';
GO

/*
5.	Write an index to improve performance of the query by replacing the clustered index scan on vb_bids 
*/

DROP INDEX IF EXISTS ix_bid_status ON dbo.vb_bids;
GO
CREATE INDEX ix_bid_status ON dbo.vb_bids (bid_status) INCLUDE (bid_item_id, bid_user_id, bid_datetime, bid_amount);
GO

/*
6.	Using fudgemart_v3, create a schemabound view from the following query: 
Name the view v_orders 
*/

USE fudgemart_v3;
GO
DROP VIEW IF EXISTS dbo.v_orders;
GO
CREATE OR ALTER VIEW dbo.v_orders
WITH SCHEMABINDING
AS
SELECT c.customer_state
    , c.customer_firstname + ' ' + c.customer_lastname AS customer_name
    , datepart(year, order_date) AS order_year
    , o.order_id
    , o.ship_via
    , od.order_qty AS order_detail_qty
    , od.order_qty * p.product_retail_price AS order_detail_extd_price
    , p.product_id
    , p.product_name
    , p.product_department
FROM dbo.fm_orders o
JOIN dbo.fm_customers c
    ON o.customer_id = c.customer_id
JOIN dbo.fm_order_details od
    ON o.order_id = od.order_id
JOIN dbo.fm_products p
    ON p.product_id = od.product_id;
GO

DROP INDEX IF EXISTS ix_orders ON dbo.v_orders;
CREATE UNIQUE CLUSTERED INDEX ix_orders ON dbo.v_orders (
    order_id
    , product_id
    );

/*
7.	Write code to add a unique clustered index to the view v_orders. Execute your view ( select * from v_orders), and then observe the query plan to see if the index is being used.  If the index is not being used, that’s an indication there is not enough data to warrant the index. You can force the index to be used by using the noexpand option on the query: select * from v_orders with (noexpand). 
*/

SELECT product_name
    , sum(order_detail_qty)
FROM v_orders WITH (noexpand)
GROUP BY product_name;
GO

SELECT DISTINCT customer_name, product_department
FROM v_orders with (noexpand);
GO

/*
8.	Write code to add a columnstore index to v_orders. Include all the columns from the view in the column store index. Provide screen shots of code to demonstrate you created the columnstore index and that these queries use it:
*/

CREATE NONCLUSTERED COLUMNSTORE INDEX cci_orders ON dbo.v_orders (
    [customer_state]
    , [customer_name]
    , [order_year]
    , [order_id]
    , [ship_via]
    , [order_detail_qty]
    , [order_detail_extd_price]
    , [product_id]
    , [product_name]
    , [product_department]
    )
