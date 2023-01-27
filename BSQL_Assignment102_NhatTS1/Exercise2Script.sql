
CREATE TABLE Employees(
	EmployeeSsn INT NOT NULL PRIMARY KEY IDENTITY,
	Salary MONEY NOT NULL,
	Phone INT NOT NULL,
	DepartmentNumber INT NOT NULL
)
GO
CREATE TABLE Departments(
	DepartmentNumber INT NOT NULL PRIMARY KEY IDENTITY,
	DepartmentName VARCHAR(50) NOT NULL,
	Budget MONEY NOT NULL,
	EmployeeManagerSsn INT NOT NULL UNIQUE FOREIGN KEY REFERENCES [Employees] ([EmployeeSsn])
)
GO
CREATE TABLE ChildrenOfEmployees(
	ChildrenName NVARCHAR(50),
	EmloyeeParentSsn INT NOT NULL,
	Age INT,
	PRIMARY KEY ([ChildrenName],[EmloyeeParentSsn]),
	FOREIGN KEY([EmloyeeParentSsn]) REFERENCES [Employees] ([EmployeeSsn])
)
GO
ALTER TABLE Employees
ADD CONSTRAINT FK_Employees FOREIGN KEY([DepartmentNumber]) REFERENCES [Departments] ([DepartmentNumber]);