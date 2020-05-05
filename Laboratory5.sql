CREATE DATABASE [Library]
USE [Library]
CREATE TABLE Books(
	BID int PRIMARY KEY,
	ISBN int UNIQUE,
	Title varchar(50),
	Author VARCHAR(50),
	Publisher VARCHAR(60)
	)

CREATE TABLE Clients(
	CID int PRIMARY KEY,
	Age int,
	[FName] VARCHAR(50),
	[LName] VARCHAR(50),
	)

CREATE TABLE Rentals(
	RID int primary key,
	BID int FOREIGN KEY REFERENCES Books(BID),
	CID int FOREIGN KEY REFERENCES Clients(CID),
	[Date] date
	)

	--a
--clustered index scan
SELECT * FROM Books

--clustered index seek
SELECT Title, Author FROM Books WHERE BID in (1, 3)



--nonclustered index scan
SELECT Title, Author FROM Books

--nonclustered index seek
CREATE INDEX idx_ISBN
ON Books(ISBN)
INCLUDE (Title, Author)

SELECT Title, Author FROM Books WHERE ISBN > 1000

--key lookup
SELECT * FROM Books WHERE ISBN = 3175

	--b
SELECT *
FROM Clients
WHERE Age = 30 --clustered index scan, cost: 0.0032864

CREATE INDEX idx_age
ON Clients(Age)
INCLUDE (CID, LName, FName)

--cost 0.0032842

--c
go
CREATE VIEW view1
AS
	SELECT Clients.LName, Clients.FName, Clients.Age
	FROM Clients INNER JOIN Rentals ON Clients.CID = Rentals.CID WHERE Age = 30
go

SELECT * FROM view1