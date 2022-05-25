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


--Miranda: 
    --Stored procedure

    --In Table Data Inserts 
    --insert into port
    --port syn trx wrapper
    --insert into review
    --review syn trx wrapper

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

