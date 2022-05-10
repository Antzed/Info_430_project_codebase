USE group5_INFO430 
GO

CREATE TABLE PASSENGER_TYPE
(PassengerTypeID INTEGER IDENTITY(1,1) primary key,
PassengerTypeName varchar(50) Not null,
PassengerTypeDescr varchar(500) null,
 )
 GO


CREATE TABLE MEMBERSHIP
(MembershipID INTEGER IDENTITY(1,1) primary key,
MembershipName varchar(50) not null,
MembershipDescr varchar(500) not null,
)
GO

CREATE TABLE PASSENGER
(PassengerID INTEGER IDENTITY(1,1) primary key,
PassengerTypeID INT NOT NULL FOREIGN KEY REFERENCES PASSENGER_TYPE(PassengerTypeID),
MembershipID INT NOT NULL FOREIGN KEY REFERENCES MEMBERSHIP(MembershipID),
PassengerFname varchar(50) not null,
PassengerLname varchar(50) not null,
PassengerDOB Date not null
 )
 GO


 CREATE TABLE BOOKING
 (BookingID INTEGER IDENTITY(1,1) primary key,
 PassengerID INT NOT NULL FOREIGN KEY REFERENCES PASSENGER(PassengerID),
 TripID INT NOT NULL FOREIGN KEY REFERENCES TRIP(TripID),
 BookDateTime DateTime not null,
 Fare decimal(10, 2) not null
 )
 GO

 CREATE TABLE CABIN
 (CabinID INTEGER IDENTITY(1,1) primary key,
 ShipID INT NOT NULL FOREIGN KEY REFERENCES SHIP(ShipID),
 CabinName varchar(50) not null,
 CabinDescr varchar(500) null,
 )
 GO

 CREATE TABLE BOOK_CABIN
 (BookCabin INTEGER IDENTITY(1,1) primary key,
 BookingID INT NOT NULL FOREIGN KEY REFERENCES BOOKING(BookingID),
 CabinID INT NOT NULL FOREIGN KEY REFERENCES CABIN(CabinID),
 )
 GO

 CREATE TABLE FACILITY_TYPE
(FacilityTypeID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
FacilityTypeName varchar(50) NOT NULL,
FacilityTypeDescr varchar(225) NOT NULL)
GO
 
CREATE TABLE FACILITY
(FacilityID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
FacilityTypeID INT FOREIGN KEY REFERENCES FACILITY_TYPE(FacilityTypeID) NOT NULL,
FacilityName varchar(50) NOT NULL,
FacilityDescr varchar(225) NOT NULL,
FacilityFee Numeric(8, 2) NOT NULL)
GO
 
CREATE TABLE SHIP_TYPE
(ShipTypeID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
ShipTypeName varchar(50) NOT NULL,
ShipTypeDescr varchar(225) NOT NULL)
GO
 
CREATE TABLE SHIP
(ShipID INT IDENTITY(1,1) PRIMARY KEY,
ShipTypeID INT FOREIGN KEY REFERENCES SHIP_TYPE(ShipTypeID) NOT NULL,
ShipName varchar(100) NOT NULL,
ShipDescr varchar(225) NOT NULL,
CabinCount INT NOT NULL,
YearLaunch char(4) NOT NULL,
Tonnage INT NOT NULL,
Capacity INT NOT NULL)
GO
 
CREATE TABLE SHIP_FACILITY
(ShipFacilityID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
ShipID INT FOREIGN KEY REFERENCES SHIP(ShipID) NOT NULL,
FacilityID INT FOREIGN KEY REFERENCES FACILITY(FacilityID) NOT NULL)



