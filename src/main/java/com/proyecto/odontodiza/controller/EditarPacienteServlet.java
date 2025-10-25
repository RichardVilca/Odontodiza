package com.proyecto.odontodiza.controller;

import com.proyecto.odontodiza.dao.HistorialDentalDAO;
import com.proyecto.odontodiza.dao.PacienteDAO;
import com.proyecto.odontodiza.dao.PersonaDAO;
import com.proyecto.odontodiza.dao.UsuarioDAO;
import com.proyecto.odontodiza.model.HistorialDental;
import com.proyecto.odontodiza.model.Paciente;
import com.proyecto.odontodiza.model.Persona;
import com.proyecto.odontodiza.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/editarPaciente")
public class EditarPacienteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PacienteDAO pacienteDAO;
    private PersonaDAO personaDAO;
    private UsuarioDAO usuarioDAO;
    private HistorialDentalDAO historialDentalDAO;

    public void init() {
        pacienteDAO = new PacienteDAO();
        personaDAO = new PersonaDAO();
        usuarioDAO = new UsuarioDAO();
        historialDentalDAO = new HistorialDentalDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pacienteIdParam = request.getParameter("pacienteId");
        if (pacienteIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Falta el ID del paciente.");
            return;
        }

        try {
            int pacienteId = Integer.parseInt(pacienteIdParam);
            Paciente paciente = pacienteDAO.findById(pacienteId);
            if (paciente == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Paciente no encontrado.");
                return;
            }
            request.getRequestDispatcher("/WEB-INF/views/odontologo/editar-paciente.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Error al cargar los datos del paciente para edición.", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pacienteIdParam = request.getParameter("pacienteId");
        if (pacienteIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Falta el ID del paciente.");
            return;
        }

        try {
            int pacienteId = Integer.parseInt(pacienteIdParam);
            
            // Obtener objetos existentes
            Paciente paciente = pacienteDAO.findById(pacienteId);
            if (paciente == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Paciente no encontrado para actualizar.");
                return;
            }
            Persona persona = paciente.getUsuario().getPersona();
            HistorialDental historial = paciente.getHistorialDental();

            // Validar unicidad del email si ha cambiado
            String nuevoEmail = request.getParameter("email");
            if (!nuevoEmail.equals(persona.getEmail())) {
                Usuario usuarioExistente = usuarioDAO.findByEmail(nuevoEmail);
                if (usuarioExistente != null) {
                    request.setAttribute("errorMessage", "El nuevo correo electrónico ya está en uso por otro usuario.");
                    request.setAttribute("paciente", paciente); // Re-enviar el objeto original para no perder datos
                    request.getRequestDispatcher("/WEB-INF/views/odontologo/editar-paciente.jsp").forward(request, response);
                    return;
                }
            }

            // Actualizar Persona
            persona.setNombre(request.getParameter("nombre"));
            persona.setApellido(request.getParameter("apellido"));
            persona.setEmail(nuevoEmail);
            persona.setTelefono(request.getParameter("telefono"));
            
            // Parse fechaNacimiento to Date
            String fechaNacimientoStr = request.getParameter("fechaNacimiento");
            if (fechaNacimientoStr != null && !fechaNacimientoStr.isEmpty()) {
                try {
                    java.util.Date fechaNacimiento = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(fechaNacimientoStr);
                    persona.setFechaNacimiento(fechaNacimiento);
                } catch (java.text.ParseException e) {
                    System.err.println("Error parsing date: " + fechaNacimientoStr);
                    // Handle error or set to null
                }
            }

            persona.setGenero(request.getParameter("genero"));
            persona.setDireccion(request.getParameter("direccion"));
            personaDAO.update(persona);

            // Actualizar Historial Dental
            historial.setCondicionGeneralOral(request.getParameter("condicionGeneralOral"));
            historial.setObservacionesGenerales(request.getParameter("observacionesGenerales"));
            historial.setTratamientosPrevios(request.getParameter("tratamientosPrevios"));
            historial.setAlergiasDentales(request.getParameter("alergiasDentales"));
            historial.setMedicamentosActuales(request.getParameter("medicamentosActuales"));
            historialDentalDAO.update(historial);

            // Redirigir con mensaje de éxito
            response.sendRedirect(request.getContextPath() + "/listPatients?successUpdate=true");

        } catch (Exception e) {
            throw new ServletException("Error al actualizar el paciente.", e);
        }
    }
}
