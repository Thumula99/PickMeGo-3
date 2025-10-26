package com.sliit.pickmegoweb.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sliit.pickmegoweb.dao.RideDAO;
import com.sliit.pickmegoweb.model.Trip;
import com.sliit.pickmegoweb.model.PricingRule;
import com.sliit.pickmegoweb.model.Offer;
import com.sliit.pickmegoweb.dao.PricingDAO;
import com.sliit.pickmegoweb.dao.OfferDAO;
import com.sliit.pickmegoweb.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;

@WebServlet("/FinanceServlet")
public class FinanceServlet extends HttpServlet {
	private RideDAO rideDAO;
	private final Gson gson = new Gson();
    private PricingDAO pricingDAO;
    private OfferDAO offerDAO;

	@Override
	public void init() {
		rideDAO = new RideDAO();
        pricingDAO = new PricingDAO();
        offerDAO = new OfferDAO();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect(request.getContextPath() + "/views/login.jsp");
			return;
		}

		User user = (User) session.getAttribute("user");
		if (user == null || (!"Finance".equals(user.getRole()) && !"Admin".equals(user.getRole()))) {
			response.sendRedirect(request.getContextPath() + "/views/login.jsp");
			return;
		}

		String action = request.getParameter("action");
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

		try {
			if ("summary".equalsIgnoreCase(action)) {
				JsonObject summary = getFinanceSummary();
				out.print(gson.toJson(summary));
				return;
			}

			if ("listPricing".equalsIgnoreCase(action)) {
                try {
                    out.print(gson.toJson(pricingDAO.listAll()));
                } catch (Exception ex) {
                    // Table may not exist yet; return empty list gracefully
                    out.print("[]");
                }
                return;
            }

			if ("listOffers".equalsIgnoreCase(action)) {
                out.print(gson.toJson(offerDAO.listActive()));
                return;
            }

			if ("completedTrips".equalsIgnoreCase(action)) {
				List<Trip> allTrips = rideDAO.getAllTrips();
				// Basic in-memory filter to avoid schema edits
				List<Trip> completed = allTrips.stream()
					.filter(t -> t.getStatus() != null && "Completed".equalsIgnoreCase(t.getStatus()))
					.toList();
				out.print(gson.toJson(completed));
				return;
			}

			JsonObject error = new JsonObject();
			error.addProperty("success", false);
			error.addProperty("message", "Invalid action");
			out.print(gson.toJson(error));
		} catch (Exception e) {
			e.printStackTrace();
			JsonObject error = new JsonObject();
			error.addProperty("success", false);
			error.addProperty("message", "An error occurred: " + e.getMessage());
			out.print(gson.toJson(error));
		}
	}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(401);
            return;
        }
        User user = (User) session.getAttribute("user");
        if (user == null || (!"Finance".equals(user.getRole()) && !"Admin".equals(user.getRole()))) {
            response.setStatus(403);
            return;
        }

        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            if ("upsertPricing".equalsIgnoreCase(action)) {
                String vehicleType = request.getParameter("vehicleType");
                double base = Double.parseDouble(request.getParameter("basePrice"));
                double perKm = Double.parseDouble(request.getParameter("pricePerKm"));
                boolean ok = pricingDAO.upsertPricing(new PricingRule(vehicleType, base, perKm));
                out.print("{\"success\":" + ok + "}");
                return;
            }

            if ("createOffer".equalsIgnoreCase(action)) {
                Offer o = new Offer();
                o.setTitle(request.getParameter("title"));
                o.setDescription(request.getParameter("description"));
                o.setDiscountType(request.getParameter("discountType"));
                o.setDiscountValue(Double.parseDouble(request.getParameter("discountValue")));
                String v = request.getParameter("vehicleType");
                o.setVehicleType((v == null || v.isEmpty()) ? null : v);
                o.setCreatedBy(user.getId());
                o.setActive(true);
                boolean ok = offerDAO.createOffer(o);
                out.print("{\"success\":" + ok + "}");
                return;
            }

            if ("deleteOffer".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = offerDAO.deactivateOffer(id);
                out.print("{\"success\":" + ok + "}");
                return;
            }

            out.print("{\"success\":false,\"message\":\"Invalid action\"}");
        } catch (Exception ex) {
            ex.printStackTrace();
            out.print("{\"success\":false}");
        }
    }

	private JsonObject getFinanceSummary() {
		List<Trip> allTrips = rideDAO.getAllTrips();
		double totalRevenue = 0.0;
		int completedCount = 0;
		double todayRevenue = 0.0;
		int todayCompleted = 0;

		LocalDate today = LocalDate.now(ZoneId.systemDefault());

		for (Trip t : allTrips) {
			if (t.getStatus() != null && "Completed".equalsIgnoreCase(t.getStatus())) {
				completedCount++;
				double price = t.getPrice();
				totalRevenue += price;

				// Prefer completion time if available; otherwise fallback to booking time
				java.util.Date date = null;
				if (t.getCompletionTime() != null) {
					date = t.getCompletionTime();
				} else if (t.getBookingTime() != null) {
					date = t.getBookingTime();
				}
				if (date != null) {
					LocalDate d = new Timestamp(date.getTime()).toLocalDateTime().toLocalDate();
					if (today.equals(d)) {
						todayRevenue += price;
						todayCompleted++;
					}
				}
			}
		}

		double averageFare = completedCount > 0 ? totalRevenue / completedCount : 0.0;

		JsonObject summary = new JsonObject();
		summary.addProperty("success", true);
		summary.addProperty("totalRevenue", round2(totalRevenue));
		summary.addProperty("completedTrips", completedCount);
		summary.addProperty("averageFare", round2(averageFare));
		summary.addProperty("todayRevenue", round2(todayRevenue));
		summary.addProperty("todayCompleted", todayCompleted);
		return summary;
	}

	private double round2(double value) {
		return Math.round(value * 100.0) / 100.0;
	}
}


