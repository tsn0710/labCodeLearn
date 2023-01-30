USE master
GO

-- Drop the database if it already exists
IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'NhatTS1Assignment6'
)
DROP DATABASE NhatTS1Assignment6
GO

CREATE DATABASE NhatTS1Assignment6
GO
USE NhatTS1Assignment6
GO
CREATE TABLE Trainees(
	TraineeID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	FullName VARCHAR(100) NOT NULL,
	BirthDate DATE NOT NULL,
	Gender BIT NOT NULL,
	EntryIQ INT CHECK(EntryIQ BETWEEN 0 AND 20) NOT NULL,
	EntryGMath INT CHECK(EntryGMath BETWEEN 0 AND 20) NOT NULL,
	EntryEnglish INT CHECK(EntryEnglish BETWEEN 0 AND 50) NOT NULL,
	TrainingClass VARCHAR(50) NOT NULL,
	EvaluationNote NVARCHAR(MAX) NULL,
)

--Q1B: add at least 10 records into each created table.
INSERT Trainees(FullName,BirthDate,Gender,EntryIQ,EntryGMath,EntryEnglish,TrainingClass,EvaluationNote)
VALUES	
('Tong Sy Nhat','2023-01-10',0,16,17,18,'DOT NET','Hoc chan chi'),
('Nguyen Xuan Thanh','2023-02-28',0,5,9,19,'DOT NET','Hoc gioi'),
('ThaiLS','2023-03-30',0,6,8,20,'C SHARP','nhanh tay thu nhat'),
('HoangCM','2023-04-30',0,7,7,21,'JAVA','nhanh tay thu hai'),
('TuanKM1','2023-05-30',0,8,6,22,'PYTHON','giong tuanVM'),

('TanDV3','2023-06-30',0,9,18,23,'FRONT END','uhm..nothing'),
('AnhDHN','2020-07-30',0,10,17,24,'INTERN','uhm..nothing'),
('NhanPT12','2023-08-30',0,11,16,25,'ENGLISH','uhm..nothing'),
('LongNP14','2023-09-30',0,12,15,26,'Japanese','uhm..nothing'),
('HuyPQ50','2023-10-30',0,13,14,27,'DOT NET','uhm..nothing')
GO
--them mot truong Fsoft_Account  vao bang Movies
ALTER TABLE Trainees ADD FsoftAccount VARCHAR(300) NOT NULL DEFAULT NEWID();
--UNIQUE notnull
ALTER TABLE Trainees ADD CONSTRAINT Trainees_FsoftAccount UNIQUE(FsoftAccount)

SELECT * FROM Trainees
--Create a VIEW that includes all the ET-passed trainees. One trainee is considered as ET-passed 
--when he/she has the entry test points satisfied below criteria:
GO
 CREATE VIEW vwETPassedTrainees
 AS
	 SELECT (t.EntryIQ + t.EntryGMath) AS 'EntryIQ + EntryGMath',t.TraineeID,t.FullName,t.Gender,t.BirthDate,t.EntryIQ,t.EntryGMath,t.EntryEnglish,t.EvaluationNote
	 FROM Trainees t
	 WHERE (t.EntryIQ + t.EntryGMath) >= 20 
			AND t.EntryIQ >=8
			AND t.EntryGMath >=8
			AND t.EntryEnglish >=18
GO
--Query all the trainees who are passed the entry test, group them into different birth months.
SELECT *
FROM
(
	SELECT MONTH(t.BirthDate) AS [MonthOfBirthDate], 
		NULL AS 'TraineeID',
		NULL AS 'FullName' ,
		NULL AS 'BirthDate' ,
		NULL AS 'Gender',
		NULL AS 'EntryIQ',
		NULL AS 'EntryGMath',
		NULL AS 'EntryEnglish',
		NULL AS 'TrainingClass',
		NULL AS 'EvaluationNote',
		NULL AS 'FsoftAccount'
	FROM Trainees t 
	WHERE T.TraineeID IN
	( 
	SELECT vw.TraineeID 
	FROM vwETPassedTrainees vw
	)
UNION ALL
SELECT MONTH(t.BirthDate) AS [MonthOfBirthDate],t.* 
FROM Trainees t 
WHERE T.TraineeID IN
	( 
	SELECT vw.TraineeID 
	FROM vwETPassedTrainees vw
	)
)a
ORDER BY a.MonthOfBirthDate ASC, a.BirthDate ASC

--Query the trainee who has the longest name, showing his/her age along with his/her basic information (as defined in the table).


SELECT TOP 1 WITH TIES *, DATEDIFF(year,t.BirthDate,GETDATE()) AS 'Age'
FROM Trainees t
ORDER BY LEN(t.FullName)
