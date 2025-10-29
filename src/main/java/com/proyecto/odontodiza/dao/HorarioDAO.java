package com.proyecto.odontodiza.dao;

import com.proyecto.odontodiza.model.HorarioDisponible;
import com.proyecto.odontodiza.util.DBUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class HorarioDAO {

    public void insert(HorarioDisponible horario) {
        String sql = "INSERT INTO horarios_disponibles (odontologo_id, fecha_hora_inicio, duracion_minutos, tipo_atencion, estado) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, horario.getOdontologoId());
            pstmt.setTimestamp(2, Timestamp.valueOf(horario.getFechaHoraInicio()));
            pstmt.setInt(3, horario.getDuracionMinutos());
            pstmt.setString(4, horario.getTipoAtencion());
            pstmt.setString(5, "Disponible");
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al insertar horario", e);
        }
    }

    public List<HorarioDisponible> findByOdontologoId(int odontologoId) {
        List<HorarioDisponible> horarios = new ArrayList<>();
        String sql = "SELECT * FROM horarios_disponibles WHERE odontologo_id = ? AND fecha_hora_inicio >= CURDATE() ORDER BY fecha_hora_inicio ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, odontologoId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    HorarioDisponible horario = new HorarioDisponible();
                    horario.setId(rs.getInt("id"));
                    horario.setOdontologoId(rs.getInt("odontologo_id"));
                    horario.setFechaHoraInicio(rs.getTimestamp("fecha_hora_inicio").toLocalDateTime());
                    horario.setDuracionMinutos(rs.getInt("duracion_minutos"));
                    horario.setEstado(rs.getString("estado"));
                    horario.setTipoAtencion(rs.getString("tipo_atencion"));
                    horarios.add(horario);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al buscar horarios por odontologo", e);
        }
        return horarios;
    }

    public void delete(int horarioId) {
        String sql = "DELETE FROM horarios_disponibles WHERE id = ? AND estado = 'Disponible'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, horarioId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al eliminar horario", e);
        }
    }

    public List<HorarioDisponible> findAllAvailable() {
        List<HorarioDisponible> horarios = new ArrayList<>();
        String sql = "SELECT * FROM horarios_disponibles WHERE estado = 'Disponible' AND fecha_hora_inicio >= CURDATE() ORDER BY fecha_hora_inicio ASC";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                HorarioDisponible horario = new HorarioDisponible();
                horario.setId(rs.getInt("id"));
                horario.setOdontologoId(rs.getInt("odontologo_id"));
                horario.setFechaHoraInicio(rs.getTimestamp("fecha_hora_inicio").toLocalDateTime());
                horario.setDuracionMinutos(rs.getInt("duracion_minutos"));
                horario.setEstado(rs.getString("estado"));
                horario.setTipoAtencion(rs.getString("tipo_atencion"));
                horarios.add(horario);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al buscar todos los horarios disponibles", e);
        }
        return horarios;
    }
}
