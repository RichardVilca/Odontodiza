package com.proyecto.odontodiza.dao;

import com.proyecto.odontodiza.model.HistorialDental; // Changed import
import com.proyecto.odontodiza.model.Paciente;
import com.proyecto.odontodiza.model.Usuario;
import com.proyecto.odontodiza.model.Persona;
import com.proyecto.odontodiza.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HistorialDentalDAO { // Changed class name

    public List<HistorialDental> listAll() { // Changed return type
        List<HistorialDental> historiales = new ArrayList<>(); // Changed list type
        String sql = "SELECT hc.id, hc.fecha_creacion, hc.ultima_actualizacion, hc.condicion_general_oral, hc.observaciones_generales, hc.tratamientos_previos, hc.alergias_dentales, hc.medicamentos_actuales, " +
                     "p.id as paciente_id, u.id as usuario_id, pe.nombre, pe.apellido " +
                     "FROM historiales_dentales hc " + // Changed table name
                     "JOIN pacientes p ON hc.id = p.historial_dental_id " + // Changed join condition
                     "JOIN usuarios u ON p.usuario_id = u.id " +
                     "JOIN personas pe ON u.persona_id = pe.id";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                HistorialDental historial = new HistorialDental(); // Changed object creation
                historial.setId(rs.getInt("id"));
                historial.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                historial.setUltimaActualizacion(rs.getTimestamp("ultima_actualizacion"));
                historial.setCondicionGeneralOral(rs.getString("condicion_general_oral"));
                historial.setObservacionesGenerales(rs.getString("observaciones_generales"));
                historial.setTratamientosPrevios(rs.getString("tratamientos_previos"));
                historial.setAlergiasDentales(rs.getString("alergias_dentales"));
                historial.setMedicamentosActuales(rs.getString("medicamentos_actuales"));

                // The Paciente object is not directly part of HistorialDental in the model,
                // but it's joined here for context. We'll keep it simple for now.
                // If a full Paciente object is needed, it should be fetched separately or in a more complex join.
                // For now, we'll just set the ID if needed, or remove this part if not.
                // Given the model, HistorialDental does not contain a Paciente object directly.
                // So, I will remove the Paciente object creation and setting.

                historiales.add(historial);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return historiales;
    }

    public HistorialDental findById(int id) { // Changed return type
        HistorialDental historial = null; // Changed object type
        String sql = "SELECT hc.id, hc.fecha_creacion, hc.ultima_actualizacion, hc.condicion_general_oral, hc.observaciones_generales, hc.tratamientos_previos, hc.alergias_dentales, hc.medicamentos_actuales " +
                     "FROM historiales_dentales hc " + // Changed table name
                     "WHERE hc.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    historial = new HistorialDental(); // Changed object creation
                    historial.setId(rs.getInt("id"));
                    historial.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                    historial.setUltimaActualizacion(rs.getTimestamp("ultima_actualizacion"));
                    historial.setCondicionGeneralOral(rs.getString("condicion_general_oral"));
                    historial.setObservacionesGenerales(rs.getString("observaciones_generales"));
                    historial.setTratamientosPrevios(rs.getString("tratamientos_previos"));
                    historial.setAlergiasDentales(rs.getString("alergias_dentales"));
                    historial.setMedicamentosActuales(rs.getString("medicamentos_actuales"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return historial;
    }

    public void insert(HistorialDental historial) { // Changed parameter type
        String sql = "INSERT INTO historiales_dentales (condicion_general_oral, observaciones_generales, tratamientos_previos, alergias_dentales, medicamentos_actuales) VALUES (?, ?, ?, ?, ?)"; // Changed table name and columns
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, historial.getCondicionGeneralOral());
            pstmt.setString(2, historial.getObservacionesGenerales());
            pstmt.setString(3, historial.getTratamientosPrevios());
            pstmt.setString(4, historial.getAlergiasDentales());
            pstmt.setString(5, historial.getMedicamentosActuales());
            pstmt.executeUpdate();

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    historial.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void update(HistorialDental historial) { // Changed parameter type
        String sql = "UPDATE historiales_dentales SET condicion_general_oral = ?, observaciones_generales = ?, tratamientos_previos = ?, alergias_dentales = ?, medicamentos_actuales = ? WHERE id = ?"; // Changed table name and columns
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, historial.getCondicionGeneralOral());
            pstmt.setString(2, historial.getObservacionesGenerales());
            pstmt.setString(3, historial.getTratamientosPrevios());
            pstmt.setString(4, historial.getAlergiasDentales());
            pstmt.setString(5, historial.getMedicamentosActuales());
            pstmt.setInt(6, historial.getId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM historiales_dentales WHERE id = ?"; // Changed table name
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
