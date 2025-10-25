package com.proyecto.odontodiza.controller;

import com.proyecto.odontodiza.dao.CitaDAO;
import com.proyecto.odontodiza.dao.PacienteDAO;
import com.proyecto.odontodiza.dao.OdontologoDAO; // Changed import
import com.proyecto.odontodiza.model.Odontologo;
import com.proyecto.odontodiza.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.WeekFields;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@WebServlet("/odontologo") // Changed annotation
public class OdontologoServlet extends HttpServlet {

    private CitaDAO citaDAO;
    private PacienteDAO pacienteDAO;
    private OdontologoDAO odontologoDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        citaDAO = new CitaDAO();
        pacienteDAO = new PacienteDAO();
        odontologoDAO = new OdontologoDAO();
    } // Changed class name

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("OdontologoServlet: doGet called. Request URI: " + request.getRequestURI()); // Changed log
        HttpSession session = request.getSession(false);
        System.out.println("OdontologoServlet: Session ID at start of doGet: " + (session != null ? session.getId() : "null")); // Changed log
        if (session == null || session.getAttribute("usuario") == null || !("Odontologo".equalsIgnoreCase(((Usuario)session.getAttribute("usuario")).getRol()))) { // Changed role check
            System.out.println("OdontologoServlet: Session check failed. Redirecting to login."); // Changed log
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // --- Lógica de Estadísticas ---
        Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
        Odontologo odontologo = odontologoDAO.findByUsuarioId(usuarioLogueado.getId());
        if (odontologo == null) {
            System.out.println("OdontologoServlet: Odontologo object not found for user ID: " + usuarioLogueado.getId());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Odontólogo no encontrado.");
            return;
        }
        request.setAttribute("odontologo", odontologo);

        CitaDAO citaDAO = new CitaDAO();
        PacienteDAO pacienteDAO = new PacienteDAO();
        int citasHoy = citaDAO.countCitasHoy();
        int nuevosPacientesMes = pacienteDAO.countNuevosPacientesMes();
        int pacientesSinCitaProxima = pacienteDAO.countPacientesSinCitaProxima();
        List<com.proyecto.odontodiza.model.Cita> citasDelDia = citaDAO.findCitasDeHoy();
        
        // --- Lógica del Calendario Dinámico ---
        String weekParam = request.getParameter("week");
        LocalDate today = LocalDate.now();
        
        LocalDate startDate;
        if (weekParam != null && !weekParam.isEmpty()) {
            try {
                startDate = LocalDate.parse(weekParam);
            } catch (java.time.format.DateTimeParseException e) {
                startDate = today;
            }
        } else {
            startDate = today;
        }

        WeekFields weekFields = WeekFields.of(new Locale("es", "ES"));
        LocalDate firstDayOfWeek = startDate.with(weekFields.dayOfWeek(), 1);
        
        List<LocalDate> weekDays = new ArrayList<>();
        List<java.util.Date> weekDaysAsDates = new ArrayList<>(); // Nueva lista para la JSP
        for (int i = 0; i < 7; i++) {
            LocalDate currentDay = firstDayOfWeek.plusDays(i);
            weekDays.add(currentDay);
            weekDaysAsDates.add(java.util.Date.from(currentDay.atStartOfDay(ZoneId.systemDefault()).toInstant()));
        }

        // Obtener citas para cada día de la semana
        Map<LocalDate, List<com.proyecto.odontodiza.model.Cita>> citasPorDia = new HashMap<>();
        for (LocalDate day : weekDays) {
            citasPorDia.put(day, citaDAO.findCitasByDate(day));
        }

        // --- Datos para el gráfico de citas semanales ---
        Map<LocalDate, Integer> citasPorDiaCount = new HashMap<>();
        for (LocalDate day : weekDays) {
            citasPorDiaCount.put(day, citaDAO.countCitasByDate(day));
        }

        LocalDate lastDayOfWeek = firstDayOfWeek.plusDays(6);

        // Calcular citas de la semana
        Date inicioSemana = java.util.Date.from(firstDayOfWeek.atStartOfDay(ZoneId.systemDefault()).toInstant());
        Date finSemana = java.util.Date.from(lastDayOfWeek.atStartOfDay(ZoneId.systemDefault()).toInstant());
        int citasSemana = citaDAO.countCitasSemana(inicioSemana, finSemana);

        LocalDate previousWeek = firstDayOfWeek.minusWeeks(1);
        LocalDate nextWeek = firstDayOfWeek.plusWeeks(1);

        // Formatear las fechas para el título directamente en el servlet
        DateTimeFormatter headerFormatter = DateTimeFormatter.ofPattern("d 'de' MMMM", new Locale("es", "ES"));
        DateTimeFormatter yearHeaderFormatter = DateTimeFormatter.ofPattern("d 'de' MMMM, yyyy", new Locale("es", "ES"));

        String firstDayFormatted = firstDayOfWeek.format(headerFormatter);
        String lastDayFormatted = lastDayOfWeek.format(yearHeaderFormatter);

        // Enviar datos a la vista (JSP)
        request.setAttribute("citasHoy", citasHoy);
        request.setAttribute("nuevosPacientesMes", nuevosPacientesMes);
        request.setAttribute("citasSemana", citasSemana);
        request.setAttribute("pacientesSinCitaProxima", pacientesSinCitaProxima);
        request.setAttribute("citasDelDia", citasDelDia);
        request.setAttribute("citasPorDia", citasPorDia);
        request.setAttribute("citasPorDiaCount", citasPorDiaCount);
        
        request.setAttribute("weekDays", weekDays); // Para la lógica
        request.setAttribute("weekDaysAsDates", weekDaysAsDates); // Para el formateo
        request.setAttribute("firstDayFormatted", firstDayFormatted);
        request.setAttribute("lastDayFormatted", lastDayFormatted);
        request.setAttribute("previousWeek", previousWeek.toString());
        request.setAttribute("nextWeek", nextWeek.toString());
        request.setAttribute("today", today);

        System.out.println("OdontologoServlet: Forwarding to odontologo.jsp");
        request.getRequestDispatcher("/WEB-INF/views/odontologo/odontologo.jsp").forward(request, response);
    }
}
