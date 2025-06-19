package DbConnection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConnection {
    private static final String SERVER_NAME = "sql.truongvu.id.vn";
    private static final String DB_NAME = "CGMS";
    private static final String PORT_NUMBER = "58833";
    private static final String INSTANCE_NAME = "";
    private static final String USER_ID = "admin";
    private static final String PASSWORD = "FMCSystem@1234";

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
