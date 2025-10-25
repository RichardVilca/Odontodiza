package com.proyecto.odontodiza.dao;

import com.proyecto.odontodiza.model.Notificacion;
import com.proyecto.odontodiza.model.Usuario;
import com.proyecto.odontodiza.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificacionDAO {

    public List<Notificacion> listAll() {
        List<Notificacion> notificaciones = new ArrayList<>();
        String sql = "SELECT n.id, n.mensaje, n.fecha_envio, n.leida, " +
                     "u.id as usuario_id, u.nombre_usuario " +
                     "FROM notificaciones n " +
                     "JOIN usuarios u ON n.usuario_id = u.id";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Notificacion notificacion = new Notificacion();
                notificacion.setId(rs.getInt("id"));
                notificacion.setMensaje(rs.getString("mensaje"));
                notificacion.setFechaEnvio(rs.getTimestamp("fecha_envio"));
                notificacion.setLeida(rs.getBoolean("leida"));

                Usuario usuario = new Usuario();
                usuario.setId(rs.getInt("usuario_id"));
                usuario.setNombreUsuario(rs.getString("nombre_usuario"));
                notificacion.setUsuario(usuario);

                notificaciones.add(notificacion);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return notificaciones;
    }

    public Notificacion findById(int id) {
        Notificacion notificacion = null;
        String sql = "SELECT n.id, n.mensaje, n.fecha_envio, n.leida, " +
                     "u.id as usuario_id, u.nombre_usuario " +
                     "FROM notificaciones n " +
                     "JOIN usuarios u ON n.usuario_id = u.id " +
                     "WHERE n.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    notificacion = new Notificacion();
                    notificacion.setId(rs.getInt("id"));
                    notificacion.setMensaje(rs.getString("mensaje"));
                    notificacion.setFechaEnvio(rs.getTimestamp("fecha_envio"));
                    notificacion.setLeida(rs.getBoolean("leida"));

                    Usuario usuario = new Usuario();
                    usuario.setId(rs.getInt("usuario_id"));
                    usuario.setNombreUsuario(rs.getString("nombre_usuario"));
                    notificacion.setUsuario(usuario);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return notificacion;
    }

    public void insert(Notificacion notificacion) {
        String sql = "INSERT INTO notificaciones (usuario_id, mensaje, fecha_envio, leida) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, notificacion.getUsuario().getId());
            pstmt.setString(2, notificacion.getMensaje());
            pstmt.setTimestamp(3, new Timestamp(notificacion.getFechaEnvio().getTime()));
            pstmt.setBoolean(4, notificacion.isLeida());
            pstmt.executeUpdate();

            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    notificacion.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void update(Notificacion notificacion) {
        String sql = "UPDATE notificaciones SET usuario_id = ?, mensaje = ?, fecha_envio = ?, leida = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, notificacion.getUsuario().getId());
            pstmt.setString(2, notificacion.getMensaje());
            pstmt.setTimestamp(3, new Timestamp(notificacion.getFechaEnvio().getTime()));
            pstmt.setBoolean(4, notificacion.isLeida());
            pstmt.setInt(5, notificacion.getId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM notificaciones WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
