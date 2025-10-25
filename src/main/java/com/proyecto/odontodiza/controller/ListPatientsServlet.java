package com.proyecto.odontodiza.controller;

import com.proyecto.odontodiza.dao.PacienteDAO;
import com.proyecto.odontodiza.model.Paciente;
import com.proyecto.odontodiza.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/listPatients")
public class ListPatientsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int PAGE_SIZE = 10; // Número de pacientes por página
    private PacienteDAO pacienteDAO;

    public void init() {
        pacienteDAO = new PacienteDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null || !"Odontologo".equals(((Usuario)session.getAttribute("usuario")).getRol())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String searchTerm = request.getParameter("search");
            String pageParam = request.getParameter("page");
            int currentPage = (pageParam == null || pageParam.trim().isEmpty()) ? 1 : Integer.parseInt(pageParam);

            List<Paciente> patients;
            int totalPatients;
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                totalPatients = pacienteDAO.countByName(searchTerm.trim());
                patients = pacienteDAO.searchByName(searchTerm.trim(), (currentPage - 1) * PAGE_SIZE, PAGE_SIZE);
            } else {
                totalPatients = pacienteDAO.countAll();
                patients = pacienteDAO.listAll((currentPage - 1) * PAGE_SIZE, PAGE_SIZE);
            }
            
            int totalPages = (int) Math.ceil((double) totalPatients / PAGE_SIZE);

            request.setAttribute("patients", patients);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            
            request.getRequestDispatcher("/WEB-INF/views/odontologo/pacientes.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            // Manejo de error si el parámetro de página no es un número
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parámetro de página inválido.");
        } catch (RuntimeException e) {
            throw new ServletException("Error al listar pacientes", e);
        }
    }
}
