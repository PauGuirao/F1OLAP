package Controller;

import Model.Model;
import Model.Settings;

import java.sql.*;
import java.util.ArrayList;

public class Controller {

    private Connection remoteConnection;
    private Connection localConnection;

    public boolean startRemoteConnection(){
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            remoteConnection = DriverManager.getConnection("jdbc:mysql://puigpedros.salleurl.edu/?user=" + Settings.REMOTEUSER + "&password=" + Settings.REMOTEPASSWORD + "&serverTimezone=UTC");
            return true;
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }

    public boolean startLocalConnection(){
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            localConnection = DriverManager.getConnection("jdbc:mysql://localhost:3306/F1_OLTP?allowPublicKeyRetrieval=true&useSSL=false", "root", "2112");
            return true;
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }

    public void loadDataBaseInfo(String tableName,Model model) throws SQLException {
        ResultSet rs;
        Statement stmt;

        System.out.println("Reading remote info");

        stmt = remoteConnection.createStatement();
        stmt.executeQuery("USE F1");


        //buidem la taula de la base local
        PreparedStatement localSt = localConnection.prepareStatement("delete from " + tableName + ";");
        localSt.executeUpdate();


        //select de les dades de la base remota
        PreparedStatement remoteSt = remoteConnection.prepareStatement("select * from " + tableName + ";");
        rs = remoteSt.executeQuery();

        //extraiem la metadata i d'alla el numero de columnes
        ResultSetMetaData rsmd = rs.getMetaData();
        int col = rsmd.getColumnCount();

        //Model modelExample;
        while (rs.next()) {
            String insert = fabricarString(tableName, col);

            System.out.println("UPDATE: " + localSt);

            localSt = localConnection.prepareStatement(insert);

            for(int i=1;i<=col;i++){
                //inserim el valor de cada columna respectivament dins del update
                localSt.setString(i,rs.getString(i));
            }
            //executem el update
            localSt.executeUpdate();


        }
        rs.close();
        stmt.close();

    }

    private static String fabricarString(String table, int col) {
        String insert = "insert into " + table + " values(";

        for(int i=1;i<=col;i++){
            //fem la string modular segons el numero de columnes
            insert = insert + "?,";
        }
        //eliminem la ultima coma
        insert = esborraUltimChar(insert);
        //completem la string del update
        insert = insert + ");";
        return insert;
    }

    private static String esborraUltimChar(String str) {
        return str.substring(0, str.length() - 1);
    }

}
