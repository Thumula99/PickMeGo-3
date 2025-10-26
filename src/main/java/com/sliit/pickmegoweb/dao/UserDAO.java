package com.sliit.pickmegoweb.dao;

import com.sliit.pickmegoweb.model.User;
import com.sliit.pickmegoweb.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

public class UserDAO {

    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT 1 FROM Users WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, email);
            try (ResultSet rs = statement.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean registerUser(User user) throws SQLException {
        // First try with vehicleType and vehicleName columns
        String sqlWithVehicle = "INSERT INTO Users (firstName, lastName, email, passwordHash, phoneNumber, role, vehicleType, vehicleName) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        String sqlWithoutVehicle = "INSERT INTO Users (firstName, lastName, email, passwordHash, phoneNumber, role) VALUES (?, ?, ?, ?, ?, ?)";

        boolean rowInserted = false;

        // First try with vehicleType column
        try (Connection con = DBConnection.getConnection();
             PreparedStatement statement = con.prepareStatement(sqlWithVehicle)) {
            statement.setString(1, user.getFirstName());
            statement.setString(2, user.getLastName());
            statement.setString(3, user.getEmail());
            statement.setString(4, user.getPassword());
            statement.setString(5, user.getPhoneNumber());
            statement.setString(6, user.getRole());

            // Set vehicleType and vehicleName for drivers, null for others
            if ("Driver".equals(user.getRole())) {
                statement.setString(7, user.getVehicleType());
                statement.setString(8, user.getVehicleName());
            } else {
                statement.setNull(7, java.sql.Types.VARCHAR);
                statement.setNull(8, java.sql.Types.VARCHAR);
            }

            rowInserted = statement.executeUpdate() > 0;
        } catch (SQLException e) {
            // If the column doesn't exist, try without vehicleType and vehicleName
            if (e.getMessage().contains("vehicleType") || e.getMessage().contains("vehicleName")) {
                try (Connection con = DBConnection.getConnection();
                     PreparedStatement statement = con.prepareStatement(sqlWithoutVehicle)) {
                    statement.setString(1, user.getFirstName());
                    statement.setString(2, user.getLastName());
                    statement.setString(3, user.getEmail());
                    statement.setString(4, user.getPassword());
                    statement.setString(5, user.getPhoneNumber());
                    statement.setString(6, user.getRole());

                    rowInserted = statement.executeUpdate() > 0;
                }
            } else {
                throw e;
            }
        }
        return rowInserted;
    }

    public User loginUser(String email, String password) throws SQLException {
        String sql = "SELECT * FROM Users WHERE email = ? AND passwordHash = ?";
        User user = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, email);
            statement.setString(2, password);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    user = new User();
                    user.setId(resultSet.getInt("UserID"));
                    user.setFirstName(resultSet.getString("firstName"));
                    user.setLastName(resultSet.getString("lastName"));
                    user.setEmail(resultSet.getString("email"));
                    user.setPassword(resultSet.getString("passwordHash"));
                    user.setPhoneNumber(resultSet.getString("phoneNumber"));
                    user.setRole(resultSet.getString("role"));

                    // Try to get vehicleType, but handle if column doesn't exist
                    try {
                        user.setVehicleType(resultSet.getString("vehicleType"));
                    } catch (SQLException e) {
                        if (e.getMessage().contains("vehicleType")) {
                            user.setVehicleType("Car"); // Default value
                        } else {
                            throw e;
                        }
                    }
                    
                    // Try to get vehicleName, but handle if column doesn't exist
                    try {
                        user.setVehicleName(resultSet.getString("vehicleName"));
                    } catch (SQLException e) {
                        if (e.getMessage().contains("vehicleName")) {
                            user.setVehicleName(""); // Default empty value
                        } else {
                            throw e;
                        }
                    }
                }
            }
        }
        return user;
    }

    public List<User> getAllUsers() throws SQLException {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT * FROM Users";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement statement = con.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                User user = new User();
                user.setId(resultSet.getInt("UserID"));
                user.setFirstName(resultSet.getString("firstName"));
                user.setLastName(resultSet.getString("lastName"));
                user.setEmail(resultSet.getString("email"));
                user.setPhoneNumber(resultSet.getString("phoneNumber"));
                user.setRole(resultSet.getString("role"));

                // Try to get vehicleType, but handle if column doesn't exist
                try {
                    user.setVehicleType(resultSet.getString("vehicleType"));
                } catch (SQLException e) {
                    if (e.getMessage().contains("vehicleType")) {
                        user.setVehicleType("Car"); // Default value
                    } else {
                        throw e;
                    }
                }

                userList.add(user);
            }
        }
        return userList;
    }
    
    public List<User> getDriversByVehicleType(String vehicleType) throws SQLException {
        List<User> driverList = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role = 'Driver' AND LOWER(vehicleType) = LOWER(?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, vehicleType);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    User user = new User();
                    user.setId(resultSet.getInt("UserID"));
                    user.setFirstName(resultSet.getString("firstName"));
                    user.setLastName(resultSet.getString("lastName"));
                    user.setEmail(resultSet.getString("email"));
                    user.setPhoneNumber(resultSet.getString("phoneNumber"));
                    user.setRole(resultSet.getString("role"));
                    
                    // Try to get vehicleType, but handle if column doesn't exist
                    try {
                        user.setVehicleType(resultSet.getString("vehicleType"));
                    } catch (SQLException e) {
                        if (e.getMessage().contains("vehicleType")) {
                            user.setVehicleType("Car"); // Default value
                        } else {
                            throw e;
                        }
                    }
                    
                    driverList.add(user);
                }
            }
        }
        return driverList;
    }
    
    public User getUserById(int userId) throws SQLException {
        String sql = "SELECT * FROM Users WHERE UserID = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, userId);
            ResultSet resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                User user = new User();
                user.setId(resultSet.getInt("UserID"));
                user.setFirstName(resultSet.getString("firstName"));
                user.setLastName(resultSet.getString("lastName"));
                user.setEmail(resultSet.getString("email"));
                user.setPhoneNumber(resultSet.getString("phoneNumber"));
                user.setRole(resultSet.getString("role"));
                
                // Handle vehicleType column (may not exist)
                try {
                    user.setVehicleType(resultSet.getString("vehicleType"));
                } catch (SQLException e) {
                    if (e.getMessage().contains("vehicleType")) {
                        user.setVehicleType("Car"); // Default value
                    } else {
                        throw e;
                    }
                }
                
                return user;
            }
        }
        return null;
    }

    // Update user details
    public boolean updateUser(User user) throws SQLException {
        System.out.println("UserDAO.updateUser called for user ID: " + user.getId());
        
        // Try with vehicleName column first
        String sqlWithVehicleName = "UPDATE Users SET firstName = ?, lastName = ?, email = ?, phoneNumber = ?, vehicleType = ?, vehicleName = ? WHERE UserID = ?";
        String sqlWithoutVehicleName = "UPDATE Users SET firstName = ?, lastName = ?, email = ?, phoneNumber = ?, vehicleType = ? WHERE UserID = ?";
        
        boolean rowUpdated = false;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement statement = con.prepareStatement(sqlWithVehicleName)) {
            System.out.println("Trying SQL with vehicleName column");
            statement.setString(1, user.getFirstName());
            statement.setString(2, user.getLastName());
            statement.setString(3, user.getEmail());
            statement.setString(4, user.getPhoneNumber());
            statement.setString(5, user.getVehicleType());
            statement.setString(6, user.getVehicleName());
            statement.setInt(7, user.getId());
            
            System.out.println("Executing update with vehicleName column");
            rowUpdated = statement.executeUpdate() > 0;
            System.out.println("Update with vehicleName result: " + rowUpdated);
        } catch (SQLException e) {
            System.out.println("SQL Exception with vehicleName: " + e.getMessage());
            // If vehicleName column doesn't exist, try without it
            if (e.getMessage().contains("vehicleName")) {
                System.out.println("Trying SQL without vehicleName column");
                try (Connection con = DBConnection.getConnection();
                     PreparedStatement statement = con.prepareStatement(sqlWithoutVehicleName)) {
                    statement.setString(1, user.getFirstName());
                    statement.setString(2, user.getLastName());
                    statement.setString(3, user.getEmail());
                    statement.setString(4, user.getPhoneNumber());
                    statement.setString(5, user.getVehicleType());
                    statement.setInt(6, user.getId());
                    
                    System.out.println("Executing update without vehicleName column");
                    rowUpdated = statement.executeUpdate() > 0;
                    System.out.println("Update without vehicleName result: " + rowUpdated);
                }
            } else {
                System.out.println("Different SQL exception, rethrowing: " + e.getMessage());
                throw e;
            }
        }
        return rowUpdated;
    }
    
    // Delete user account (soft delete - mark as inactive)
    public boolean deleteUser(int userId) throws SQLException {
        String sql = "UPDATE Users SET isActive = 0 WHERE UserID = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, userId);
            return statement.executeUpdate() > 0;
        }
    }
    
    // Hard delete user (cascading delete - removes all related data)
    public boolean hardDeleteUser(int userId) throws SQLException {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Start transaction
            
            // Delete related records first
            deleteUserFeedbacks(con, userId);
            deleteUserTrips(con, userId);
            deleteUserIncidents(con, userId);
            deleteUserNotifications(con, userId);
            deleteUserWatchlist(con, userId);
            
            // Finally delete the user
            String sql = "DELETE FROM Users WHERE UserID = ?";
            try (PreparedStatement statement = con.prepareStatement(sql)) {
                statement.setInt(1, userId);
                int result = statement.executeUpdate();
                
                if (result > 0) {
                    con.commit(); // Commit transaction
                    return true;
                } else {
                    con.rollback(); // Rollback if no user found
                    return false;
                }
            }
        } catch (SQLException e) {
            if (con != null) {
                con.rollback(); // Rollback on error
            }
            throw e;
        } finally {
            if (con != null) {
                con.setAutoCommit(true); // Reset auto-commit
                con.close();
            }
        }
    }
    
    // Helper methods to delete related records
    private void deleteUserFeedbacks(Connection con, int userId) throws SQLException {
        String sql = "DELETE FROM Feedbacks WHERE CustomerID = ?";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.executeUpdate();
        }
    }
    
    private void deleteUserTrips(Connection con, int userId) throws SQLException {
        String sql = "DELETE FROM Trips WHERE CustomerID = ? OR DriverID = ?";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setInt(2, userId);
            statement.executeUpdate();
        }
    }
    
    private void deleteUserIncidents(Connection con, int userId) throws SQLException {
        String sql = "DELETE FROM Incidents WHERE DriverID = ?";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.executeUpdate();
        }
    }
    
    private void deleteUserNotifications(Connection con, int userId) throws SQLException {
        String sql = "DELETE FROM Notifications WHERE DriverID = ? OR CustomerID = ?";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setInt(2, userId);
            statement.executeUpdate();
        }
    }
    
    private void deleteUserWatchlist(Connection con, int userId) throws SQLException {
        String sql = "DELETE FROM DriverWatchlist WHERE DriverID = ? OR AdminID = ?";
        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setInt(2, userId);
            statement.executeUpdate();
        }
    }
    
    // Get user count
    public int getUserCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement statement = con.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        }
        return 0;
    }
    
    // Get users by role
    public List<User> getUsersByRole(String role) throws SQLException {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, role);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    User user = new User();
                    user.setId(resultSet.getInt("UserID"));
                    user.setFirstName(resultSet.getString("firstName"));
                    user.setLastName(resultSet.getString("lastName"));
                    user.setEmail(resultSet.getString("email"));
                    user.setPhoneNumber(resultSet.getString("phoneNumber"));
                    user.setRole(resultSet.getString("role"));
                    
                    // Handle vehicleType column (may not exist)
                    try {
                        user.setVehicleType(resultSet.getString("vehicleType"));
                    } catch (SQLException e) {
                        if (e.getMessage().contains("vehicleType")) {
                            user.setVehicleType("Car"); // Default value
                        } else {
                            throw e;
                        }
                    }
                    
                    userList.add(user);
                }
            }
        }
        return userList;
    }
    
    // Create user (for admin)
    public boolean createUser(User user) throws SQLException {
        return registerUser(user);
    }
    
    // Update user role
    public boolean updateUserRole(int userId, String newRole) throws SQLException {
        String sql = "UPDATE Users SET role = ? WHERE UserID = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, newRole);
            statement.setInt(2, userId);
            return statement.executeUpdate() > 0;
        }
    }
}