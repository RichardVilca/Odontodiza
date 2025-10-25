package com.proyecto.odontodiza.dao;

import com.proyecto.odontodiza.model.TratamientoOdontologico;
import com.proyecto.odontodiza.model.Paciente;
import com.proyecto.odontodiza.model.Odontologo;
import com.proyecto.odontodiza.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TratamientoOdontologicoDAO {

    public List<TratamientoOdontologico> listAll() {
        List<TratamientoOdontologico> tratamientos = new ArrayList<>();
        String sql = "SELECT to.id, to.nombre_tratamiento, to.descripcion, to.fecha_inicio, to.fecha_fin, to.estado, to.costo, to.observaciones, " +
                     "p.id as paciente_id, o.id as odontologo_id " +
                     "FROM tratamientos_odontologicos to " +
                     "JOIN pacientes p ON to.paciente_id = p.id " +
                     "JOIN odontologos o ON to.odontologo_id = o.id";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                TratamientoOdontologico tratamiento = new TratamientoOdontologico();
                tratamiento.setId(rs.getInt("id"));
                tratamiento.setNombreTratamiento(rs.getString("nombre_tratamiento"));
                tratamiento.setDescripcion(rs.getString("descripcion"));
                tratamiento.setFechaInicio(rs.getDate("fecha_inicio"));
                tratamiento.setFechaFin(rs.getDate("fecha_fin"));
                tratamiento.setEstado(rs.getString("estado"));
                tratamiento.setCosto(rs.getDouble("costo"));
                tratamiento.setObservaciones(rs.getString("observaciones"));

                // For simplicity, only setting IDs for related objects.
                // Full objects would be fetched in a more complete application.
                Paciente paciente = new Paciente();
                paciente.setId(rs.getInt("paciente_id"));
                tratamiento.setPaciente(paciente);

                Odontologo odontologo = new Odontologo();
                odontologo.setId(rs.getInt("odontologo_id"));
                tratamiento.setOdontologo(odontologo);

                tratamientos.add(tratamiento);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return tratamientos;
    }

    public TratamientoOdontologico findById(int id) {
        TratamientoOdontologico tratamiento = null;
        String sql = "SELECT to.id, to.nombre_tratamiento, to.descripcion, to.fecha_inicio, to.fecha_fin, to.estado, to.costo, to.observaciones, " +
                     "p.id as paciente_id, o.id as odontologo_id " +
                     "FROM tratamientos_odontologicos to " +
                     "JOIN pacientes p ON to.paciente_id = p.id " +
                     "JOIN odontologos o ON to.odontologo_id = o.id " +
                     "WHERE to.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    tratamiento = new TratamientoOdontologico();
                    tratamiento.setId(rs.getInt("id"));
                    tratamiento.setNombreTratamiento(rs.getString("nombre_tratamiento"));
                    tratamiento.setDescripcion(rs.getString("descripcion"));
                    tratamiento.setFechaInicio(rs.getDate("fecha_inicio"));
                    tratamiento.setFechaFin(rs.getDate("fecha_fin"));
                    tratamiento.setEstado(rs.getString("estado"));
                    tratamiento.setCosto(rs.getDouble("costo"));
                    tratamiento.setObservaciones(rs.getString("observaciones"));

                    Paciente paciente = new Paciente();
                    paciente.setId(rs.getInt("paciente_id"));
                    tratamiento.setPaciente(paciente);

                    Odontologo odontologo = new Odontologo();
                    odontologo.setId(rs.getInt("odontologo_id"));
                    tratamiento.setOdontologo(odontologo);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return tratamiento;
    }

    public void insert(TratamientoOdontologico tratamiento) {
        String sql = "INSERT INTO tratamientos_odontologicos (paciente_id, odontologo_id, nombre_tratamiento, descripcion, fecha_inicio, fecha_fin, estado, costo, observaciones) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, tratamiento.getPaciente().getId());
            pstmt.setInt(2, tratamiento.getOdontologo().getId());
            pstmt.setString(3, tratamiento.getNombreTratamiento());
            pstmt.setString(4, tratamiento.getDescripcion());
            pstmt.setDate(5, new java.sql.Date(tratamiento.getFechaInicio().getTime()));
            pstmt.setDate(6, tratamiento.getFechaFin() != null ? new java.sql.Date(tratamiento.getFechaFin().getTime()) : null);
            pstmt.setString(7, tratamiento.getEstado());
            pstmt.setDouble(8, tratamiento.getCosto());
            pstmt.setString(9, tratamiento.getObservaciones());
            pstmt.executeUpdate();

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    tratamiento.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void update(TratamientoOdontologico tratamiento) {
        String sql = "UPDATE tratamientos_odontologicos SET paciente_id = ?, odontologo_id = ?, nombre_tratamiento = ?, descripcion = ?, fecha_inicio = ?, fecha_fin = ?, estado = ?, costo = ?, observaciones = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, tratamiento.getPaciente().getId());
            pstmt.setInt(2, tratamiento.getOdontologo().getId());
            pstmt.setString(3, tratamiento.getNombreTratamiento());
            pstmt.setString(4, tratamiento.getDescripcion());
            pstmt.setDate(5, new java.sql.Date(tratamiento.getFechaInicio().getTime()));
            pstmt.setDate(6, tratamiento.getFechaFin() != null ? new java.sql.Date(tratamiento.getFechaFin().getTime()) : null);
            pstmt.setString(7, tratamiento.getEstado());
            pstmt.setDouble(8, tratamiento.getCosto());
            pstmt.setString(9, tratamiento.getObservaciones());
            pstmt.setInt(10, tratamiento.getId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM tratamientos_odontologicos WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<TratamientoOdontologico> findByPacienteId(int pacienteId) {
        List<TratamientoOdontologico> tratamientos = new ArrayList<>();
        String sql = "SELECT to.id, to.nombre_tratamiento, to.descripcion, to.fecha_inicio, to.fecha_fin, to.estado, to.costo, to.observaciones, " +
                     "p.id as paciente_id, o.id as odontologo_id " +
                     "FROM tratamientos_odontologicos to " +
                     "JOIN pacientes p ON to.paciente_id = p.id " +
                     "JOIN odontologos o ON to.odontologo_id = o.id " +
                     "WHERE to.paciente_id = ? ORDER BY to.fecha_inicio DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, pacienteId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    TratamientoOdontologico tratamiento = new TratamientoOdontologico();
                    tratamiento.setId(rs.getInt("id"));
                    tratamiento.setNombreTratamiento(rs.getString("nombre_tratamiento"));
                    tratamiento.setDescripcion(rs.getString("descripcion"));
                    tratamiento.setFechaInicio(rs.getDate("fecha_inicio"));
                    tratamiento.setFechaFin(rs.getDate("fecha_fin"));
                    tratamiento.setEstado(rs.getString("estado"));
                    tratamiento.setCosto(rs.getDouble("costo"));
                    tratamiento.setObservaciones(rs.getString("observaciones"));

                    Paciente paciente = new Paciente();
                    paciente.setId(rs.getInt("paciente_id"));
                    tratamiento.setPaciente(paciente);

                    Odontologo odontologo = new Odontologo();
                    odontologo.setId(rs.getInt("odontologo_id"));
                    tratamiento.setOdontologo(odontologo);

                    tratamientos.add(tratamiento);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return tratamientos;
    }
}
