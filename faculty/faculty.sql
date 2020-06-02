
CREATE database School_Information

drop table faculty
Create table Faculty (

FacultyID int NOT NULL,
Name varchar(255),
department varchar(255),
gender varchar(255)
PRIMARY KEY (FacultyID)

)

truncate table Faculty
INSERT INTO Faculty (FacultyID, Name, department, gender)

values

(001, 'Aakash', 'CS', 'M'),
(002, 'Sahil', 'EC', 'M'),
(003, 'John', 'HSS', 'M'),
(004, 'Shelley', 'CS', 'F'),
(005, 'Anannya', 'CS', 'F'),
(006, 'Sia', 'HSS', 'F')

UPDATE Faculty
SET department =  CASE department
	WHEN 'CS' THEN 'Computer Science'
	WHEN 'EC' THEN 'Electronics and Communication'
	WHEN 'HSS' THEN 'Humanities and Social Sciences'
END

SELECT FacultyID, Name, department,
	case gender
		WHEN 'M' THEN 'Male'
		WHEN 'F' THEN 'female'
	end as gender
FROM Faculty

CREATE PROCEDURE SortByTuple2 @OrderBy varchar(255)
as
	SELECT * 
	FROM Faculty
	ORDER BY 
		CASE when @OrderBy = 'name' THEN name end DESC,
		CASE when @OrderBy = 'department' THEN department end DESC,
		CASE when @OrderBy = 'gender' THEN gender end DESC

GO



--8

use master;
GO
drop database [School_Information]
GO

