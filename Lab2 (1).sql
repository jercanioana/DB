
USE Clinic2
ALTER TABLE Doctor_Equipment
ADD CONSTRAINT PK_Doctor_Equipment PRIMARY KEY (DoctorID, EquipmentID);

INSERT INTO Doctor(DoctorID, [First Name], [Last Name], Gender, Age, Section, Salary)
Values (5, 'Radu', 'Pop' , 'M', 50, 'Oncology', 50000);
INSERT INTO Nurse(NurseID, [First Name], [Last Name], Gender, Age, Section, Salary)
Values (3, 'Emilian', 'Pop' , 'M', 50, 'Oncology', 35000);
INSERT INTO Nurse(NurseID, [First Name], [Last Name], Gender, Age, Section, Salary)
Values (4, 'Daniela Narcis', 'Gavril' ,'F', 50, 'Oncology', 35000);
INSERT INTO Nurse(NurseID, [First Name], [Last Name], Gender, Age, Section, Salary)
Values (5, 'Silviu', 'Pop' , 'M', 50, 'Oncology', 35000);
INSERT INTO Doctor(DoctorID, [First Name], [Last Name], Gender, Age, Section, Salary)
Values (6, 'Vlad', 'Popistasu' , 'M', 29, 'Oncology', 50000);

--statement vioaltes an integrity constraint at gender.
INSERT INTO Doctor(DoctorID, [First Name], [Last Name], Gender, Age, Section, Salary)
Values (7, 'Vlad', 'Popistasu' , 'S', 29, 'Oncology', 50000);


INSERT INTO Doctor(DoctorID, [First Name], [Last Name], Gender, Age, Section, Salary)
VALUES(16, 'Elizabeth', 'Swan', 'F', 29, 'ORL', 50000);

INSERT INTO Patient(PatientID, [First Name], [Last Name], Gender, Age, [Date of check in], [Date of check out], DoctorID, NurseID, WardID)
Values(2, 'Ioana', 'Jercan' ,'F', 20, '2019-01-18', '2019-01-23', 5, 4, 1);
INSERT INTO Treatment(TreatmentID, DoctorID, PatientID)
Values(2, 5, 2);
INSERT INTO Patient(PatientID, [First Name], [Last Name], Gender, Age, [Date of check in], [Date of check out], DoctorID, NurseID, WardID)
values(3, 'Tudor', 'Popescu', 'M', 18, '2019-01-18', '2019-01-23', 16, 5, 1);
INSERT INTO Treatment(TreatmentID, DoctorID, PatientID)
Values(3, 16, 2);

UPDATE Doctor
SET [First Name] = 'Iulian'
WHERE DoctorID = 6;
UPDATE Doctor
SET [Salary] = 45000
WHERE Salary >= 30000;

UPDATE Doctor
SET [Salary] = 50000
WHERE DoctorID BETWEEN '2' and '5';


UPDATE Doctor
SET [Section] = 'ORL'
WHERE DoctorID = 6;

UPDATE Nurse
SET [First Name] = 'Maria'
WHERE NurseID = 2;
UPDATE Nurse
SET [Last Name] = 'Dediu'
WHERE [First Name] LIKE 'M%a';
UPDATE Nurse
SET Salary = 30000
WHERE NurseID BETWEEN '3' AND  '5';

UPDATE Patient
SET [Date of check out] = '2019-01-24'
WHERE PatientID IN ('2','3');
UPDATE Patient
SET [Date of check out] = '2019-01-26'
WHERE [First Name] = 'Tudor' AND PatientID = 3;
UPDATE Patient
SET [WardID] = 1
WHERE WardID IS NULL;

DELETE FROM Doctor
Where DoctorID = 16;
DELETE FROM Nurse 
WHERE NurseID = 5;

--a
--All the names of the employees who have at least a salary of 30000 (doctors) and 25000 (nurses).
SELECT [Last Name] FROM Doctor
WHERE Salary > 30000
UNION 
SELECT [Last Name] FROM Nurse
WHERE Salary > 25000


--All the names of the patients who checked out on either dates.
SELECT [Last Name] From Patient
WHERE [Date of check out] = '2019-01-26' OR [Date of check out] = '2019-01-24'

--b
--All the female doctors who have a salary of 50000.
SELECT DoctorID FROM Doctor
Where SALARY = 50000
INTERSECT
SELECT DoctorID FROM Doctor
Where Gender = 'F';

--All the patients from wards 1 or 4.
SELECT PatientID FROM Patient
WHERE WardID IN ('1', '4')

--c
--All the nurses with age not 30.
SELECT [Last Name] FROM Nurse
WHERE Age not in (30)

--All the names of the male nurses who have a salary of at least 20000.
SELECT [Last Name] FROM Nurse
WHERE Salary >= 20000
EXCEPT
SELECT [Last Name] FROM Nurse
WHERE Gender = 'F';

--d
--The names of the medicine used on treatment with ID 1.
SELECT Medicine.Name
FROM Medicine
INNER JOIN Treatment_Medicine ON Medicine.MedicineID = Treatment_Medicine.MedicineID
INNER JOIN Treatment ON Treatment_Medicine.TreatmentID = Treatment.TreatmentID
WHERE Treatment.TreatmentID = 1;

--The names of the patients treated by female doctors.
SELECT Patient.[First Name], Patient.[Last Name]
FROM Patient
Right join Doctor ON Doctor.DoctorID = Patient.DoctorID
WHERE Doctor.Gender = 'F';

--the names of the equipments used by doctors in the cardiology section
SELECT Equipment.Name
FROM Doctor_Equipment
Left join Equipment ON Doctor_Equipment.EquipmentID = Equipment.EquipmentID
Left join Doctor ON Doctor_Equipment.DoctorID = Doctor.DoctorID
WHERE Doctor.Section = 'Cardiology';


--The name of the doctors who performed the treatment where the stetoscope was used.
SELECT Doctor.[First Name], Doctor.[Last Name], Treatment.TreatmentID
FROM Doctor_Equipment
FULL JOIN Equipment ON Doctor_Equipment.EquipmentID = Equipment.EquipmentID
FULL JOIN Doctor ON Doctor_Equipment.DoctorID = Doctor.DoctorID
FULL JOIN Treatment ON Treatment.DoctorID = Doctor.DoctorID
FULL JOIN Treatment_Medicine ON Treatment_Medicine.TreatmentID = Treatment.TreatmentID
WHERE Equipment.Name = 'Stetoscope';

--e
--The names of the nurses who treat the adult patients from Ward 1.
SELECT [Last Name]
FROM Nurse
WHERE NurseID IN (
	SELECT NurseID
	FROM Patient
	WHERE WardID = 1 AND Patient.Age > 18);

--All the doctors who performed a consultation on a male patient.
SELECT *
FROM Doctor
WHERE DoctorID IN (
	SELECT DoctorID
	FROM Consultation
	WHERE PatientID IN (
		SELECT PatientID
		FROM Patient
		WHERE Gender = 'M')
);

--f
--names of the medicine used for treatments

SELECT Name
FROM Medicine
WHERE EXISTS(
	select MedicineID
	from Treatment_Medicine
);

--all the doctors who are currently treating male patients
SELECT *
FROM Doctor
WHERE EXISTS(
	SELECT DoctorID
	FROM Patient
	WHERE Patient.Gender = 'M');

--g
--Doctors who treated the patients checked out in date ''
SELECT D.DoctorID
FROM (SELECT Doctor.DoctorID
	  FROM Doctor INNER JOIN Patient ON Patient.DoctorID = Doctor.DoctorID
	  WHERE Patient.[Date of check out] = '2019-01-26')D;
	  
--Names of the patients who where diagnosed by Doctor 'Pop'
SELECT V.[First Name]
from ( SELECT Patient.[First Name]
		FROM Patient inner join Diagnostic ON Patient.PatientID = Diagnostic.PatientID
		inner join Doctor ON Doctor.DoctorID = Diagnostic.DoctorID
		WHERE Doctor.[Last Name] = 'Pop')V;



--h
--Number of patients in each ward.
SELECT COUNT(PatientID) AS Patients, WardID
FROM Patient
GROUP BY WardID
ORDER BY WardID;

--List of the sections which have at least 2 doctors and display the maximum salary on the section
SELECT Section, MAx(Salary) AS MaxSalary
FROM Doctor
GROUP BY Section
HAVING Count(DoctorID) >= 2
ORDER BY Section;

--The names of the doctors whose salary is bigger than the overall average salaries for doctors
SELECT [Last Name]
FROM Doctor
GROUP BY [Last Name]
HAVING avg(Salary) > ( SELECT avg(Salary) FROM Doctor);


--The medicines which would expire first
SELECT Name
FROM Medicine
GROUP BY Name
HAVING avg(Availabilty) > (SELECT avg(Availabilty) FROM Medicine);
--i
--The doctor ID's of those whose salaries is greater than the ones' whose last name is Pop.
SELECT D.DoctorID
FROM Doctor D
WHERE D.Salary > ALL(
	SELECT D2.Salary
	FROM Doctor D2
	WHERE D2.[Last Name] = 'Pop');

SELECT D.DoctorID
FROM Doctor D
WHERE D.Salary > (
	SELECT MAx(D2.Salary)
	FROM Doctor D2
	WHERE D2.[Last Name] = 'Pop');

--The names of the equipments, except for the most expensive ones.
SELECT DISTINCT E.Name
FROM Equipment E
WHERE E.Price NOT IN (
	select MAX(E1.Price)
	FROM Equipment E1);

SELECT DISTINCT E.Name
FROM Equipment E
WHERE E.Price <> ALL(
	select MAX(E1.Price)
	FROM Equipment E1);


--The female doctors whose seniority is greater than the one who has the least seniority

SELECT D.[First Name], D.[Last Name]
FROM Doctor D
WHERE D.Seniority > ANY (SELECT D1.Seniority
						FROM Doctor D1
						WHERE D.Gender = 'F') AND D.Gender = 'F';

SELECT D.[First Name], D.[Last Name]
FROM Doctor D
WHERE D.Seniority > (SELECT Min(D1.Seniority)
						FROM Doctor D1
						WHERE D.Gender = 'F') AND D.Gender = 'F';

	
--The medicine used for treatment with ID 1.
SELECT DISTINCT M.Name
FROM Medicine M
WHERE M.MedicineID =Any(SELECT M2.MedicineID
						FROM Treatment_Medicine M2
						Where M2.TreatmentID = 1);

SELECT M.Name
FROM Medicine M
WHERE M.MedicineID IN (SELECT M2.MedicineID
						FROM Treatment_Medicine M2
						Where M2.TreatmentID = 1);

		
--2 queries with TOP
--The first two female doctors in the table.
SELECT TOP 2 *
FROM Doctor
WHERE Gender = 'F'

SELECT TOP 2 *
FROM Ward

--3 queries using mathematical expressions 
--how much a doctor earns per day, each month
SELECT [First Name], [Last Name], (Salary) / 20
FROM Doctor

--how much a nurse earns per day, each month
SELECT [First Name], [Last Name], (Salary) / 20
FROM Nurse

--how many years a doctor has until retirement 

SELECT [First Name], [Last Name], 65 - Age
FROM Doctor





