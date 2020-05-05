CREATE PROCEDURE USP_CreateTable2
AS
begin
	CREATE TABLE NewBorns(
	NBID tinyint NOT NULL,
	[Name] varchar(1000),
	DOB Date,
	Gender Varchar(700),
	DoctorID tinyint)
end
GO

go
CREATE PROCEDURE USP_DropTable
AS
begin
	DROP TABLE NewBorns
end
GO

go
CREATE PROCEDURE USP_AddPrimaryKey1
AS
begin
	ALTER TABLE NewBorns 
	ADD CONSTRAINT PK_NewBorns PRIMARY KEY (NBID);
end
go
CREATE PROCEDURE USP_RemovePrimaryKey
AS
begin
	ALTER TABLE NewBorns
	DROP CONSTRAINT PK_NewBorns;
end
go
CREATE PROCEDURE USP_ChangeColumn
AS
begin
	ALTER TABLE Nurse
	ALTER COLUMN Age int;
end
go
CREATE PROCEDURE USP_ChangeBackColumn
AS
begin
	ALTER TABLE Nurse
	ALTER COLUMN Age tinyint ;
end
go
CREATE PROCEDURE USP_AddColumn
AS
begin
	ALTER TABLE Treatment
	ADD [Name] varchar(30);
end
go
CREATE PROCEDURE USP_RemoveColumn
AS
begin
	ALTER TABLE Treatment
	DROP COLUMN [Name];
end
go
CREATE PROCEDURE USP_AddConstraint
AS
begin
	ALTER TABLE Nurse
	ADD CONSTRAINT df_constraint DEFAULT 35000 for Salary;
end
go

CREATE PROCEDURE USP_RemoveConstraint
AS
begin
	ALTER TABLE Nurse
	DROP df_constraint;
end
go

CREATE PROCEDURE USP_AddForeignKey1
AS
begin
	ALTER TABLE NewBorns
	ADD CONSTRAINT FK_DoctorID FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID);
end
go
CREATE PROCEDURE USP_RemoveForeignKey
AS
begin
	ALTER TABLE NewBorns
	DROP CONSTRAINT FK_DoctorID;
end
go
CREATE PROCEDURE USP_AddCandidateKey
AS
begin
	ALTER TABLE Doctor
	ADD CONSTRAINT UQ_Doctor_id_phone_number unique(DoctorID, [Phone Number]);
end
go
CREATE PROCEDURE USP_RemoveCandidateKey
AS
begin
	ALTER TABLE Doctor
	DROP CONSTRAINT UQ_Doctor_id_phone_number;
end
go
Use Clinic2
CREATE TABLE VERSION(
	currentVersion int,
	queryDo VARCHAR(1000),
	queryUndo VARCHAR(1000)
	);
go
CREATE TABLE CurrentVersion(
	currentVersion int);
go
CREATE PROCEDURE USP_ChangeVersion6(@newVersion int)
AS
begin
	DECLARE @currentVersion int
	DECLARE @queryToDo VARCHAR(1000)
	DECLARE @queryToUndo VARCHAR(1000)
	SET @currentVersion = (Select currentVersion FROM CurrentVersion)
	if @newVersion = @currentVersion or 1 > @newVersion or 7 < @newVersion
		RAISERROR('Not a valid version',10,1);
	else
	begin
		if @currentVersion < @newVersion
			begin
				begin
					while @currentVersion <= @newVersion
						set @queryToDo = (SELECT queryDo FROM VERSION WHERE currentVersion = @currentVersion)
						set @currentVersion = @currentVersion + 1
				
							
						exec (@queryToDo)
						UPDATE CurrentVersion SET currentVersion = @newVersion
					end
			
			end
		else
			while @currentVersion >= @newVersion 
					begin					
						set @queryToUndo = (SELECT queryUndo FROM VERSION WHERE currentVersion = @currentVersion)
						set @currentVersion = @currentVersion - 1
						
						exec (@queryToUndo)
						UPDATE CurrentVersion SET currentVersion = @newVersion
					end
	end
	
	
	
end
go

use Clinic2
EXEC USP_ChangeVersion6 1;
go


	




