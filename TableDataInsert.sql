USE group5_INFO430 
GO

INSERT INTO PASSENGER_TYPE(PassengerTypeName)
VALUES('Adult'), ('Child'), ('Infant without a seat'), ('Infant with a seat'), ('Unaccompanied  child')

INSERT INTO MEMBERSHIP(MembershipName, MembershipDescr)
VALUES('Classic', 'default'), ('Silver', '1000 travel points'), ('Gold',  '10,000 travel points'), ('Diamond', '20,000 travel points'), ('Lifelong', '50,000 travel points')
GO

INSERT INTO RATING (RatingNum, RatingDesc)
VALUES ('1', 'Not satisfied'), ('2', 'Slightly not satisfied'), ('3', 'Just okay'), ('4', 'Good'), ('5', 'Excellent')


INSERT INTO SHIP_TYPE (ShipTypeName, ShipTypeDescr)
VALUES('Mainstream Cruise Ship', 'The most common and known type of cruise ship, marketed to suit the needs of the majority of passengers, with all sorts of standard resort features'),
('Mega Cruise Ship', 'Can accommodate more than 5,000 persons, and they are currently the largest and more sophisticated vessels in the world'),
('Ocean Cruise Ship', 'Built to the most exacting standards to withstand the harsh conditions of ocean voyages in long and world cruises'),
('Luxury Cruise Ship', 'Equipped with the most sophisticated and technologically advanced nautical systems, high standard features and luxurious comforts'),
('Small Cruise Ship', 'With a capacity up to a few hundred passengers onboard, offering more intimate and relaxing experiences in less familiar destinations'),
('Adventure Cruise Ship', 'Designed and equipped to provide services that include visits of remote destinations, most commonly inaccessible to larger vessels'),
('Expedition Cruise Ship', 'Specially designed ships, or adapted research or icebreaker vessels, operated by specialized companies to offer their customers an exclusive experience in remote destinations'),
('River Cruise Ship', 'Have a capacity for no more than a few hundred passengers, and are specially designed to navigate rivers and inland waterways')
GO

INSERT INTO FACILITY_TYPE (FacilityTypeName, FacilityTypeDescr)
VALUES ('Dinning', 'Provide food services'), 
('Entertainment', 'People can have fun'),
('Shopping', 'People can buy things on the ship'), 
('Sporting Facilities', 'People can workout and play sports'),
('Medical Facilities','Medical or emergency treatment')
GO

INSERT INTO FACILITY (FacilityTypeID, FacilityName, FacilityDescr, FacilityFee)
VALUES ('1', 'Main dinning room', 'Where people can eat in a large room', '0'),
('1', 'Buffet', 'Where people can get a variety of food', '35'),
('1', 'Specialty restaurant', 'Where people can get a specific type of food', '60'),
('1', 'Room service', 'Where people can order food directly sending to their rooms', '40'),
('1', 'Daily snacks', 'Small packaged food for grab and go', '0'),
('1', 'Bar', 'Where people can get drinks', '0'),
('2', 'Live musicals', 'Musical shows', '0'),
('2', 'Interactive performance for kids', 'Musical shows for kids under 13', '0'),
('2', 'Movie theater', 'Play movies at the theater', '0'),
('2', 'Onboard tattoos', 'People can get tattoos', '80'),
('2', 'E-game center', 'People can play video games', '20'),
('2', 'Discotheques', 'People can dance', '0'),
('2', 'Karraoke lounge', 'People can sing', '0'),
('2', 'Water park', 'Where people can play with water', '0'),
('2', 'Discotheques', 'People can dance', '0'),
('2', 'Casinos', 'People can play card games and earn money', '10'),
('2', 'Slot Machine', 'People can play games on machines and earn money', '5'),
('3', 'Duty-free store', 'Products without duty', '150'),
('3', 'Luxury store', 'High-end brands', '500'),
('3', 'Liquor store', 'Alcoholic drkins', '200'),
('4', 'Table tennis', 'Play table tennis', '0'),
('4', 'Basketball', 'Play in 2 teams', '0'),
('4', 'Shuffleboard', '2 people play', '0'),
('4', 'Ice skating', 'Skating on ice', '5'),
('4', 'Surfing', 'Play surfing board', '0'),
('4', 'Swimming pool', 'Where people can swim', '0'),
('4', 'Gym', 'Where people can workout', '0'),
('4', 'Jogging track', 'Where people can run', '0'),
('4', 'Golf court', 'Where people can play mini-golf', '0'),
('4', 'Rock-climbing', 'Where people can climb', '0'),
('4', 'Bowling alley', 'Where people can go bowling', '0'),
('5', 'Cardiac monitor', 'Medical treatment', '0'),
('5', 'Automated external defibrillator', 'Medical treatment', '0'),
('5', 'Ventilator', 'Medical treatment', '0'),
('5', 'X-ray machine and processor', 'Medical treatment', '0'),
('5', 'Laboratory equipment', 'Medical treatment', '0'),
('5', 'Surgical and orthopedic supplies', 'Medical treatment', '0')
GO

INSERT INTO SHIP (ShipTypeID, ShipName, ShipDescr, CabinCount, YearLaunch, Tonnage, Capacity)
VALUES ('1', 'Journey', 'A cruise ship', '3.55', '2016','30.28', '6.94'),
('1', 'Quest', 'A cruise ship', '3.55', '2016','30.28', '6.94'),
('1', 'Celebration', 'A cruise ship', '7.43', '1996','47.26', '14.86'),
('1', 'Conquest', 'A cruise ship', '14.88', '2011','110', '29.74'),
('1', 'Destiny', 'A cruise ship', '13.21', '2011','101.53', '26.42'),
('2', 'Ecstasy', 'A cruise ship', '10.2', '2000','70.37', '20.52'),
('2', 'Elation', 'A cruise ship', '10.2', '2007','70.37', '20.52'),
('2', 'Fantasy', 'A cruise ship', '10.22', '1997','70.37', '20.56'),
('2', 'Freedom', 'A cruise ship', '14.87', '2016','110.24', '37'),
('2', 'Glory', 'A cruise ship', '14.87', '2012','110', '29.74'),
('3', 'Imagination', 'A cruise ship', '10.2', '2004','70.37', '20.52'),
('3', 'Inspiration', 'A cruise ship', '10.2', '2005','70.37', '20.52'),
('3', 'Legend', 'A cruise ship', '10.62', '2011','86', '21.24'),
('3', 'Liberty', 'A cruise ship', '14.87', '2014','110', '29.74'),
('3', 'Miracle', 'A cruise ship', '10.62', '2013','88.5', '21.24'),
('4', 'Paradise', 'A cruise ship', '10.2', '2007','70.37', '20.52'),
('4', 'Pride', 'A cruise ship', '11.62', '2010','88.5', '21.24'),
('4', 'Sensation', 'A cruise ship', '10.2', '2002','70.37', '20.52'),
('4', 'Spirit', 'A cruise ship', '10.56', '2010','88.5', '21.24'),
('4', 'Triumph', 'A cruise ship', '13.21', '2008','101.51', '27.58'),
('5', 'Victory', 'A cruise ship', '13.79', '2009','101.51', '27.58'),
('5', 'Valor', 'A cruise ship', '14.87', '2013','110', '29.74'),
('5', 'Century', 'A cruise ship', '8.75', '2004','70.61', '17.7'),
('5', 'Constellation', 'A cruise ship', '9.75', '2011','91', '20.32'),
('5', 'Galaxy', 'A cruise ship', '9.35', '2005','77.71', '18.9')
GO




USE group5_INFO430
-- insert crew
INSERT INTO CREW(CrewFName, CrewLName, CrewDOB)
SELECT [StudentFname], [StudentLname], [StudentBirth]
FROM UNIVERSITY.dbo.tblSTUDENT

-- insert role
INSERT INTO ROLES(RoleName, RoleDescr)
VALUES('Captain', 'Person in charge'),
('Staff Captain', 'Person in charge of staff'),
('Safety Officer', 'Person in charge of security'),
('Environmental Compliance Officer', 'Person in charge of environment'),
('Cleaner', 'Person in charge of hygiene'),
('Waiter', 'Person in charge of food serving')

-- insert route
INSERT INTO ROUTES(RouteName, RouteDescr)
VALUES('SOU-AKL', 'SOU-AKL'),
('SOU-BNE', 'SOU-BNE'),
('SOU-SFO', 'SOU-SFO'),
('SYD-BNE', 'SYD-BNE'),
('SYD-HKG', 'SYD-HKG'),
('SFO-SYD', 'SFO-SYD'),
('AKL-SYD', 'AKL-SYD'),
('SYD-SIN', 'SYD-SIN'),
('BNE-SOU', 'BNE-SOU'),
('HKG-DXB', 'HKG-DXB'),
('SIN-SOU', 'SIN-SOU'),
('DXB-SOU', 'DXB-SOU'),
('SFO-AKL', 'SFO-AKL'),
('AKL-SOU', 'AKL-SOU'),
('SOU-SOU', 'SOU-SOU')
GO

-- insert trip
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

EXEC getPortID
@CountryN = @CountryName_E,
@CityN = @CityName_E,
@PortN = @PortName_E,
@PortID = @PortE_ID OUTPUT

EXEC getPortID
@CountryN = @CountryName_D,
@CityN = @CityName_D,
@PortN = @PortName_D,
@PortID = @PortD_ID OUTPUT

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

-- INSERT TRIP_CREW
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

EXEC getCrewID
@Fname = @FnameP,
@Lname = @LnameP,
@DOB = @DOBP,
@CrewID = @CREW_ID

EXEC getRoleID
@Name = @ROLEName,
@Descr = @ROLEDescr,
@RoleID = @ROLE_ID

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

exec populateTripCrew 100
GO


--INSERT booking information
select * from BOOKING
select * from TRIP
select * from PASSENGER
select * from PASSENGER_TYPE
select * from MEMBERSHIP
GO
--syth trax for passenger
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
DECLARE @P_RowCount INT = (SELECT COUNT(*) FROM PEEPS.dbo.tblCUSTOMER)
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
SET @PF = (SELECT DISTINCT CustomerFname FROM PEEPS.dbo.tblCUSTOMER WHERE CustomerID = @P_PK)
SET @PL = (SELECT DISTINCT CustomerLname FROM PEEPS.dbo.tblCUSTOMER WHERE CustomerID = @P_PK)
SET @PBDay = (SELECT DISTINCT DateOfBirth FROM PEEPS.dbo.tblCUSTOMER WHERE CustomerID = @P_PK)

EXEC InsertPassenger
@PFname = @PF,
@PLname  = @PL,
@PBirth = @PBDay,
@PTName = @PTN,
@MName = @MN

SET @RUN = @RUN -1
END

EXEC Wraper_insert_passenger 500000
select * from PASSENGER where PassengerFname = 'Anthony'
--debug
ALTER TABLE BOOKING
DROP CONSTRAINT FK__BOOKING__Passeng__7F2BE32F;
DELETE FROM PASSENGER
DBCC CHECKIDENT ('PASSENGER', RESEED, 0)
SELECT * FROM PASSENGER
--debug ends

--insert data to CABIN

select * from SHIP
GO

INSERT INTO CABIN(CabinName, CabinDescr)
VALUES('Interior rooms', 'Small interior rooms are the most budget friendly on any cruise ship. Just keep in mind that they dont have windows to the sea'),
('Ocean view rooms', 'For those who want some sunlight and a glimpse of the ocean from their room, ocean views are a great compromise between the lower price of an interior room and the jump up to a full on balcony.'),
('Balcony rooms', 'Balcony rooms let you get a bit of fresh air from the comfort of your own room. That can be a blessing when you need a break from the lively vibes elsewhere on your cruise.'),
('Suites', 'If you are looking for luxury on your cruise, suites offer the most space and best room locations, often with separate living and sleeping areas. They generally feature large balconies, and extra amenities and perks. In other words, a suite can be considered the best cabin on any cruise ship.'),
('Outside rooms', 'These rooms feature a window or porthole with a view to the sea, often similarly sized to an inside cabin (or a bit larger). Outside cabins are also referred to as oceanview rooms')
GO


--INSERT DATA TO SHIP CABIN
Create PROCEDURE GetShipID
@SNamey varchar(100),
@SIDy INT OUTPUT

AS

SET @SIDy= (SELECT ShipID FROM SHIP WHERE ShipName = @SNamey)
GO

CREATE PROCEDURE GetCabinID
@CNamey varchar(50),
@CIDy INT OUTPUT

AS
SET @CIDy = (SELECT CabinID FROM CABIN WHERE CabinName = @CNamey)
GO

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

CREATE PROCEDURE Wraper_insert_CabinShip @RUN INT
AS

DECLARE @C_RowCount INT = (SELECT COUNT(*) FROM CABIN)
DECLARE @S_RowCount INT = (SELECT COUNT(*) FROM SHIP)

DECLARE @C_PK INT
DECLARE @S_PK INT

DECLARE @CN varchar(50)
DECLARE @SN varchar(50)

WHILE @RUN > 0

BEGIN
SET @C_PK = (SELECT RAND() * @C_RowCount + 1)
SET @CN = (SELECT CabinName FROM CABIN WHERE CabinID = @C_PK)

SET @S_PK = (SELECT RAND() * @S_RowCount + 1)
SET @SN = (SELECT ShipName FROM SHIP WHERE ShipID = @S_PK)

EXEC InsertCabinShip
@SName = @SN,
@CName = @CN

SET @RUN = @RUN -1
END

EXEC Wraper_insert_CabinShip 500000
GO


--Insert booking table
Create PROCEDURE GetPassengerID
@PFnamey varchar(50),
@PLnamey varchar(50),
@PDOBy date,
@PIDy INT OUTPUT

AS

SET @PIDy= (SELECT PassengerID FROM PASSENGER WHERE PassengerFname = @PFnamey
												AND PassengerLname = @PLnamey
												AND PassengerDOB = @PDOBy)
GO

CREATE PROCEDURE GetTripID_2
@TRNamey varchar(50),
@TEPNamey varchar(50),
@TDPNamey varchar(50),
@TBDaty date,
@TIDy INT OUTPUT

AS
SET @TIDy = (SELECT TripID FROM TRIP T
							JOIN ROUTES R on T.RouteID = R.RouteID
							JOIN PORT Pd on T.DisembarkPortID = Pd.PortID 
							JOIN PORT Pe on T.EmbarkPortID = Pe.PortID
						   WHERE R.RouteName = @TRNamey
						   AND Pd.PortName = @TDPNamey
						   AND Pe.PortName = @TEPNamey
						   AND T.TripBeginDate = @TBDaty)
GO
DROP PROCEDURE

--debug
SELECT TripID FROM TRIP T
				JOIN ROUTES R on T.RouteID = R.RouteID
				JOIN PORT Pd on T.DisembarkPortID = Pd.PortID 
				JOIN PORT Pe on T.EmbarkPortID = Pe.PortID
			  WHERE R.RouteName = 'SOU-SOU'
			  AND Pd.PortName = 'Villa Carlos Paz'
			  AND Pe.PortName = 'Saldanha'
			  AND T.TripBeginDate = '2016-08-23'
SELECT * FROM TRIP
SELECT * FROM PORT WHERE PortID = 141
SELECT * FROM ROUTES WHERE RouteID = 15

SELECT * FROM PASSENGER WHERE PassengerFname = 'Stephany' AND PassengerLname = 'Alesna' AND PassengerDOB = '1937-07-20'
--Find duplicates
SELECT PassengerFname, PassengerLname, PassengerDOB, COUNT(*) as count
FROM PASSENGER
GROUP BY PassengerFname, PassengerLname, PassengerDOB
HAVING COUNT(*) > 1
--delete duplicates
DELETE FROM PASSENGER
    WHERE PassengerID NOT IN
    (
		SELECT MAX(PassengerID)
        FROM PASSENGER
        GROUP BY PassengerFname, PassengerLname, PassengerDOB
	)

DROP PROCEDURE GetTripID_2
--debug end






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
DROP PROCEDURE InsertBooking

CREATE PROCEDURE Wraper_insert_Booking @RUN INT
AS

DECLARE @P_RowCount INT = (SELECT COUNT(*) FROM PASSENGER)
DECLARE @T_RowCount INT = (SELECT COUNT(*) FROM TRIP)

DECLARE @P_PK INT
DECLARE @T_PK INT

DECLARE @PFnamez varchar(50), @PLnamez varchar(50), @Pdobz date
DECLARE @TRNamez varchar(50), @TEPNamez varchar(50), @TDPNamez varchar(50), @TBDatz date

DECLARE @BDTz datetime, @Farez decimal(10, 2)

WHILE @RUN > 0

BEGIN
SET @P_PK = (SELECT RAND() * @P_RowCount + 1)
SET @PFnamez = (SELECT PassengerFname FROM PASSENGER WHERE PassengerID = @P_PK)
SET @PLnamez = (SELECT PassengerLname FROM PASSENGER WHERE PassengerID = @P_PK)
SET @Pdobz = (SELECT PassengerDOB FROM PASSENGER WHERE PassengerID = @P_PK)

SET @T_PK = (SELECT RAND() * @T_RowCount + 1)
SET @TRNamez = (SELECT R.RouteName FROM TRIP T
							JOIN ROUTES R on T.RouteID = R.RouteID
						  WHERE T.TripID = @T_PK)
SET @TEPNamez = (SELECT Pe.PortName FROM TRIP T
							JOIN Port Pe on T.EmbarkPortID = Pe.PortID
						  WHERE T.TripID = @T_PK)
SET @TDPNamez = (SELECT Pd.PortName FROM TRIP T
							JOIN Port Pd on T.DisembarkPortID = Pd.PortID
						  WHERE T.TripID = @T_PK)
SET @TBDatz = (SELECT TripBeginDate FROM TRIP WHERE TripID = @T_PK)

SET @BDTz = (SELECT GetDate() - (SELECT RAND() * 10000))
SET @Farez = (SELECT ROUND((SELECT RAND()*10000), 2))

EXEC InsertBooking
@PFname = @PFnamez,
@PLname = @PLnamez,
@PDOB = @Pdobz,
@TRName = @TRNamez,
@TEPName = @TEPNamez,
@TDPName = @TDPNamez,
@TBDate = @TBDatz,
@BDT = @BDTz,
@F = @Farez

SET @RUN = @RUN -1
END

EXEC Wraper_insert_Booking 500000
GO

SELECT * FROM BOOKING
DELETE FROM BOOKING
DBCC CHECKIDENT ('Booking', RESEED, 0)



--Insert data to REVIEW
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
@TBD DATE, 
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
@TBDate DATE, 
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

BEGIN TRANSACTION T1
INSERT INTO REVIEW (BookingID, RatingID, ReviewTitle, ReviewContent, ReviewDate)
VALUES (@B_ID, @R_ID, @RTitle, @RContent, @RDate)
COMMIT TRANSACTION T1
GO 

--wrapper for inserting review
CREATE PROCEDURE populateReviewWrapper
@RUN INT 
AS 

DECLARE @FN VARCHAR(50), @LN VARCHAR(50), @BDate DATE, @RNum INT, @TBDate DATE, @ReviewDate DATE, @RouteN VARCHAR(50)
DECLARE @RouteRowCount INT = (SELECT COUNT(*) FROM ROUTES)
DECLARE @PassRowCount INT = (SELECT COUNT(*) FROM PASSENGER)
DECLARE @R_PK INT, @P_PK INT

WHILE @RUN > 0
BEGIN 
SET @R_PK = (SELECT RAND() * @RouteRowCount + 1)
SET @P_PK = (SELECT RAND() * @PassRowCount + 1)
SET @FN = (SELECT PassengerFname FROM PASSENGER WHERE PassengerID = @P_PK)
SET @LN = (SELECT PassengerLname FROM PASSENGER WHERE PassengerID = @P_PK)
SET @BDate = (SELECT PassengerDOB FROM PASSENGER WHERE PassengerID = @P_PK)
SET @RouteN = (SELECT RouteName FROM ROUTES WHERE RouteID = @R_PK)
SET @TBDate = (SELECT GETDATE() - (RAND() * 100))
SET @ReviewDate = (SELECT GETDATE() - (RAND() * 100))
SET @RNum = (SELECT RAND() * 4 + 1)

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

EXEC populateReviewWrapper 500000

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

--insert DATA to BOOK_CABIN


Create PROCEDURE GetBookingID_2
@PFname_b varchar(50),
@PLname_b varchar(50),
@PDOB_b date,
@TRName_b varchar(50),
@TEPName_b varchar(50),
@TDPName_b varchar(50),
@TBDate_b date,
@BDT_b Datetime,
@F_b decimal(10, 2),
@BIDy INT OUTPUT

AS

SET @BIDy= (SELECT BookingID FROM BOOKING B
								JOIN PASSENGER P on B.PassengerID = P.PassengerID
								JOIN TRIP T on B.TripID = T.TripID
								JOIN ROUTES R on T.RouteID = R.RouteID
								JOIN PORT Pe on T.EmbarkPortID = Pe.PortID
								JOIN PORT Pd on T.DisembarkPortID = Pe.PortID
							  WHERE P.PassengerFname = @PFname_b 
								AND P.PassengerLname = @PLname_b
								AND P.PassengerDOB = @PDOB_b
								AND R.RouteName = @TRName_b
								AND Pe.PortName = @TEPName_b
								AND Pd.PortName = @TDPName_b
								AND T.TripBeginDate = @TBDate_b
								AND B.BookDateTime = @BDT_b
								AND B.Fare = @F_b)
GO

CREATE PROCEDURE InsertBookCabin
@PFname_bc varchar(50),
@PLname_bc varchar(50),
@PDOB_bc date,
@TRName_bc varchar(50),
@TEPName_bc varchar(50),
@TDPName_bc varchar(50),
@TBDate_bc date,
@BDT_bc Datetime,
@F_bc decimal(10, 2),
@CName_bc varchar(50)


AS

DECLARE @B_ID INT, @C_ID INT

EXEC GetBookingID_2
@PFname_b = @PFname_bc,
@PLname_b = @PLname_bc,
@PDOB_b = @PDOB_bc,
@TRName_b = @TRName_bc,
@TEPName_b = @TEPName_bc,
@TDPName_b = @TDPName_bc,
@TBDate_b = @TBDate_bc,
@BDT_b = @BDT_bc,
@F_b = @F_bc,
@BIDy = @B_ID OUTPUT

IF @B_ID is null
	BEGIN
		PRINT '@B_ID returns null, something is wrong with the data';
		THROW 55001, '@B_ID cannot be null. Terminating the process', 1;
	END

EXEC GetCabinID
@CNamey = @CName_bc,
@CIDy = @C_ID OUTPUT

IF @C_ID is null
	BEGIN
		PRINT '@C_ID returns null, something is wrong with the data';
		THROW 55001, '@C_ID cannot be null. Terminating the process', 1;
	END

BEGIN TRANSACTION T1
INSERT INTO BOOK_CABIN(BookingID, CabinID)
VALUES (@B_ID, @C_ID)
COMMIT TRANSACTION T1
GO


CREATE PROCEDURE Wraper_insert_BookCabin @RUN INT
AS

DECLARE @B_RowCount INT = (SELECT COUNT(*) FROM BOOKING)
DECLARE @C_RowCount INT = (SELECT COUNT(*) FROM CABIN)

DECLARE @B_PK INT
DECLARE @C_PK INT

DECLARE @PFnamez_bcw varchar(50), @PLnamez_bcw varchar(50), @Pdobz_bcw date
DECLARE @TRNamez_bcw varchar(50), @TEPName_bcw varchar(50), @TDPNamez_bcw varchar(50), @TBDatz_bcw date
DECLARE @BDTz_bcw datetime, @Farez_bcw decimal(10, 2)

DECLARE @CNamez_bcw varchar(50)

WHILE @RUN > 0

BEGIN
SET @B_PK = (SELECT RAND() * @B_RowCount + 1)
SET @PFnamez_bcw = (SELECT P.PassengerFname FROM BOOKING B
											 JOIN PASSENGER P on B.PassengerID = P.PassengerID
											 WHERE B.BookingID = @B_PK)
SET @PLnamez_bcw = (SELECT P.PassengerLname FROM BOOKING B
											 JOIN PASSENGER P on B.PassengerID = P.PassengerID
											 WHERE B.BookingID = @B_PK)
SET @Pdobz_bcw = (SELECT P.PassengerDOB FROM BOOKING B
											 JOIN PASSENGER P on B.PassengerID = P.PassengerID
											 WHERE B.BookingID = @B_PK)
SET @TRNamez_bcw = (SELECT R.RouteName FROM BOOKING B
									JOIN TRIP T on B.TripID = T.TripID
									JOIN ROUTES R on T.RouteID = R.RouteID
								   WHERE B.BookingID = @B_PK)
SET @TEPName_bcw = (SELECT Pe.PortName FROM BOOKING B
									JOIN TRIP T on B.TripID = T.TripID
									JOIN Port Pe on T.EmbarkPortID = Pe.PortID
									WHERE B.BookingID = @B_PK)
SET @TDPNamez_bcw = (SELECT Pd.PortName FROM BOOKING B
										 JOIN TRIP T on B.TripID = T.TripID
										 JOIN Port Pd on T.DisembarkPortID = Pd.PortID
									WHERE B.BookingID = @B_PK)
SET @TBDatz_bcw = (SELECT T.TripBeginDate FROM BOOKING B
										 JOIN TRIP T on B.TripID = T.TripID
										WHERE B.BookingID = @B_PK)

SET @BDTz_bcw = (SELECT BookDateTime FROM BOOKING WHERE BookingID = @B_PK)
SET @Farez_bcw = (SELECT Fare FROM BOOKING WHERE BookingID = @B_PK)

SET @C_PK = (SELECT RAND() * @C_RowCount + 1)
SET @CNamez_bcw = (SELECT CabinName FROM CABIN WHERE CabinID = @C_PK)

EXEC InsertBookCabin
@PFname_bc = @Pdobz_bcw,
@PLname_bc = @PLnamez_bcw,
@PDOB_bc = @Pdobz_bcw,
@TRName_bc  = @TRNamez_bcw,
@TEPName_bc = @TEPName_bcw,
@TDPName_bc = @TDPNamez_bcw,
@TBDate_bc = @TBDatz_bcw,
@BDT_bc = @BDTz_bcw,
@F_bc = @Farez_bcw,
@CName_bc = @CNamez_bcw

SET @RUN = @RUN -1
END

EXEC Wraper_insert_BookCabin 500000

SELECT COUNT(*) FROM PASSENGER
