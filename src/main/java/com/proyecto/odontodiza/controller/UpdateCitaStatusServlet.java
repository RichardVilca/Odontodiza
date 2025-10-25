package com.proyecto.odontodiza.controller;

import com.proyecto.odontodiza.dao.CitaDAO;
import com.proyecto.odontodiza.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/updateCitaStatus")
public class UpdateCitaStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CitaDAO citaDAO;

    public void init() {
        citaDAO = new CitaDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "No autorizado.");
            return;
        }

        String citaIdParam = request.getParameter("citaId");
        String newStatus = request.getParameter("status");

        if (citaIdParam == null || newStatus == null || citaIdParam.trim().isEmpty() || newStatus.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Faltan parámetros requeridos.");
            return;
        }

        try {
            int citaId = Integer.parseInt(citaIdParam);
            String role = usuario.getRol();

            if ("Odontologo".equals(role)) {
                citaDAO.updateStatus(citaId, newStatus);
                response.sendRedirect(request.getContextPath() + "/listCitas?update=success");
            } else if ("Paciente".equals(role)) {
                // Lógica de seguridad para pacientes
                // (Esta lógica asume que CitaDAO.findById ha sido re-implementado)
                // Cita cita = citaDAO.findById(citaId);
                // Paciente paciente = new PacienteDAO().findByUsuarioId(usuario.getId());
                // if (cita != null && cita.getPaciente().getId() == paciente.getId()) {
                    citaDAO.updateStatus(citaId, newStatus);
                    response.sendRedirect(request.getContextPath() + "/misCitas?cancel=success");
                // } else {
                //     response.sendError(HttpServletResponse.SC_FORBIDDEN, "No puede cancelar una cita que no es suya.");
                // }
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Rol no válido.");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "El ID de la cita debe ser un número.");
        } catch (Exception e) {
            throw new ServletException("Error al actualizar el estado de la cita.", e);
        }
    }
}
