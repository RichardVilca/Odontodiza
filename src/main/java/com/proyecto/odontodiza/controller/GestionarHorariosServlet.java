package com.proyecto.odontodiza.controller;

import com.proyecto.odontodiza.dao.HorarioDAO;
import com.proyecto.odontodiza.dao.OdontologoDAO;
import com.proyecto.odontodiza.model.HorarioDisponible;
import com.proyecto.odontodiza.model.Odontologo;
import com.proyecto.odontodiza.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/gestionarHorarios")
public class GestionarHorariosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private HorarioDAO horarioDAO;
    private OdontologoDAO odontologoDAO;

    public void init() {
        horarioDAO = new HorarioDAO();
        odontologoDAO = new OdontologoDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null || !"Odontologo".equals(usuario.getRol())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Odontologo odontologo = odontologoDAO.findByUsuarioId(usuario.getId());
        List<HorarioDisponible> horarios = horarioDAO.findByOdontologoId(odontologo.getId());

        request.setAttribute("horarios", horarios);
        request.getRequestDispatcher("/WEB-INF/views/odontologo/gestionar-horarios.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null || !"Odontologo".equals(usuario.getRol())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            handleDelete(request, response);
            return;
        }

        try {
            Odontologo odontologo = odontologoDAO.findByUsuarioId(usuario.getId());
            String fechaHoraStr = request.getParameter("fechaHora");
            int duracion = Integer.parseInt(request.getParameter("duracion"));
            String tipoAtencion = request.getParameter("tipoAtencion");

            HorarioDisponible nuevoHorario = new HorarioDisponible();
            nuevoHorario.setOdontologoId(odontologo.getId());
            nuevoHorario.setFechaHoraInicio(LocalDateTime.parse(fechaHoraStr));
            nuevoHorario.setDuracionMinutos(duracion);
            nuevoHorario.setTipoAtencion(tipoAtencion);

            horarioDAO.insert(nuevoHorario);

            response.sendRedirect(request.getContextPath() + "/gestionarHorarios");
        } catch (Exception e) {
            throw new ServletException("Error al crear el horario", e);
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int horarioId = Integer.parseInt(request.getParameter("horarioId"));
            horarioDAO.delete(horarioId);
            response.sendRedirect(request.getContextPath() + "/gestionarHorarios");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error al eliminar el horario.");
        }
    }
}
