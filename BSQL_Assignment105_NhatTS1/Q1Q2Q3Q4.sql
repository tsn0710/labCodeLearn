USE master
GO

-- Drop the database if it already exists
IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'NhatTS1Assignment5'
)
DROP DATABASE NhatTS1Assignment5
GO

CREATE DATABASE NhatTS1Assignment5
GO

USE  NhatTS1Assignment5
--Q1:
--use TrainingDay2Assignment2
CREATE TABLE Employees(
	EmpNo		VARCHAR(50) NOT NULL PRIMARY KEY,
	EmpName		NVARCHAR(50) NOT NULL,
	BirthDay	DATE NOT NULL,
	DeptNo		INT NOT NULL,
	MgrNo		VARCHAR(50) NOT NULL,
	StartDate	DATE NOT NULL,
	Salary		MONEY NOT NULL,
	[Level]		INT NOT NULL,
	[Status]	TINYINT NOT NULL,
	Note		NVARCHAR(MAX) NULL,
)
CREATE TABLE EmployeeSkills(
	SkillNo			INT NOT NULL,
	EmpNo			VARCHAR(50) NOT NULL,
	SkillLevel		INT NOT NULL,
	RegDate			DATE NOT NULL,
	[Description]	NVARCHAR(MAX) NULL,
)
CREATE TABLE Skills(
	SkillNo		INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	SkillName	VARCHAR(50) NOT NULL,
	Note		NVARCHAR(MAX) NULL,
)
CREATE TABLE Departments(
	DeptNo		INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	DeptName	VARCHAR(50) NOT NULL,
	Note		NVARCHAR(MAX) NULL,
)
--THEM RANG BUOC 
ALTER TABLE Employees ADD CONSTRAINT CheckLevel CHECK (Level>0 AND LEVEL<8);
ALTER TABLE Employees ADD CONSTRAINT CheckStatus CHECK (Status in (0,1,2));
ALTER TABLE Employees ADD CONSTRAINT CheckSalary CHECK (Salary >= 0);
ALTER TABLE Employees ADD CONSTRAINT CheckBirthDay CHECK (DATEDIFF(YEAR,BirthDay,GETDATE()) >= 18);
ALTER TABLE Employees  ADD CONSTRAINT FK_Employees_DeptNo FOREIGN KEY ([DeptNo]) REFERENCES Departments([DeptNo]);


ALTER TABLE EmployeeSkills ADD CONSTRAINT PK_EmployeeSkills PRIMARY KEY([SkillNo],[EmpNo]);
ALTER TABLE EmployeeSkills ADD CONSTRAINT CheckSkillLevel CHECK (SkillLevel>=1 AND SkillLevel<=3);
ALTER TABLE EmployeeSkills  ADD CONSTRAINT FK_EmployeeSkills_SkillNo FOREIGN KEY ([SkillNo]) REFERENCES Skills([SkillNo]);
ALTER TABLE EmployeeSkills  ADD CONSTRAINT FK_EmployeeSkills_EmpNo FOREIGN KEY ([EmpNo]) REFERENCES Employees([EmpNo]);

/*
--Q2a:
--them mot truong Email vao bang Employees
ALTER TABLE Employees ADD Email NVARCHAR(50) NULL;
--UNIQUE
ALTER TABLE Employees ADD CONSTRAINT Employees_Email unique(Email)
*/
--Q2b:
ALTER TABLE Employees ADD CONSTRAINT Employees_MgrNo DEFAULT 0 FOR MgrNo;
ALTER TABLE Employees ADD CONSTRAINT Employees_Status DEFAULT 0 FOR Status;
/*
--Q3a:
ALTER TABLE Employees  ADD CONSTRAINT FK_Employees_DeptNo2 FOREIGN KEY ([DeptNo]) REFERENCES Departments([DeptNo]);
--Q3b:
--XOA COT Description
ALTER TABLE EmployeeSkills DROP COLUMN [Description]
*/
--Q4a:
--insert skill
INSERT Skills(SkillName, Note)
VALUES ('Listen','Listen other talkin'), 
	('Talk','Talk to other listenin'),
	('Read','Read information'),
	('Write','Write for other read'),
	('Think','Create new information')

--insert department
INSERT Departments(DeptName, Note)
VALUES ('Code','very inteligen'),
	('Sale','look inteligent'),
	('Manage','thinkbout future'),
	('Intern','chiken'),
	('Fish', NULL)
--insert employee
INSERT Employees(EmpNo,EmpName,BirthDay,DeptNo,MgrNo,StartDate,Salary,[Level],[Status],Note)
VALUES ('NhatTS1',N'Tống Sỹ Nhật','2001-10-07', 4,'9999','2023-01-09',0.6969,1,0,'good boy'),
('QuangHE',N'He He Quang','2001-02-02', 4,'9999','2023-01-09',99,2,0,'iteligen boy'),
('NhatTS2',N'Tống Sỹ Nhật hai','2001-10-07', 4,'9999','2023-01-09',0.6969,3,0,NULL),
('NhatTS3',N'Tống Sỹ Nhật ba','2001-10-07', 4,'9999','2023-01-09',0.6969,4,0,NULL),
('NhatTS4',N'Tống Sỹ Nhật bon','2001-10-07',4,'9999','2023-01-09',0.6969,5,0,NULL)
--insert employeeSkills
INSERT EmployeeSkills(SkillNo,EmpNo,SkillLevel,RegDate,[Description])

VALUES (4,'NhatTS1',3,'2023-01-11',N'good intun'),
(4,'QuangHE',3,'2023-01-11',N'good fren'),
(3,'QuangHE',3,'2023-01-11',N'good future leader'),
(5,'NhatTS2',3,'2023-01-11',NULL),
(5,'NhatTS3',3,'2023-01-11',N'cá cảnh')

--Q4b:
GO
 CREATE VIEW vwEmployeeTracking
 AS
	 SELECT e.EmpNo, e.EmpName as Emp_Name, e.Level
	 FROM Employees e
	 WHERE e.Level >=3 AND e.Level <=5
go
SELECT * FROM vwEmployeeTracking
