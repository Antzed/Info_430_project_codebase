USE group5_INFO430 
GO

--Anthony Zhang
--view on showing the top 10 passengers who spend the most on booking cuirse ship for each memembership

WITH top10_CTE(fname, lname, fare, farerank)
AS
(SELECT PassengerFname, PassengerLname, SUM(B.Fare),
RANK() OVER(PARTITION BY M.MembershipName ORDER BY SUM(B.Fare))
FROM PASSENGER P
	JOIN BOOKING B on P.PassengerID = B.PassengerID
	JOIN MEMBERSHIP M on P.MembershipID = M.MembershipID
GROUP BY PassengerFname, PassengerLname)

SELECT TOP(10) fname, lname FROM top10_CTE ORDER BY farerank

--view showing the ranking of the most popular route for each ship
WITH popularRoute_CTE(shipName, RouteName, routeRank)
AS
(SELECT S.ShipName, R.RouteName, 
RANK() OVER(PARTITION BY S.ShipName ORDER BY Count(B.BookingID))
FROM SHIP S
	JOIN CABIN_SHIP CS on CS.ShipID  = S.ShipID
	JOIN CABIN C on CS.CabinID = C.CabinID
	JOIN BOOK_CABIN BC on BC.CabinID = C.CabinID
	JOIN BOOKING B on BC.BookingID = B.BookingID
	JOIN TRIP T on B.TripID = T.TripID
	JOIN ROUTES R on T.RouteID = R.RouteID
GROUP BY S.ShipName, R.RouteName)

SELECT TOP(10) shipName, RouteName FROM popularRoute_CTE ORDER BY routeRank
GO
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
AS (dbo.totalSpending(P.PassengerID))
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
AS (dbo.totalSpending(P.PassengerID))
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

ALTER TABLE BOOKING
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

ALTER TABLE BOOK_CABIN
ADD CONSTRAINT CK_no_classic_suite
CHECK (dbo.noClassicSuite() = 0)

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

drop procedure populatereviewwrapper
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

ALTER TABLE COUNTRY 
DROP COLUMN CountryID 
ADD CountryID INT IDENTITY (1,1)

--DBCC CHECKIDENT ('Trip', RESEED, 0)

select * from Country

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

        ALTER TABLE BOOKING 
        ADD CONSTRAINT noPassAlone18
        CHECK(dbo.noPassAlone18()=0)

    --Computed column

        --Calculate how many trips started at each port
        CREATE FUNCTION portTripStarted(@PK INT)
        RETURNS INTEGER 
        AS
        BEGIN 

        DECLARE @RET INTEGER = (
            SELECT COUNT(*)
            FROM TRIP T 
            JOIN PORT P ON T.EmbarkPortID = P.PortID
            WHERE P.PortID = @PK
        )

        RETURN @RET
        END 
        GO 

        ALTER TABLE PORT 
        ADD Calc_TripsStarted AS (dbo.portTripStarted(PortID))
        GO

        --Calculate the average rating a route has
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
        SELECT T.TripID, M.MembershipID, M.MembershipName, (M.MembershipID) AS NumMembership
        FROM MEMBERSHIP M
        JOIN PASSENGER P ON M.MembershipID = P.MembershipID
        JOIN BOOKING B ON P.PassengerID = B.PassengerID
        JOIN TRIP T ON B.TripID = T.TripID
        JOIN ROUTES R ON T.RouteID = R.RouteID
        GROUP BY T.TripID, M.MembershipID, M.MembershipName

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

