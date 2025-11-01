package com.proyecto.odontodiza.controller;

import com.google.gson.Gson;
import com.proyecto.odontodiza.dao.PacienteDAO;
import com.proyecto.odontodiza.dao.TratamientoOdontologicoDAO;
import com.proyecto.odontodiza.model.Paciente;
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

    private PacienteDAO pacienteDAO;
    private TratamientoOdontologicoDAO tratamientoDAO;
    private Gson gson = new Gson();

    @Override
    public void init() {
        pacienteDAO = new PacienteDAO();
        tratamientoDAO = new TratamientoOdontologicoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Validar sesión (igual que en el JSP)
        if (req.getSession(false) == null || req.getSession().getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2. Obtener ID del paciente
        int pacienteId = Integer.parseInt(req.getParameter("pacienteId"));

        // 3. Obtener datos del paciente y sus tratamientos
        Paciente paciente = pacienteDAO.findById(pacienteId);
        List<TratamientoOdontologico> tratamientos = tratamientoDAO.findByPacienteId(pacienteId);

        // 4. Pasar datos a la solicitud
        req.setAttribute("paciente", paciente);
        req.setAttribute("tratamientos", tratamientos);
        
        // Convertir tratamientos a JSON para usarlo en JavaScript si es necesario
        req.setAttribute("jsonTratamientos", gson.toJson(tratamientos));

        // 5. Reenviar al JSP
        req.getRequestDispatcher("/WEB-INF/views/odontologo/historial-paciente.jsp").forward(req, resp);
    }
}