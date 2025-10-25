package com.proyecto.odontodiza.dao;

import com.proyecto.odontodiza.model.Persona;
import com.proyecto.odontodiza.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PersonaDAO {

    public List<Persona> listAll() {
        List<Persona> personas = new ArrayList<>();
        String sql = "SELECT * FROM personas";
        System.out.println("Ejecutando consulta SQL: " + sql);
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            int rowCount = 0;
            while (rs.next()) {
                Persona persona = new Persona();
                persona.setId(rs.getInt("id"));
                persona.setNombre(rs.getString("nombre"));
                persona.setApellido(rs.getString("apellido"));
                persona.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                persona.setGenero(rs.getString("genero"));
                persona.setDireccion(rs.getString("direccion"));
                persona.setTelefono(rs.getString("telefono"));
                persona.setEmail(rs.getString("email"));
                personas.add(persona);
                rowCount++;
            }
            System.out.println("Se encontraron " + rowCount + " personas.");
        } catch (SQLException e) {
            System.err.println("Error en PersonaDAO.listAll(): " + e.getMessage());
            throw new RuntimeException(e);
        }
        return personas;
    }

    public Persona findById(int id) {
        Persona persona = null;
        String sql = "SELECT * FROM personas WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    persona = new Persona();
                    persona.setId(rs.getInt("id"));
                    persona.setNombre(rs.getString("nombre"));
                    persona.setApellido(rs.getString("apellido"));
                    persona.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                    persona.setGenero(rs.getString("genero"));
                    persona.setDireccion(rs.getString("direccion"));
                    persona.setTelefono(rs.getString("telefono"));
                    persona.setEmail(rs.getString("email"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return persona;
    }

    public void insert(Persona persona) {
        String sql = "INSERT INTO personas (nombre, apellido, fecha_nacimiento, genero, direccion, telefono, email) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, persona.getNombre());
            pstmt.setString(2, persona.getApellido());
            pstmt.setDate(3, new java.sql.Date(persona.getFechaNacimiento().getTime()));
            pstmt.setString(4, persona.getGenero());
            pstmt.setString(5, persona.getDireccion());
            pstmt.setString(6, persona.getTelefono());
            pstmt.setString(7, persona.getEmail());
            pstmt.executeUpdate();

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    persona.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void update(Persona persona) {
        String sql = "UPDATE personas SET nombre = ?, apellido = ?, fecha_nacimiento = ?, genero = ?, direccion = ?, telefono = ?, email = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, persona.getNombre());
            pstmt.setString(2, persona.getApellido());
            pstmt.setDate(3, new java.sql.Date(persona.getFechaNacimiento().getTime()));
            pstmt.setString(4, persona.getGenero());
            pstmt.setString(5, persona.getDireccion());
            pstmt.setString(6, persona.getTelefono());
            pstmt.setString(7, persona.getEmail());
            pstmt.setInt(8, persona.getId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM personas WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
