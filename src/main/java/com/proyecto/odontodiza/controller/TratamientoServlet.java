package com.proyecto.odontodiza.controller;

import com.proyecto.odontodiza.dao.TratamientoOdontologicoDAO;
import com.proyecto.odontodiza.model.TratamientoOdontologico;
import com.proyecto.odontodiza.model.Paciente;
import com.proyecto.odontodiza.model.Odontologo;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/tratamiento")
public class TratamientoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TratamientoOdontologicoDAO tratamientoDAO;

    public void init() {
        tratamientoDAO = new TratamientoOdontologicoDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String pacienteId = request.getParameter("pacienteId");

        try {
            if ("create".equals(action) || "update".equals(action)) {
                handleCreateOrUpdate(request, response);
            } else if ("delete".equals(action)) {
                handleDelete(request, response);
            }
        } catch (Exception e) {
            throw new ServletException("Error al procesar el tratamiento", e);
        }

        response.sendRedirect(request.getContextPath() + "/historialPaciente?pacienteId=" + pacienteId);
    }

    private void handleCreateOrUpdate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String nombre = request.getParameter("nombreTratamiento");
        String descripcion = request.getParameter("descripcion");
        String fechaInicioStr = request.getParameter("fechaInicio");
        String fechaFinStr = request.getParameter("fechaFin");
        String estado = request.getParameter("estado");
        double costoDouble = Double.parseDouble(request.getParameter("costo"));
        BigDecimal costo = BigDecimal.valueOf(costoDouble);
        String observaciones = request.getParameter("observaciones");
        String dientesAfectados = request.getParameter("dientesAfectados");
        int pacienteId = Integer.parseInt(request.getParameter("pacienteId"));
        int odontologoId = Integer.parseInt(request.getParameter("odontologoId"));

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date fechaInicio = sdf.parse(fechaInicioStr);
        Date fechaFin = (fechaFinStr != null && !fechaFinStr.isEmpty()) ? sdf.parse(fechaFinStr) : null;

        String action = request.getParameter("action");
        TratamientoOdontologico tratamiento;

        if ("update".equals(action)) {
            int tratamientoId = Integer.parseInt(request.getParameter("tratamientoId"));
            tratamiento = tratamientoDAO.findById(tratamientoId);
        } else {
            tratamiento = new TratamientoOdontologico();
        }

        tratamiento.setNombreTratamiento(nombre);
        tratamiento.setDescripcion(descripcion);
        tratamiento.setFechaInicio(fechaInicio);
        tratamiento.setFechaFin(fechaFin);
        tratamiento.setEstado(estado);
        tratamiento.setCosto(costo);
        tratamiento.setObservaciones(observaciones);
        tratamiento.setDientesAfectados(dientesAfectados);
        
        Paciente p = new Paciente();
        p.setId(pacienteId);
        tratamiento.setPaciente(p);

        Odontologo o = new Odontologo();
        o.setId(odontologoId);
        tratamiento.setOdontologo(o);

        if ("update".equals(action)) {
            tratamientoDAO.update(tratamiento);
        } else {
            tratamientoDAO.insert(tratamiento);
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int tratamientoId = Integer.parseInt(request.getParameter("tratamientoId"));
        tratamientoDAO.delete(tratamientoId);
    }
}
