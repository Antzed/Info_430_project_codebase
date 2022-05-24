--1) Stored procedure
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

-- Populate SHIP_FACILITY Table
CREATE PROCEDURE GetShipID
@SpN varchar(50),
@SpLaunch char(4),
@StName varchar(50),
@SpID INT OUTPUT
AS
SET @SpID = (SELECT S.ShipID 
FROM SHIP S
            JOIN SHIP_TYPE ST ON S.ShipTypeID = ST.ShipTypeID
WHERE S.ShipName = @SpN 
AND S.YearLaunch = @SpLaunch
AND ST.ShipTypeName = @StName)
GO 
--Look up table GetFacilityID
CREATE PROCEDURE GetFacilityID 
@FacName varchar(50),
@FacFee NUMERIC(8,2),
@FtName varchar(50),
@FacID INT OUTPUT 
AS
SET @FacID = (SELECT F.FacilityID 
FROM FACILITY F 
            JOIN FACILITY_TYPE FT ON F.FacilityTypeID = FT.FacilityTypeID
WHERE F.FacilityName = @FacName
AND FT.FacilityTypeName = @FtName)
GO
-- Insert SHIP_FACILITY Table
CREATE PROCEDURE PopShipFacility
@Ship varchar(50),
@ShipType varchar(50),
@FacType varchar(50),
@YrLaunch char(4),
@Facility varchar(50),
@FacFee Numeric(8,2)
AS
DECLARE @SP_ID INT, @FAC_ID INT

EXEC GetShipID
@SpN = @Ship,
@SpLaunch = @YrLaunch,
@StName = @ShipType,
@SpID = @SP_ID OUTPUT
IF @SP_ID IS NULL
    BEGIN
        PRINT ' @SP_ID is Null, check spelling';
        THROW 50014,'@SP_ID cannot be null; Process is terminating', 1;
    END
EXEC GetFacilityID 
@FacName = @Facility,
@FacFee = @FacFee,
@FtName = @FacType,
@FacID = @FAC_ID OUTPUT 
IF @FAC_ID IS NULL
    BEGIN
        PRINT ' @FAC_ID is Null, check spelling';
        THROW 50010,'@FAC_ID cannot be null; Process is terminating', 1;
    END
BEGIN TRANSACTION T1
INSERT INTO SHIP_FACILITY (ShipID, FacilityID)
VALUES(@SP_ID, @FAC_ID)
IF @@ERROR <> 0
BEGIN
PRINT '@@ERROR is showing an error somewhere...terminating process'
ROLLBACK TRANSACTION T1
END
ELSE
COMMIT TRANSACTION T1
GO
--Synthetic Transaction 
CREATE PROCEDURE group5WRAPPER_PopShipFacility
@RUN INT
AS 
DECLARE @ShipName varchar(50), @Lyear char(4), @Fty varchar(50), @Fee Numeric(8,2), @SpType varchar(50), @FType varchar(50)
DECLARE @ShipRowCount INT = (SELECT COUNT(*) FROM SHIP)
DECLARE @FacRowCount INT = (SELECT COUNT(*) FROM FACILITY)
DECLARE @ShipTypeRowCount INT = (SELECT COUNT(*) FROM SHIP_TYPE)
DECLARE @FacTypeRowCount INT = (SELECT COUNT(*) FROM FACILITY_TYPE)
DECLARE @ST_ID INT, @Fty_ID INT, @SType_ID INT, @FType_ID INT
WHILE @RUN > 0
BEGIN
SET @ST_ID = (SELECT RAND() * @ShipRowCount +1)
SET @Fty_ID = (SELECT RAND() * @FacRowCount + 1)
SET @SType_ID = (SELECT RAND() * @ShipTypeRowCount + 1)
SET @FType_ID = (SELECT RAND() * @FacTypeRowCount + 1)
SET @ShipName = (SELECT ShipName FROM SHIP WHERE ShipID = @ST_ID)
SET @SpType = (SELECT ShipTypeName FROM SHIP_TYPE WHERE ShipTypeID = @SType_ID)
SET @FType = (SELECT FacilityTypeName FROM FACILITY_TYPE WHERE FacilityTypeID = @FType_ID)
SET @Lyear = (SELECT YearLaunch FROM SHIP WHERE ShipID = @ST_ID)
SET @Fty = (SELECT FacilityName FROM FACILITY WHERE FacilityID = @Fty_ID)
SET @Fee = (SELECT RAND() * 1000 + 1)

EXEC PopShipFacility
@Ship = @ShipName,
@ShipType = @SpType,
@FacType = @FType,
@YrLaunch = @Lyear,
@Facility = @Fty,
@FacFee = @Fee

SET @RUN = @RUN - 1
END 
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
            JOIN CABIN_SHIP CP ON S.ShipID = CP.ShipID
            JOIN CABIN C ON CP.CabinID = C.CabinID
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
            JOIN CABIN_SHIP CP ON S.ShipID = CP.ShipID
            JOIN CABIN C ON CP.CabinID = C.CabinID
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
                        JOIN CABIN_SHIP CP ON C.CabinID = CP.CabinID
                        JOIN SHIP S ON CP.ShipID = S.ShipID   
                    WHERE B.BookDateTime > DATEADD(YEAR, -5, GETDATE())
                    AND S.ShipID = @PK)
RETURN @RET
END
GO

ALTER TABLE SHIP
ADD Calc_TotalPassengers_ShipPast5 AS (dbo.Calc_ShipPassengerPast5(ShipID))

-- Calculate the Average Rating for each Ship in the past 3 years
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
                        JOIN CABIN_SHIP CP ON C.CabinID = CP.CabinID
                        JOIN SHIP S ON CP.ShipID = S.ShipID    
                    WHERE B.BookDateTime > DATEADD(YEAR, -3, GETDATE())
                    AND S.ShipID = @PK)
RETURN @RET
END
GO

ALTER TABLE SHIP 
ADD Calc_AvgShipRating5 AS (dbo.Calc_AvgRatingShip5(ShipID))

-- 4) Views
-- Total number of Passengers on each Ship embarking in the city of Seattle
-- that has at least 10 reviews in the past 2 years for each ship 
CREATE VIEW ShipName_NumPassenger
AS 
SELECT P.PassengerFname, P.PassengerLname, S.ShipID, S.ShipName, T.TripBeginDate, COUNT(P.PassengerID) AS NumPassengers
FROM PASSENGER P 
    JOIN BOOKING B ON P.PassengerID = B.PassengerID
    JOIN BOOK_CABIN BC ON B.BookingID = BC.BookingID
    JOIN CABIN C ON BC.CabinID = C.CabinID
    JOIN CABIN_SHIP CP ON C.CabinID = CP.CabinID
    JOIN SHIP S ON CP.ShipID = S.ShipID    
    JOIN TRIP T ON B.TripID = T.TripID 
    JOIN PORT PT ON T.EmbarkPortID = PT.PortID
    JOIN CITY CT ON PT.CityID = CT.CityID 
WHERE C.CityName = 'Seattle'
GROUP BY P.PassengerFname, P.PassengerLname, S.ShipName, T.TripBeginDate
ORDER BY NumPassengers

CREATE VIEW ShipReviews_Past2
AS 
SELECT S.ShipID, S.ShipName, R.ReviewDate, COUNT(R.ReviewID) AS TotalNumReviews
FROM SHIP S 
    JOIN CABIN_SHIP CP ON C.ShipID = CP.ShipID
    JOIN CABIN C ON CP.CabinID = C.CabinID
    JOIN BOOK_CABIN BC ON C.CabinID = BC.CabinID
    JOIN BOOKING B ON BC.BookingID = B.BookingID
    JOIN REVIEW R ON B.BookingID = R.BookingID
WHERE R.ReviewDate > DATEADD(YEAR, -2, GETDATE())
GROUP BY S.ShipID, S.ShipName, R.ReviewDate
HAVING COUNT(R.ReviewID) >= 10

SELECT * FROM ShipName_NumPassenger A 
JOIN ShipReviews_Past2 B ON A.ShipID = B.ShipID

--Total number of Ships for each Route with a duration of 14 days
-- that the average rating of all bookings from 2017 to 2019 is above 3.5
CREATE VIEW TotalShips_Route
AS 
SELECT S.ShipID, S.ShipName, S.YearLaunch, S.Tonnage, S.Capacity, S.CabinCount, R.RouteName, COUNT(S.ShipID) AS TotalNumShips
FROM SHIP S 
    JOIN CABIN_SHIP CP ON C.ShipID = CP.ShipID
    JOIN CABIN C ON CP.CabinID = C.CabinID
    JOIN BOOK_CABIN BC ON C.CabinID = BC.CabinID
    JOIN BOOKING B ON BC.BookingID = B.BookingID
    JOIN TRIP T ON B.TripID = T.TripID
    JOIN ROUTES R ON T.RouteID = R.RouteID 
WHERE T.Duration = 14
GROUP BY S.ShipName, S.YearLaunch, S.Tonnage, S.Capacity, S.CabinCount, R.RouteName
ORDER BY TotalNumShips

CREATE VIEW AvgRating_Over2yrs
AS
SELECT S.ShipID, S.ShipName, R.ReviewDate, AVG(RA.RatingNum) AS AvgRating_Over2yrs
FROM SHIP S 
    JOIN CABIN_SHIP CP ON C.ShipID = CP.ShipID
    JOIN CABIN C ON CP.CabinID = C.CabinID
    JOIN BOOK_CABIN BC ON C.CabinID = BC.CabinID
    JOIN BOOKING B ON BC.BookingID = B.BookingID
    JOIN REVIEW R ON B.BookingID = R.BookingID
    JOIN RATING RA ON R.RatingID = RA.RatingID
WHERE YEAR(B.BookDateTime) BETWEEN 2017 AND 2019
GROUP BY S.ShipID, S.ShipName, R.ReviewDate
HAVING AVG(RA.RatingNum) > 3.5

SELECT * FROM TotalShips_Route A 
JOIN AvgRating_Over2yrs B ON A.ShipID = B.ShipID
