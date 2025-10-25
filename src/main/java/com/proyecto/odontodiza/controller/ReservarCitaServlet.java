package com.proyecto.odontodiza.controller;

import com.proyecto.odontodiza.dao.CitaDAO;
import com.proyecto.odontodiza.dao.HorarioDAO;
import com.proyecto.odontodiza.dao.PacienteDAO;
import com.proyecto.odontodiza.dao.OdontologoDAO;
import com.proyecto.odontodiza.model.Odontologo;
import com.proyecto.odontodiza.model.Cita;
import com.proyecto.odontodiza.model.HorarioDisponible;
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
import java.util.stream.Collectors;

@WebServlet("/reservarCita")
public class ReservarCitaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private HorarioDAO horarioDAO;
    private PacienteDAO pacienteDAO;
    private CitaDAO citaDAO;
    private OdontologoDAO odontologoDAO;

    public void init() {
        horarioDAO = new HorarioDAO();
        pacienteDAO = new PacienteDAO();
        citaDAO = new CitaDAO();
        odontologoDAO = new OdontologoDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Seguridad: solo pacientes logueados
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null || !"Paciente".equals(((Usuario)session.getAttribute("usuario")).getRol())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Obtener todos los horarios de todos los nutricionistas que estén disponibles
        // En una implementación más grande, se podría filtrar por nutricionista
        List<HorarioDisponible> todosLosHorarios = horarioDAO.findAllAvailable();
        
        // Fetch Odontologo for each available schedule
        for (HorarioDisponible horario : todosLosHorarios) {
            Odontologo odontologo = odontologoDAO.findById(horario.getOdontologoId());
            horario.setOdontologo(odontologo);
        }
        
        request.setAttribute("horariosDisponibles", todosLosHorarios);
        request.getRequestDispatcher("/WEB-INF/views/paciente/pacienteCita.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;
        if (usuario == null || !"Paciente".equals(usuario.getRol())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            int horarioId = Integer.parseInt(request.getParameter("horarioId"));
            String motivo = request.getParameter("motivo");

            // Obtener el paciente a partir del usuario en sesión
            Paciente paciente = pacienteDAO.findByUsuarioId(usuario.getId());

            // Crear el objeto Cita
            Cita nuevaCita = new Cita();
            nuevaCita.setMotivo(motivo);
            nuevaCita.setPaciente(paciente);
            
            HorarioDisponible horarioSeleccionado = new HorarioDisponible();
            horarioSeleccionado.setId(horarioId);
            nuevaCita.setHorario(horarioSeleccionado);

            // Insertar la cita (la transacción se maneja en el DAO)
            citaDAO.insert(nuevaCita);

            response.sendRedirect(request.getContextPath() + "/misCitas?reserva=exitosa");

        } catch (Exception e) {
            throw new ServletException("Error al reservar la cita", e);
        }
    }
}
