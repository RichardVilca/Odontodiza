package com.proyecto.odontodiza.dao;

import com.proyecto.odontodiza.model.Paciente;
import com.proyecto.odontodiza.model.Usuario;
import com.proyecto.odontodiza.model.HistorialDental;
import com.proyecto.odontodiza.model.Persona;
import com.proyecto.odontodiza.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PacienteDAO {

    private Paciente mapRowToPaciente(ResultSet rs) throws SQLException {
        Paciente paciente = new Paciente();
        paciente.setId(rs.getInt("id"));

        Usuario usuario = new Usuario();
        usuario.setId(rs.getInt("usuario_id"));
        usuario.setNombreUsuario(rs.getString("nombre_usuario"));
        usuario.setRol(rs.getString("rol"));

        Persona persona = new Persona();
        persona.setId(rs.getInt("persona_id")); // BUG FIX: Set the Persona ID
        persona.setNombre(rs.getString("nombre"));
        persona.setApellido(rs.getString("apellido"));
        persona.setEmail(rs.getString("email"));
        persona.setTelefono(rs.getString("telefono"));
        persona.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
        persona.setGenero(rs.getString("genero"));
        persona.setDireccion(rs.getString("direccion"));
        usuario.setPersona(persona);

        paciente.setUsuario(usuario);

        HistorialDental hd = new HistorialDental();
        hd.setId(rs.getInt("historial_dental_id"));
        hd.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
        hd.setUltimaActualizacion(rs.getTimestamp("ultima_actualizacion"));
        hd.setCondicionGeneralOral(rs.getString("condicion_general_oral"));
        hd.setObservacionesGenerales(rs.getString("observaciones_generales"));
        hd.setTratamientosPrevios(rs.getString("tratamientos_previos"));
        hd.setAlergiasDentales(rs.getString("alergias_dentales"));
        hd.setMedicamentosActuales(rs.getString("medicamentos_actuales"));
        paciente.setHistorialDental(hd);

        return paciente;
    }

    public List<Paciente> listAll(int offset, int limit) {
        List<Paciente> pacientes = new ArrayList<>();
        String sql = "SELECT pa.id, pa.usuario_id, p.id as persona_id, pa.historial_dental_id, " +
                     "u.nombre_usuario, u.rol, " +
                     "p.nombre, p.apellido, p.email, p.telefono, p.fecha_nacimiento, p.genero, p.direccion, " +
                     "hc.fecha_creacion, hc.ultima_actualizacion, hc.condicion_general_oral, hc.observaciones_generales, hc.tratamientos_previos, hc.alergias_dentales, hc.medicamentos_actuales " +
                     "FROM pacientes pa " +
                     "JOIN usuarios u ON pa.usuario_id = u.id " +
                     "JOIN personas p ON u.persona_id = p.id " +
                     "JOIN historiales_dentales hc ON pa.historial_dental_id = hc.id " +
                     "ORDER BY p.apellido, p.nombre LIMIT ? OFFSET ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, limit);
            pstmt.setInt(2, offset);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    pacientes.add(mapRowToPaciente(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return pacientes;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM pacientes";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return 0;
    }

    public List<Paciente> searchByName(String name, int offset, int limit) {
        List<Paciente> pacientes = new ArrayList<>();
        String sql = "SELECT pa.id, pa.usuario_id, p.id as persona_id, pa.historial_dental_id, " +
                     "u.nombre_usuario, u.rol, " +
                     "p.nombre, p.apellido, p.email, p.telefono, p.fecha_nacimiento, p.genero, p.direccion, " +
                     "hc.fecha_creacion, hc.ultima_actualizacion, hc.condicion_general_oral, hc.observaciones_generales, hc.tratamientos_previos, hc.alergias_dentales, hc.medicamentos_actuales " +
                     "FROM pacientes pa " +
                     "JOIN usuarios u ON pa.usuario_id = u.id " +
                     "JOIN personas p ON u.persona_id = p.id " +
                     "JOIN historiales_dentales hc ON pa.historial_dental_id = hc.id " +
                     "WHERE p.nombre LIKE ? OR p.apellido LIKE ? " +
                     "ORDER BY p.apellido, p.nombre LIMIT ? OFFSET ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String likeTerm = "%" + name + "%";
            pstmt.setString(1, likeTerm);
            pstmt.setString(2, likeTerm);
            pstmt.setInt(3, limit);
            pstmt.setInt(4, offset);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    pacientes.add(mapRowToPaciente(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return pacientes;
    }

    public int countByName(String name) {
        String sql = "SELECT COUNT(*) FROM pacientes pa " +
                     "JOIN usuarios u ON pa.usuario_id = u.id " +
                     "JOIN personas p ON u.persona_id = p.id " +
                     "WHERE p.nombre LIKE ? OR p.apellido LIKE ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String likeTerm = "%" + name + "%";
            pstmt.setString(1, likeTerm);
            pstmt.setString(2, likeTerm);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return 0;
    }

    public List<Paciente> listAll() {
        List<Paciente> pacientes = new ArrayList<>();
        String sql = "SELECT pa.id, pa.usuario_id, p.id as persona_id, pa.historial_dental_id, " +
                     "u.nombre_usuario, u.rol, " +
                     "p.nombre, p.apellido, p.email, p.telefono, p.fecha_nacimiento, p.genero, p.direccion, " +
                     "hc.fecha_creacion, hc.ultima_actualizacion, hc.condicion_general_oral, hc.observaciones_generales, hc.tratamientos_previos, hc.alergias_dentales, hc.medicamentos_actuales " +
                     "FROM pacientes pa " +
                     "JOIN usuarios u ON pa.usuario_id = u.id " +
                     "JOIN personas p ON u.persona_id = p.id " +
                     "JOIN historiales_dentales hc ON pa.historial_dental_id = hc.id " +
                     "ORDER BY p.apellido, p.nombre";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                pacientes.add(mapRowToPaciente(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return pacientes;
    }

    public Paciente findById(int id) {
        Paciente paciente = null;
        String sql = "SELECT pa.id, pa.usuario_id, p.id as persona_id, pa.historial_dental_id, " +
                     "u.nombre_usuario, u.rol, " +
                     "p.nombre, p.apellido, p.email, p.telefono, p.fecha_nacimiento, p.genero, p.direccion, " +
                     "hc.fecha_creacion, hc.ultima_actualizacion, hc.condicion_general_oral, hc.observaciones_generales, hc.tratamientos_previos, hc.alergias_dentales, hc.medicamentos_actuales " +
                     "FROM pacientes pa " +
                     "JOIN usuarios u ON pa.usuario_id = u.id " +
                     "JOIN personas p ON u.persona_id = p.id " +
                     "JOIN historiales_dentales hc ON pa.historial_dental_id = hc.id " +
                     "WHERE pa.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    paciente = mapRowToPaciente(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return paciente;
    }

    public Paciente findByUsuarioId(int usuarioId) {
        // This method seems incomplete and only used for appointments. I'll leave it as is.
        Paciente paciente = null;
        String sql = "SELECT * FROM pacientes WHERE usuario_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, usuarioId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    paciente = new Paciente();
                    paciente.setId(rs.getInt("id"));
                    // Aquí puedes inflar el resto de los datos del paciente si es necesario
                    // Por ahora, solo necesitamos el ID del paciente para la cita
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return paciente;
    }

    public void insert(Paciente paciente) {
        String sql = "INSERT INTO pacientes (usuario_id, historial_dental_id) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, paciente.getUsuario().getId());
            pstmt.setInt(2, paciente.getHistorialDental().getId());
            pstmt.executeUpdate();

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    paciente.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void update(Paciente paciente) {
        String sql = "UPDATE pacientes SET usuario_id = ?, historial_dental_id = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, paciente.getUsuario().getId());
            pstmt.setInt(2, paciente.getHistorialDental().getId());
            pstmt.setInt(3, paciente.getId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM pacientes WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    public int countNuevosPacientesMes() {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE rol = 'paciente' AND MONTH(fecha_registro) = MONTH(CURDATE()) AND YEAR(fecha_registro) = YEAR(CURDATE())";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return 0;
    }

    public int countPacientesSinCitaProxima() {
        String sql = "SELECT COUNT(DISTINCT pa.id) " +
                     "FROM pacientes pa " +
                     "LEFT JOIN citas c ON pa.id = c.paciente_id " +
                     "LEFT JOIN horarios_disponibles h ON c.horario_id = h.id AND h.fecha_hora_inicio >= CURDATE() " +
                     "WHERE h.id IS NULL";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return 0;
    }
}