package com.proyecto.odontodiza.controller;

import com.proyecto.odontodiza.dao.HistorialDentalDAO;
import com.proyecto.odontodiza.model.HistorialDental;
import com.proyecto.odontodiza.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/actualizarHistorial")
public class ActualizarHistorialServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private HistorialDentalDAO historialDentalDAO;

    public void init() {
        historialDentalDAO = new HistorialDentalDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null || !"Odontologo".equalsIgnoreCase(((Usuario) session.getAttribute("usuario")).getRol())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado.");
            return;
        }

        try {
            int historialId = Integer.parseInt(request.getParameter("historialId"));
            int pacienteId = Integer.parseInt(request.getParameter("pacienteId"));

            HistorialDental historial = historialDentalDAO.findById(historialId);
            if (historial == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Historial no encontrado.");
                return;
            }

            // Actualizar el objeto con los datos del formulario
            historial.setCondicionGeneralOral(request.getParameter("condicionGeneralOral"));
            historial.setObservacionesGenerales(request.getParameter("observacionesGenerales"));
            historial.setTratamientosPrevios(request.getParameter("tratamientosPrevios"));
            historial.setAlergiasDentales(request.getParameter("alergiasDentales"));
            historial.setMedicamentosActuales(request.getParameter("medicamentosActuales"));

            // Guardar los cambios en la base de datos
            historialDentalDAO.update(historial);

            // Redirigir de vuelta a la página de historial con un mensaje de éxito
            response.sendRedirect(request.getContextPath() + "/historialPaciente?pacienteId=" + pacienteId + "&update=success");

        } catch (Exception e) {
            throw new ServletException("Error al actualizar el historial dental.", e);
        }
    }
}
