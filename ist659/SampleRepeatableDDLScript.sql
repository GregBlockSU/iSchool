-- drop all database objects in reverse order of their dependencies
-- including views, stored procedures and tables; note the use of
-- OBJECT_ID to detect if the object exists and conditionally deletes
-- existing objects only. The 2nd parameter to OBJECT_ID is the object
-- type - P for procedure, V for view, U for table

-- drop all procedures
IF OBJECT_ID('dbo.InsertAuthor', 'P') IS NOT NULL
		DROP PROCEDURE dbo.InsertAuthor;
go

IF OBJECT_ID('dbo.InsertBook', 'P') IS NOT NULL
		DROP PROCEDURE dbo.InsertBook;
go

IF OBJECT_ID('dbo.InsertPublisher', 'P') IS NOT NULL
		DROP PROCEDURE dbo.InsertPublisher;
go

-- drop all views
IF OBJECT_ID('dbo.PublisherAuthorBook', 'V') IS NOT NULL
		DROP VIEW dbo.PublisherAuthorBook;
go

-- drop all tables in reverse order of their dependencies
IF OBJECT_ID('dbo.RoyaltyPayment', 'U') IS NOT NULL
		DROP TABLE dbo.RoyaltyPayment;
go

IF OBJECT_ID('dbo.AuthorBook', 'U') IS NOT NULL
		DROP TABLE dbo.AuthorBook;
go

IF OBJECT_ID('dbo.Author', 'U') IS NOT NULL
		DROP TABLE dbo.Author;
go

IF OBJECT_ID('dbo.Book', 'U') IS NOT NULL
		DROP TABLE dbo.Book;
go

IF OBJECT_ID('dbo.Publisher', 'U') IS NOT NULL
		DROP TABLE dbo.Publisher;
go

-- create all tables in order of their dependencies

CREATE TABLE dbo.Publisher
(
	PublisherID int NOT NULL IDENTITY,
	PublisherName varchar(50) NOT NULL,
	CONSTRAINT Publisher_PK PRIMARY KEY (PublisherID)
);
go

CREATE TABLE dbo.Book
(
	BookID int NOT NULL IDENTITY,
	BookTitle varchar(50) NOT NULL,
	PublisherID int NOT NULL,
	CONSTRAINT Book_PK PRIMARY KEY (BookID),
	CONSTRAINT Book_FK1 FOREIGN KEY (PublisherID) REFERENCES dbo.Publisher (PublisherID)	
);
go

CREATE TABLE dbo.Author
(
	AuthorID int NOT NULL IDENTITY,
	FirstName varchar(50) NOT NULL,
	LastName varchar(50) NOT NULL,
	CONSTRAINT Author_PK PRIMARY KEY (AuthorID)
);
go

CREATE TABLE dbo.AuthorBook
(
	AuthorBookID int NOT NULL IDENTITY,
	AuthorID int NOT NULL,
	BookID int NOT NULL,
	CONSTRAINT AuthorBook_PK PRIMARY KEY (AuthorBookID),
	CONSTRAINT AuthorBook_FK1 FOREIGN KEY (AuthorID) REFERENCES dbo.Author (AuthorID),
	CONSTRAINT AuthorBook_FK2 FOREIGN KEY (BookID) REFERENCES dbo.Book (BookID)
);
go

CREATE TABLE dbo.RoyaltyPayment
(
	RoyaltyPaymentID int NOT NULL IDENTITY,
	AuthorBookID int NOT NULL,
	PaymentDate date NOT NULL,
	PaymentAmount money NOT NULL,
	CONSTRAINT RoyaltyPayment_PK PRIMARY KEY (RoyaltyPaymentID),
	CONSTRAINT RoyaltyPayment_FK1 FOREIGN KEY (AuthorBookID) REFERENCES dbo.AuthorBook (AuthorBookID),
);
go

CREATE PROCEDURE dbo.InsertPublisher 
	@PublisherName varchar(50)
AS
	INSERT dbo.Publisher (PublisherName) VALUES (@PublisherName);
	RETURN SCOPE_IDENTITY();
go

CREATE PROCEDURE dbo.InsertBook 
	@BookTitle varchar(50)
AS
	INSERT dbo.Book (BookTitle) VALUES (@BookTitle);
	RETURN SCOPE_IDENTITY();
go

CREATE PROCEDURE dbo.InsertAuthor
	@FirstName varchar(50),
	@LastName varchar(50)
AS
	INSERT dbo.Author (FirstName, LastName) VALUES (@FirstName, @LastName);
	RETURN SCOPE_IDENTITY();
go

-- insert records into tables; note using scalar SELECT statements to avid hard-coding IDENTITY values
INSERT dbo.Publisher (PublisherName) 
VALUES	('Random House'), ('Penguin');
go

INSERT dbo.Book (BookTitle, PublisherID) 
VALUES	('The sun also rises', (SELECT PublisherID FROM dbo.Publisher WHERE PublisherName ='Random House')), 
		('The great gatsby', (SELECT PublisherID FROM dbo.Publisher WHERE PublisherName ='Penguin'));
go

INSERT dbo.Author (FirstName, LastName) 
VALUES	('Ernest', 'Hemingway'), 
		('Scott', 'Fitzgerald');
go

INSERT dbo.AuthorBook (AuthorID, BookID) 
VALUES	((SELECT AuthorID FROM dbo.Author WHERE LastName = 'Hemingway'), (SELECT BookID FROM dbo.Book WHERE BookTitle = 'The sun also rises')),
		((SELECT AuthorID FROM dbo.Author WHERE LastName = 'Fitzgerald'), (SELECT BookID FROM dbo.Book WHERE BookTitle = 'The great gatsby'));
go

-- finally, pull results from the tables
SELECT	*
FROM	dbo.Publisher;
go

SELECT	*
FROM	dbo.Book;
go

SELECT	*
FROM	dbo.Author;
go

CREATE VIEW dbo.PublisherAuthorBook
AS
SELECT	PUB.PublisherName, AU.FirstName, AU.LastName, BK.BookTitle
FROM	dbo.Publisher AS PUB
INNER	JOIN dbo.Book AS BK ON BK.PublisherID = PUB.PublisherID
INNER	JOIN dbo.AuthorBook AS AB ON AB.BookID = BK.BookID
INNER	JOIN dbo.Author AS AU ON AU.AuthorID = AB.AuthorID
;
go

SELECT	* 
FROM	dbo.PublisherAuthorBook
ORDER	BY PublisherName, FirstName, LastName, BookTitle;
go