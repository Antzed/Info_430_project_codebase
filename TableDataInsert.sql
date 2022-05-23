--SELECT TOP 100 *
--FROM peeps.dbo.tblCUSTOMER

INSERT INTO PASSENGER_TYPE(PassengerTypeName)
VALUES('Adult'), ('Child'), ('Infant without a seat'), ('Infant with a seat'), ('Unaccompanied  child')

INSERT INTO MEMBERSHIP(MembershipName, MembershipDescr)
VALUES('Classic', 'default'), ('Silver', '1000 travel points'), ('Gold',  '10,000 travel points'), ('Diamond', '20,000 travel points'), ('Lifelong', '50,000 travel points')

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

populateTripCrew 100
GO