import geopy
import pyodbc


def getServer():
    return pyodbc.connect(r'Driver=SQL Server;'
                          r'Server=(local);'
                          r'Database=master;'
                          r'Trusted_Connection=yes;')


def getZipcodes(connection):
    latitude, longitude, zipcode = [], [], []
    cursor = connection.cursor()
    try:
        # For every latitude and longitude add a zipcode into stations table
        cursor.execute("SELECT LATITUDE, LONGITUDE FROM STATIONS")
        geolocator = geopy.Nominatim(user_agent='ReverseGeoCode')
        while True:
            row = cursor.fetchone()
            if not row:
                break
            else:
                # Converts the raw address into a list where one of the elements is the zipcode
                address = geolocator.reverse(str(row)[1:-1:]).address.split(", ")
                # Selects only the zipcode from the raw address
                zipcode = address[len(address) - 2][0:5]
                latitude.append(str(row[0]))
                longitude.append(str(row[1]))
                zipcode.append(zipcode)
    except AttributeError:
        print("Error")
    finally:
        cursor.close()
    return latitude, longitude, zipcode


def updateZipcodes(connection, latitude, longitude, zipcode):
    # Checking if ZIPCODE column exists
    cursor = connection.cursor()
    try:
        cursor.execute("ALTER TABLE Stations ADD ZIPCODE INTEGER").commit()
    except Exception:
        pass
    finally:
        cursor.close()
    # Update ZIPCODE column
    cursor = connection.cursor()
    try:
        for i in range(len(zipcode)):
            cursor.execute("UPDATE STATIONS SET ZIPCODE = " + zipcode[i] +
                           " WHERE Latitude = " + latitude[i] +
                           " AND Longitude = " + longitude[i]).commit()
    except AttributeError:
        print("Error: attributes don't match")
    finally:
        cursor.close()


# def popularZipcode(connection, zipcode):
#     postalcode = set(zipcode)
#     zipcode = list(postalcode   )
#     mostPopularZipcode, maxNumberOfUsers = 0, 0
#     for i in zipcode:
#         cursor = connection.cursor()
#         cursor.execute("SELECT NumUsers FROM Trips " +
#                        "WHERE stationID IN (SELECT ID FROM Stations WHERE ZIPCODE = " + i + ")")
#         users = list(cursor.fetchall())
#         sum = 0
#         for j in users:
#             sum += j[0]
#         if sum > maxNumberOfUsers:
#             mostPopularZipcode = i
#             maxNumberOfUsers = sum
#         cursor.close()
#     return mostPopularZipcode, maxNumberOfUsers
def popularZipcode(connection, zipcode):
    zipcode = list(set(zipcode))
    map = {}
    for i in zipcode:
        cursor = connection.cursor()
        cursor.execute("SELECT NumUsers FROM Trips " +
                       "WHERE stationID IN (SELECT ID FROM Stations WHERE ZIPCODE = " + i + ")")
        users = list(cursor.fetchall())
        sum = 0
        for j in users:
            sum += j[0]
        map[i] = sum
        cursor.close()
    return map


if __name__ == '__main__':
    server = getServer()
    latitudes, longitudes, zipcodes = getZipcodes(server)
    # updateZipcodes(server, latitudes, longitudes, zipcodes)
    test = popularZipcode(server, zipcodes)
    postalcode, max = 0,0
    for i in test:
        print(i, test[i])
        if test[i] > max:
            postalcode = i
            max = test[i]
    print(postalcode, max)
