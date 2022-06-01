USE group5_INFO430 
GO
--Whitney Zhang
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

-- Populate SHIP_FACILITY Table
CREATE PROCEDURE GetShipID
@STypeName varchar(50),
@SpN varchar(50),
@SDescr varchar(225),
@CabinCount NUMERIC(5,2),
@Yr char(4),
@Tonnage NUMERIC(8,2),
@Capacity NUMERIC(8,2),
@SpID INT OUTPUT
AS
SET @SpID = (SELECT S.ShipID
    FROM SHIP S
           JOIN SHIP_TYPE ST ON S.ShipTypeID = ST.ShipTypeID
            WHERE S.ShipName = @SpN
            AND S.ShipDescr = @SDescr
            AND S.CabinCount = @CabinCount
            AND S.YearLaunch = @Yr
            AND S.Tonnage = @Tonnage
            AND S.Capacity = @Capacity
            AND ST.ShipTypeName = @STypeName)
GO
-- Populate Facility table
CREATE PROCEDURE GetFacilityID
@FacName varchar(50),
@FDescr varchar(225),
@FacFee NUMERIC(8,2),
@FtName varchar(50),
@FacID INT OUTPUT
AS
SET @FacID = (SELECT F.FacilityID
FROM FACILITY F
           JOIN FACILITY_TYPE FT ON F.FacilityTypeID = FT.FacilityTypeID
            WHERE F.FacilityName = @FacName
            AND F.FacilityDescr = @FDescr
            AND FT.FacilityTypeName = @FtName)
GO

-- Insert SHIP_FACILITY Table
CREATE PROCEDURE PopShipFacility
@Ship varchar(50),
@ShipDescr varchar(225),
@Cabin Numeric(5,2),
@Y char(4),
@Ton Numeric(8,2),
@Cap Numeric(8,2),
@ShipType varchar(50),
@FacType varchar(50),
@Facility varchar(50),
@FtFee Numeric(8,2),
@Fdescr varchar(225)
AS
DECLARE @SP_ID INT, @FAC_ID INT
 
EXEC GetShipID
@STypeName = @ShipType,
@SpN = @Ship,
@SDescr = @ShipDescr,
@CabinCount = @Cabin,
@Yr = @Y,
@Tonnage = @Ton,
@Capacity = @Cap,
@SpID = @SP_ID OUTPUT
IF @SP_ID IS NULL
   BEGIN
       PRINT ' @SP_ID is Null, check spelling';
       THROW 50014,'@SP_ID cannot be null; Process is terminating', 1;
   END

EXEC GetFacilityID
@FacName = @Facility,
@FDescr = @Fdescr,
@FacFee = @FtFee,
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
ALTER PROCEDURE group5WRAPPER_PopShipFacility
@RUN INT
AS 
DECLARE @ShipName varchar(50), @SDescr varchar(225), @Cab NUMERIC(5,2), @Tonnage NUMERIC(8,2), @SCap NUMERIC(8,2),
@Lyear char(4), @Fty varchar(50), @Fee Numeric(8,2), @SpType varchar(50), @FType varchar(50), @FacDescr varchar(225)

DECLARE @ShipRowCount INT = (SELECT COUNT(*) FROM SHIP)
DECLARE @FacRowCount INT = (SELECT COUNT(*) FROM FACILITY)
DECLARE @ST_ID INT, @Fty_ID INT

WHILE @RUN > 0
BEGIN
    SET @ST_ID = (SELECT RAND() * @ShipRowCount +1)
    SET @Fty_ID = (SELECT RAND() * @FacRowCount + 1)
        IF @Fty_ID =  12 
        BEGIN
            SET @Fty_ID = 6
        END 
        IF @Fty_ID =  15 
        BEGIN
            SET @Fty_ID = 6
        END 

    SET @ShipName = (SELECT ShipName FROM SHIP WHERE ShipID = @ST_ID)
    SET @SDescr = (SELECT ShipDescr FROM SHIP WHERE ShipID = @ST_ID)
    SET  @Cab = (SELECT CabinCount FROM SHIP WHERE ShipID = @ST_ID)
    SET @Tonnage = (SELECT Tonnage FROM SHIP WHERE ShipID = @ST_ID)
    SET @SCap = (SELECT Capacity FROM SHIP WHERE ShipID = @ST_ID)
    SET @Lyear = (SELECT YearLaunch FROM SHIP WHERE ShipID = @ST_ID)
    SET @FacDescr = (SELECT FacilityDescr FROM FACILITY WHERE FacilityID = @Fty_ID)
    SET @SpType = (SELECT ShipTypeName FROM SHIP S JOIN SHIP_TYPE ST ON S.ShipTypeID = ST.ShipTypeID
                    WHERE ShipID = @ST_ID)
    SET @FType = (SELECT FacilityTypeName FROM FACILITY F
                    JOIN FACILITY_TYPE FT ON  F.FacilityTypeID = FT.FacilityTypeID 
                    WHERE FacilityID = @Fty_ID)
    SET @Fty = (SELECT FacilityName FROM FACILITY WHERE FacilityID = @Fty_ID)
    SET @Fee = (SELECT FacilityFee FROM FACILITY WHERE FacilityID = @Fty_ID)

EXEC PopShipFacility
@Ship = @ShipName,
@ShipDescr = @SDescr,
@Cabin = @Cab,
@Y = @Lyear,
@Ton = @Tonnage,
@Cap = @SCap,
@ShipType = @SpType,
@FacType = @FType,
@Facility = @Fty,
@FtFee = @Fee,
@Fdescr = @FacDescr

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
CREATE FUNCTION Calc_ShipPassengerPast5s(@PK INT)
RETURNS INT
AS 
BEGIN
DECLARE @RET INT = (SELECT COUNT(P.PassengerID) 
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
ADD Calc_TotalPassengers_ShipPast5s AS (dbo.Calc_ShipPassengerPast5s(ShipID))
GO

-- Calculate the Average Rating for each Ship in the past 3 years
CREATE FUNCTION Calc_AvgRatingShip5(@PK INT)
RETURNS NUMERIC(8,2)
AS 
BEGIN
DECLARE @RET NUMERIC(8,2) = (SELECT AVG(R.RatingNum) 
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
GO

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
WHERE CT.CityName = 'Seattle'
GROUP BY P.PassengerFname, P.PassengerLname, S.ShipID, S.ShipName, T.TripBeginDate
GO

CREATE VIEW ShipReviews_Past2
AS 
SELECT S.ShipID, S.ShipName, R.ReviewDate, COUNT(R.ReviewID) AS TotalNumReviews
FROM SHIP S 
    JOIN CABIN_SHIP CP ON S.ShipID = CP.ShipID
    JOIN CABIN C ON CP.CabinID = C.CabinID
    JOIN BOOK_CABIN BC ON C.CabinID = BC.CabinID
    JOIN BOOKING B ON BC.BookingID = B.BookingID
    JOIN REVIEW R ON B.BookingID = R.BookingID
WHERE R.ReviewDate > DATEADD(YEAR, -2, GETDATE())
GROUP BY S.ShipID, S.ShipName, R.ReviewDate
HAVING COUNT(R.ReviewID) >= 10
GO
SELECT * FROM ShipName_NumPassenger A 
JOIN ShipReviews_Past2 B ON A.ShipID = B.ShipID
GO
--Total number of Ships for each Route with a duration of 14 days
-- that the average rating in the 75th percentile of all bookings from 2017 to 2019
CREATE VIEW TotalShips_Route
AS 
SELECT S.ShipID, S.ShipName, S.YearLaunch, S.Tonnage, S.Capacity, S.CabinCount, R.RouteName, COUNT(S.ShipID) AS TotalNumShips
FROM SHIP S 
    JOIN CABIN_SHIP CP ON S.ShipID = CP.ShipID
    JOIN CABIN C ON CP.CabinID = C.CabinID
    JOIN BOOK_CABIN BC ON C.CabinID = BC.CabinID
    JOIN BOOKING B ON BC.BookingID = B.BookingID
    JOIN TRIP T ON B.TripID = T.TripID
    JOIN ROUTES R ON T.RouteID = R.RouteID 
WHERE T.Duration = 14
GROUP BY S.ShipID, S.ShipName, S.YearLaunch, S.Tonnage, S.Capacity, S.CabinCount, R.RouteName
GO

CREATE VIEW AvgRating_Over2yrs_75th
AS
SELECT S.ShipID, S.ShipName, R.ReviewDate, AVG(RA.RatingNum) AS AvgRating_Over2yrs, 
        NTILE (100) OVER (ORDER BY AVG(RA.RatingNum)) AS NtileAvgRating
FROM SHIP S 
    JOIN CABIN_SHIP CP ON S.ShipID = CP.ShipID
    JOIN CABIN C ON CP.CabinID = C.CabinID
    JOIN BOOK_CABIN BC ON C.CabinID = BC.CabinID
    JOIN BOOKING B ON BC.BookingID = B.BookingID
    JOIN REVIEW R ON B.BookingID = R.BookingID
    JOIN RATING RA ON R.RatingID = RA.RatingID
WHERE YEAR(B.BookDateTime) BETWEEN 2017 AND 2019
GROUP BY S.ShipID, S.ShipName, R.ReviewDate
HAVING AVG(RA.RatingNum) > 3.5
GO 

SELECT * FROM TotalShips_Route A 
JOIN AvgRating_Over2yrs_75th B ON A.ShipID = B.ShipID
WHERE NtileAvgRating = 75
GO

-- Joy
-- 1) Stored procedure
-- Use synthetic transaction to insert Trip_Crew table
CREATE PROCEDURE getCrewID
@Fname varchar(50),
@Lname varchar(50),
@DOB date,
@CrewID INT OUTPUT
AS 
SET @CrewID = (SELECT CrewID 
    FROM CREW 
    WHERE CrewFname = @Fname AND CrewLname = @Lname AND CrewDOB = @DOB)
GO

CREATE PROCEDURE getRoleID
@Name varchar(50),
@Descr varchar(50),
@RoleID INT OUTPUT
AS
SET @RoleID = (SELECT RoleID FROM ROLES WHERE RoleName = @Name AND RoleDescr = @Descr)
GO

ALTER PROCEDURE getTripID
@RouteN VARCHAR(50),
@CountryName_E varchar(50),
@CityName_E VARCHAR(50),
@PortName_E varchar(50),
@CountryName_D varchar(50),
@CityName_D VARCHAR(50),
@PortName_D varchar(50),
@BeginDate date,
@Durations INT,
@TripID INT OUTPUT
AS
SET @TripID = (SELECT TripID FROM TRIP T JOIN ROUTES R ON T.RouteID = R.RouteID
    JOIN PORT PE ON T.EmbarkPortID = PE.PortID
    JOIN CITY CE ON PE.CityID = CE.CityID
    JOIN COUNTRY COE ON CE.CountryID = COE.CountryID
    JOIN PORT P ON T.DisembarkPortID = P.PortID
    JOIN CITY C ON P.CityID = C.CityID
    JOIN COUNTRY CO ON C.CountryID = CO.CountryID
    WHERE R.RouteName = @RouteN AND COE.CountryName = @CountryName_E
        AND CE.CityName = @CityName_E AND PE.PortName = @PortName_E
        AND CO.CountryName = @CountryName_D
        AND C.CityName = @CityName_D AND P.PortName = @PortName_D
        AND T.TripBeginDate = @BeginDate AND T.Duration = @Durations)
GO

ALTER PROCEDURE insertTRIP_CREW
@RouteNP VARCHAR(50),
@CountryName_EP varchar(50),
@CityName_EP VARCHAR(50),
@PortName_EP varchar(50),
@CountryName_DP varchar(50),
@CityName_DP VARCHAR(50),
@PortName_DP varchar(50),
@BeginDateP date,
@DurationsP int,
@FnameP varchar(50),
@LnameP varchar(50),
@DOBP date,
@ROLEName varchar(50),
@ROLEDescr varchar(50)
AS
DECLARE @TRIP_ID INT, @CREW_ID INT, @ROLE_ID INT

EXEC getTripID
@RouteN = @RouteNP,
@CountryName_E = @CountryName_EP,
@CityName_E = @CityName_EP,
@PortName_E = @PortName_EP,
@CountryName_D = @CountryName_DP,
@CityName_D = @CityName_DP,
@PortName_D = @PortName_DP,
@BeginDate = @BeginDateP,
@Durations = @DurationsP,
@TripID = @TRIP_ID OUTPUT

IF @TRIP_ID IS NULL
    BEGIN
        PRINT 'Trip ID is null';
        THROW 55143, '@TRIP_ID IS NULL', 1;
    END

EXEC getCrewID
@Fname = @FnameP,
@Lname = @LnameP,
@DOB = @DOBP,
@CrewID = @CREW_ID OUTPUT

IF @CREW_ID IS NULL
    BEGIN
        PRINT 'Crew ID is null';
        THROW 55143, '@CREW_ID IS NULL', 1;
    END

EXEC getRoleID
@Name = @ROLEName,
@Descr = @ROLEDescr,
@RoleID = @ROLE_ID OUTPUT

IF @ROLE_ID IS NULL
    BEGIN
        PRINT 'Role ID is null';
        THROW 55143, '@ROLE_ID IS NULL', 1;
    END

BEGIN TRAN T1
INSERT INTO TRIP_CREW(TripID, CrewID, RoleID)
VALUES(@TRIP_ID, @CREW_ID, @ROLE_ID)
COMMIT TRAN T1
GO


ALTER PROCEDURE populateTripCrew
@RUN INT
AS
DECLARE
@RouteN VARCHAR(50),
@CountryName_E varchar(50),
@CityName_E VARCHAR(50),
@PortName_E varchar(50),
@CountryName_D varchar(50),
@CityName_D VARCHAR(50),
@PortName_D varchar(50),
@BeginDate date,
@Durations int,
@Fname varchar(50),
@Lname varchar(50),
@DOB date,
@ROLENamey varchar(50),
@ROLEDescry varchar(50),
@R_PK INT,
@C_PK INT,
@T_PK INT,
@RoleRowCount INT = (SELECT COUNT(*) FROM ROLES),
@CrewRowCount INT = (SELECT COUNT(*) FROM CREW),
@TripRowCount INT = (SELECT COUNT(*) FROM TRIP)

WHILE @RUN > 0
BEGIN
    SET @R_PK = (SELECT RAND() * @RoleRowCount + 1)
    SET @C_PK = (SELECT RAND() * @CrewRowCount + 1)
    SET @T_PK = (SELECT RAND() * @TripRowCount + 1)
    SET @RouteN = (SELECT RouteName FROM ROUTES R JOIN TRIP T ON R.RouteID = T.RouteID WHERE TripID = @T_PK)
    SET @CountryName_E = (SELECT CountryName FROM TRIP T JOIN PORT P ON T.EmbarkPortID = P.PortID JOIN CITY C ON P.CityID = C.CityID
        JOIN COUNTRY CO ON C.CountryID = CO.CountryID
        WHERE TripID = @T_PK)
    SET @CityName_E = (SELECT CityName FROM TRIP T JOIN PORT P ON T.EmbarkPortID = P.PortID JOIN CITY C ON P.CityID = C.CityID
        WHERE TripID = @T_PK)
    SET @PortName_E = (SELECT PortName from TRIP T JOIN PORT P ON T.EmbarkPortID = P.PortID WHERE TripID = @T_PK)
    SET @CountryName_D = (SELECT CountryName FROM Trip T JOIN PORT P ON T.DisembarkPortID = P.PortID JOIN CITY C ON P.CityID = C.CityID
        JOIN COUNTRY CO ON C.CountryID = CO.CountryID
        WHERE TripID = @T_PK)
    SET @CityName_D = (SELECT CityName FROM TRIP T JOIN PORT P ON T.DisembarkPortID = P.PortID JOIN CITY C ON P.CityID = C.CityID
        WHERE TripID = @T_PK)
    SET @PortName_D = (SELECT PortName FROM TRIP T JOIN PORT P ON T.DisembarkPortID = P.PortID WHERE TripID = @T_PK)
    SET @BeginDate = (SELECT TripBeginDate FROM TRIP WHERE TripID = @T_PK)
    SET @Durations = (SELECT Duration FROM TRIP WHERE TripID = @T_PK)
    SET @Fname = (SELECT CrewFName FROM CREW WHERE CrewID = @C_PK)
    SET @Lname = (SELECT CrewLName FROM CREW WHERE CrewID = @C_PK)
    SET @DOB = (SELECT CrewDOB FROM CREW WHERE CrewID = @C_PK)
    SET @ROLENamey = (SELECT RoleName FROM ROLES WHERE RoleID = @R_PK)
    SET @ROLEDescry = (SELECT RoleDescr FROM ROLES WHERE RoleID = @R_PK)

    EXEC insertTRIP_CREW
    @RouteNP = @RouteN,
    @CountryName_EP = @CountryName_E,
    @CityName_EP = @CityName_E,
    @PortName_EP = @PortName_E,
    @CountryName_DP = @CountryName_D,
    @CityName_DP = @CityName_D,
    @PortName_DP = @PortName_D,
    @BeginDateP = @BeginDate,
    @DurationsP = @Durations,
    @FnameP = @Fname,
    @LnameP = @Lname,
    @DOBP = @DOB,
    @ROLEName = @ROLENamey,
    @ROLEDescr = @ROLEDescry

    SET @RUN = @RUN - 1
END
GO

populateTripCrew 500000
GO

-- Use synthetic transaction to insert Trip table
CREATE PROCEDURE getRouteID
@RName varchar(50),
@RDescr varchar(50),
@RouteID INT OUTPUT 
AS
SET @RouteID = (SELECT RouteID FROM ROUTES WHERE RouteName = @RName AND RouteDescr = @RDescr)
GO 

CREATE PROCEDURE getPortID
@CountryN varchar(50),
@CityN VARCHAR(50),
@PortN VARCHAR(50),
@PortID INT OUTPUT
AS 
SET @PortID = (SELECT PortID FROM PORT P JOIN CITY C ON P.CityID = C.CityID JOIN COUNTRY CO ON C.CountryID = CO.CountryID
    WHERE CO.CountryName = @CountryN AND C.CityName = @CityN AND P.PortName = @PortN)
GO

CREATE PROCEDURE populateTrip
@RouteN VARCHAR(50),
@RouteD VARCHAR(50),
@CountryName_E varchar(50),
@CityName_E VARCHAR(50),
@PortName_E varchar(50),
@CountryName_D varchar(50),
@CityName_D VARCHAR(50),
@PortName_D varchar(50),
@Begin date,
@Duration INT
AS 
DECLARE @Route_ID INT, @PortE_ID INT, @PortD_ID INT

EXEC getRouteID
@RName = @RouteN,
@RDescr = @RouteD,
@RouteID = @Route_ID OUTPUT

IF @Route_ID IS NULL
    BEGIN
        PRINT 'Route ID is null';
        THROW 55628, '@Route_ID IS NULL', 1;
    END

EXEC getPortID
@CountryN = @CountryName_E,
@CityN = @CityName_E,
@PortN = @PortName_E,
@PortID = @PortE_ID OUTPUT

IF @PortE_ID IS NULL
    BEGIN
        PRINT 'Embark Port ID is null';
        THROW 55143, '@PortE_ID IS NULL', 1;
    END

EXEC getPortID
@CountryN = @CountryName_D,
@CityN = @CityName_D,
@PortN = @PortName_D,
@PortID = @PortD_ID OUTPUT

IF @PortD_ID IS NULL
    BEGIN
        PRINT 'Disembark Port ID is null';
        THROW 55143, '@PortD_ID IS NULL', 1;
    END

BEGIN TRAN T1
INSERT INTO TRIP(RouteID, EmbarkPortID, DisembarkPortID, TripBeginDate, Duration)
VALUES(@Route_ID, @PortE_ID, @PortD_ID, @Begin, @Duration)
COMMIT TRAN T1
GO

ALTER PROCEDURE wraperPopTrip
@RUN INT
AS
DECLARE @RouteName VARCHAR(50),
@RouteDescr VARCHAR(50),
@CountryName_Em varchar(50),
@CityName_Em VARCHAR(50),
@PortName_Em varchar(50),
@CountryName_Di varchar(50),
@CityName_Di VARCHAR(50),
@PortName_Di varchar(50),
@BeginDate date,
@Durations INT,
@R_PK INT,
@E_PK INT,
@D_PK INT,
@RouteRowCount INT = (SELECT COUNT(*) FROM ROUTES),
@PortRowCount INT = (SELECT COUNT(*) FROM PORT)

WHILE @RUN > 0
BEGIN
    SET @R_PK = (SELECT RAND() * @RouteRowCount + 1)
    SET @E_PK = (SELECT RAND() * @PortRowCount + 1)
    SET @D_PK = (SELECT RAND() * @PortRowCount + 1)
    SET @RouteName = (SELECT RouteName FROM ROUTES WHERE RouteID = @R_PK)
    SET @RouteDescr = (SELECT RouteDescr FROM ROUTES WHERE RouteID = @R_PK)
    SET @CountryName_Em = (SELECT TOP 1 CountryName FROM PORT P JOIN CITY C ON P.CityID = C.CityID
        JOIN COUNTRY CO ON C.CountryID = CO.CountryID
        WHERE P.PortID = @E_PK)
    SET @CityName_Em = (SELECT TOP 1 CityName FROM PORT P JOIN CITY C ON P.CityID = C.CityID
        WHERE P.PortID = @E_PK)
    SET @PortName_Em = (SELECT TOP 1 PortName from PORT WHERE PortID = @E_PK)
    SET @CountryName_Di = (SELECT TOP 1 CountryName FROM PORT P JOIN CITY C ON P.CityID = C.CityID
        JOIN COUNTRY CO ON C.CountryID = CO.CountryID
        WHERE P.PortID = @D_PK)
    SET @CityName_Di = (SELECT TOP 1 CityName FROM PORT P JOIN CITY C ON P.CityID = C.CityID
        WHERE P.PortID = @D_PK)
    SET @PortName_Di = (SELECT TOP 1 PortName from PORT WHERE PortID = @D_PK)
    SET @BeginDate = (SELECT GetDate() - (RAND() * 10000))
    SET @Durations = (SELECT RAND() * 100)

    EXEC populateTrip
    @RouteN = @RouteName,
    @RouteD = @RouteDescr,
    @CountryName_E = @CountryName_Em,
    @CityName_E = @CityName_Em,
    @PortName_E = @PortName_Em,
    @CountryName_D = @CountryName_Di,
    @CityName_D = @CityName_Di,
    @PortName_D = @PortName_Di,
    @Begin = @BeginDate,
    @Duration = @Durations

    SET @RUN = @RUN - 1
END
GO

EXEC wraperPopTrip 500000
GO

-- 2) Check constraint
-- No crews who 1)have been on more than 5 trips that have more than 5 days of duration and embark from
-- port in China 2) have been on more than 5 routes that include SOU can be a waiter in the trips that
-- last for more than 10 days
CREATE FUNCTION ConstraintCrew()
RETURNS INTEGER
AS
BEGIN
DECLARE @RET INT = 0
IF EXISTS (
    SELECT C.CrewID, C.CrewFName, C.CrewLName, CountRoutes, COUNT(TP.TripCrewID) AS CountTrip
    FROM CREW C JOIN TRIP_CREW TP ON C.CrewID = TP.CrewID
        JOIN TRIP T ON TP.TripID = T.TripID
        JOIN ROUTES R ON T.RouteID = R.RouteID
        JOIN PORT P ON T.EmbarkPortID = P.PortID
        JOIN CITY CI ON P.CityID = CI.CityID
        JOIN COUNTRY CO ON CI.CountryID = CO.CountryID
        JOIN ROLES RO ON TP.RoleID = RO.RoleID
        JOIN (SELECT C.CrewID, C.CrewFName, C.CrewLName,COUNT(R.RouteID) AS CountRoutes
            FROM CREW C JOIN TRIP_CREW TP ON C.CrewID = TP.CrewID
                JOIN TRIP T ON TP.TripID = T.TripID
                JOIN ROUTES R ON T.RouteID = R.RouteID
            GROUP BY C.CrewID, C.CrewFName, C.CrewLName
            HAVING COUNT(R.RouteID) > 5) AS subq ON C.CrewID = subq.CrewID
    WHERE T.Duration > 5 AND CO.CountryName = 'China'
        AND RO.RoleName = 'Waiter' 
        AND R.RouteName LIKE '%SOU%'
        AND T.Duration > 10
    GROUP BY C.CrewID, C.CrewFName, C.CrewLName, CountRoutes
    HAVING COUNT(TP.TripCrewID) > 5
)
BEGIN
    SET @RET = 1
END
RETURN @RET
END
GO

ALTER TABLE TRIP_CREW
ADD CONSTRAINT noCrew
CHECK(dbo.ConstraintCrew() = 0)
go

-- No Silver membership passenger who gave out more than 4 reviews and had
-- bookings in Balcony rooms can have bookings on ship Celebration
CREATE FUNCTION noPassengerRating()
RETURNS INTEGER
AS
BEGIN
DECLARE @RET INT = 0
IF EXISTS(
    SELECT P.PassengerID, P.PassengerFname, P.PassengerLname, COUNT(R.ReviewID) AS CountReview
    FROM MEMBERSHIP M JOIN PASSENGER P ON M.MembershipID = P.MembershipID
        JOIN BOOKING B ON P.PassengerID = B.PassengerID
        JOIN REVIEW R ON B.BookingID = R.BookingID
        JOIN RATING RA ON R.RatingID = RA.RatingID
        JOIN BOOK_CABIN BC ON B.BookingID = BC.BookingID
        JOIN CABIN C ON BC.CabinID = C.CabinID
        JOIN CABIN_SHIP CS ON C.CabinID = CS.CabinID
        JOIN SHIP S ON CS.ShipID = S.ShipID
    WHERE C.CabinName = 'Balcony rooms'
        AND M.MembershipName = 'Silver'
        AND S.ShipName = 'Celebration'
    GROUP BY P.PassengerID, P.PassengerFname, P.PassengerLname
    HAVING COUNT(R.ReviewID) > 4
)
BEGIN
    SET @RET = 1
END
RETURN @RET
END
GO

ALTER TABLE BOOKING
ADD CONSTRAINT noPRating
CHECK(dbo.noPassengerRating() = 0)
GO 


-- 3) Computed column
-- Calculate YTD number of trips for each embark country that have ratings over 1
CREATE FUNCTION Cal_YTDTrip(@PK_ID INT)
RETURNS NUMERIC(12,2)
AS
BEGIN
DECLARE @RET NUMERIC(12,2) = (SELECT COUNT(T.TripID)
    FROM TRIP T 
        JOIN PORT P ON T.EmbarkPortID = P.PortID
        JOIN CITY CI ON P.CityID = CI.CityID
        JOIN COUNTRY CO ON CI.CountryID = CO.CountryID
        JOIN BOOKING B ON T.TripID = B.TripID
        JOIN REVIEW RE ON B.BookingID = RE.BookingID
        JOIN RATING RA ON RE.RatingID = RA.RatingID
    WHERE RA.RatingNum > 1
        AND YEAR(T.TripBeginDate) = YEAR(GetDate())
        AND CO.CountryID = @PK_ID)
RETURN @RET
END
GO

ALTER TABLE COUNTRY
ADD CalTrip AS (dbo.Cal_YTDTrip(CountryID))
GO

-- Calculate the number of cleaner crew over 20 years old of trips that contain SYD in routes
CREATE FUNCTION Cal_Crew(@PK_ID INT)
RETURNS NUMERIC(12,2)
AS
BEGIN 
DECLARE @RET NUMERIC(12,2) = (SELECT COUNT(TC.TripCrewID)
    FROM ROLES R
        JOIN TRIP_CREW TC ON R.RoleID = TC.RoleID
        JOIN CREW C ON TC.CrewID = C.CrewID
        JOIN TRIP T ON TC.TripID = T.TripID
        JOIN ROUTES RO ON T.RouteID = RO.RouteID
    WHERE C.CrewDOB < (GETDATE() - 20 * 365)
        AND RO.RouteName LIKE '%SYD%'
        AND R.RoleName = 'Cleaner'
        AND T.TripID = @PK_ID)
RETURN @RET
END
GO

ALTER TABLE TRIP
ADD CalCrew AS (dbo.Cal_Crew(TripID))
GO

-- 4) Views
-- Determine the top 10 trips that have Classic passengers over 20 in 'Suites' cabin who travelled in ship
-- 'Glory', 'Inspiration', 'Victory', and 'Galaxy' rated more than 4 reviews 
-- with ranking more than 2.
CREATE VIEW vwTopTrip
AS
SELECT TOP 10 WITH TIES T.TripID, COUNT(R.ReviewID) as CountReview
FROM TRIP T JOIN BOOKING B ON T.TripID = B.TripID
    JOIN PASSENGER P ON B.PassengerID = P.PassengerID
    JOIN MEMBERSHIP M ON P.MembershipID = M.MembershipID
    JOIN REVIEW R ON B.BookingID = R.BookingID
    JOIN RATING RA ON R.RatingID = RA.RatingID
    JOIN BOOK_CABIN BC ON B.BookingID = BC.BookingID
    JOIN CABIN C ON BC.CabinID = C.CabinID
    JOIN CABIN_SHIP CS ON C.CabinID = CS.CabinID
    JOIN SHIP S ON CS.ShipID = S.ShipID
WHERE P.PassengerDOB < (GETDATE() - 20 * 365)
    AND M.MembershipName = 'Classic'
    AND C.CabinName = 'Suites'
    AND S.ShipName IN ('Glory', 'Inspiration', 'Victory','Galaxy')
    AND RA.RatingNum > 2
GROUP BY T.TripID
HAVING COUNT(R.ReviewID) > 4
ORDER BY COUNT(R.ReviewID) DESC
GO

-- Determine the 13th trip with most passengers that disembark in Japan and have more than 
-- 1000 crews as waiter
CREATE VIEW vwOldestCrews
AS
WITH CTE_OldestCrew(TripID, CountBooking, CountCrew, RankBooking)
AS (
    SELECT T.TripID, COUNT(B.BookingID), COUNT(TC.CrewID),
    DENSE_RANK() OVER (ORDER BY COUNT(B.BookingID) ASC)
    FROM CREW C JOIN TRIP_CREW TC ON C.CrewID = TC.CrewID
        JOIN TRIP T ON TC.TripID = T.TripID
        JOIN PORT P ON T.DisembarkPortID = P.PortID
        JOIN ROLES R ON TC.RoleID = R.RoleID
        JOIN CITY CI ON P.CityID = CI.CityID
        JOIN COUNTRY CO ON CI.CountryID = CO.CountryID
        JOIN BOOKING B ON T.TripID = B.TripID
    WHERE P.PortName = 'Japan'
        AND R.RoleName = 'Waiter'
    GROUP BY T.TripID, C.CrewID, C.CrewFName, C.CrewLName
    HAVING COUNT(TC.CrewID) > 1000
)
SELECT TripID, CountBooking, RankBooking
FROM CTE_OldestCrew
WHERE RankBooking = 13
GO

--Anthony Zhang
--view on showing the top 10 passengers who spend the most on booking cuirse ship for each memembership
CREATE VIEW vw_top10_CTEv
AS
WITH top10_CTE(fname, lname, membership, fare, farerank)
AS
(SELECT PassengerFname, PassengerLname, MembershipName, SUM(B.Fare),
RANK() OVER(PARTITION BY M.MembershipName ORDER BY SUM(B.Fare) DESC)
FROM PASSENGER P
	JOIN BOOKING B on P.PassengerID = B.PassengerID
	JOIN MEMBERSHIP M on P.MembershipID = M.MembershipID
GROUP BY PassengerFname, PassengerLname, MembershipName)

SELECT fname, lname, membership,fare,  farerank
FROM top10_CTE 
WHERE farerank <= 10
GO

--view showing the ranking of the most popular route
CREATE VIEW vwpopularRoute_CTE
AS
WITH popularRoute_CTE(RouteName, routeCount, routeRank)
AS
(SELECT R.RouteName, S.ShipName, Count(B.BookingID) as Book_raw_count
--RANK() OVER(PARTITION BY R.RouteName ORDER BY Count(B.BookingID))
FROM BOOKING B
	JOIN TRIP T on B.TripID = T.TripID
	JOIN ROUTES R on T.RouteID = R.RouteID
	JOIN BOOK_CABIN BC on B.BookingID = BC.BookingID
	JOIN CABIN C on BC.CabinID = C.CabinID
	JOIN CABIN_SHIP CS on C.CabinID = CS.CabinID
	JOIN SHIP S on CS.ShipID = S.ShipID
GROUP BY R.RouteName, S.ShipName)

SELECT COUNT(BookingID) FROM BOOKING

SELECT shipName, RouteName FROM popularRoute_CTE WHERE routeRank <= 10
GO

--How many people have booked each type of room in the past 20 years and what memebership
CREATE VIEW vwCabinTypePopularity
AS
SELECT C.CabinName, Count(B.BookingID) as BookingNum,
RANK() OVER (ORDER BY Count(B.BookingID))  as ranking
FROM PASSENGER P
	JOIN BOOKING B on P.PassengerID = B.PassengerID
	JOIN BOOK_CABIN BC on B.BookingID = BC.BookingID
	JOIN CABIN C on BC.CabinID = C.CabinID
	JOIN MEMBERSHIP M on P.MembershipID = M.MembershipID
WHERE BookDateTime > DATEADD(YEAR, -20, GetDate())
GROUP BY C.CabinName
GO

DROP VIEW vwCabinTypePopularity

--computed column on how much did passengers spent the trip to Japan
CREATE FUNCTION totalSpending(@PK INT)
RETURNS INT
AS
BEGIN

DECLARE @RET INT = (SELECT SUM(B.Fare)
					FROM PASSENGER P
						JOIN BOOKING B on P.PassengerID = B.PassengerID
						JOIN TRIP T on B.TripID = T.TripID
						JOIN PORT PO on T.EmbarkPortID = PO.PortID
						JOIN CITY C on PO.CityID = C.CityID
						JOIN COUNTRY CY on C.CountryID = CY.CountryID
					WHERE CY.CountryName = 'Japan'
					AND P.PassengerID = @PK)
RETURN @RET
END
GO

ALTER TABLE PASSENGER
ADD totalSpendingJapan
AS (dbo.totalSpending(PassengerID))
GO

SELECT * FROM COUNTRY
GO
--computed column showing the average spending of passenger between the age of 20 to 30
CREATE FUNCTION averageSpending(@PK INT)
RETURNS INT
AS
BEGIN

DECLARE @RET INT = (SELECT AVG(B.Fare)
					FROM PASSENGER P
						JOIN BOOKING B on P.PassengerID = B.PassengerID
						JOIN TRIP T on B.TripID = T.TripID
						JOIN PORT PO on T.EmbarkPortID = PO.PortID
						JOIN CITY C on PO.CityID = C.CityID
						JOIN COUNTRY CY on C.CountryID = CY.CountryID
					WHERE P.PassengerID = @PK)
RETURN @RET
END
GO

ALTER TABLE PASSENGER
ADD averageSpending
AS (dbo.totalSpending(PassengerID))
GO

--busniess rule no passenger that is nont a adult is allow to book a cuise ship

CREATE FUNCTION noChildBooking()
RETURNS INT
AS
BEGIN

DECLARE @RET INT = 0
IF EXISTS (SELECT *
		 FROM PASSENGER P
			JOIN PASSENGER_TYPE PT on P.PassengerTypeID = PT.PassengerTypeID
			JOIN BOOKING B on P.PassengerID = B.PassengerID
		 WHERE PT.PassengerTypeName != 'Adult')
	BEGIN
		SET @RET = 1
	END
RETURN @RET
END
GO	

ALTER TABLE BOOKING with nocheck
ADD CONSTRAINT CK_no_child_booking
CHECK (dbo.noChildBooking() = 0)
GO

--business rule no passenger with calssic membership are allowed to book suites
CREATE FUNCTION noClassicSuite()
RETURNS INT
AS
BEGIN

DECLARE @RET INT = 0
IF EXISTS (SELECT *
		 FROM PASSENGER P
			JOIN PASSENGER_TYPE PT on P.PassengerTypeID = PT.PassengerTypeID
			JOIN BOOKING B on P.PassengerID = B.PassengerID
			JOIN BOOK_CABIN BC on B.BookingID = BC.BookingID
			JOIN CABIN C on BC.CabinID = C.CabinID
		 WHERE PT.PassengerTypeName = 'Classic'
		 AND C.CabinName = 'Suite')
	BEGIN
		SET @RET = 1
	END
RETURN @RET
END
GO	

ALTER TABLE BOOK_CABIN with nocheck
ADD CONSTRAINT CK_no_classic_suite
CHECK (dbo.noClassicSuite() = 0)
GO

--one of my database storeprocedure
CREATE PROCEDURE InsertCabinShip
@SName varchar(100),
@CName varchar(50)

AS

DECLARE @C_ID INT, @S_ID INT

EXEC GetShipID
@SNamey = @SName,
@SIDy = @S_ID OUTPUT

IF @S_ID is null
	BEGIN
		PRINT '@S_ID returns null, something is wrong with the data';
		THROW 55001, '@S_ID cannot be null. Terminating the process', 1;
	END

EXEC GetCabinID
@CNamey = @CName,
@CIDy = @C_ID OUTPUT

IF @C_ID is null
	BEGIN
		PRINT '@C_ID returns null, something is wrong with the data';
		THROW 55001, '@C_ID cannot be null. Terminating the process', 1;
	END

BEGIN TRANSACTION T1
INSERT INTO CABIN_SHIP(CabinID, ShipID)
VALUES (@C_ID, @S_ID)
COMMIT TRANSACTION T1
GO

--another example of store procedure
CREATE PROCEDURE InsertBooking
@PFname varchar(50),
@PLname varchar(50),
@PDOB date,
@TRName varchar(50),
@TEPName varchar(50),
@TDPName varchar(50),
@TBDate date,
@BDT Datetime,
@F decimal(10, 2)


AS

DECLARE @P_ID INT, @T_ID INT

EXEC GetPassengerID
@PFnamey = @PFname,
@PLnamey = @PLname,
@PDOBy = @PDOB,
@PIDy = @P_ID OUTPUT

IF @P_ID is null
	BEGIN
		PRINT '@P_ID returns null, something is wrong with the data';
		THROW 55001, '@P_ID cannot be null. Terminating the process', 1;
	END

EXEC GetTripID_2
@TRNamey = @TRName,
@TEPNamey = @TEPName,
@TDPNamey = @TDPName,
@TBDaty = @TBDate,
@TIDy = @T_ID OUTPUT

IF @T_ID is null
	BEGIN
		PRINT '@T_ID returns null, something is wrong with the data';
		THROW 55002, '@T_ID cannot be null. Terminating the process', 1;
	END

BEGIN TRANSACTION T1
INSERT INTO BOOKING(PassengerID, TripID, BookDateTime, Fare)
VALUES (@P_ID, @T_ID, @BDT, @F)
COMMIT TRANSACTION T1
GO

--Anthony part end


--Miranda: 
    --Stored procedure

    --getRatingID
CREATE PROCEDURE getRatingID 
@RNum INT, 
@RID INT OUTPUT
AS 

SET @RID = (SELECT RatingID FROM RATING WHERE RatingNum = @RNum )
GO 

--getBookingID
CREATE PROCEDURE getBookingID 
@FName VARCHAR(50), 
@LName VARCHAR(50), 
@DOB DATE, 
@TBD DATETIME, 
@RN VARCHAR(50),
@BID INT OUTPUT
AS

SET @BID = (SELECT BookingID FROM BOOKING B 
            JOIN PASSENGER P ON B.PassengerID = P.PassengerID
            JOIN TRIP T ON B.TripID = T.TripID
            JOIN ROUTES R ON T.RouteID = R.RouteID
            WHERE P.PassengerFname = @FName
            AND P.PassengerLname = @LName
            AND P.PassengerDOB = @DOB
            AND T.TripBeginDate = @TBD
            AND R.RouteName = @RN)
GO 
 

--stored procedure to insert review
CREATE PROCEDURE insertReview 
@RTitle VARCHAR(40), 
@RContent VARCHAR(2000), 
@RDate DATE, 
@RN INT,
@FN VARCHAR(50), 
@LN VARCHAR(50), 
@BDate DATE, 
@TBDate DATETIME, 
@RouteN VARCHAR(50)
AS 

DECLARE @R_ID INT, @B_ID INT 

EXEC getRatingID
@RNum = @RN, 
@RID = @R_ID OUTPUT

EXEC getBookingID
@FName = @FN, 
@LName = @LN, 
@DOB = @BDate, 
@TBD = @TBDate, 
@RN = @RouteN,
@BID = @B_ID OUTPUT

IF @R_ID is null
	BEGIN
		PRINT '@R_ID returns null, something is wrong with the data';
		THROW 56001, '@R_ID cannot be null. Terminating the process', 1;
	END

IF @B_ID is null
	BEGIN
		PRINT '@B_ID returns null, something is wrong with the data';
		THROW 56001, '@B_ID cannot be null. Terminating the process', 1;
	END

BEGIN TRANSACTION T1
INSERT INTO REVIEW (BookingID, RatingID, ReviewTitle, ReviewContent, ReviewDate)
VALUES (@B_ID, @R_ID, @RTitle, @RContent, @RDate)
COMMIT TRANSACTION T1
GO 

--wrapper for inserting review
CREATE PROCEDURE populateReviewWrapper
@RUN INT 
AS 

DECLARE @FN VARCHAR(50), @LN VARCHAR(50), @BDate DATE, @RNum INT, @TBDate Datetime, @ReviewDate DATE, @RouteN VARCHAR(50)
DECLARE @BookRowCount INT = (SELECT COUNT(*) FROM BOOKING)
DECLARE @B_PK INT, @P_PK INT

WHILE @RUN > 0
BEGIN 
SET @B_PK = (SELECT RAND() * @BookRowCount + 1)
SET @P_PK = (SELECT PassengerID FROM BOOKING WHERE BookingID = @B_PK)
SET @FN = (SELECT PassengerFname FROM PASSENGER WHERE PassengerID = @P_PK)
SET @LN = (SELECT PassengerLname FROM PASSENGER WHERE PassengerID = @P_PK)
SET @BDate = (SELECT PassengerDOB FROM PASSENGER WHERE PassengerID = @P_PK)
SET @RouteN = (SELECT RouteName FROM ROUTES R JOIN TRIP T ON R.RouteID = T.RouteID JOIN BOOKING B ON T.TripID = B.TripID WHERE B.BookingID = @B_PK)
SET @TBDate = (SELECT TripBeginDate FROM TRIP T JOIN BOOKING B ON T.TripID = B.TripID WHERE B.BookingID = @B_PK)
SET @ReviewDate = (SELECT GETDATE() - (RAND() * 100))
SET @RNum = (SELECT RAND() * 5 + 1)

IF @B_PK is null
	BEGIN
		PRINT '@T_PK returns null, something is wrong with the data';
		THROW 56001, '@T_PK cannot be null. Terminating the process', 1;
	END
IF @P_PK is null
	BEGIN
		PRINT '@T_PK returns null, something is wrong with the data';
		THROW 56001, '@T_PK cannot be null. Terminating the process', 1;
	END

EXEC insertReview
@RTitle = 'My Review', 
@RContent = 'This route is interesting..', 
@RDate = @ReviewDate, 
@RN = @RNum,
@FN = @FN, 
@LN = @LN, 
@BDate = @BDate, 
@TBDate = @TBDate, 
@RouteN = @RouteN

SET @RUN = @RUN - 1
END 
GO 

EXEC populateReviewWrapper 450000
SELECT * FROM REVIEW

--insert unique records into copy of raw data
SELECT City, Country INTO Working_Copy_Cities 
FROM raw_cities
GROUP BY City, Country HAVING COUNT(*) = 1

alter table Working_Copy_Cities
add CityID int identity(1,1)

select * from Working_Copy_Cities
GO

--Insert into country
INSERT INTO COUNTRY (CountryName)
SELECT DISTINCT Country
FROM working_Copy_Cities
GO

ALTER TABLE COUNTRY 
DROP COLUMN CountryID 
ADD CountryID INT IDENTITY (1,1)

--DBCC CHECKIDENT ('Trip', RESEED, 0)

select * from Country
GO

--getCountryID
CREATE PROCEDURE getCountryID
@CName VARCHAR(50),
@CID INT OUTPUT
AS 

SET @CID = (SELECT CountryID FROM COUNTRY WHERE CountryName = @CName)
GO 

--insert into city and port
CREATE PROCEDURE insertPort
@CityN VARCHAR(50), 
@CounN VARCHAR(50)
AS 

DECLARE @Country_ID INT, @City_ID INT

EXEC getCountryID
@CName = @CounN, 
@CID = @Country_ID OUTPUT

IF @Country_ID is null
	BEGIN
		PRINT '@C_ID returns null, something is wrong with the data';
		THROW 55001, '@ C_ID cannot be null. Terminating the process', 1;
	END

BEGIN TRANSACTION T1
INSERT INTO CITY(CityName, CountryID)
VALUES (@CityN, @Country_ID)

SET @City_ID = SCOPE_IDENTITY()

INSERT INTO PORT(PortName, PortDescr, CityID)
VALUES(@CityN, 'This is a port', @City_ID)
COMMIT TRANSACTION T1
GO 

--insert wrapper

CREATE PROCEDURE wrapperPort

AS
DECLARE @CityName VARCHAR(50), @CounName VARCHAR(50)

DECLARE @Counter INT, @MinID INT

SET @Counter = (SELECT COUNT(CityID) FROM Working_Copy_Cities)
SET @MinID = (SELECT MIN(CityID) FROM Working_Copy_Cities)

WHILE (@MinID IS NOT NULL)
BEGIN 
    SET @CityName = (SELECT city FROM Working_Copy_Cities WHERE CityID = @MinID)
    SET @CounName = (SELECT country FROM Working_Copy_Cities WHERE CityID = @MinID)

    exec insertPort
    @CityN = @CityName,
    @CounN = @CounName

    DELETE FROM Working_Copy_Cities WHERE CityID = @MinID
    SET @MinID = (SELECT MIN(CityID) FROM Working_Copy_Cities)
END

EXEC wrapperPort
GO

    --Check constraint

        --No ship can have more passengers than capacity
        CREATE FUNCTION noPassMoreThanCapa()
        RETURNS INTEGER 
        AS
        BEGIN
        DECLARE @RET INTEGER = 0

        IF EXISTS(
            SELECT * 
            FROM PASSENGER P 
            JOIN BOOKING B ON P.PassengerID = B.PassengerID
            JOIN BOOK_CABIN BC ON B.BookingID = BC.BookingID
            JOIN CABIN C ON BC.CabinID = C.CabinID
            JOIN SHIP S ON C.ShipID = S.ShipID
            GROUP BY S.ShipID
            HAVING COUNT(P.PassengerID) >= S.Capacity
        )
        BEGIN 
        SET @RET = 1
        END 

        RETURN @RET
        END
        GO

        ALTER TABLE BOOKING 
        ADD CONSTRAINT noPassMoreThanCapa
        CHECK(dbo.noPassMoreThanCapa()=0)
        GO

        --No passenger under 18 can stay in a cabin alone
        CREATE FUNCTION noPassAlone18()
        RETURNS INTEGER 
        AS
        BEGIN
        DECLARE @RET INTEGER = 0

        IF EXISTS(
            SELECT *
            FROM PASSENGER P 
            JOIN BOOKING B ON P.PassengerID = B.PassengerID
            JOIN BOOK_CABIN BC ON B.BookingID = BC.BookingID
            WHERE DATEADD(YEAR, 18, P.PassengerDOB) > GETDATE()
            GROUP BY BC.CabinID
            HAVING COUNT(P.PassengerID) = 1
        )
        BEGIN 
        SET @RET = 1
        END 

        RETURN @RET
        END
        GO

        ALTER TABLE BOOKING 
        ADD CONSTRAINT noPassAlone18
        CHECK(dbo.noPassAlone18()=0)
        GO

    --Computed column

        --Calculate how many trips started at each port in the past five years
        CREATE FUNCTION portTripStarted(@PK INT)
        RETURNS INTEGER 
        AS
        BEGIN 

        DECLARE @RET INTEGER = (
            SELECT COUNT(*)
            FROM TRIP T 
            JOIN PORT P ON T.EmbarkPortID = P.PortID
            WHERE P.PortID = @PK
            AND T.TripBeginDate > DATEADD(YEAR, -5, GETDATE())
        )

        RETURN @RET
        END 
        GO 

        ALTER TABLE PORT 
        ADD Calc_TripsStarted AS (dbo.portTripStarted(PortID))
        GO

        --Calculate the average rating a route has in the past five years
        CREATE FUNCTION routeRating(@PK INT)
        RETURNS NUMERIC(3,2)
        AS
        BEGIN 

        DECLARE @RET NUMERIC(3,2) = (
            SELECT AVG(RA.RatingNum)
            FROM RATING RA 
            JOIN REVIEW R ON RA.RatingID = R.RatingID
            JOIN BOOKING B ON R.BookingID = B.BookingID
            JOIN TRIP T ON B.TripID = T.TripID
            JOIN ROUTES RO ON T.RouteID = RO.RouteID
            WHERE RO.RouteID = @PK
            AND T.TripBeginDate > DATEADD(YEAR, -5, GETDATE())
        )

        RETURN @RET 
        END 
        GO 

        ALTER TABLE ROUTES
        ADD Calc_AvgRating AS (dbo.routeRating(RouteID))
        GO

    --Views

        --create a view for the number of passengers in each membership tier on one trip
		CREATE VIEW numMembershipOnTrip AS
        SELECT T.TripID, M.MembershipID, M.MembershipName, COUNT(M.MembershipID) AS NumMembership
        FROM MEMBERSHIP M
        JOIN PASSENGER P ON M.MembershipID = P.MembershipID
        JOIN BOOKING B ON P.PassengerID = B.PassengerID
        JOIN TRIP T ON B.TripID = T.TripID
        JOIN ROUTES R ON T.RouteID = R.RouteID
		GROUP BY T.TripID, M.MembershipID, M.MembershipName
        GO

        CREATE VIEW numMembershipOnTrip2 AS
        SELECT  M.MembershipName,R.RouteName, COUNT(P.PassengerID) AS Numpassenger
		FROM MEMBERSHIP M
        JOIN PASSENGER P ON M.MembershipID = P.MembershipID
        JOIN BOOKING B ON P.PassengerID = B.PassengerID
        JOIN TRIP T ON B.TripID = T.TripID
        JOIN ROUTES R ON T.RouteID = R.RouteID
		GROUP BY  M.MembershipName,R.RouteName

        --create a view for the top 100 passenger who have done the most trips on cruises in suites rooms
        CREATE VIEW passMostTrips AS
        SELECT TOP 100 P.PassengerID, P.PassengerFname, P.PassengerLname, COUNT(T.TripID) AS numTrips
        FROM PASSENGER P 
        JOIN BOOKING B ON P.PassengerID = B.PassengerID
        JOIN TRIP T ON B.TripID = T.TripID
        JOIN BOOK_CABIN BC ON BC.BookingID = B.BookingID
        JOIN CABIN C ON BC.CabinID = C.CabinID
        WHERE C.CabinName = 'Suites'
        GROUP BY P.PassengerID, P.PassengerFname, P.PassengerLname
        ORDER BY COUNT(T.TripID) DESC

