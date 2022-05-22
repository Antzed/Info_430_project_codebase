--SELECT TOP 100 *
--FROM peeps.dbo.tblCUSTOMER

INSERT INTO PASSENGER_TYPE(PassengerTypeName)
VALUES('Adult'), ('Child'), ('Infant without a seat'), ('Infant with a seat'), ('Unaccompanied  child')

INSERT INTO MEMBERSHIP(MembershipName, MembershipDescr)
VALUES('Classic', 'default'), ('Silver', '1000 travel points'), ('Gold',  '10,000 travel points'), ('Diamond', '20,000 travel points'), ('Lifelong', '50,000 travel points')
GO


CREATE PROCEDURE GetPassengerTypeID
@PTNamey varchar(50),
@PTIDy INT OUTPUT
AS

SET @PTIDy = (SELECT PassengerTypeID FROM PASSENGER_TYPE WHERE PassengerTypeName = @PTNamey)
GO

CREATE PROCEDURE GetMemberShip
@MNamey varchar(50),
@MIDy INT OUTPUT
AS

SET @MIDy = (SELECT MembershipID FROM MEMBERSHIP WHERE MembershipName = @MNamey)
GO

CREATE PROCEDURE InsertPassenger
@PFname varchar(50),
@PLname varchar(50),
@PBirth date,
@PTName varchar(50),
@MName varchar(50)

AS

DECLARE @PT_ID INT, @M_ID INT

EXEC GetPassengerTypeID
@PTNamey = @PTName,
@PTIDy = @PT_ID OUTPUT

IF @PT_ID is null
	BEGIN
		PRINT '@PT_ID returns null, something is wrong with the data';
		THROW 55001, '@PT_ID cannot be null. Terminating the process', 1;
	END


EXEC GetMemberShip
@MNamey = @MName,
@MIDy = @M_ID OUTPUT

IF @M_ID is null
	BEGIN
		PRINT '@M_ID returns null, something is wrong with the data';
		THROW 55001, '@M_ID cannot be null. Terminating the process', 1;
	END

BEGIN TRANSACTION T1
INSERT INTO PASSENGER(PassengerTypeID, MembershipID, PassengerFname, PassengerLname, PassengerDOB)
VALUES (@PT_ID, @M_ID, @PFname, @PLname, @PBirth)
COMMIT TRANSACTION T1
GO

CREATE PROCEDURE Wraper_insert_passenger @RUN INT
AS

DECLARE @PF varchar(50), @PL varchar(50), @PBDay Date
DECLARE @PT_RowCount INT = (SELECT COUNT(*) FROM PASSENGER_TYPE)
DECLARE @M_RowCount INT = (SELECT COUNT(*) FROM MEMBERSHIP)
DECLARE @P_RowCount INT = (SELECT COUNT(*) FROM PASSENGER)
DECLARE @PT_PK INT
DECLARE @M_PK INT
DECLARE @P_PK INT

DECLARE @PTN varchar(50)
DECLARE @MN varchar(50)

WHILE @RUN > 0

BEGIN
SET @PT_PK = (SELECT RAND() * @PT_RowCount + 1)
SET @PTN = (SELECT PassengerTypeName FROM PASSENGER_TYPE WHERE PassengerTypeID = @PT_PK)

SET @M_PK = (SELECT RAND() * @M_RowCount + 1)
SET @MN = (SELECT MembershipName FROM MEMBERSHIP WHERE MembershipID = @M_PK)

SET @P_PK = (SELECT RAND() * @P_RowCount + 1)
SET @PF = (SELECT PassengerFname FROM PASSENGER WHERE PassengerID = @P_PK)
SET @PL = (SELECT PassengerLname FROM PASSENGER WHERE PassengerID = @P_PK)
SET @PBDay = (SELECT PassengerDOB FROM PASSENGER WHERE PassengerID = @P_PK)

EXEC InsertPassenger
@PFname = @PF,
@PLname  = @CL,
@PBirth = @PBDay,
@PTName = @PTN,
@MName = @MN

SET @RUN = @RUN -1
END