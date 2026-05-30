IF NOT EXISTS (SELECT * FROM master.sys.sysdatabases WHERE name = 'moze2')
	CREATE DATABASE moze2;
go

USE moze2;
go

-- Down
DROP TABLE IF EXISTS customers;
go

DROP TABLE IF EXISTS state_lookup;
go

-- Up
CREATE TABLE state_lookup (
	state_code char(2) NOT NULL,
	CONSTRAINT pk_state_lookup_state_code PRIMARY KEY (state_code)
);
go

CREATE TABLE [customers]
(
	[customer_id] [int] IDENTITY(1,1) NOT NULL,
	[customer_email] [varchar](50) NOT NULL,
	[customer_min_price] [money] NOT NULL,
	[customer_max_price] [money] NOT NULL,
	[customer_city] [varchar](50) NOT NULL,
	[customer_state] [char](2) NOT NULL,
	CONSTRAINT [pk_customers_customer_id] PRIMARY KEY CLUSTERED ([customer_id]),
	CONSTRAINT [uk_customers_customer_email] UNIQUE NONCLUSTERED ([customer_email]),
	CONSTRAINT [ck_customers_valid_prices] CHECK  (([customer_min_price]<=[customer_max_price])),
	CONSTRAINT [fk_customers_state_lookup] FOREIGN KEY([customer_state])
		REFERENCES [dbo].[state_lookup] ([state_code]));
go

INSERT state_lookup (state_code)
VALUES ('NY'), ('NJ'), ('CT');

-- verify
SELECT * FROM state_lookup;
go