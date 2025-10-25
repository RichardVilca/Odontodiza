package com.proyecto.odontodiza.controller;

import com.proyecto.odontodiza.dao.HistorialDentalDAO;
import com.proyecto.odontodiza.dao.PacienteDAO;
import com.proyecto.odontodiza.dao.PersonaDAO;
import com.proyecto.odontodiza.dao.UsuarioDAO;
import com.proyecto.odontodiza.model.HistorialDental;
import com.proyecto.odontodiza.model.Paciente;
import com.proyecto.odontodiza.model.Persona;
import com.proyecto.odontodiza.model.Usuario;
import com.proyecto.odontodiza.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/nuevoPaciente")
public class NuevoPacienteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PersonaDAO personaDAO;
    private UsuarioDAO usuarioDAO;
    private HistorialDentalDAO historialDentalDAO;
    private PacienteDAO pacienteDAO;

    public void init() {
        personaDAO = new PersonaDAO();
        usuarioDAO = new UsuarioDAO();
        historialDentalDAO = new HistorialDentalDAO();
        pacienteDAO = new PacienteDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/odontologo/nuevo-paciente.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Recoger los datos del formulario
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String telefono = request.getParameter("telefono");
        String fechaNacimiento = request.getParameter("fechaNacimiento");
        String genero = request.getParameter("genero");
        String direccion = request.getParameter("direccion");
        String alergias = request.getParameter("alergias");
        String enfermedades = request.getParameter("enfermedades");

        // 1. Validar si el email ya existe
        if (usuarioDAO.findByEmail(email) != null) {
            request.getRequestDispatcher("/WEB-INF/views/odontologo/nuevo-paciente.jsp").forward(request, response);
            return;
        }

        try {
            // 2. Crear y guardar la Persona
            Persona nuevaPersona = new Persona();
            nuevaPersona.setNombre(nombre);
            nuevaPersona.setApellido(apellido);
            nuevaPersona.setEmail(email);
            nuevaPersona.setTelefono(telefono);
            
            // Parse fechaNacimiento to Date
            if (fechaNacimiento != null && !fechaNacimiento.isEmpty()) {
                try {
                    java.util.Date parsedFechaNacimiento = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(fechaNacimiento);
                    nuevaPersona.setFechaNacimiento(parsedFechaNacimiento);
                } catch (java.text.ParseException e) {
                    System.err.println("Error parsing date: " + fechaNacimiento);
                    // Handle error or set to null
                }
            }

            nuevaPersona.setGenero(genero);
            nuevaPersona.setDireccion(direccion);
            personaDAO.insert(nuevaPersona); // El ID se autogenera y se setea en el objeto

            // 3. Crear y guardar el Historial Dental
            HistorialDental nuevoHistorial = new HistorialDental();
            nuevoHistorial.setCondicionGeneralOral("Sin observaciones iniciales");
            nuevoHistorial.setObservacionesGenerales("Sin observaciones iniciales");
            nuevoHistorial.setTratamientosPrevios("Ninguno");
            nuevoHistorial.setAlergiasDentales(alergias);
            nuevoHistorial.setMedicamentosActuales(enfermedades);
            historialDentalDAO.insert(nuevoHistorial); // El ID se autogenera

            // 4. Crear y guardar el Usuario
            Usuario nuevoUsuario = new Usuario();
            nuevoUsuario.setNombreUsuario(email); // Usar email como nombre de usuario por defecto
            nuevoUsuario.setContrasena(PasswordUtil.hashPassword(password));
            nuevoUsuario.setRol("Paciente");
            nuevoUsuario.setPersona(nuevaPersona);
            usuarioDAO.insert(nuevoUsuario); // El ID se autogenera

            // 5. Crear y guardar el Paciente
            Paciente nuevoPaciente = new Paciente();
            nuevoPaciente.setUsuario(nuevoUsuario);
            nuevoPaciente.setHistorialDental(nuevoHistorial);
            pacienteDAO.insert(nuevoPaciente);

            // 6. Redirigir a la lista de pacientes con un mensaje de éxito
            response.sendRedirect(request.getContextPath() + "/listPatients?success=true");

        } catch (Exception e) {
            // Manejo de errores
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error al registrar el paciente: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/odontologo/nuevo-paciente.jsp").forward(request, response);
        }
    }
}
