package com.proyecto.odontodiza.controller;

import com.proyecto.odontodiza.dao.PacienteDAO;
import com.proyecto.odontodiza.dao.HistorialDentalDAO;
import com.proyecto.odontodiza.dao.TratamientoOdontologicoDAO;

import com.proyecto.odontodiza.model.Paciente;
import com.proyecto.odontodiza.model.HistorialDental;
import com.proyecto.odontodiza.model.TratamientoOdontologico;
import com.proyecto.odontodiza.dao.HistorialDentalDAO;
import com.proyecto.odontodiza.dao.TratamientoOdontologicoDAO;
import com.proyecto.odontodiza.model.HistorialDental;
import com.proyecto.odontodiza.model.TratamientoOdontologico;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/historialPaciente")
public class HistorialPacienteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PacienteDAO pacienteDAO;
    private HistorialDentalDAO historialDentalDAO;
    private TratamientoOdontologicoDAO tratamientoOdontologicoDAO;

    public void init() {
        pacienteDAO = new PacienteDAO();
        historialDentalDAO = new HistorialDentalDAO();
        tratamientoOdontologicoDAO = new TratamientoOdontologicoDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pacienteIdParam = request.getParameter("pacienteId");
        if (pacienteIdParam == null || pacienteIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Falta el ID del paciente.");
            return;
        }

        try {
            int pacienteId = Integer.parseInt(pacienteIdParam);

            // 1. Obtener los datos del paciente
            Paciente paciente = pacienteDAO.findById(pacienteId);
            if (paciente == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Paciente no encontrado.");
                return;
            }

            // 2. Obtener el historial dental del paciente
            HistorialDental historialDental = paciente.getHistorialDental();

            // 3. Obtener los tratamientos odontológicos del paciente
            List<TratamientoOdontologico> tratamientos = tratamientoOdontologicoDAO.findByPacienteId(pacienteId);

            // 4. Poner los datos en el request
            request.setAttribute("paciente", paciente);
            request.setAttribute("historialDental", historialDental);
            request.setAttribute("tratamientos", tratamientos);

            // 5. Reenviar al JSP
            request.getRequestDispatcher("/WEB-INF/views/odontologo/historial-paciente.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "El ID del paciente debe ser un número.");
        } catch (Exception e) {
            throw new ServletException("Error al cargar el historial del paciente.", e);
        }
    }
}
