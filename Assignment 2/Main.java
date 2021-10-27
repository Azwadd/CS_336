import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

interface FamilyRelations {
    static Connection getConnection(String username, String password) {
        Properties connectionProperties = new Properties();
        connectionProperties.put("user", username);
        connectionProperties.put("password", password);
        Connection connection = null;
        try {
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/Family-Relations", connectionProperties);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
        return connection;
    }

    static ResultSet getChildren(Connection connection, Persons spouse1, Persons spouse2) throws SQLException {
        String sqlStatement = String.format("SELECT * FROM Persons WHERE Id IN (SELECT pid FROM Family WHERE fid = %s AND mid = %s OR " + "fid = %s " +
                        "AND mid = %s)", spouse1.getId(), spouse2.getId(), spouse2.getId(), spouse1.getId());
        return getResultSet(connection, sqlStatement);
    }

    static ResultSet getChildren(Connection connection, Persons parent) throws SQLException {
        String sqlStatement = String.format("SELECT Name AS 'Child', Sex FROM Persons P WHERE id IN\n" +
                "    (SELECT pid FROM FAMILY WHERE fid = %d OR mid = %d);", parent.getId(), parent.getId());
        return getResultSet(connection, sqlStatement);
    }

    static ResultSet getGrandparents(Connection connection, Persons person) {
        int Id = person.getId();
        String formatStr = "(SELECT Name FROM Person WHERE id IN " +
                "(SELECT %s FROM Family F2 WHERE F2.pid IN " +
                "(SELECT %s FROM Family F1 WHERE F1.pid = %d))) AS '%s'";
        String sqlStatement = String.format("SELECT Name AS 'Given Person', %s, %s, %s, %s FROM Person WHERE id = %d",
                String.format(formatStr, "fid", "fid", Id, "Paternal Grandfather"),
                String.format(formatStr, "mid", "fatherId", Id, "Paternal Grandmother"),
                String.format(formatStr, "fid", "motherId", Id, "Maternal Grandfather"),
                String.format(formatStr, "mid", "motherId", Id, "Maternal Grandmother"),
                Id);
        return getResultSet(connection, sqlStatement);
    }

    static ResultSet getNephews(Connection connection, Persons person) {
        int id = person.getId();
        String sqlStatement = "WITH V AS (SELECT A.pId FROM (SELECT * FROM FAMILY F1 WHERE F1.pid <> " + id + ") A, " +
                "(SELECT F2.fid, F2.mid FROM FAMILY F2 WHERE F2.pid = " + id + ") B WHERE A.fid = B.fid OR A.mid = B.mid) " +
                "SELECT * FROM PERSONS WHERE Sex = 'M' AND Id IN (SELECT F.pid FROM FAMILY F WHERE F.fid IN (SELECT pid FROM V) OR F.mid IN (SELECT pid FROM V))";
        return getResultSet(connection, sqlStatement);
    }

    static ResultSet getBrotherInLaw(Connection connection, Persons person) throws SQLException {
        String sqlStatement = "SELECT * FROM PERSONS WHERE id IN (SELECT bid FROM BROTHERINLAW WHERE id = " + person.getId();
        return getResultSet(connection, sqlStatement);
    }

    static ResultSet getResultSet(Connection connection, String sqlStatement) {
        ResultSet resultSet = null;
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sqlStatement);
            resultSet = preparedStatement.executeQuery();
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
        return resultSet;
    }

    static void main(String[] args)  {
        Connection connection = getConnection("root", "root");
        Persons person = new Persons();
        person.setRecord(connection, 24, "great grandfather", "M");
        person = person.getRecord(connection, 24);
        System.out.println(person.toString());
    }
}

