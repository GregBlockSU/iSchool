USE demo;
GO

DROP TABLE IF EXISTS [dbo].[fudgenbooks];
go

DROP TABLE IF EXISTS [dbo].[fudgenbooks_1nf];
go

DROP TABLE IF EXISTS [dbo].[fb_books_subjects];
go

DROP TABLE IF EXISTS [dbo].[fb_subjects];
go

DROP TABLE IF EXISTS [dbo].[fb_book_authors];
go

DROP TABLE IF EXISTS [dbo].[fb_authors];
GO

DROP TABLE IF EXISTS [dbo].[fb_books];
go

DROP TABLE IF EXISTS [dbo].[fb_publishers];
go


CREATE TABLE [dbo].[fudgenbooks] 
(
    isbn VARCHAR(20) NOT NULL
    , title VARCHAR(50) NOT NULL
    , price MONEY
    , author1 VARCHAR(20) NOT NULL
    , author2 VARCHAR(20) NULL
    , author3 VARCHAR(20) NULL
    , subjects VARCHAR(100) NOT NULL
    , pages INT NOT NULL
    , pub_no INT NOT NULL
    , pub_name VARCHAR(50) NOT NULL
    , pub_website VARCHAR(50) NOT NULL
    , CONSTRAINT pk_fudgenbooks_isbn PRIMARY KEY (isbn)
);
go

INSERT [dbo].[fudgenbooks]
VALUES ('372317842', 'Introduction to Money Laundering', 29.95, 'Mandafort', 
	'Made-Off', NULL, 'scams,money laundering', 367, 101, 'Rypoff',
    'http://www.rypoffpublishing.com'),
    ('472325845', 'Imbezzle Like a Pro', 34.95, 'Made-Off',
		'Moneesgon', NULL, 'imbezzle,scams', 670, 101, 'Rypoff',
    'http://www.rypoffpublishing.com'),
    ('535621977', 'The Internet Scammer''s Bible', 44.95, 'Screwm',
		'Sucka', NULL, 'phishing,id theft,scams', 944, 102, 'BS Press',
    'http://www.bspress.com/books'),
    ('635619239', 'Art of the Ponzi Scheme', 39.95, 'Dewey', 
	'Screwm', 'Howe', 'scams,ponzi', 450, 102, 'BS Press', 
	'http://www.bspress.com/books');
GO

SELECT	*
FROM	[dbo].[fudgenbooks];
GO

/*
1.	Provide a screen shot of your working migrations for Steps 1.4, 3.1, and 3.2 in the walkthrough.
*/

SELECT	[isbn], [title], [price], [pub_no], [pages], [pub_name], [pub_website]
INTO	[dbo].[fudgenbooks_1nf]
FROM	[dbo].[fudgenbooks];

ALTER TABLE [dbo].[fudgenbooks_1nf] ADD CONSTRAINT [pk_fudgenbooks_1nf] 
	PRIMARY KEY (isbn);
GO

SELECT	a.author_name
INTO	[dbo].[fb_authors]
FROM (
    SELECT author1 AS author_name
    FROM [dbo].[fudgenbooks]
    WHERE author1 IS NOT NULL
    
    UNION
    
    SELECT author2
    FROM [dbo].[fudgenbooks]
    WHERE author2 IS NOT NULL
    
    UNION
    
    SELECT author3
    FROM [dbo].[fudgenbooks]
    WHERE author3 IS NOT NULL
    ) AS a;
GO

ALTER TABLE [dbo].[fb_authors] ALTER column [author_name] VARCHAR(20) NOT NULL;
GO

ALTER TABLE [dbo].[fb_authors] ADD CONSTRAINT [pk_fb_author] PRIMARY KEY (author_name)
GO

SELECT	isbn, author_name
INTO	[dbo].[fb_book_authors]
FROM	[dbo].[fudgenbooks]
UNPIVOT
	(
		author_name FOR author_column IN (author1, author2, author3)
	) AS upvt;
GO

ALTER TABLE [dbo].[fb_book_authors] ALTER COLUMN author_name VARCHAR(20) NOT NULL;
GO

ALTER TABLE [dbo].[fb_book_authors] ADD 
	CONSTRAINT [pk_fb_book_authors] PRIMARY KEY (isbn, author_name);
go

SELECT DISTINCT [value] AS subject
INTO [dbo].[fb_subjects]
FROM [dbo].[fudgenbooks]
CROSS APPLY string_split(subjects, ',')
go

ALTER TABLE [dbo].[fb_subjects] ALTER COLUMN [subject] VARCHAR(20) NOT NULL;
go

ALTER TABLE [dbo].[fb_subjects] ADD CONSTRAINT [pk_fb_subjects] 
	PRIMARY KEY ([subject]);
GO

SELECT	isbn, [value] AS subject
INTO	[dbo].[fb_books_subjects]
FROM	[dbo].[fudgenbooks]
CROSS	APPLY string_split(subjects, ',');
go

ALTER TABLE [dbo].[fb_books_subjects] ALTER COLUMN [subject] VARCHAR(20) NOT NULL;

ALTER TABLE [dbo].[fb_books_subjects] ADD 
	CONSTRAINT [pk_books_subjects] PRIMARY KEY (isbn, subject);
go

SELECT	isbn, title, price, pages, pub_no
INTO	[dbo].[fb_books]
FROM	[dbo].[fudgenbooks_1nf];
go

ALTER TABLE [dbo].[fb_books] ALTER COLUMN isbn VARCHAR(20) NOT NULL;
go

ALTER TABLE [dbo].[fb_books] ADD CONSTRAINT [pk_fb_books] PRIMARY KEY (isbn)
go

SELECT DISTINCT pub_no, pub_name, pub_website
INTO	[dbo].[fb_publishers]
FROM	[dbo].[fudgenbooks_1nf];
go

ALTER TABLE [dbo].[fb_publishers] ALTER COLUMN [pub_no] INT NOT NULL;
go

ALTER TABLE [dbo].[fb_publishers] ADD CONSTRAINT [pk_fb_publishers] 
	PRIMARY KEY (pub_no);
GO

/*
2.	Provide a screen shot of your adding foreign keys in Step 4 and a separate screen shot of your code to drop the foreign keys.
*/

--4
SELECT *
FROM INFORMATION_SCHEMA.tables
WHERE table_name LIKE 'fb_%'
GO

ALTER TABLE [dbo].[fb_book_authors]
	DROP CONSTRAINT IF EXISTS [fk_book_authors_author_name];

ALTER TABLE [dbo].[fb_books] 
	DROP CONSTRAINT IF EXISTS [fk_books_pub_no];
go

ALTER TABLE [dbo].[fb_book_authors] 
	DROP CONSTRAINT IF EXISTS [fk_book_authors_isbn];
go

ALTER TABLE [dbo].[fb_book_authors]
	DROP CONSTRAINT IF EXISTS [fk_book_authors_author_name];
go

ALTER TABLE [dbo].[fb_books_subjects]
	DROP CONSTRAINT IF EXISTS [fk_book_subjects_isbn];
go

ALTER TABLE [dbo].[fb_books_subjects]
	DROP CONSTRAINT IF EXISTS [fk_book_subjects_subject];
Go

ALTER TABLE [dbo].[fb_books] ADD CONSTRAINT [fk_books_pub_no] 
	FOREIGN KEY ([pub_no]) REFERENCES [dbo].[fb_publishers] ([pub_no])
GO

ALTER TABLE [dbo].[fb_books_subjects] ADD CONSTRAINT [fk_book_subjects_isbn] 
	FOREIGN KEY ([isbn]) REFERENCES [dbo].[fb_books] (isbn);
go

ALTER TABLE [dbo].[fb_books_subjects] ADD CONSTRAINT [fk_book_subjects_subject] 
	FOREIGN KEY ([subject]) REFERENCES [dbo].[fb_subjects] ([subject]);
go

ALTER TABLE [dbo].[fb_book_authors] ADD CONSTRAINT [fk_book_authors_isbn] 
	FOREIGN KEY (isbn) REFERENCES [dbo].[fb_books] (isbn);
go

ALTER TABLE [dbo].[fb_book_authors] ADD CONSTRAINT [fk_book_authors_author_name] 
	FOREIGN KEY (author_name) REFERENCES [dbo].[fb_authors] (author_name);
go
