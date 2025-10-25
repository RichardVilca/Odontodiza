package com.proyecto.odontodiza.dao;

import com.proyecto.odontodiza.model.Reporte;
import com.proyecto.odontodiza.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReporteDAO {

    public List<Reporte> listAll() {
        List<Reporte> reportes = new ArrayList<>();
        String sql = "SELECT * FROM reportes";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Reporte reporte = new Reporte();
                reporte.setId(rs.getInt("id"));
                reporte.setTipo(rs.getString("tipo"));
                reporte.setFechaGeneracion(rs.getTimestamp("fecha_generacion"));
                reporte.setDatos(rs.getString("datos"));
                reportes.add(reporte);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return reportes;
    }

    public Reporte findById(int id) {
        Reporte reporte = null;
        String sql = "SELECT * FROM reportes WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    reporte = new Reporte();
                    reporte.setId(rs.getInt("id"));
                    reporte.setTipo(rs.getString("tipo"));
                    reporte.setFechaGeneracion(rs.getTimestamp("fecha_generacion"));
                    reporte.setDatos(rs.getString("datos"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return reporte;
    }

    public void insert(Reporte reporte) {
        String sql = "INSERT INTO reportes (tipo, fecha_generacion, datos) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, reporte.getTipo());
            pstmt.setTimestamp(2, new Timestamp(reporte.getFechaGeneracion().getTime()));
            pstmt.setString(3, reporte.getDatos());
            pstmt.executeUpdate();

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    reporte.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void update(Reporte reporte) {
        String sql = "UPDATE reportes SET tipo = ?, fecha_generacion = ?, datos = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, reporte.getTipo());
            pstmt.setTimestamp(2, new Timestamp(reporte.getFechaGeneracion().getTime()));
            pstmt.setString(3, reporte.getDatos());
            pstmt.setInt(4, reporte.getId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM reportes WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
