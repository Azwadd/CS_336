SET @GLOBAL.local_infile = 1;
USE Transportation;

DROP TABLE IF EXISTS CitiBike;
CREATE TABLE CitiBike(
    TripDuration FLOAT,
    StartTime VARCHAR(30),
    StartDay VARCHAR(9) DEFAULT NULL,
    EndTime VARCHAR(30),
    EndDay VARCHAR(9),
    StartStationId INT,
    StartStationName VARCHAR(64),
    StartStationLatitude FLOAT,
    StartStationLongitude FLOAT,
    EndStation INT,
    EndStationName VARCHAR(64),
    EndStationLatitude FLOAT,
    EndStationLongitude FLOAT,
    BikeId INT,
    UserType VARCHAR(10),
    Birth VARCHAR(4),
    Gender INT
);

SELECT * FROM CitiBike;
#INSERT INTO CitiBike FROM 'data.txt'
#CREATE TABLE STATION(Id INT, Name VARCHAR(64), Latitude DOUBLE, Longitude DOUBLE)
#CREATE TABLE TRIPS(StationId INT, MinTripDuration, MaxTripDuration, AvgTripDuration, NumberUsers INT)
#UsageByDay(StationId, NumberUsersWeekday, NumberUsersWeekend)
#UsageByGender(StationId, NumberMaleUsers, NumberFemaleUsers)
#UsageByAge(StationId, NumberUsersUnder18, NumberUsers18To40, NumberUsersOver40)