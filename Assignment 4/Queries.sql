-- Top 10 Most Frequent Trips Between Any Station
DECLARE @Day VARCHAR(9) = 'Monday';
SELECT TOP(10)NumberOfTrips FROM
    (SELECT StartStationID, EndStationID, COUNT(*) As 'NumberOfTrips' FROM CitiBike
        WHERE StartDay = @Day GROUP BY StartStationId, EndStationID) as TripCount ORDER BY NumberOfTrips desc;

-- Usage Pattern By Gender And Age
SELECT StationID, NumberOfMales, NumberOfFemales, Under18, Between18And40, Over40 FROM
    (SELECT A.StationID, A.NumberMaleUsers as 'NumberOfMales', A.NumberFemaleUsers as 'NumberOfFemales',
            B.NumberUsersUnder18 as 'Under18', B.NumberUsers18To40 as 'Between18And40', B.NumberUsersOver40 as 'Over40' FROM UsageByGender A, UsageByAge B
        WHERE A.StationID = B.StationID) as Pattern

-- Identify Any Dormant or Vacant Bike Stations
SELECT Vacant, Dormant FROM
    (SELECT DISTINCT A.StartStationID as 'Vacant', B.EndStationID 'Dormant' From CitiBike A, CitiBike B
        WHERE A.StartStationId NOT IN (SELECT EndStationID FROM CitiBike) AND B.EndStationID NOT IN (SELECT StartStationID FROM CitiBike)) as VacantAndDormant