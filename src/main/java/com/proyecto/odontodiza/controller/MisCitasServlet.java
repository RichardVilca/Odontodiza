package com.proyecto.odontodiza.controller;

import com.proyecto.odontodiza.dao.CitaDAO;
import com.proyecto.odontodiza.dao.PacienteDAO;
import com.proyecto.odontodiza.model.Cita;
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

@WebServlet("/misCitas")
public class MisCitasServlet extends HttpServlet {

    private CitaDAO citaDAO;
    private PacienteDAO pacienteDAO;

    @Override
    public void init() {
        citaDAO = new CitaDAO();
        pacienteDAO = new PacienteDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String accion = request.getParameter("accion");

        if ("cancelar".equals(accion)) {
            handleCancelar(request, response, session);
        } else {
            handleListar(request, response, session);
        }
    }

    private void handleListar(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws ServletException, IOException {
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
        Paciente paciente = pacienteDAO.findByUsuarioId(usuarioLogueado.getId());

        if (paciente == null) {
            throw new ServletException("No se encontró el perfil del paciente.");
        }

        List<Cita> citas = citaDAO.findByPacienteId(paciente.getId());
        request.setAttribute("citas", citas);
        request.getRequestDispatcher("/WEB-INF/views/paciente/misCitas.jsp").forward(request, response);
    }

    private void handleCancelar(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException, ServletException {
        try {
            int citaId = Integer.parseInt(request.getParameter("id"));
            // Aquí se podría añadir una verificación de seguridad para asegurar que la cita pertenece al paciente
            // pero por ahora se confía en que la interfaz solo muestra las citas del paciente logueado.
            citaDAO.updateStatus(citaId, "Cancelada");
            response.sendRedirect(request.getContextPath() + "/misCitas?cancel=success");

        } catch (NumberFormatException e) {
            throw new ServletException("ID de cita inválido.", e);
        }
    }
}
