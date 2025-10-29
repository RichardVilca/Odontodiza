package com.proyecto.odontodiza.controller;

import com.proyecto.odontodiza.dao.PacienteDAO;
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
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@WebServlet("/exportarPacientes")
public class ExportarPacientesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PacienteDAO pacienteDAO;

    public void init() {
        pacienteDAO = new PacienteDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null || !"Odontologo".equalsIgnoreCase(((Usuario) session.getAttribute("usuario")).getRol())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            List<Paciente> pacientes = pacienteDAO.listAll();

            Workbook workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("Pacientes");

            // Crear la fila de encabezado
            Row headerRow = sheet.createRow(0);
            String[] headers = {"ID", "Nombre", "Apellido", "Email", "Teléfono"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
            }

            // Llenar las filas con los datos de los pacientes
            int rowNum = 1;
            for (Paciente paciente : pacientes) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(paciente.getId());
                row.createCell(1).setCellValue(paciente.getUsuario().getPersona().getNombre());
                row.createCell(2).setCellValue(paciente.getUsuario().getPersona().getApellido());
                row.createCell(3).setCellValue(paciente.getUsuario().getPersona().getEmail());
                row.createCell(4).setCellValue(paciente.getUsuario().getPersona().getTelefono());
            }

            // Configurar la respuesta para descargar el archivo
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"pacientes.xlsx\"");

            // Escribir el libro de trabajo en el OutputStream de la respuesta
            workbook.write(response.getOutputStream());
            workbook.close();

        } catch (Exception e) {
            throw new ServletException("Error al exportar pacientes a Excel", e);
        }
    }
}
