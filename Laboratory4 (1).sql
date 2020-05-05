USE Clinic2

GO
CREATE VIEW View_1
AS
SELECT        dbo.Doctor.[First Name], dbo.Doctor.[Last Name], dbo.Nurse.[First Name] AS Expr1, dbo.Nurse.[Last Name] AS Expr2
FROM            dbo.Doctor CROSS JOIN
                         dbo.Nurse
GO

CREATE VIEW View_2
AS
SELECT        *
FROM            dbo.Treatment
GO

CREATE VIEW View_3
AS
SELECT        dbo.Medicine.Name, dbo.Medicine.MedicineID
FROM            dbo.Medicine INNER JOIN
                         dbo.Treatment_Medicine ON dbo.Medicine.MedicineID = dbo.Treatment_Medicine.MedicineID INNER JOIN
                         dbo.Treatment ON dbo.Treatment_Medicine.TreatmentID = dbo.Treatment.TreatmentID AND dbo.Treatment_Medicine.TreatmentID = dbo.Treatment.TreatmentID
GROUP BY dbo.Medicine.Name, dbo.Medicine.MedicineID
GO

CREATE PROC select_view_1
AS
	SELECT * FROM View_1
GO
CREATE PROC select_view_2
AS
	SELECT * FROM View_2
GO
CREATE PROC select_view_3
AS
	SELECT * FROM View_3
GO


DELETE FROM Views
INSERT INTO Views VALUES ('View_1'), ('View_2'), ('View_3')

DELETE FROM Tables
INSERT INTO Tables VALUES ('Medicine'),('Treatment'), ('Treatment_Medicine')

DELETE FROM Tests
INSERT INTO Tests VALUES ('delete_table'),('insert_table'), ('select_view')

DELETE FROM TestViews
INSERT INTO TestViews VALUES (3, 1), (3, 2), (3, 3)

INSERT INTO TestTables VALUES (1, 1008, 100, 1), (1, 1009, 100, 2), (1, 1010, 100, 3)
GO
CREATE PROC insert_medicine2
AS
begin
	DECLARE @NoOFRows int
	DECLARE @MID tinyint
	DECLARE @name VARCHAR(255)
	DECLARE @usage varchar(255)
	DECLARE @availabilty tinyint
	SELECT TOP 1 @NoOFRows = NoOfRows FROM TestTables WHERE TableID = 1008
	SET @MID = 1
	WHILE @MID < @NoOFRows
	begin
		SET @name = 'name' + CONVERT(VARCHAR(255), @MID)
		SET @usage = 'usage' + CONVERT(VARCHAR(255), @MID)
		SET @availabilty = 30
		INSERT INTO Medicine(MedicineID, Name, Usage, Availabilty) values (@MID, @name, @usage, @availabilty)
		SET @MID = @MID + 1
			
	end

end
GO

CREATE PROC insert_treatment1
AS
begin
	DECLARE @NoOFRows int
	DECLARE @TID tinyint
	DECLARE @MID tinyint
	DECLARE @name varchar(30)
	SELECT TOP 1 @NoOFRows = NoOfRows FROM TestTables WHERE TableID = 1009
	SELECT TOP 1 @MID = MedicineID FROM Medicine
	SET @TID = 1
	WHILE @TID < @NoOFRows
	begin
		SET @name = 'name' + CONVERT(VARCHAR(255), @TID)
		INSERT INTO Treatment(TreatmentID, MedicineID, Name) VALUES (@TID, @MID, @name)
		SET @TID = @TID + 1
	end

end
GO

CREATE PROC insert_treatment_medicine1
AS
begin
	DECLARE @NoOFRows int
	DECLARE @TID tinyint
	DECLARE @MID tinyint
	SELECT TOP 1 @NoOfRows = NoOfRows FROM TestTables WHERE TableID = 1010
	SELECT TOP 1 @MID = MedicineID FROM Medicine
	set @TID = 1
	while @TID < @NoOFRows
	begin
		INSERT INTO Treatment_Medicine(TreatmentID, MedicineID) VALUES (@TID, @MID)
		SET @TID = @TID + 1
	end

end
GO

CREATE PROC delete_medicine
AS
	DELETE Medicine
GO

CREATE PROC delete_treatment
AS
	DELETE Treatment
GO

CREATE PROC delete3
AS
	DELETE Treatment_Medicine
GO

CREATE PROC TestRunTables_1
AS
	DECLARE @ds DATETIME
	DECLARE @de DATETIME
	DECLARE @id1 int
	SELECT @id1 = TableID FROM Tables WHERE Name = 'Medicine'
	SET @ds = GETDATE()
	EXEC delete_medicine
	SET @de = GETDATE()
	INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('delete_medicine', @ds, @de)
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@@IDENTITY, @id1, @ds, @de)
	SET @ds = GETDATE()
	EXEC insert_medicine2
	SET @de = GETDATE()
	INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('insert_medicine', @ds, @de)
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@@IDENTITY, @id1, @ds, @de)
GO


CREATE PROC TestRunTables_2
AS
	DECLARE @ds DATETIME
	DECLARE @de DATETIME
	SET @ds = GETDATE()
	DECLARE @id1 int
	SELECT @id1 = TableID FROM Tables WHERE Name = 'Treatment'
	EXEC delete_treatment
	SET @de = GETDATE()
	INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('delete_treatment', @ds, @de)
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@@IDENTITY, @id1, @ds, @de)
	SET @ds = GETDATE()
	EXEC dbo.insert_treatment1
	SET @de = GETDATE()
	INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('insert_treatment', @ds, @de)
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@@IDENTITY, @id1, @ds, @de)

GO

CREATE PROC TestRunTables_3
AS
	DECLARE @ds DATETIME
	DECLARE @de DATETIME
	DECLARE @desc VARCHAR(30)
	DECLARE @id1 int
	SELECT @id1 = TableID FROM Tables WHERE Name = 'Treatment_Medicine'
	SET @ds = GETDATE()
	EXEC delete_treatment_medicine
	SET @de = GETDATE()
	INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('delete_treatment_medicine', @ds, @de)
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@@IDENTITY, @id1, @ds, @de)
	SET @ds = GETDATE()
	EXEC insert_treatment_medicine1
	SET @de = GETDATE()
	INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('insert_treatment_medicine', @ds, @de)
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@@IDENTITY, @id1, @ds, @de)

GO

CREATE PROC TestRunView_1
AS
	DECLARE @ds DATETIME
	DECLARE @de DATETIME
	DECLARE @id1 int
	SELECT @id1 = ViewID FROM Views WHERE Name = 'View_1'
	SET @ds = GETDATE()
	EXEC select_view_1
	SET @de = GETDATE()
	INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('select1', @ds, @de)
	INSERT INTO TestRunViews(TestRunID, ViewID, StartAt,EndAt) VALUES (@@IDENTITY, @id1, @ds, @de)
GO

CREATE PROC TestRunView_2
AS
	DECLARE @ds DATETIME
	DECLARE @de DATETIME
	DECLARE @id1 int
	SELECT @id1 = ViewID FROM Views WHERE Name = 'View_2'
	SET @ds = GETDATE()
	EXEC select_view_2
	SET @de = GETDATE()
	INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('select2', @ds, @de)
	INSERT INTO TestRunViews(TestRunID, ViewID, StartAt,EndAt) VALUES (@@IDENTITY, @id1, @ds, @de)
GO

CREATE PROC TestRunView_3
AS
	DECLARE @ds DATETIME
	DECLARE @de DATETIME
	SET @ds = GETDATE()
	DECLARE @id1 int
	SELECT @id1 = ViewID FROM Views WHERE Name = 'View_3'
	EXEC select_view_3
	SET @de = GETDATE()
	INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('select3', @ds, @de)
	INSERT INTO TestRunViews(TestRunID, ViewID, StartAt,EndAt) VALUES (@@IDENTITY, @id1, @ds, @de)
GO

CREATE PROC Test_delete
AS
	DECLARE @position int
	DECLARE @procedure varchar(100)
	SELECT @position = Position
	FROM TestTables
	set @procedure = 'delete' + CONVERT(VARCHAR(30), @position)
	exec @procedure
	

GO

CREATE PROC Test_main @param int
AS
	DECLARE @ds DATETIME
	DECLARE @de DATETIME
	SET @ds = GETDATE()
	SET @de  = GETDATE()
	DECLARE @procedure VARCHAR(255)
	SET @procedure = 'TestRunTables_' + CONVERT(VARCHAR(255), @param)
	EXEC @procedure
	SET @procedure = 'TestRunView_' + CONVERT(VARCHAR(255), @param)
	EXEC @procedure
GO

EXEC delete_treatment_medicine
EXEC delete_treatment
EXEC delete_medicine
delete from TestRunViews
delete from TestRuns
delete from TestRunTables
EXEC Test_main 1
EXEC Test_main 2
exec Test_main 3
