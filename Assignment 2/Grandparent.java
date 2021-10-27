import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Grandparent extends Persons {
    String type = "Grandparent";
    Persons person;
    List<Persons> grandparents = new ArrayList<>();

    public Grandparent(Connection connection, Persons person) {
        this.person = person;
        try {
            ResultSet results = FamilyRelations.getGrandparents(connection, person);
            while (results.next()) {
                grandparents.add(new Persons(results.getInt("id"), type, results.getString("Name"), results.getString("Sex")));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
    }

    public List<Persons> getGrandparents() { return this.grandparents; }

    @Override
    public String toString() {
        String output = String.format("The grandparents of %s:\n", this.person.getName());
        for (Persons P : getGrandparents())
            output += P.getName() + "\n";
        return output;
    }

    public void print() { System.out.println(this.toString()); }
}