package com.proyecto.odontodiza.dao;

import com.proyecto.odontodiza.model.Odontologo; // Changed import
import com.proyecto.odontodiza.model.Usuario;
import com.proyecto.odontodiza.model.Persona;
import com.proyecto.odontodiza.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OdontologoDAO { // Changed class name

    public List<Odontologo> listAll() { // Changed return type
        List<Odontologo> odontologos = new ArrayList<>(); // Changed list type
        String sql = "SELECT n.id, n.especialidad, n.licencia, n.usuario_id, " +
                     "u.nombre_usuario, u.rol, " +
                     "p.nombre, p.apellido " +
                     "FROM odontologos n " + // Changed table name
                     "JOIN usuarios u ON n.usuario_id = u.id " +
                     "JOIN personas p ON u.persona_id = p.id";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Odontologo odontologo = new Odontologo(); // Changed object creation
                odontologo.setId(rs.getInt("id"));
                odontologo.setEspecialidad(rs.getString("especialidad"));
                odontologo.setLicencia(rs.getString("licencia"));

                Usuario usuario = new Usuario();
                usuario.setId(rs.getInt("usuario_id"));
                usuario.setNombreUsuario(rs.getString("nombre_usuario"));
                usuario.setRol(rs.getString("rol"));

                Persona persona = new Persona();
                persona.setNombre(rs.getString("nombre"));
                persona.setApellido(rs.getString("apellido"));
                usuario.setPersona(persona);

                odontologo.setUsuario(usuario); // Changed setter
                odontologos.add(odontologo); // Changed list add
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return odontologos; // Changed return
    }

    public Odontologo findById(int id) { // Changed return type
        Odontologo odontologo = null; // Changed object type
        String sql = "SELECT n.id, n.especialidad, n.licencia, n.usuario_id, " +
                     "u.nombre_usuario, u.rol, " +
                     "p.nombre, p.apellido " +
                     "FROM odontologos n " + // Changed table name
                     "JOIN usuarios u ON n.usuario_id = u.id " +
                     "JOIN personas p ON u.persona_id = p.id " +
                     "WHERE n.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    odontologo = new Odontologo(); // Changed object creation
                    odontologo.setId(rs.getInt("id"));
                    odontologo.setEspecialidad(rs.getString("especialidad"));
                    odontologo.setLicencia(rs.getString("licencia"));

                    Usuario usuario = new Usuario();
                    usuario.setId(rs.getInt("usuario_id"));
                    usuario.setNombreUsuario(rs.getString("nombre_usuario"));
                    usuario.setRol(rs.getString("rol"));

                    Persona persona = new Persona();
                    persona.setNombre(rs.getString("nombre"));
                    persona.setApellido(rs.getString("apellido"));
                    usuario.setPersona(persona);

                    odontologo.setUsuario(usuario); // Changed setter
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return odontologo; // Changed return
    }

    public Odontologo findByUsuarioId(int usuarioId) { // Changed return type
        Odontologo odontologo = null; // Changed object type
        String sql = "SELECT * FROM odontologos WHERE usuario_id = ?"; // Changed table name
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, usuarioId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    odontologo = new Odontologo(); // Changed object creation
                    odontologo.setId(rs.getInt("id"));
                    odontologo.setEspecialidad(rs.getString("especialidad"));
                    odontologo.setLicencia(rs.getString("licencia"));
                    // El objeto de usuario se puede inflar aquí si es necesario
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return odontologo; // Changed return
    }

    public void insert(Odontologo odontologo) { // Changed parameter type
        String sql = "INSERT INTO odontologos (especialidad, licencia, usuario_id) VALUES (?, ?, ?)"; // Changed table name
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, odontologo.getEspecialidad());
            pstmt.setString(2, odontologo.getLicencia());
            pstmt.setInt(3, odontologo.getUsuario().getId());
            pstmt.executeUpdate();

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    odontologo.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void update(Odontologo odontologo) { // Changed parameter type
        String sql = "UPDATE odontologos SET especialidad = ?, licencia = ?, usuario_id = ? WHERE id = ?"; // Changed table name
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, odontologo.getEspecialidad());
            pstmt.setString(2, odontologo.getLicencia());
            pstmt.setInt(3, odontologo.getUsuario().getId());
            pstmt.setInt(4, odontologo.getId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM odontologos WHERE id = ?"; // Changed table name
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
