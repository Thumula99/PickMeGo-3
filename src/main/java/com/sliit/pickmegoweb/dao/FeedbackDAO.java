package com.sliit.pickmegoweb.dao;

import com.sliit.pickmegoweb.model.Feedback;
import com.sliit.pickmegoweb.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    private Connection connection;

    public FeedbackDAO() {
        try { connection = DBConnection.getConnection(); } catch (SQLException e) { e.printStackTrace(); }
    }

    public boolean create(Feedback f) {
        String sql = "INSERT INTO Feedbacks (CustomerID, Title, Content, Rating, Status) VALUES (?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, f.getCustomerId());
            ps.setString(2, f.getTitle());
            ps.setString(3, f.getContent());
            if (f.getRating() == null) ps.setNull(4, Types.INTEGER); else ps.setInt(4, f.getRating());
            ps.setString(5, "Pending"); // Explicitly set status to 'Pending' to satisfy CHECK constraint
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Feedback> listAll() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM Feedbacks ORDER BY CreatedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Feedback> listByCustomer(int customerId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM Feedbacks WHERE CustomerID = ? ORDER BY CreatedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean reply(int id, String reply, String status) {
        String sql = "UPDATE Feedbacks SET Reply = ?, RepliedAt = GETDATE(), Status = ? WHERE FeedbackID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, reply);
            ps.setString(2, status);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean update(Feedback f) {
        String sql = "UPDATE Feedbacks SET Title = ?, Content = ?, Rating = ? WHERE FeedbackID = ? AND CustomerID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, f.getTitle());
            ps.setString(2, f.getContent());
            if (f.getRating() == null) ps.setNull(3, Types.INTEGER); else ps.setInt(3, f.getRating());
            ps.setInt(4, f.getId());
            ps.setInt(5, f.getCustomerId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Feedbacks WHERE FeedbackID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private Feedback map(ResultSet rs) throws SQLException {
        Feedback f = new Feedback();
        f.setId(rs.getInt("FeedbackID"));
        f.setCustomerId(rs.getInt("CustomerID"));
        f.setTitle(rs.getString("Title"));
        f.setContent(rs.getString("Content"));
        int r = rs.getInt("Rating");
        f.setRating(rs.wasNull() ? null : r);
        f.setStatus(rs.getString("Status"));
        f.setReply(rs.getString("Reply"));
        f.setCreatedAt(rs.getTimestamp("CreatedAt"));
        f.setRepliedAt(rs.getTimestamp("RepliedAt"));
        return f;
    }
}


