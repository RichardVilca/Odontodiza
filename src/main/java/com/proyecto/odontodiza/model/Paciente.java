package com.proyecto.odontodiza.model;

public class Paciente {

    private int id;
    private HistorialDental historialDental;
    private Usuario usuario;

    public Paciente() {
    }

    public Paciente(int id, HistorialDental historialDental, Usuario usuario) {
        this.id = id;
        this.historialDental = historialDental;
        this.usuario = usuario;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public HistorialDental getHistorialDental() {
        return historialDental;
    }

    public void setHistorialDental(HistorialDental historialDental) {
        this.historialDental = historialDental;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }
}
