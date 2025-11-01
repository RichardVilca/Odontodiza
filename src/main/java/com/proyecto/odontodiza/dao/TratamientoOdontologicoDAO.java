package com.proyecto.odontodiza.dao;

import com.proyecto.odontodiza.model.TratamientoOdontologico;
import com.proyecto.odontodiza.model.Paciente;
import com.proyecto.odontodiza.model.Odontologo;
import com.proyecto.odontodiza.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TratamientoOdontologicoDAO {

    public List<TratamientoOdontologico> findByPacienteId(int pacienteId) {
        List<TratamientoOdontologico> tratamientos = new ArrayList<>();
        String sql = "SELECT * FROM tratamientos_odontologicos WHERE paciente_id = ? ORDER BY fecha_inicio DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, pacienteId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                TratamientoOdontologico t = new TratamientoOdontologico();
                t.setId(rs.getInt("id"));
                // Aquí necesitaríamos DAOs de Paciente y Odontologo para cargarlos completos
                // Por simplicidad, solo seteamos el ID por ahora.
                Paciente p = new Paciente();
                p.setId(rs.getInt("paciente_id"));
                t.setPaciente(p);
                
                Odontologo o = new Odontologo();
                o.setId(rs.getInt("odontologo_id"));
                t.setOdontologo(o);

                t.setNombreTratamiento(rs.getString("nombre_tratamiento"));
                t.setDescripcion(rs.getString("descripcion"));
                t.setFechaInicio(rs.getDate("fecha_inicio"));
                t.setFechaFin(rs.getDate("fecha_fin"));
                t.setEstado(rs.getString("estado"));
                t.setCosto(rs.getBigDecimal("costo"));
                t.setObservaciones(rs.getString("observaciones"));
                t.setDientesAfectados(rs.getString("dientes_afectados"));
                tratamientos.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tratamientos;
    }
    
    public TratamientoOdontologico findById(int id) {
        String sql = "SELECT * FROM tratamientos_odontologicos WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                TratamientoOdontologico t = new TratamientoOdontologico();
                t.setId(rs.getInt("id"));
                Paciente p = new Paciente();
                p.setId(rs.getInt("paciente_id"));
                t.setPaciente(p);
                Odontologo o = new Odontologo();
                o.setId(rs.getInt("odontologo_id"));
                t.setOdontologo(o);
                t.setNombreTratamiento(rs.getString("nombre_tratamiento"));
                t.setDescripcion(rs.getString("descripcion"));
                t.setFechaInicio(rs.getDate("fecha_inicio"));
                t.setFechaFin(rs.getDate("fecha_fin"));
                t.setEstado(rs.getString("estado"));
                t.setCosto(rs.getBigDecimal("costo"));
                t.setObservaciones(rs.getString("observaciones"));
                t.setDientesAfectados(rs.getString("dientes_afectados"));
                return t;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insert(TratamientoOdontologico t) {
        String sql = "INSERT INTO tratamientos_odontologicos (paciente_id, odontologo_id, nombre_tratamiento, descripcion, fecha_inicio, fecha_fin, estado, costo, observaciones, dientes_afectados) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, t.getPaciente().getId());
            pstmt.setInt(2, t.getOdontologo().getId());
            pstmt.setString(3, t.getNombreTratamiento());
            pstmt.setString(4, t.getDescripcion());
            pstmt.setDate(5, new java.sql.Date(t.getFechaInicio().getTime()));
            pstmt.setDate(6, (t.getFechaFin() != null) ? new java.sql.Date(t.getFechaFin().getTime()) : null);
            pstmt.setString(7, t.getEstado());
            pstmt.setBigDecimal(8, t.getCosto());
            pstmt.setString(9, t.getObservaciones());
            pstmt.setString(10, t.getDientesAfectados());
            pstmt.executeUpdate();

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    t.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(TratamientoOdontologico t) {
        String sql = "UPDATE tratamientos_odontologicos SET paciente_id = ?, odontologo_id = ?, nombre_tratamiento = ?, descripcion = ?, fecha_inicio = ?, fecha_fin = ?, estado = ?, costo = ?, observaciones = ?, dientes_afectados = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, t.getPaciente().getId());
            pstmt.setInt(2, t.getOdontologo().getId());
            pstmt.setString(3, t.getNombreTratamiento());
            pstmt.setString(4, t.getDescripcion());
            pstmt.setDate(5, new java.sql.Date(t.getFechaInicio().getTime()));
            pstmt.setDate(6, (t.getFechaFin() != null) ? new java.sql.Date(t.getFechaFin().getTime()) : null);
            pstmt.setString(7, t.getEstado());
            pstmt.setBigDecimal(8, t.getCosto());
            pstmt.setString(9, t.getObservaciones());
            pstmt.setString(10, t.getDientesAfectados());
            pstmt.setInt(11, t.getId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM tratamientos_odontologicos WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}