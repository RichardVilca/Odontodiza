package com.proyecto.odontodiza.controller;

import com.proyecto.odontodiza.dao.CitaDAO;
import com.proyecto.odontodiza.model.Cita;
import com.proyecto.odontodiza.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet("/listCitas")
public class ListCitasServlet extends HttpServlet {

    private CitaDAO citaDAO;

    @Override
    public void init() {
        citaDAO = new CitaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null || !"Odontologo".equals(((Usuario)session.getAttribute("usuario")).getRol())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            List<Cita> citas = citaDAO.getAllCitasReservadas();
            request.setAttribute("citas", citas);
            request.getRequestDispatcher("/WEB-INF/views/odontologo/citas.jsp").forward(request, response);
        } catch (RuntimeException e) {
            throw new ServletException("Error al listar las citas", e);
        }
    }
}
