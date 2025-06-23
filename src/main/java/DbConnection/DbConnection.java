package DbConnection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import Utilities.ConfigUtil;

public class DbConnection {
    private static String SERVER_NAME;
    private static String DB_NAME;
    private static String PORT_NUMBER;
    private static String INSTANCE_NAME;
    private static String USER_ID;
    private static String PASSWORD;

    static {
        loadDatabaseProperties();
    }

    private static void loadDatabaseProperties() {
        SERVER_NAME = ConfigUtil.getProperty("db.server");
        DB_NAME = ConfigUtil.getProperty("db.name");
        PORT_NUMBER = ConfigUtil.getProperty("db.port");
        INSTANCE_NAME = ConfigUtil.getProperty("db.instance", "");
        USER_ID = ConfigUtil.getProperty("db.user");
        PASSWORD = ConfigUtil.getProperty("db.password");
    }

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        String url = "jdbc:sqlserver://" + SERVER_NAME + ":" + PORT_NUMBER
                + ";databaseName=" + DB_NAME
                + ";encrypt=true;trustServerCertificate=true";
        if (!INSTANCE_NAME.isEmpty()) {
            url += ";instance=" + INSTANCE_NAME;
        }

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection(url, USER_ID, PASSWORD);
            return conn;
        } catch (ClassNotFoundException | SQLException e) {
            throw e;
        }
    }

    public static void closeConnection(Connection connection) {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
