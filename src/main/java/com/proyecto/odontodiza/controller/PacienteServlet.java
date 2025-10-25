package com.proyecto.odontodiza.controller;

import com.proyecto.odontodiza.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/paciente")
public class PacienteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null || !"Paciente".equals(((Usuario)session.getAttribute("usuario")).getRol())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // Si el usuario es un paciente y está logueado, mostrar su panel
        request.getRequestDispatcher("/WEB-INF/views/paciente/paciente.jsp").forward(request, response);
    }
}
