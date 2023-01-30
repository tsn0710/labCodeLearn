USE master
GO

-- Drop the database if it already exists
IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'NhatTS1Assignment'
)
DROP DATABASE NhatTS1Assignment
GO

CREATE DATABASE NhatTS1Assignment
GO
USE NhatTS1Assignment
--Q1
CREATE TABLE Movies(
	MovieId INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	MovieName NVARCHAR(100) NOT NULL,
	Duration DECIMAL(10,4) NOT NULL, 
	Genre INT NOT NULL,
	Director NVARCHAR(50) NOT NULL,
	AmountOfMoneyMadeAtBoxOffice DECIMAL(18,2) NOT NULL,
	Comment NVARCHAR(MAX) NULL
)
--THEM RANG BUOC 
ALTER TABLE Movies ADD CONSTRAINT CheckDuration CHECK (Duration/3600 >= 1);
ALTER TABLE Movies ADD CONSTRAINT CheckGenre CHECK (Genre BETWEEN 1 AND 8);

--
CREATE TABLE Actors(
	ActorId INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	ActorName NVARCHAR(50) NOT NULL,
	Age INT NOT NULL,
	AverageMovieSalary DECIMAL(18,2) NOT NULL,
	Nationality NVARCHAR(50) NOT NULL,
)
--THEM RANG BUOC 
ALTER TABLE Actors ADD CONSTRAINT CheckAge CHECK (Age BETWEEN 0 AND 100);
--
CREATE TABLE ActorActedInMovie(
	ActorId INT NOT NULL,
	MovieId INT NOT NULL,
)
--THEM RANG BUOC 
ALTER TABLE ActorActedInMovie ADD CONSTRAINT PK_ActorActedInMovie PRIMARY KEY([ActorId],[MovieId]);
ALTER TABLE ActorActedInMovie ADD CONSTRAINT FK_ActorActedInMovie_ActorId FOREIGN KEY ([ActorId]) REFERENCES Actors([ActorId]);
ALTER TABLE ActorActedInMovie ADD CONSTRAINT FK_ActorActedInMovie_MovieId FOREIGN KEY ([MovieId]) REFERENCES Movies([MovieId]);


--Q2a
--them mot truong ImageLink vao bang Movies
ALTER TABLE Movies ADD ImageLink NVARCHAR(300);
--UNIQUE
ALTER TABLE Movies ADD CONSTRAINT Movies_ImageLink UNIQUE(ImageLink)
--test Q2a
--Insert Movies(MovieName,Duration,Genre,Director,AmountOfMoneyMadeAtBoxOffice,Comment,ImageLink)
--VALUES		(N'MovieName1','09:56:33.22',1,'Nhat',999,NULL, 'https://123.22/asdfas'),
--			    (N'MovieName2','23:59:33.22',2,'Nhat',9992,NULL, 'https://123.22/asdfas')
--Expected result: error: "Violation of UNIQUE KEY constraint 'Movies_ImageLink'. Cannot insert duplicate key in object 'dbo.Movies'. The duplicate key value is (https://123.22/asdfas)."

--Q2b
INSERT Movies(MovieName,Duration,Genre,Director,AmountOfMoneyMadeAtBoxOffice,Comment,ImageLink)
VALUES	(N'Trường cấp ba',3601,1,'Thay co',100000,'a','https://vu.tien/thpt'),
		(N'Trường đại học',7888.0,2,'Giang vien',500000,'b','https://ep.pi.ti/dh'),
		(N'Trường chưa thực tập',23456.0,3,'Giang vien',200000,'c','https://ep.pi.ti/dh1'),
		(N'Trường đang thực tập',444444.0,1,'Anh chi',900000,'d','https://ep.pi.ti/fsoft'),
		(N'Trường đời',99999.0,5,'every one',9990000,'e','https://everythin/')
GO
INSERT Actors(ActorName,Age,AverageMovieSalary,Nationality)
VALUES (N'Tống Sĩ Nhật',22,1111,N'Việt Nam'),
		(N'Nguyễn Văn Thành',22,5555,N'Mỹ'),
		(N'Tạ Kiều Quang',21,3333,'Canada'),
		(N'Đinh Ngọc Long',77,2222,'Japan'),
		(N'Tống Sỹ Nhật hai',99,4444,N'Thái Lan')
GO
INSERT ActorActedInMovie(ActorId,MovieId)
VALUES  (1,1),(1,2),(1,3),(1,4),(1,5),
		(2,2),(2,3),(2,4),
		(3,3),(3,4),
		(4,1),(4,2),(4,3),(4,4),
		(5,5)
--update a row after mis-type
UPDATE Actors
SET ActorName=N'Tống Sỹ Nhật'
WHERE ActorName=N'Tống Sĩ Nhật';

--Q2c
--Write a query to retrieve all the data in the Actor table for actors that are older than 50.
SELECT a.ActorName AS [Name of actor], a.Age, CAST(a.AverageMovieSalary AS nvarchar(100))+' Dollar' as [Average Salary], a.Nationality
FROM Actors a
WHERE a.Age >50

--Q2d
--Write a query to retrieve all actor names and average salaries from ACTOR and sort the results by average salary.
SELECT a.ActorName AS [Name of actor], CAST(a.AverageMovieSalary AS nvarchar(100))+' Dollar' as [Average Salary]
FROM Actors a
ORDER BY a.AverageMovieSalary ASC

--Q2e
--Using an actor name from your table, write a query to retrieve the names of all the movies that actor has acted in.
--Truong hop 1: 
SELECT m.MovieName
FROM Movies m
WHERE m.MovieId IN (
	SELECT aaim.MovieId 
	FROM ActorActedInMovie aaim 
	WHERE aaim.ActorId IN (
		SELECT a.ActorId 
		FROM Actors a 
		WHERE a.ActorName LIKE N'%Nhật%' )
)
--Truong hop 2: 
SELECT m.MovieName
FROM Movies m
WHERE m.MovieId in (
	SELECT aaim.MovieId 
	FROM ActorActedInMovie aaim 
	WHERE aaim.ActorId IN (
		SELECT a.ActorId 
		FROM Actors a 
		WHERE a.ActorName LIKE N'%Thành%' )
)
--Q2f
--Write a view to retrieve the names of all the action movies that amount of actor be greater than 3
GO
 CREATE VIEW vwActionMoviesMoreThanThreeActors
 AS
	 SELECT m.MovieName
	 FROM Movies m
	 WHERE m.Genre=1 AND m.MovieId IN (
			SELECT aaim.MovieId
			FROM ActorActedInMovie aaim 
			GROUP BY aaim.MovieId 
			HAVING COUNT(aaim.ActorId)>3 )
GO
--TEST
SELECT * FROM vwActionMoviesMoreThanThreeActors


