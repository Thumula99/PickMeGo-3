package com.sliit.pickmegoweb.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sliit.pickmegoweb.dao.FeedbackDAO;
import com.sliit.pickmegoweb.model.Feedback;
import com.google.gson.JsonObject;
import com.sliit.pickmegoweb.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {
    private final Gson gson = new Gson();
    private final FeedbackDAO feedbackDAO = new FeedbackDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) { response.sendRedirect(request.getContextPath() + "/views/login.jsp"); return; }
        User user = (User) session.getAttribute("user");

        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if ("listAll".equalsIgnoreCase(action)) {
            if (!"Feedback".equals(user.getRole()) && !"Admin".equals(user.getRole())) { response.setStatus(403); return; }
            out.print(gson.toJson(feedbackDAO.listAll()));
            return;
        }
        if ("listMine".equalsIgnoreCase(action)) {
            out.print(gson.toJson(feedbackDAO.listByCustomer(user.getId())));
            return;
        }
        response.sendError(400, "Invalid action");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) { response.setStatus(401); return; }
        User user = (User) session.getAttribute("user");

        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        switch (action == null ? "" : action) {
            case "create": {
                // customer create feedback
                Feedback f = new Feedback();
                f.setCustomerId(user.getId());
                f.setTitle(request.getParameter("title"));
                f.setContent(request.getParameter("content"));
                String r = request.getParameter("rating");
                f.setRating((r == null || r.isEmpty()) ? null : Integer.parseInt(r));
                out.print("{\"success\":" + feedbackDAO.create(f) + "}");
                return;
            }
            case "reply": {
                // feedback manager reply
                if (!"Feedback".equals(user.getRole()) && !"Admin".equals(user.getRole())) { response.setStatus(403); return; }
                int id = Integer.parseInt(request.getParameter("id"));
                String reply = request.getParameter("reply");
                String status = request.getParameter("status"); // Expected: Pending, Resolved, Looking For It, Other
                if (status == null || status.isEmpty()) status = "Pending";
                out.print("{\"success\":" + feedbackDAO.reply(id, reply, status) + "}");
                return;
            }
            case "update": {
                // customer can update own feedback
                Feedback f = new Feedback();
                f.setId(Integer.parseInt(request.getParameter("id")));
                f.setCustomerId(user.getId());
                f.setTitle(request.getParameter("title"));
                f.setContent(request.getParameter("content"));
                String r = request.getParameter("rating");
                f.setRating((r == null || r.isEmpty()) ? null : Integer.parseInt(r));
                out.print("{\"success\":" + feedbackDAO.update(f) + "}");
                return;
            }
            case "delete": {
                // manager can delete any; customer can delete own (optional: enforce ownership separately)
                int id = Integer.parseInt(request.getParameter("id"));
                out.print("{\"success\":" + feedbackDAO.delete(id) + "}");
                return;
            }
            default:
                response.sendError(400, "Invalid action");
        }
    }
}


