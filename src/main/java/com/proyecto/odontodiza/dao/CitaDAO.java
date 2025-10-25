package com.proyecto.odontodiza.dao;

import com.proyecto.odontodiza.model.Persona;
import com.proyecto.odontodiza.model.HorarioDisponible;
import com.proyecto.odontodiza.model.Cita;
import com.proyecto.odontodiza.model.Usuario;
import com.proyecto.odontodiza.model.Paciente;
import com.proyecto.odontodiza.model.Odontologo;
import com.proyecto.odontodiza.util.DBUtil;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class CitaDAO {

    private Cita mapRowToCita(ResultSet rs) throws SQLException {
        Cita cita = new Cita();
        cita.setId(rs.getInt("cita_id"));
        cita.setMotivo(rs.getString("motivo"));
        cita.setEstado(rs.getString("cita_estado"));

        HorarioDisponible horario = new HorarioDisponible();
        horario.setId(rs.getInt("horario_id"));
        horario.setFechaHoraInicio(rs.getTimestamp("fecha_hora_inicio").toLocalDateTime());
        horario.setDuracionMinutos(rs.getInt("duracion_minutos"));
        // Assuming odontologoId is set in HorarioDisponible model
        horario.setOdontologoId(rs.getInt("odontologo_id"));
        cita.setHorario(horario);

        Paciente paciente = new Paciente();
        paciente.setId(rs.getInt("paciente_id"));
        Usuario usuario = new Usuario();
        usuario.setId(rs.getInt("usuario_id"));
        Persona persona = new Persona();
        persona.setNombre(rs.getString("nombre"));
        persona.setApellido(rs.getString("apellido"));
        usuario.setPersona(persona);
        paciente.setUsuario(usuario);
        cita.setPaciente(paciente);

        Odontologo odontologo = new Odontologo();
        odontologo.setId(rs.getInt("odontologo_id"));
        Usuario odontologoUsuario = new Usuario();
        Persona odontologoPersona = new Persona();
        odontologoPersona.setNombre(rs.getString("odontologo_nombre"));
        odontologoPersona.setApellido(rs.getString("odontologo_apellido"));
        odontologoUsuario.setPersona(odontologoPersona);
        odontologo.setUsuario(odontologoUsuario);
        // You might want to set the odontologo object in the HorarioDisponible or Cita object directly
        // For now, I'll just ensure the data is fetched.

        return cita;
    }

    public void insert(Cita cita) {
        String sqlInsertCita = "INSERT INTO citas (paciente_id, horario_id, motivo, estado) VALUES (?, ?, ?, ?)";
        String sqlUpdateHorario = "UPDATE horarios_disponibles SET estado = 'Reservado' WHERE id = ?";
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement pstmtCita = conn.prepareStatement(sqlInsertCita, Statement.RETURN_GENERATED_KEYS);
                 PreparedStatement pstmtHorario = conn.prepareStatement(sqlUpdateHorario)) {
                
                pstmtCita.setInt(1, cita.getPaciente().getId());
                pstmtCita.setInt(2, cita.getHorario().getId());
                pstmtCita.setString(3, cita.getMotivo());
                pstmtCita.setString(4, "Programada");
                pstmtCita.executeUpdate();

                try (ResultSet generatedKeys = pstmtCita.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        cita.setId(generatedKeys.getInt(1));
                    }
                }

                pstmtHorario.setInt(1, cita.getHorario().getId());
                pstmtHorario.executeUpdate();

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw new RuntimeException("Error en la transacción de inserción de cita", e);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al conectar con la base de datos para insertar cita", e);
        }
    }

    public List<Cita> getAllCitasReservadas() {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.id as cita_id, c.motivo, c.estado as cita_estado, " +
                     "h.id as horario_id, h.fecha_hora_inicio, h.duracion_minutos, " +
                     "p.id as paciente_id, u.id as usuario_id, pe.nombre, pe.apellido, " +
                     "o.id as odontologo_id, po.nombre as odontologo_nombre, po.apellido as odontologo_apellido " +
                     "FROM citas c " +
                     "JOIN horarios_disponibles h ON c.horario_id = h.id " +
                     "JOIN pacientes p ON c.paciente_id = p.id " +
                     "JOIN usuarios u ON p.usuario_id = u.id " +
                     "JOIN personas pe ON u.persona_id = pe.id " +
                     "JOIN odontologos o ON h.odontologo_id = o.id " +
                     "JOIN personas po ON o.usuario_id = po.id " +
                     "ORDER BY h.fecha_hora_inicio DESC";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                citas.add(mapRowToCita(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al obtener todas las citas reservadas", e);
        }
        return citas;
    }

    public List<Cita> findByPacienteId(int pacienteId) {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.id as cita_id, c.motivo, c.estado as cita_estado, " +
                     "h.id as horario_id, h.fecha_hora_inicio, h.duracion_minutos, " +
                     "p.id as paciente_id, u.id as usuario_id, pe.nombre, pe.apellido, " +
                     "o.id as odontologo_id, po.nombre as odontologo_nombre, po.apellido as odontologo_apellido " +
                     "FROM citas c " +
                     "JOIN horarios_disponibles h ON c.horario_id = h.id " +
                     "JOIN pacientes p ON c.paciente_id = p.id " +
                     "JOIN usuarios u ON p.usuario_id = u.id " +
                     "JOIN personas pe ON u.persona_id = pe.id " +
                     "JOIN odontologos o ON h.odontologo_id = o.id " +
                     "JOIN personas po ON o.usuario_id = po.id " +
                     "WHERE c.paciente_id = ? ORDER BY h.fecha_hora_inicio DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, pacienteId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    citas.add(mapRowToCita(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al buscar citas por paciente", e);
        }
        return citas;
    }

    public void updateStatus(int citaId, String estado) {
        String sql = "UPDATE citas SET estado = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, estado);
            pstmt.setInt(2, citaId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizar estado de la cita", e);
        }
    }

    public int countCitasByDate(LocalDate date) {
        String sql = "SELECT COUNT(*) FROM citas c JOIN horarios_disponibles h ON c.horario_id = h.id WHERE DATE(h.fecha_hora_inicio) = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, Date.valueOf(date));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al contar citas por fecha", e);
        }
        return 0;
    }

    public int countCitasHoy() {
        return countCitasByDate(LocalDate.now());
    }

    public List<Cita> findCitasDeHoy() {
        return findCitasByDate(LocalDate.now());
    }

    public List<Cita> findCitasByDate(LocalDate date) {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.id as cita_id, c.motivo, c.estado as cita_estado, " +
                     "h.id as horario_id, h.fecha_hora_inicio, h.duracion_minutos, " +
                     "p.id as paciente_id, u.id as usuario_id, pe.nombre, pe.apellido, " +
                     "o.id as odontologo_id, po.nombre as odontologo_nombre, po.apellido as odontologo_apellido " +
                     "FROM citas c " +
                     "JOIN horarios_disponibles h ON c.horario_id = h.id " +
                     "JOIN pacientes p ON c.paciente_id = p.id " +
                     "JOIN usuarios u ON p.usuario_id = u.id " +
                     "JOIN personas pe ON u.persona_id = pe.id " +
                     "JOIN odontologos o ON h.odontologo_id = o.id " +
                     "JOIN personas po ON o.usuario_id = po.id " +
                     "WHERE DATE(h.fecha_hora_inicio) = ? ORDER BY h.fecha_hora_inicio ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, Date.valueOf(date));
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    citas.add(mapRowToCita(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al buscar citas por fecha", e);
        }
        return citas;
    }

    public int countCitasSemana(java.util.Date inicio, java.util.Date fin) {
        String sql = "SELECT COUNT(*) FROM citas c JOIN horarios_disponibles h ON c.horario_id = h.id WHERE h.fecha_hora_inicio BETWEEN ? AND ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setTimestamp(1, new Timestamp(inicio.getTime()));
            pstmt.setTimestamp(2, new Timestamp(fin.getTime()));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al contar citas por semana", e);
        }
        return 0;
    }
}