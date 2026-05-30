USE fudgemart_v3;
go

DROP TABLE IF EXISTS demo.dbo.timesheets;
go

-- create new table
SELECT	* 
INTO	demo.dbo.timesheets
FROM	fudgemart_v3.dbo.fudgemart_employees 
INNER	JOIN fudgemart_v3.dbo.fudgemart_employee_timesheets ON employee_id = timesheet_employee_id;

USE demo;

-- unoptimized SELECT statement
SELECT  employee_id, employee_firstname, employee_lastname, 
		SUM(timesheet_hourlyrate*timesheet_hours) AS total_hours
FROM	dbo.timesheets
GROUP	BY employee_id, employee_firstname, employee_lastname;

DROP INDEX IF EXISTS dbo.timesheets.timesheets_IX1;

CREATE INDEX timesheets_IX1 ON dbo.timesheets (employee_id) 
	INCLUDE ( employee_firstname, employee_lastname, timesheet_hourlyrate, timesheet_hours);

-- index scan
SELECT  employee_id, employee_firstname, employee_lastname, 
		SUM(timesheet_hourlyrate*timesheet_hours) AS total_hours
FROM	dbo.timesheets
GROUP	BY employee_id, employee_firstname, employee_lastname;

-- index seek
SELECT  employee_id, employee_firstname, employee_lastname --, 
		--SUM(timesheet_hourlyrate*timesheet_hours) AS total_hours
FROM	dbo.timesheets
WHERE	employee_id = 1
--GROUP	BY employee_id, employee_firstname, employee_lastname;
SELECT  *
		--SUM(timesheet_hourlyrate*timesheet_hours) AS total_hours
FROM	dbo.timesheets
WHERE	employee_id = 1


SELECT	employee_department, SUM(timesheet_hours) AS total_hours
FROM	dbo.timesheets 
GROUP	BY employee_department;
go

SELECT	employee_jobtitle, AVG(timesheet_hourlyrate) AS avg_hours
FROM	dbo.timesheets 
GROUP	BY employee_jobtitle;
go

DROP INDEX IF EXISTS dbo.timesheets.timesheets_IX2;
go

CREATE NONCLUSTERED COLUMNSTORE INDEX timesheets_IX2 ON [dbo].[timesheets]
(
	[employee_jobtitle],
	[employee_department],
	[timesheet_hourlyrate],
	[timesheet_hours]
);

SELECT	employee_department, SUM(timesheet_hours) AS total_hours
FROM	dbo.timesheets 
GROUP	BY employee_department;
go

SELECT	employee_jobtitle, AVG(timesheet_hourlyrate) AS avg_hours
FROM	dbo.timesheets 
GROUP	BY employee_jobtitle;
go

DROP VIEW IF EXISTS dbo.v_employees;
go

CREATE VIEW dbo.v_employees WITH SCHEMABINDING
AS 
SELECT	employee_id, [employee_firstname], [employee_lastname], 
		[employee_jobtitle], [employee_department], 
		COUNT(*) AS timesheet_count
FROM	dbo.timesheets
GROUP	BY employee_id, [employee_firstname], [employee_lastname], 
		[employee_jobtitle], [employee_department];
go

DROP INDEX IF EXISTS v_employees.v_employees_IX1;
go

CREATE UNIQUE CLUSTERED INDEX v_employees_IX1 ON 
	dbo.v_employees (employee_id);
go

SELECT	*
FROM	dbo.v_employees;
go

SELECT	employee_id, [employee_firstname], [employee_lastname], COUNT(*) AS timesheet_count, SUM(timesheet_hours) AS hours_total,
		AVG([timesheet_hourlyrate]) AS hourlyrate_average
FROM	dbo.timesheets
GROUP	BY employee_id, [employee_firstname], [employee_lastname];
go

-- copy output to https://jsonformatter.curiousconcept.com/
SELECT	employee_id, [employee_firstname], [employee_lastname], 
		COUNT(*) AS timesheet_count, SUM(timesheet_hours) AS hours_total,
		AVG([timesheet_hourlyrate]) AS hourlyrate_average
FROM	dbo.timesheets
GROUP	BY employee_id, [employee_firstname], [employee_lastname]
FOR JSON AUTO;

