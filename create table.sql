CREATE DATABASE anthoz3_project_temp
GO

USE anthoz3_project_temp
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



