USE group5_INFO430 
GO

INSERT INTO PASSENGER_TYPE(PassengerTypeName)
VALUES('Adult'), ('Child'), ('Infant without a seat'), ('Infant with a seat'), ('Unaccompanied  child')

INSERT INTO MEMBERSHIP(MembershipName, MembershipDescr)
VALUES('Classic', 'default'), ('Silver', '1000 travel points'), ('Gold',  '10,000 travel points'), ('Diamond', '20,000 travel points'), ('Lifelong', '50,000 travel points')
GO



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
SET @PF = (SELECT CustomerFname FROM PEEPS.dbo.tblCUSTOMER WHERE CustomerID = @P_PK)
SET @PL = (SELECT CustomerLname FROM PEEPS.dbo.tblCUSTOMER WHERE CustomerID = @P_PK)
SET @PBDay = (SELECT DateOfBirth FROM PEEPS.dbo.tblCUSTOMER WHERE CustomerID = @P_PK)

EXEC InsertPassenger
@PFname = @PF,
@PLname  = @PL,
@PBirth = @PBDay,
@PTName = @PTN,
@MName = @MN

SET @RUN = @RUN -1
END

EXEC Wraper_insert_passenger 100000

--insert data to CABIN

select * from  SHIP

Create PROCEDURE GetShipID
@