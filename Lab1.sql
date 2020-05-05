USE Clinic2

CREATE TABLE Patient(
PatientID TINYINT PRIMARY KEY,
[First Name] VARCHAR(30),
[Last Name] VARCHAR(30),
Gender CHAR(2) CHECK (Gender = 'F' or Gender = 'M'),
Age TINYINT,
[Date of check in] DATE,
[Date of check out] DATE,
)

CREATE TABLE Doctor(
DoctorID TINYINT PRIMARY KEY,
[First Name] VARCHAR(30),
[Last Name] VARCHAR(30),
Gender CHAR(2) CHECK (Gender = 'F' or Gender = 'M'),
Age TINYINT,
Section VARCHAR(30),
Salary DECIMAL(8,2))

CREATE TABLE Nurse(
NurseID TINYINT PRIMARY KEY,
[First Name] VARCHAR(30),
[Last Name] VARCHAR(30),
Gender CHAR(2) CHECK (Gender = 'F' or Gender = 'M'),
Age TINYINT,
Section VARCHAR(30),
Salary DECIMAL(8,2))

CREATE TABLE Ward(
WardID TINYINT PRIMARY KEY,
Capacity TINYINT,
[Floor] TINYINT)

CREATE TABLE Treatment(
TreatmentID TINYINT PRIMARY KEY,
DoctorID TINYINT,
PatientID TINYINT)

CREATE TABLE Medicine(
MedicineID TINYINT PRIMARY KEY,
[Name] VARCHAR(100),
Usage VARCHAR(100))

CREATE TABLE Consultation(
ConsultationID TINYINT PRIMARY KEY,
DoctorID TINYINT,
PatientID TINYINT,
[Date] DATE)

CREATE TABLE Diagnostic(
DiagnosticID TINYINT PRIMARY KEY,
DoctorID TINYINT,
TreatmentID TINYINT,
PatientID TINYINT)

CREATE TABLE Equipment(
EquipmentID TINYINT PRIMARY KEY,
[Date purchased] DATE)
