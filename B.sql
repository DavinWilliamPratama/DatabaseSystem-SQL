CREATE DATABASE Project
GO
/* 
USE master
DROP DATABASE Project
*/
USE Project
GO
CREATE TABLE [User](
	UserID CHAR(6),
	UserFullName VARCHAR(255),
	UserNickname VARCHAR(255),
	UserEmail VARCHAR(255), 
	UserCity VARCHAR(255),
	[description] VARCHAR(255),
	PRIMARY KEY (UserID),
	CONSTRAINT UserID_Check CHECK (UserID LIKE 'USR[0-9][0-9][0-9]'),
	CONSTRAINT UserEmail_Check CHECK (UserEmail LIKE '%@%'),
	CONSTRAINT UserNick_Check CHECK (UserNickname LIKE '______%')
)

CREATE TABLE Director(
	DirectorID CHAR(6),
	DirectorName VARCHAR(255),
	DirectorEmail VARCHAR(255),
	DirectorPhone NUMERIC(12,0),
	DirectorAddress VARCHAR(255),
	DirectorCity VARCHAR(255),
	PRIMARY KEY (DirectorID),
	CONSTRAINT DirectorID_Check CHECK (DirectorID LIKE 'DIR[0-9][0-9][0-9]'),
	CONSTRAINT DirectorEmail_Check CHECK (DIrectorEmail LIKE '%@%'),
)

CREATE TABLE Publisher(
	PublisherID CHAR(6),
	PublisherName VARCHAR(255),
	PublisherEmail VARCHAR(255),
	PublisherPhone NUMERIC(12,0),
	PublisherAddress VARCHAR(255),
	PublisherCity VARCHAR(255),
	PRIMARY KEY (PublisherID),
	CONSTRAINT PublisherID_Check CHECK (PublisherID LIKE 'PUB[0-9][0-9][0-9]'),
	CONSTRAINT PublisherName_Check CHECK (PublisherAddress LIKE '________________%')
)

CREATE TABLE Genre(
	GenreID CHAR(6),
	GenreName VARCHAR(255),
	PRIMARY KEY (GenreID),
	CONSTRAINT GenreID_Check CHECK (GenreID LIKE 'GEN[0-9][0-9][0-9]') 
)


CREATE TABLE SalesTransaction(
	TransactionID CHAR(6),
	UserID CHAR(6),
	TransactionDate DATE,
	PRIMARY KEY (TransactionID),
	FOREIGN KEY (UserID) REFERENCES [User](UserID),
	CONSTRAINT TransactionID_Check CHECK (TransactionID LIKE 'SAL[0-9][0-9][0-9]')
)

CREATE TABLE Movie(
	MovieID CHAR(6),
	DirectorID CHAR(6),
	PublisherID CHAR(6),
	MovieTitle VARCHAR(255),
	MovieReleaseDate DATE,
	Price INT,
	MovieDescription VARCHAR(1000),
	PRIMARY KEY (MovieID),
	FOREIGN KEY (DirectorID) REFERENCES Director(DirectorID),
	FOREIGN KEY (PublisherID) REFERENCES Publisher(PublisherID),
	CONSTRAINT MovieReleaseDate_Check CHECK (YEAR(MovieReleaseDate) >= 2000 AND YEAR(MovieReleaseDate) <= 2016),
	CONSTRAINT MovieDescription_Check CHECK (MovieDescription LIKE '_____________________%'),
	CONSTRAINT MovieID_Check CHECK (MovieID LIKE 'MOV[0-9][0-9][0-9]')
)

CREATE TABLE DetailTransaction(
	MovieID CHAR(6),
	TransactionID CHAR(6),
	Quantity INT,
	PRIMARY KEY (MovieID, TransactionID),
	FOREIGN KEY (MovieID) REFERENCES Movie(MovieID),
	FOREIGN KEY (TransactionID) REFERENCES SalesTransaction(TransactionID)
)

CREATE TABLE Movie_Genre(
	GenreID CHAR(6),
	MovieID CHAR(6),
	PRIMARY KEY (GenreID,MovieID),
	FOREIGN KEY (GenreID) REFERENCES Genre(GenreID),
	FOREIGN KEY (MovieID) REFERENCES Movie(MovieID)
)

CREATE TABLE Review(
	UserID CHAR(6),
	MovieID CHAR(6),
	Recommendationstatus VARCHAR(255),
	ReviewContent VARCHAR(255),
	ReviewDate DATE,
	PRIMARY KEY (UserID, MovieID),
	FOREIGN KEY (MovieID) REFERENCES Movie(MovieID),
	FOREIGN KEY (UserID) REFERENCES [User](UserID),
	CONSTRAINT ReviewContent_Check CHECK (ReviewContent LIKE '_____________________%')
)

/*
USE master
DROP DATABASE Project
*/