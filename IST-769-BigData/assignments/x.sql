SELECT	product_id, product_name, 
		CASE CHARINDEX(' ', product_name) 
			WHEN 0 THEN product_name 
			ELSE RIGHT(product_name + ' ', CHARINDEX(' ', REVERSE(product_name)) - 1)
		END AS product_category
FROM	fudgemart_products;

IF OBJECT_ID('f_total_vendor_sales') IS NOT NULL
	DROP FUNCTION f_total_vendor_sales;
go

CREATE FUNCTION dbo.f_total_vendor_sales
(
	@vendor_id AS int
)
RETURNS int 
AS
BEGIN
RETURN
	(
		SELECT	SUM(PR.product_wholesale_price * ORD.order_qty) 
		FROM	fudgemart_products AS PR
		INNER	JOIN fudgemart_order_details AS ORD ON ORD.product_id = PR.product_id
		WHERE	PR.product_vendor_id = @vendor_id
	);
END
go 

SELECT	vendor_name, dbo.f_total_vendor_sales(vendor_id) AS total_sales
FROM	dbo.fudgemart_vendors
ORDER	BY 1;
go

IF OBJECT_ID('dbo.p_write_vendor') IS NOT NULL
	DROP PROCEDURE p_write_vendor;
go

CREATE PROCEDURE dbo.p_write_vendor 
	@vendor_name varchar(50),
	@vendor_phone varchar(20),
	@vendor_website varchar(1000)
AS 
	MERGE	dbo.fudgemart_vendors AS TGT
	USING	(
				SELECT	@Vendor_name AS vendor_name,
						@vendor_phone AS vendor_phone,
						@vendor_website AS vendor_website
			) AS SRC ON SRC.vendor_name = TGT.vendor_name
	WHEN MATCHED THEN UPDATE
	SET		vendor_phone = SRC.vendor_phone,
			vendor_website = SRC.vendor_website
	WHEN NOT MATCHED THEN INSERT
		(vendor_name, vendor_phone, vendor_website)
		VALUES	(@vendor_name, @vendor_phone, @vendor_website);
go

EXEC dbo.p_write_vendor 'My vendor', '800-555-1212', 'http://www.yahoo.com';
go

IF OBJECT_ID('dbo.f_employee_timesheets') IS NOT NULL
	DROP FUNCTION dbo.f_employee_timesheets;
go

CREATE FUNCTION dbo.f_employee_timesheets
(
	@employee_id int
)
RETURNS TABLE
AS
RETURN
(
	SELECT	EMP.employee_id, EMP.employee_lastname, EMP.employee_firstname,
			EMP.employee_department, TS.timesheet_payrolldate,
			TS.timesheet_hourlyrate, 
			TS.timesheet_hours * TS.timesheet_hourlyrate AS gross_pay
	FROM	fudgemart_employee_timesheets AS TS
	INNER	JOIN fudgemart_employees EMP on EMP.employee_id= TS.timesheet_employee_id
	WHERE	EMP.employee_id = @employee_id 
);