USE payroll;
go

SELECT	COUNT(*)
FROM	dbo.employees 
WHERE	employee_jobtitle = 'Store Manager' OR employee_jobtitle = 'Owner'
GROUP BY employee_jobtitle;
go

SELECT	employee_id, employee_firstname, employee_lastname, 
		employee_jobtitle
FROM	dbo.employees 
WHERE	employee_jobtitle = 'Store Manager' OR employee_jobtitle = 'Owner';
go

DROP INDEX IF EXISTS dbo.employees.ix_employees_employee_jobtitle;
go

CREATE INDEX ix_employees_employee_jobtitle ON dbo.employees (employee_jobtitle)
	INCLUDE (employee_id, employee_firstname, employee_lastname)
