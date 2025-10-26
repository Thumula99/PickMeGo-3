package com.sliit.pickmegoweb.dao;

import com.sliit.pickmegoweb.model.DriverWatchlist;
import com.sliit.pickmegoweb.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DriverWatchlistDAO {

    // ------------------- ADD DRIVER TO WATCHLIST -------------------
    public boolean addDriverToWatchlist(int driverId, int adminId, String reason) {
        String sql = "INSERT INTO DriverWatchlist (DriverID, AdminID, Reason, Status, CreatedDate, UpdatedDate) VALUES (?, ?, ?, 'Active', GETDATE(), GETDATE())";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ps.setInt(2, adminId);
            ps.setString(3, reason);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("DEBUG: addDriverToWatchlist - rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("DEBUG: SQL Error in addDriverToWatchlist: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ------------------- REMOVE DRIVER FROM WATCHLIST -------------------
    public boolean removeDriverFromWatchlist(int watchlistId) {
        String sql = "UPDATE DriverWatchlist SET Status = 'Removed', UpdatedDate = GETDATE() WHERE WatchlistID = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, watchlistId);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("DEBUG: removeDriverFromWatchlist - rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("DEBUG: SQL Error in removeDriverFromWatchlist: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ------------------- GET ALL WATCHLIST ENTRIES -------------------
    public List<DriverWatchlist> getAllWatchlistEntries() {
        List<DriverWatchlist> watchlist = new ArrayList<>();
        String sql = "SELECT w.*, " +
                    "d.FirstName + ' ' + d.LastName as DriverName, d.Email as DriverEmail, " +
                    "a.FirstName + ' ' + a.LastName as AdminName " +
                    "FROM DriverWatchlist w " +
                    "INNER JOIN Users d ON w.DriverID = d.UserID " +
                    "INNER JOIN Users a ON w.AdminID = a.UserID " +
                    "WHERE w.Status = 'Active' " +
                    "ORDER BY w.CreatedDate DESC";
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                DriverWatchlist entry = extractWatchlistFromResultSet(rs);
                watchlist.add(entry);
            }
        } catch (SQLException e) {
            System.out.println("DEBUG: SQL Error in getAllWatchlistEntries: " + e.getMessage());
            e.printStackTrace();
        }
        
        return watchlist;
    }

    // ------------------- CHECK IF DRIVER IS ON WATCHLIST -------------------
    public boolean isDriverOnWatchlist(int driverId) {
        String sql = "SELECT COUNT(*) FROM DriverWatchlist WHERE DriverID = ? AND Status = 'Active'";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("DEBUG: SQL Error in isDriverOnWatchlist: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }

    // ------------------- GET WATCHLIST ENTRY BY DRIVER ID -------------------
    public DriverWatchlist getWatchlistEntryByDriverId(int driverId) {
        String sql = "SELECT w.*, " +
                    "d.FirstName + ' ' + d.LastName as DriverName, d.Email as DriverEmail, " +
                    "a.FirstName + ' ' + a.LastName as AdminName " +
                    "FROM DriverWatchlist w " +
                    "INNER JOIN Users d ON w.DriverID = d.UserID " +
                    "INNER JOIN Users a ON w.AdminID = a.UserID " +
                    "WHERE w.DriverID = ? AND w.Status = 'Active'";
        
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractWatchlistFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("DEBUG: SQL Error in getWatchlistEntryByDriverId: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }

    // ------------------- UPDATE WATCHLIST REASON -------------------
    public boolean updateWatchlistReason(int watchlistId, String newReason) {
        String sql = "UPDATE DriverWatchlist SET Reason = ?, UpdatedDate = GETDATE() WHERE WatchlistID = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newReason);
            ps.setInt(2, watchlistId);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("DEBUG: updateWatchlistReason - rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("DEBUG: SQL Error in updateWatchlistReason: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ------------------- HELPER METHOD TO EXTRACT WATCHLIST FROM RESULTSET -------------------
    private DriverWatchlist extractWatchlistFromResultSet(ResultSet rs) throws SQLException {
        DriverWatchlist watchlist = new DriverWatchlist();
        
        watchlist.setWatchlistId(rs.getInt("WatchlistID"));
        watchlist.setDriverId(rs.getInt("DriverID"));
        watchlist.setAdminId(rs.getInt("AdminID"));
        watchlist.setReason(rs.getString("Reason"));
        watchlist.setStatus(rs.getString("Status"));
        watchlist.setCreatedDate(rs.getTimestamp("CreatedDate"));
        watchlist.setUpdatedDate(rs.getTimestamp("UpdatedDate"));
        
        // Set display names if available
        try {
            watchlist.setDriverName(rs.getString("DriverName"));
            watchlist.setDriverEmail(rs.getString("DriverEmail"));
            watchlist.setAdminName(rs.getString("AdminName"));
        } catch (SQLException e) {
            // These fields might not be present in all queries
            System.out.println("DEBUG: Optional fields not available in result set");
        }
        
        return watchlist;
    }
}
