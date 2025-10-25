package com.proyecto.odontodiza.controller;

import com.proyecto.odontodiza.dao.HistorialDentalDAO;
import com.proyecto.odontodiza.dao.OdontologoDAO;
import com.proyecto.odontodiza.dao.PacienteDAO;
import com.proyecto.odontodiza.dao.PersonaDAO;
import com.proyecto.odontodiza.dao.UsuarioDAO;
import com.proyecto.odontodiza.model.HistorialDental;
import com.proyecto.odontodiza.model.Odontologo;
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

@WebServlet("/register")
public class RegistroServlet extends HttpServlet {

    private PersonaDAO personaDAO;
    private UsuarioDAO usuarioDAO;
    private HistorialDentalDAO historialDentalDAO;
    private PacienteDAO pacienteDAO;
    private OdontologoDAO odontologoDAO;

    @Override
    public void init() {
        personaDAO = new PersonaDAO();
        usuarioDAO = new UsuarioDAO();
        historialDentalDAO = new HistorialDentalDAO();
        pacienteDAO = new PacienteDAO();
        odontologoDAO = new OdontologoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener parámetros del formulario
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String telefono = request.getParameter("telefono");
        String fechaNacimiento = request.getParameter("fechaNacimiento");
        String genero = request.getParameter("genero");
        String direccion = request.getParameter("direccion");
        String userType = request.getParameter("userType");
        String especialidad = request.getParameter("especialidad");
        String licencia = request.getParameter("licencia");
        String verificationCode = request.getParameter("verificationCode");

        // 1. Validación
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Las contraseñas no coinciden.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (usuarioDAO.findByEmail(email) != null) {
            request.setAttribute("error", "El correo electrónico ya está en uso.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // Validar código de verificación para odontólogos
        if ("Odontologo".equals(userType)) {
            if (!"123456".equals(verificationCode)) { // Código hardcodeado por simplicidad
                request.setAttribute("error", "Código de verificación incorrecto para Odontólogo.");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }
        }

        // 2. Crear y guardar Persona
        Persona nuevaPersona = new Persona();
        nuevaPersona.setNombre(nombre);
        nuevaPersona.setApellido(apellido);
        nuevaPersona.setEmail(email);
        nuevaPersona.setTelefono(telefono);
        nuevaPersona.setGenero(genero);
        nuevaPersona.setDireccion(direccion);
        
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
        
        try {
            personaDAO.insert(nuevaPersona); // El ID se autogenera y se setea en el objeto

            // 3. Crear y guardar Usuario
            Usuario nuevoUsuario = new Usuario();
            nuevoUsuario.setNombreUsuario(email); // Usamos el email como nombre de usuario por simplicidad
            String hashedPassword = PasswordUtil.hashPassword(password);
            nuevoUsuario.setContrasena(hashedPassword);
            nuevoUsuario.setPersona(nuevaPersona); // Asociamos la persona con su ID ya generado

            if ("Odontologo".equals(userType)) {
                nuevoUsuario.setRol("Odontologo");
                usuarioDAO.insert(nuevoUsuario);

                // 4. Crear y guardar Odontologo
                Odontologo nuevoOdontologo = new Odontologo();
                nuevoOdontologo.setEspecialidad(especialidad);
                nuevoOdontologo.setLicencia(licencia);
                nuevoOdontologo.setUsuario(nuevoUsuario);
                odontologoDAO.insert(nuevoOdontologo);

            } else { // Por defecto, es Paciente
                nuevoUsuario.setRol("Paciente");
                usuarioDAO.insert(nuevoUsuario);

                // 4. Crear y guardar HistorialDental vacío
                HistorialDental nuevoHistorial = new HistorialDental();
                nuevoHistorial.setCondicionGeneralOral("Sin observaciones iniciales");
                nuevoHistorial.setObservacionesGenerales("Sin observaciones iniciales");
                nuevoHistorial.setTratamientosPrevios("Ninguno");
                nuevoHistorial.setAlergiasDentales("Ninguna");
                nuevoHistorial.setMedicamentosActuales("Ninguno");
                historialDentalDAO.insert(nuevoHistorial); // El ID se autogenera

                // 5. Crear y guardar Paciente
                Paciente nuevoPaciente = new Paciente();
                nuevoPaciente.setUsuario(nuevoUsuario);
                nuevoPaciente.setHistorialDental(nuevoHistorial);
                pacienteDAO.insert(nuevoPaciente);
            }

            // 6. Redirigir al login con mensaje de éxito
            response.sendRedirect(request.getContextPath() + "/login?registro=exitoso");

        } catch (RuntimeException e) {
            e.printStackTrace();
            request.setAttribute("error", "Ocurrió un error durante el registro. Por favor, inténtelo de nuevo.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}
