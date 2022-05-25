--Whitney
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
--Look up table GetFacilityID
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
CREATE PROCEDURE group5WRAPPER_PopShipFacility
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

group5WRAPPER_PopShipFacility 5000

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

CREATE PROCEDURE getTripID
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
        AND T.TripBeginDate = @BeginDate AND Duration = @Durations)
GO

CREATE PROCEDURE insertTRIP_CREW
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
@TripID = @TRIP_ID

IF @TRIP_ID IS NULL
    BEGIN
        PRINT 'Trip ID is null';
        THROW 55143, '@TRIP_ID IS NULL', 1;
    END

EXEC getCrewID
@Fname = @FnameP,
@Lname = @LnameP,
@DOB = @DOBP,
@CrewID = @CREW_ID

IF @CREW_ID IS NULL
    BEGIN
        PRINT 'Crew ID is null';
        THROW 55143, '@CREW_ID IS NULL', 1;
    END

EXEC getRoleID
@Name = @ROLEName,
@Descr = @ROLEDescr,
@RoleID = @ROLE_ID

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


CREATE PROCEDURE populateTripCrew
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
    SET @CountryName_E = (SELECT CountryName FROM Trip T JOIN PORT P ON T.EmbarkPortID = P.PortID JOIN CITY C ON P.CityID = C.CityID
        JOIN COUNTRY CO ON C.CountryID = CO.CountryID
        WHERE TripID = @T_PK)
    SET @CityName_E = (SELECT CityName FROM Trip T JOIN PORT P ON T.EmbarkPortID = P.PortID JOIN CITY C ON P.CityID = C.CityID
        WHERE TripID = @T_PK)
    SET @PortName_E = (SELECT PortName from Trip T JOIN PORT P ON T.EmbarkPortID = P.PortID WHERE TripID = @T_PK)
    SET @CountryName_D = (SELECT CountryName FROM Trip T JOIN PORT P ON T.DisembarkPortID = P.PortID JOIN CITY C ON P.CityID = C.CityID
        JOIN COUNTRY CO ON C.CountryID = CO.CountryID
        WHERE TripID = @T_PK)
    SET @CityName_D = (SELECT CityName FROM Trip T JOIN PORT P ON T.DisembarkPortID = P.PortID JOIN CITY C ON P.CityID = C.CityID
        WHERE TripID = @T_PK)
    SET @PortName_D = (SELECT PortName FROM Trip T JOIN PORT P ON T.DisembarkPortID = P.PortID WHERE TripID = @T_PK)
    SET @BeginDate = (SELECT GetDate() - (RAND() * 10000))
    SET @Durations = (SELECT RAND() * 10000)
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

populateTripCrew 100
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

CREATE PROCEDURE wraperPopTrip
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
    SET @CountryName_Em = (SELECT CountryName FROM PORT P JOIN CITY C ON P.CityID = C.CityID
        JOIN COUNTRY CO ON C.CountryID = CO.CountryID
        WHERE P.PortID = @E_PK)
    SET @CityName_Em = (SELECT CityName FROM PORT P JOIN CITY C ON P.CityID = C.CityID
        WHERE P.PortID = @E_PK)
    SET @PortName_Em = (SELECT PortName from PORT WHERE PortID = @E_PK)
    SET @CountryName_Di = (SELECT CountryName FROM PORT P JOIN CITY C ON P.CityID = C.CityID
        JOIN COUNTRY CO ON C.CountryID = CO.CountryID
        WHERE P.PortID = @D_PK)
    SET @CityName_Di = (SELECT CityName FROM PORT P JOIN CITY C ON P.CityID = C.CityID
        WHERE P.PortID = @D_PK)
    SET @PortName_Di = (SELECT PortName from PORT WHERE PortID = @D_PK)
    SET @BeginDate = (SELECT GetDate() - (RAND() * 10000))
    SET @Durations = (SELECT RAND() * 10000)

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

EXEC wraperPopTrip 100
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
    GROUP BY C.CrewID, C.CrewFName, C.CrewLName
    HAVING COUNT(TP.TripCrewID) > 5
        AND RO.RoleName = 'Waiter' 
        AND R.RouteName LIKE '%SOU%'
        AND T.Duration > 10
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
    WHERE RA.Rating > 1
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
SELECT TOP 10 WITH TIES T.TripID, T.TripName, COUNT(R.ReviewID) as CountReview
FROM TRIP T JOIN BOOKING B ON T.TripID = B.TripID
    JOIN PASSENGER P ON B.PassengerID = P.PassengerID
    JOIN MEMBERSHIP M ON P.MembershipID = M.MembershipID
    JOIN REVIEW R ON B.BookingID = R.BookingID
    JOIN RATING RA ON R.RatingID = RA.RatingID
    JOIN BOOKING_CABIN BC ON B.BookingID = BC.BookingID
    JOIN CABIN C ON BC.CabinID = C.CabinID
    JOIN CABIN_SHIP CS ON C.CabinID = CS.CabinID
    JOIN SHIP S ON CS.ShipID = S.ShipID
WHERE P.PassengerDOB < (GETDATE() - 20 * 365)
    AND M.MembershipName = 'Classic'
    AND C.CabinName = 'Suites'
    AND S.ShipName IN ('Glory', 'Inspiration', 'Victory','Galaxy')
    AND RA.Rating > 2
GROUP BY T.TripID, T.TripName
HAVING COUNT(R.ReviewID) > 4
ORDER BY COUNT(R.ReviewID) DESC
GO

-- Determine the 13th trip with most passengers that disembark in Japan and have more than 
-- 1000 crews as waiter
CREATE VIEW vwOldestCrew
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
ORDER BY TotalNumShips
GO




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
