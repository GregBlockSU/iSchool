IF NOT EXISTS 
(
	SELECT 1 FROM master.sys.sysdatabases WHERE [name] = 'xyz'
)
CREATE DATABASE [xyz];
go

USE [xyz];
go

/*
alter table [dbo].xyz_consulting drop constraint if exists kf_xyz_consuling_rate
GO
alter table [dbo].xyz_consulting drop constraint kf_xyz_consuling_employee
gO
alter table [dbo].xyz_consulting drop constraint kf_xyz_consuling
gO
*/

DROP TABLE IF EXISTS [dbo].[xyz_consulting];
go

DROP TABLE IF EXISTS [dbo].[project];
go

DROP TABLE IF EXISTS [dbo].[rate_category];
go
DROP TABLE if EXISTS [dbo].employee
GO

create table [dbo].[project]
(
    project_id int NOT NULL PRIMARY KEY,
    project_name varchar(100) NOT NULL
);
go

CREATE TABLE [dbo].[employee]
(
    employee_id int NOT NULL CONSTRAINT [pk_employee] PRIMARY KEY,
    employee_name varchar(100) NOT NULL
);
go

CREATE TABLE [dbo].[rate_category]
(
    rate_category char(1) NOT NULL CONSTRAINT [PK_rate_category] PRIMARY KEY,
    rate_amount money NOT NULL
);
go

create table [dbo].[xyz_consulting]
(
    project_id int not null,
    project_name varchar(50) not null,
    employee_id int not null,
    employee_name varchar(50) not null,
    rate_category char(1) not null,
    rate_amount money not null,
    billable_hours int not null,
    total_billed money not null,
    CONSTRAINT [pk_xyz_consulting] PRIMARY KEY (project_id, employee_id),
	CONSTRAINT [fk_xyz_consulting_project] 
	FOREIGN KEY (project_id) REFERENCES [dbo].[project] (project_id),
	 CONSTRAINT [fk_xyz_consuling_employee] 
	FOREIGN KEY (employee_id) REFERENCES [dbo].[employee] (employee_id),
	CONSTRAINT [fk_xyz_consuling_rate] 
	FOREIGN KEY (rate_category) REFERENCES [dbo].[rate_category] (rate_category)
);
go

ALTER TABLE [dbo].[xyz_consulting] NOCHECK CONSTRAINT ALL;
go

INSERT INTO [dbo].[xyz_consulting] 
VALUES 
(1023,	'Madagascar travel site',	11,	'Carol Ling',	'A',	 60.00, 	5,	 300.00 ),
(1023,	'Madagascar travel site',	12,	'Chip Atooth',	'B',	 50.00, 	10,	 500.00 ),
(1023,	'Madagascar travel site',	16,	'Charlie Horse',	'C',	 40.00, 	2,	 80.00), 
(1056,	'Online estate agency',	11,	'Carol Ling',	'D',	 90.00, 	5,	 450.00 ),
(1056,	'Online estate agency',	17,	'Avi Maria',	'B',	 50.00, 	2,	 100.00 ),
(1099,	'Open travel network',	11,	'Carol Ling',	'A',	 60.00, 	6,	 360.00 ),
(1099,	'Open travel network',	12,	'Chip Atooth',	'C',	 40.00, 	8,	 320.00 ),
(1099,	'Open travel network',	14,	'Arnie Hurtz',	'D',	 90.00, 	3,	 270.00 )
GO

INSERT	[dbo].[project] (project_id, project_name)
SELECT	DISTINCT project_id, project_name 
FROM	[dbo].[xyz_consulting]
ORDER	BY project_name;
go

INSERT	[dbo].[employee] (employee_id, employee_name)
SELECT	DISTINCT employee_id, employee_name 
FROM	[dbo].[xyz_consulting]
ORDER	BY employee_name;
GO

INSERT	[dbo].rate_category (rate_category, rate_amount)
SELECT	DISTINCT rate_category, rate_amount 
FROM	[dbo].[xyz_consulting] 
ORDER	BY rate_category;
GO

--Q6
SELECT *
FROM INFORMATION_SCHEMA.tables
WHERE table_name in ('project','employee','rate_category')
GO
 --Q7

 ALTER TABLE [dbo].[xyz_consulting] WITH CHECK CHECK CONSTRAINT ALL;
 go


--ALTER TABLE [dbo].[xyz_consulting] ADD CONSTRAINT [fk_xyz_consulting_project] 
--	FOREIGN KEY (project_id) REFERENCES [dbo].[project] (project_id);
--go

--ALTER TABLE [dbo].[xyz_consulting] ADD CONSTRAINT [fk_xyz_consuling_employee] 
--	FOREIGN key (employee_id) REFERENCES [dbo].[employee] (employee_id);
--go

--ALTER TABLE [dbo].[xyz_consulting] ADD CONSTRAINT [fk_xyz_consuling_rate] 
--	FOREIGN key (rate_category) REFERENCES [dbo].[rate_category] (rate_category);
--go
