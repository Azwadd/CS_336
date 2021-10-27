import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BrotherInLaw extends Persons {
    String type = "Brother In Law";
    Persons person;
    List<Persons> BrotherInLaws = new ArrayList<>();

    public BrotherInLaw(Connection connection, Persons person) {
        this.person = person;
        try {
            ResultSet results = FamilyRelations.getBrotherInLaw(connection, person);
            while (results.next()) {
                BrotherInLaws.add(new Persons(results.getInt("id"), type, results.getString("Name"), results.getString("Sex")));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
    }

    public List<Persons> getBrotherInLaw() { return this.BrotherInLaws; }
    @Override
    public String toString() {
        String output = String.format("The brother in law of %s:\n", this.person.getName());
        for (Persons P : getBrotherInLaw())
            output += P.getName() + "\n";
        return output;
    }

    public void print() { System.out.println(this.toString()); }
}