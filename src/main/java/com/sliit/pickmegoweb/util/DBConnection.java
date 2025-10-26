package com.sliit.pickmegoweb.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // connection URL for the SQLEXPRESS named instance

    private static final String DB_URL = "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=PickMeGoDB;trustServerCertificate=true;";

    // Use SQL Server Authentication credentials
    private static final String USER = "Thumula";
    private static final String PASSWORD = "1234";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            // Use DriverManager to connect with the updated URL, username, and password
            return DriverManager.getConnection(DB_URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new SQLException("SQL Server JDBC Driver not found.");
        }
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}