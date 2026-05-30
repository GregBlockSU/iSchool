--create database xyz
--go 
use xyz
go

ALTER TABLE dbo.xyz_consulting DROP CONSTRAINT KF_xyz_consulting_employee;
go

ALTER TABLE dbo.xyz_consulting DROP CONSTRAINT KF_xyz_consulting_employee;
go

ALTER TABLE dbo.xyz_consulting DROP CONSTRAINT KF_xyz_consulting_rate_category;
go

drop table if exists dbo.xyz_consulting
go

DROP TABLE IF EXISTS dbo.project;
go

DROP TABLE IF EXISTS dbo.rate_category;
go

DROP TABLE IF EXISTS dbo.employee;
go

CREATE TABLE dbo.project
(
	project_id int NOT NULL PRIMARY KEY,
	project_name varchar(100) NOT NULL
);


CREATE TABLE dbo.employee
(
	employee_id int NOT NULL PRIMARY KEY,
	employee_name varchar(100) NOT NULL
);

CREATE TABLE dbo.rate_category
(
	rate_category char(1) NOT NULL PRIMARY KEY,
	rate_amount money NOT NULL
);

create table dbo.xyz_consulting
(
    project_id int not null,
    project_name varchar(50) not null,
    employee_id int not null,
    employee_name varchar(50) not null,
    rate_category char(1) not null,
    rate_amount money not null,
    billable_hours int not null,
    total_billed money not null,
    constraint pk_xyz_consulting primary key(project_id, employee_id)
)
insert into dbo.xyz_consulting values 
(1023,	'Madagascar travel site',	11,	'Carol Ling',	'A',	 60.00, 	5,	 300.00 ),
(1023,	'Madagascar travel site',	12,	'Chip Atooth',	'B',	 50.00, 	10,	 500.00 ),
(1023,	'Madagascar travel site',	16,	'Charlie Horse',	'C',	 40.00, 	2,	 80.00), 
(1056,	'Online estate agency',	11,	'Carol Ling',	'D',	 90.00, 	5,	 450.00 ),
(1056,	'Online estate agency',	17,	'Avi Maria',	'B',	 50.00, 	2,	 100.00 ),
(1099,	'Open travel network',	11,	'Carol Ling',	'A',	 60.00, 	6,	 360.00 ),
(1099,	'Open travel network',	12,	'Chip Atooth',	'C',	 40.00, 	8,	 320.00 ),
(1099,	'Open travel network',	14,	'Arnie Hurtz',	'D',	 90.00, 	3,	 270.00 )
GO


INSERT dbo.project (project_id, project_name)
select DISTINCT project_id, project_name 
from dbo.xyz_consulting 
order by project_name;

INSERT dbo.employee (employee_id, employee_name)
select DISTINCT employee_id, employee_name 
from dbo.xyz_consulting 
order by employee_name;

INSERT dbo.rate_category (rate_category, rate_amount)
select DISTINCT rate_category, rate_amount
from dbo.xyz_consulting 
order by rate_category;
go

ALTER TABLE dbo.xyz_consulting ADD CONSTRAINT KF_xyz_consulting FOREIGN KEY (project_id)
	REFERENCES dbo.project (project_id);
go

ALTER TABLE dbo.xyz_consulting ADD CONSTRAINT KF_xyz_consulting_employee FOREIGN KEY (employee_id)
	REFERENCES dbo.employee (employee_id);
go

ALTER TABLE dbo.xyz_consulting ADD CONSTRAINT KF_xyz_consulting_rate FOREIGN KEY (rate_category)
	REFERENCES dbo.rate_category (rate_category);
go