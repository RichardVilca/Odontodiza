package com.proyecto.odontodiza.controller;

import com.proyecto.odontodiza.dao.PersonaDAO;
import com.proyecto.odontodiza.dao.UsuarioDAO;
import com.proyecto.odontodiza.model.Persona;
import com.proyecto.odontodiza.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/editarPerfilPaciente")
public class EditarPerfilPacienteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PersonaDAO personaDAO;
    private UsuarioDAO usuarioDAO;

    public void init() {
        personaDAO = new PersonaDAO();
        usuarioDAO = new UsuarioDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null || !"Paciente".equals(usuario.getRol())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Persona persona = personaDAO.findById(usuario.getPersona().getId());
            if (persona == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Perfil de paciente no encontrado.");
                return;
            }
            request.setAttribute("persona", persona);
            request.getRequestDispatcher("/WEB-INF/views/paciente/editar-perfil-paciente.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Error al cargar el perfil del paciente para edición.", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null || !"Paciente".equals(usuario.getRol())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acceso denegado.");
            return;
        }

        try {
            Persona personaActual = personaDAO.findById(usuario.getPersona().getId());
            if (personaActual == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Perfil de paciente no encontrado para actualizar.");
                return;
            }

            // Validar unicidad del email si ha cambiado
            String nuevoEmail = request.getParameter("email");
            if (!nuevoEmail.equals(personaActual.getEmail())) {
                Usuario usuarioExistente = usuarioDAO.findByEmail(nuevoEmail);
                if (usuarioExistente != null) {
                    request.setAttribute("errorMessage", "El correo electrónico ya está en uso por otro usuario.");
                    request.setAttribute("persona", personaActual); // Re-enviar el objeto original para no perder datos
                    request.getRequestDispatcher("/WEB-INF/views/paciente/editar-perfil-paciente.jsp").forward(request, response);
                    return;
                }
            }

            // Actualizar datos de la Persona
            personaActual.setNombre(request.getParameter("nombre"));
            personaActual.setApellido(request.getParameter("apellido"));
            personaActual.setEmail(nuevoEmail);
            personaActual.setTelefono(request.getParameter("telefono"));
            
            // Parse fechaNacimiento to Date
            String fechaNacimientoStr = request.getParameter("fechaNacimiento");
            if (fechaNacimientoStr != null && !fechaNacimientoStr.isEmpty()) {
                try {
                    java.util.Date fechaNacimiento = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(fechaNacimientoStr);
                    personaActual.setFechaNacimiento(fechaNacimiento);
                } catch (java.text.ParseException e) {
                    System.err.println("Error parsing date: " + fechaNacimientoStr);
                    // Handle error or set to null
                }
            }

            personaActual.setGenero(request.getParameter("genero"));
            personaActual.setDireccion(request.getParameter("direccion"));
            personaDAO.update(personaActual);

            // Actualizar el objeto Usuario en sesión para reflejar los cambios de nombre/apellido/email
            usuario.setPersona(personaActual);
            session.setAttribute("usuario", usuario);

            response.sendRedirect(request.getContextPath() + "/paciente?updateProfile=success");

        } catch (Exception e) {
            throw new ServletException("Error al actualizar el perfil del paciente.", e);
        }
    }
}
