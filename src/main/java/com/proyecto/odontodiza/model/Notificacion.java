package com.proyecto.odontodiza.model;

import java.util.Date;

public class Notificacion {

    private int id;
    private Usuario usuario;
    private String mensaje;
    private Date fechaEnvio;
    private boolean leida;

    public Notificacion() {
    }

    public Notificacion(int id, Usuario usuario, String mensaje, Date fechaEnvio, boolean leida) {
        this.id = id;
        this.usuario = usuario;
        this.mensaje = mensaje;
        this.fechaEnvio = fechaEnvio;
        this.leida = leida;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public Date getFechaEnvio() {
        return fechaEnvio;
    }

    public void setFechaEnvio(Date fechaEnvio) {
        this.fechaEnvio = fechaEnvio;
    }

    public boolean isLeida() {
        return leida;
    }

    public void setLeida(boolean leida) {
        this.leida = leida;
    }
}
