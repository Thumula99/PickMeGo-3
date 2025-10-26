package com.sliit.pickmegoweb.dao;

import com.sliit.pickmegoweb.model.PricingRule;
import com.sliit.pickmegoweb.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PricingDAO {
	private Connection connection;

	public PricingDAO() {
		try {
			connection = DBConnection.getConnection();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public PricingRule getPricingForVehicle(String vehicleType) {
		String sql = "SELECT vehicle_type, base_price, price_per_km FROM PricingRules WHERE LOWER(vehicle_type) = LOWER(?)";
		try (PreparedStatement ps = connection.prepareStatement(sql)) {
			ps.setString(1, vehicleType);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return new PricingRule(
						rs.getString("vehicle_type"),
						rs.getDouble("base_price"),
						rs.getDouble("price_per_km")
					);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public boolean upsertPricing(PricingRule rule) {
		String sql = "MERGE PricingRules AS target USING (SELECT ? AS vehicle_type, ? AS base_price, ? AS price_per_km) AS src ON LOWER(target.vehicle_type)=LOWER(src.vehicle_type) WHEN MATCHED THEN UPDATE SET base_price=src.base_price, price_per_km=src.price_per_km WHEN NOT MATCHED THEN INSERT(vehicle_type, base_price, price_per_km) VALUES (src.vehicle_type, src.base_price, src.price_per_km);";
		try (PreparedStatement ps = connection.prepareStatement(sql)) {
			ps.setString(1, rule.getVehicleType());
			ps.setDouble(2, rule.getBasePrice());
			ps.setDouble(3, rule.getPricePerKm());
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public List<PricingRule> listAll() {
		List<PricingRule> list = new ArrayList<>();
		String sql = "SELECT vehicle_type, base_price, price_per_km FROM PricingRules ORDER BY vehicle_type";
		try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				list.add(new PricingRule(
					rs.getString("vehicle_type"),
					rs.getDouble("base_price"),
					rs.getDouble("price_per_km")
				));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
}


