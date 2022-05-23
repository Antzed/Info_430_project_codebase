--1) Stored procedure
--Populate FACILITY Table; Create Procedure look up GetFacilityTypeID first
CREATE PROCEDURE GetFacilityTypeID 
@FtType varchar(50),
@FtID INT OUTPUT
AS 
SET @FtID = (SELECT FacilityTypeID FROM FACILITY_TYPE WHERE FacilityTypeName = @FtType)
GO

CREATE PROCEDURE InsertFacility 
@FtName varchar(50),
@FtDescr varchar(225),
@FacName varchar(50),
@FacDesc varchar(225),
@FacFee numeric(8,2)
AS 
DECLARE @FT_ID INT

EXEC GetFacilityTypeID 
@FtType = @FtName,
@FtID = @FT_ID OUTPUT 

IF @FT_ID IS NULL
    BEGIN
        PRINT '@FT_ID is Null, check spelling';
        THROW 50002,'@FT_ID cannot be null; Process is terminating', 1;
    END
BEGIN TRANSACTION T1
INSERT INTO FACILITY (FacilityTypeID, FacilityName, FacilityDescr, FacilityFee)
VALUES(@FT_ID, @FacName, @FacDesc, @FacFee)
IF @@ERROR <> 0
	BEGIN
		PRINT '@@ERROR is showing an error somewhere...terminating process'
		ROLLBACK TRANSACTION T1
	END
ELSE
	COMMIT TRANSACTION T1
GO


-- Populate SHIP Table
CREATE PROCEDURE GetShipTypeID
@StName varchar(50),
@StID INT OUTPUT
AS 
SET @StID = (SELECT ShipTypeID FROM SHIP_TYPE WHERE ShipTypeName = @StName)
GO

CREATE PROCEDURE InsertShip
@SpName varchar(50),
@SpDescr varchar(225),
@Cabin NUMERIC(8,2),
@YearL char(4),
@Ton Numeric(8,2),
@Cap Numeric(8,2),
@ShipType varchar(50)
AS
DECLARE @ST_ID INT

EXEC GetShipTypeID
@StName = @ShipType,
@StID = @ST_ID OUTPUT

IF @ST_ID IS NULL
    BEGIN
        PRINT '@ST_ID IS NULL, check spelling';
        THROW 50004, '@ST_ID cannot be null; process is terminating',1;
    END 

BEGIN TRANSACTION T1
INSERT INTO SHIP(ShipTypeID, ShipName, ShipDescr, CabinCount, YearLaunch, Tonnage, Capacity)
VALUES(@ST_ID, @SpName, @SpDescr, @Cabin, @YearL, @Ton, @Cap)
IF @@ERROR <> 0
	BEGIN
		PRINT '@@ERROR is showing an error somewhere...terminating process'
		ROLLBACK TRANSACTION T1
	END
ELSE
	COMMIT TRANSACTION T1
GO

-- 2) Check constraint
-- No ship launched less than 3 years can have a FacilityName 'Slot Machine' and passangers younger than 6 years old
CREATE FUNCTION fn_NoShipUnder3Years()
RETURNS INT 
AS
BEGIN
DECLARE @RET INT = 0
IF EXISTS (SELECT * FROM SHIP S
            JOIN SHIP_FACILITY SF ON S.ShipID = SF.ShipID
            JOIN FACILITY F ON SF.FacilityID = F.FacilityID
            JOIN FACILITY_TYPE FT ON F.FacilityTypeID = FT.FacilityTypeID
            JOIN CABIN C ON S.ShipID = C.ShipID
            JOIN BOOK_CABIN BC ON C.CabinID = BC.CabinID
            JOIN BOOKING B ON BC.BookingID = B.BookingID
            JOIN PASSENGER P ON B.PassengerID = P.PassengerID
            WHERE S.YearLaunch > DATEADD(YEAR, -3, GETDATE())
            AND F.FacilityName = 'Slot Machine'
            AND P.PassengerDOB > DATEADD(YEAR, -6, GETDATE()))
SET @RET = 1
RETURN @RET
END 
GO 

ALTER TABLE SHIP WITH NOCHECK
ADD CONSTRAINT CK_ShipFacilityPassenger
CHECK (dbo.fn_NoShipUnder3Years() = 0)
GO

-- No Facility with a Facility Name 'Ice skating' can be on the ship that are launched more than 8 years with passengers over 80
CREATE FUNCTION fn_NoFacilitypShip8Age80()
RETURNS INT 
AS
BEGIN
DECLARE @RET INT = 0
IF EXISTS (SELECT * FROM FACILITY F 
            JOIN SHIP_FACILITY SF ON F.FacilityID = SF.FacilityID
            JOIN SHIP S ON SF.ShipID = S.ShipID 
            JOIN CABIN C ON S.ShipID = C.ShipID
            JOIN BOOK_CABIN BC ON C.CabinID = BC.CabinID
            JOIN BOOKING B ON BC.BookingID = B.BookingID
            JOIN PASSENGER P ON B.PassengerID = P.PassengerID
            WHERE F.FacilityName = 'Ice skating' 
            AND S.YearLaunch < DATEADD(YEAR, -8, GETDATE())
            AND P.PassengerDOB < DATEADD(YEAR, -80, GETDATE()))
            
SET @RET = 1
RETURN @RET
END 
GO 

ALTER TABLE SHIP_FACILITY WITH NOCHECK
ADD CONSTRAINT CK_ShipFacilityAge
CHECK (dbo.fn_NoFacilitypShip8Age80() = 0)
GO

-- 3) Computed column
-- Calculate the Number of Passengers for each Ship in the past 5 years
CREATE FUNCTION Calc_ShipPassengerPast5(@PK INT)
RETURNS NUMERIC(8,2)
AS 
BEGIN
DECLARE @RET NUMERIC(8,2) = (SELECT COUNT(P.PassengerID) 
                    FROM PASSENGER P 
                        JOIN BOOKING B ON P.PassengerID = B.PassengerID
                        JOIN BOOK_CABIN BC ON B.BookingID = BC.BookingID
                        JOIN CABIN C ON BC.CabinID = C.CabinID
                        JOIN SHIP S ON C.ShipID = S.ShipID   
                    WHERE B.BookDateTime > DATEADD(YEAR, -5, GETDATE())
                    AND S.ShipID = @PK)
RETURN @RET
END
GO

ALTER TABLE SHIP
ADD Calc_TotalPassengers_ShipPast5 AS (dbo.Calc_ShipPassengerPast5(ShipID))

-- Calculate the Average Rating for each Ship in the past 3 years
DROP FUNCTION Calc_AvgRatingShip10
CREATE FUNCTION Calc_AvgRatingShip5(@PK INT)
RETURNS NUMERIC(8,2)
AS 
BEGIN
DECLARE @RET NUMERIC(8,2) = (SELECT AVG(R.Rating) 
                    FROM RATING R
                        JOIN REVIEW RW ON R.RatingID = RW.RatingID
                        JOIN BOOKING B ON RW.BookingID = B.BookingID
                        JOIN BOOK_CABIN BC ON B.BookingID = BC.BookingID
                        JOIN CABIN C ON BC.CabinID = C.CabinID
                        JOIN SHIP S ON C.ShipID = S.ShipID          
                    WHERE B.BookDateTime > DATEADD(YEAR, -3, GETDATE())
                    AND S.ShipID = @PK)
RETURN @RET
END
GO

ALTER TABLE SHIP 
ADD Calc_AvgShipRating5 AS (dbo.Calc_AvgRatingShip5(ShipID))

-- 4) Views
-- Total number of Passengers on each Ship
CREATE VIEW ShipName_NumPassenger
AS 
SELECT P.PassengerFname, P.PassengerLname, S.ShipName, T.TripBeginDate, COUNT(P.PassengerID) AS NumPassengers
FROM PASSENGER P 
JOIN BOOKING B ON P.PassengerID = B.PassengerID
JOIN BOOK_CABIN BC ON B.BookingID = BC.BookingID
JOIN CABIN C ON BC.CabinID = C.CabinID 
JOIN SHIP S ON C.ShipID = S.ShipID
JOIN TRIP T ON B.TripID = T.TripID 
GROUP BY P.PassengerFname, P.PassengerLname, S.ShipName, T.TripBeginDate
GO 

--Total number of Ships for each Route
CREATE VIEW TotalShips_Route
AS 
SELECT S.ShipName, S.YearLaunch, S.Tonnage, S.Capacity, S.CabinCount, R.RouteName, COUNT(S.ShipID) AS TotalNumShips
FROM SHIP S 
JOIN CABIN C ON S.ShipID = C.ShipID
JOIN BOOK_CABIN BC ON C.CabinID = BC.CabinID
JOIN BOOKING B ON BC.BookingID = B.BookingID
JOIN TRIP T ON B.TripID = T.TripID
JOIN ROUTES R ON T.RouteID = R.RouteID 
GROUP BY S.ShipName, S.YearLaunch, S.Tonnage, S.Capacity, S.CabinCount, R.RouteName
GO 


SELECT * FROM TotalShips_Route

DROP VIEW TotalShips_Route
GO
















