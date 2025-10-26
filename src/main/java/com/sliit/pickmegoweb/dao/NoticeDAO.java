package com.sliit.pickmegoweb.dao;

import com.sliit.pickmegoweb.model.Notice;
import com.sliit.pickmegoweb.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class NoticeDAO {
    
    public boolean createNotice(Notice notice) {
        String sql = "INSERT INTO Notices (Title, Message, NoticeType, Priority, CreatedBy, TargetAudience, IsActive) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, notice.getTitle());
            stmt.setString(2, notice.getMessage());
            stmt.setString(3, notice.getNoticeType());
            stmt.setString(4, notice.getPriority());
            stmt.setInt(5, notice.getCreatedBy());
            stmt.setString(6, notice.getTargetAudience());
            stmt.setBoolean(7, notice.isActive());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Notice> getAllNotices() {
        List<Notice> notices = new ArrayList<>();
        String sql = "SELECT * FROM Notices ORDER BY CreatedDate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Notice notice = mapResultSetToNotice(rs);
                notices.add(notice);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return notices;
    }
    
    public List<Notice> getActiveNotices() {
        List<Notice> notices = new ArrayList<>();
        String sql = "SELECT * FROM Notices WHERE IsActive = 1 AND (ExpiryDate IS NULL OR ExpiryDate > GETDATE()) ORDER BY Priority DESC, CreatedDate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Notice notice = mapResultSetToNotice(rs);
                notices.add(notice);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return notices;
    }
    
    public List<Notice> getNoticesForAudience(String targetAudience) {
        List<Notice> notices = new ArrayList<>();
        String sql = "SELECT * FROM Notices WHERE IsActive = 1 AND (ExpiryDate IS NULL OR ExpiryDate > GETDATE()) AND (TargetAudience = ? OR TargetAudience = 'All') ORDER BY Priority DESC, CreatedDate DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, targetAudience);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Notice notice = mapResultSetToNotice(rs);
                notices.add(notice);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return notices;
    }
    
    public Notice getNoticeById(int noticeId) {
        String sql = "SELECT * FROM Notices WHERE NoticeID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, noticeId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToNotice(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    public boolean updateNotice(Notice notice) {
        String sql = "UPDATE Notices SET Title = ?, Message = ?, NoticeType = ?, Priority = ?, TargetAudience = ?, IsActive = ?, ExpiryDate = ? WHERE NoticeID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, notice.getTitle());
            stmt.setString(2, notice.getMessage());
            stmt.setString(3, notice.getNoticeType());
            stmt.setString(4, notice.getPriority());
            stmt.setString(5, notice.getTargetAudience());
            stmt.setBoolean(6, notice.isActive());
            stmt.setTimestamp(7, notice.getExpiryDate() != null ? Timestamp.valueOf(notice.getExpiryDate()) : null);
            stmt.setInt(8, notice.getNoticeId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteNotice(int noticeId) {
        String sql = "DELETE FROM Notices WHERE NoticeID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, noticeId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean toggleNoticeStatus(int noticeId) {
        String sql = "UPDATE Notices SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END WHERE NoticeID = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, noticeId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int getNoticeCount() {
        String sql = "SELECT COUNT(*) FROM Notices";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    private Notice mapResultSetToNotice(ResultSet rs) throws SQLException {
        Notice notice = new Notice();
        notice.setNoticeId(rs.getInt("NoticeID"));
        notice.setTitle(rs.getString("Title"));
        notice.setMessage(rs.getString("Message"));
        notice.setNoticeType(rs.getString("NoticeType"));
        notice.setPriority(rs.getString("Priority"));
        notice.setCreatedBy(rs.getInt("CreatedBy"));
        
        // Convert Timestamp to String for JSON serialization
        Timestamp createdTimestamp = rs.getTimestamp("CreatedDate");
        if (createdTimestamp != null) {
            notice.setCreatedDate(createdTimestamp.toString());
        }
        
        Timestamp expiryTimestamp = rs.getTimestamp("ExpiryDate");
        if (expiryTimestamp != null) {
            notice.setExpiryDate(expiryTimestamp.toString());
        }
        
        notice.setActive(rs.getBoolean("IsActive"));
        notice.setTargetAudience(rs.getString("TargetAudience"));
        
        return notice;
    }
}
