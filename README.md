# F1OLAP
This project consits in adapt an OLTP Formula1 Database to an OLAP format and make some tests. Firstly we need to acces to a remote database in a remote server. Once the remote OLTP is we need to import it locally with a Java JDB. Next we need to create an OLAP local database and import the OLTP data with stored procedures. Finally we would realize 5 querys to check if everything is properly working

## Remote OLTP Database 
<img src="OLAP.png" alt="Example Render" width="500" height="500">
This is the remote database that we need to import locally.

## Relational Model OLAP Database
<img src="resources/PlayerInfo.png" alt="Example Render" width="500" height="300">
After analysing the OLTP databse we need to change orientation of our database for analtic pourposes and better performance. The way toa achieve that is using and OLAP structure. 

- Circuits, Laps, PitStops and Status tables keep being separate tables as in the OLTP
- Constructors, ConstructorResults, ConstructorStandings, Drivers, Qualify, Races, Seasons and Results merge in a single big table called Results
- By doing this structure Results table doesn't augment the number of rows in the original. If Drivers or Races were added the number of rows would be multiplied lowering the optiomization


## Extracting the Remote Database
-To extract the database we use a Java Application which follows the MVC(Model-View-Controller) structure. Firstly the controller controls the start and functionallity of the RemoteConnection and the LocalConnection

```java
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
```
