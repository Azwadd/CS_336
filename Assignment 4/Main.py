import geopy
import pyodbc


def getServer():
    return pyodbc.connect(r'Driver=SQL Server;'
                          r'Server=(local);'
                          r'Database=master;'
                          r'Trusted_Connection=yes;')


def getZipcodes(connection):
    geolocator = geopy.Nominatim(user_agent='ReverseGeoCode')
    lat, long, zips = [], [], []
    # Query for all the latitudes and longitudes
    cursor = connection.cursor().execute("SELECT LATITUDE, LONGITUDE FROM STATIONS")
    # For every latitude and longitude find the correlating zipcode
    while True:
        row = cursor.fetchone()
        if not row:
            break
        else:
            lat.append(row[0])
            long.append(row[1])
            # Converts the raw address into a list where one of the elements is the zipcode
            address = geolocator.reverse(str(row)[1:-1:]).address.split(", ")
            # Selects only the zipcode from the raw address
            zips.append(address[len(address) - 2][0:5])
    cursor.close()
    return lat, long, zips


def updateZipcodes(connection, lat, long, zips):
    # Check if ZIPCODE column exists in table
    cursor = connection.cursor()
    cursor.execute("SELECT TOP(1) * FROM dbo.Stations")
    columns = [desc[0] for desc in cursor.description]

    # if ZIPCODE column doesn't exist add the column to the table
    if 'ZIPCODE' not in columns:
        connection.cursor().execute("ALTER TABLE Stations ADD ZIPCODE INTEGER").commit()
    cursor.close()

    # Update the ZIPCODE column
    cursor = connection.cursor()
    for i in range(len(zips)):
        cursor.execute("UPDATE STATIONS SET ZIPCODE =" + zips[i] + " WHERE Latitude = " +
                       str(lat[i]) + " AND Longitude= " + str(long[i]))
        cursor.commit()
    cursor.close()


def maxZipcodeOccurrence(connection):
    cursor = connection.cursor()
    cursor.execute("SELECT Latitude ,Longitude FROM Stations " +
                   "WHERE ID = (SELECT StationID FROM Trips " +
                   "WHERE NumUsers = (SELECT MAX(NumUsers) FROM Trips))")
    data = cursor.fetchone()
    if not data:
        print("Error: Couldn't find latitude and longitude of the station")
        return -1
    geolocator = geopy.Nominatim(user_agent='ReverseGeoCode')
    address = geolocator.reverse(str(data)[1:-1:]).address.split(", ")
    zipcode = address[len(address) - 2][0:5]
    return zipcode


if __name__ == '__main__':
    server = getServer()
    latitudes, longitudes, zipcodes = getZipcodes(server)
    updateZipcodes(server, latitudes, longitudes, zipcodes)
    print(maxZipcodeOccurrence(server))
    # from collections import Counter
    # popular_zipcode = Counter(zipcodes)
    # print(popular_zipcode)
'''
40.72043411 -74.01020609
40.75828065 -73.97069431
40.75527307 -73.98316936
'''
