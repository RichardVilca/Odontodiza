package com.proyecto.odontodiza.dao;

import com.proyecto.odontodiza.model.Usuario;
import com.proyecto.odontodiza.model.Persona;
import com.proyecto.odontodiza.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public List<Usuario> listAll() {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT u.id, u.nombre_usuario, u.contrasena, u.rol, p.id as persona_id, p.nombre, p.apellido, p.fecha_nacimiento, p.genero, p.direccion, p.telefono, p.email FROM usuarios u JOIN personas p ON u.persona_id = p.id";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setId(rs.getInt("id"));
                usuario.setNombreUsuario(rs.getString("nombre_usuario"));
                usuario.setContrasena(rs.getString("contrasena"));
                usuario.setRol(rs.getString("rol"));

                Persona persona = new Persona();
                persona.setId(rs.getInt("persona_id"));
                persona.setNombre(rs.getString("nombre"));
                persona.setApellido(rs.getString("apellido"));
                persona.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                persona.setGenero(rs.getString("genero"));
                persona.setDireccion(rs.getString("direccion"));
                persona.setTelefono(rs.getString("telefono"));
                persona.setEmail(rs.getString("email"));

                usuario.setPersona(persona);
                usuarios.add(usuario);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return usuarios;
    }

    public Usuario findById(int id) {
        Usuario usuario = null;
        String sql = "SELECT u.id, u.nombre_usuario, u.contrasena, u.rol, p.id as persona_id, p.nombre, p.apellido, p.fecha_nacimiento, p.genero, p.direccion, p.telefono, p.email FROM usuarios u JOIN personas p ON u.persona_id = p.id WHERE u.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setId(rs.getInt("id"));
                    usuario.setNombreUsuario(rs.getString("nombre_usuario"));
                    usuario.setContrasena(rs.getString("contrasena"));
                    usuario.setRol(rs.getString("rol"));

                    Persona persona = new Persona();
                    persona.setId(rs.getInt("persona_id"));
                    persona.setNombre(rs.getString("nombre"));
                    persona.setApellido(rs.getString("apellido"));
                    persona.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                    persona.setGenero(rs.getString("genero"));
                    persona.setDireccion(rs.getString("direccion"));
                    persona.setTelefono(rs.getString("telefono"));
                    persona.setEmail(rs.getString("email"));

                    usuario.setPersona(persona);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return usuario;
    }

    public Usuario findByEmail(String email) {
        Usuario usuario = null;
        String sql = "SELECT u.id, u.nombre_usuario, u.contrasena, u.rol, p.id as persona_id, p.nombre, p.apellido, p.fecha_nacimiento, p.genero, p.direccion, p.telefono, p.email FROM usuarios u JOIN personas p ON u.persona_id = p.id WHERE p.email = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setId(rs.getInt("id"));
                    usuario.setNombreUsuario(rs.getString("nombre_usuario"));
                    usuario.setContrasena(rs.getString("contrasena"));
                    usuario.setRol(rs.getString("rol"));

                    Persona persona = new Persona();
                    persona.setId(rs.getInt("persona_id"));
                    persona.setNombre(rs.getString("nombre"));
                    persona.setApellido(rs.getString("apellido"));
                    persona.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                    persona.setGenero(rs.getString("genero"));
                    persona.setDireccion(rs.getString("direccion"));
                    persona.setTelefono(rs.getString("telefono"));
                    persona.setEmail(rs.getString("email"));

                    usuario.setPersona(persona);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return usuario;
    }

    public void insert(Usuario usuario) {
        String sql = "INSERT INTO usuarios (nombre_usuario, contrasena, rol, persona_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, usuario.getNombreUsuario());
            pstmt.setString(2, usuario.getContrasena());
            pstmt.setString(3, usuario.getRol());
            pstmt.setInt(4, usuario.getPersona().getId());
            pstmt.executeUpdate();

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    usuario.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void update(Usuario usuario) {
        String sql = "UPDATE usuarios SET nombre_usuario = ?, contrasena = ?, rol = ?, persona_id = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, usuario.getNombreUsuario());
            pstmt.setString(2, usuario.getContrasena());
            pstmt.setString(3, usuario.getRol());
            pstmt.setInt(4, usuario.getPersona().getId());
            pstmt.setInt(5, usuario.getId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM usuarios WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
