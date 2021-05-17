import Controller.Controller;
import Model.Model;

import java.sql.SQLException;
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
        Controller mysqlController = new Controller();
        Model model = new Model();

        System.out.println("Connecting to Database...");
        if (!mysqlController.startRemoteConnection()) System.exit(1);
        if (!mysqlController.startLocalConnection()) System.exit(1);

        System.out.println("Getting info...");
        try {
            mysqlController.loadDataBaseInfo("circuits",model);
            mysqlController.loadDataBaseInfo("pitStops",model);
            mysqlController.loadDataBaseInfo("results",model);
            mysqlController.loadDataBaseInfo("status",model);
            mysqlController.loadDataBaseInfo("races",model);
            mysqlController.loadDataBaseInfo("drivers",model);
            mysqlController.loadDataBaseInfo("driverStandings",model);
            mysqlController.loadDataBaseInfo("constructors",model);
            mysqlController.loadDataBaseInfo("constructorStandings",model);
            mysqlController.loadDataBaseInfo("constructorResults",model);
            mysqlController.loadDataBaseInfo("qualifying",model);
            mysqlController.loadDataBaseInfo("seasons",model);
            mysqlController.loadDataBaseInfo("lapTimes",model);


        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("Tota la info actualitzada!");
    }
}
