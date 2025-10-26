package com.sliit.pickmegoweb.controller;

import com.google.gson.Gson;
import com.sliit.pickmegoweb.dao.OfferDAO;
import com.sliit.pickmegoweb.model.User;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/OfferServlet")
public class OfferServlet extends HttpServlet {
	private final OfferDAO offerDAO = new OfferDAO();
	private final Gson gson = new Gson();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect(request.getContextPath() + "/views/login.jsp");
			return;
		}
		User user = (User) session.getAttribute("user");
		if (user == null || (!"Customer".equals(user.getRole()) && !"Admin".equals(user.getRole()) && !"Finance".equals(user.getRole()))) {
			response.sendError(403);
			return;
		}

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		out.print(gson.toJson(offerDAO.listActive()));
	}
}


