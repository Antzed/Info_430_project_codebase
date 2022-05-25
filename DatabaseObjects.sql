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
--computed column on how much did passengers spent the trip to hawaii
CREATE FUNCTION totalSpending(@PK INT)
RETURNS INT
AS
BEGIN

--computed column showing the average spending of passenger between the age of 20 to 30

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

