package com.sliit.pickmegoweb.dao;

import com.sliit.pickmegoweb.model.Offer;
import com.sliit.pickmegoweb.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OfferDAO {
	private Connection connection;

	public OfferDAO() {
		try { connection = DBConnection.getConnection(); } catch (SQLException e) { e.printStackTrace(); }
	}

    public boolean createOffer(Offer o) {
        // Map to existing Promotions table
        // Columns: PromoID (IDENTITY), PromoCode, Description, DiscountType, DiscountValue, ExpiryDate, IsActive
        String sql = "INSERT INTO Promotions (PromoCode, Description, DiscountType, DiscountValue, ExpiryDate, IsActive) VALUES (?,?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            // Use title as PromoCode; required up to 50 chars
            ps.setString(1, truncate(o.getTitle(), 50));
            ps.setString(2, truncate(o.getDescription(), 255));
            String dt = o.getDiscountType();
            if (dt != null) {
                if (dt.equalsIgnoreCase("PERCENT")) dt = "Percentage";
                else if (dt.equalsIgnoreCase("FIXED")) dt = "Fixed";
            }
            ps.setString(3, dt);
            ps.setDouble(4, o.getDiscountValue());
            // ExpiryDate is NOT NULL in your schema; if none provided, default to +30 days
            java.sql.Date expiry = (o.getExpiresAt() == null)
                ? new java.sql.Date(System.currentTimeMillis() + 30L*24*60*60*1000)
                : new java.sql.Date(o.getExpiresAt().getTime());
            ps.setDate(5, expiry);
            ps.setBoolean(6, o.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Offer> listActive() {
        List<Offer> list = new ArrayList<>();
        String sql = "SELECT PromoID, PromoCode, Description, DiscountType, DiscountValue, ExpiryDate, IsActive FROM Promotions WHERE IsActive = 1 AND (ExpiryDate IS NULL OR ExpiryDate > GETDATE()) ORDER BY PromoID DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapFromPromotions(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean deactivateOffer(int promoId) {
        String sql = "UPDATE Promotions SET IsActive = 0 WHERE PromoID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, promoId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Offer mapFromPromotions(ResultSet rs) throws SQLException {
        Offer o = new Offer();
        o.setId(rs.getInt("PromoID"));
        o.setTitle(rs.getString("PromoCode"));
        o.setDescription(rs.getString("Description"));
        o.setDiscountType(rs.getString("DiscountType"));
        o.setDiscountValue(rs.getDouble("DiscountValue"));
        // Promotions table has no vehicle filter or created_by
        o.setVehicleType(null);
        java.sql.Date d = rs.getDate("ExpiryDate");
        o.setExpiresAt(d != null ? new java.sql.Timestamp(d.getTime()) : null);
        o.setCreatedBy(0);
        o.setActive(rs.getBoolean("IsActive"));
        return o;
    }

    private String truncate(String s, int max) {
        if (s == null) return null;
        return s.length() <= max ? s : s.substring(0, max);
    }
}


