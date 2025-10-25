package com.proyecto.odontodiza.model;

public class Odontologo {

    private int id;
    private String especialidad;
    private String licencia;
    private Usuario usuario;

    public Odontologo() {
    }

    public Odontologo(int id, String especialidad, String licencia, Usuario usuario) {
        this.id = id;
        this.especialidad = especialidad;
        this.licencia = licencia;
        this.usuario = usuario;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEspecialidad() {
        return especialidad;
    }

    public void setEspecialidad(String especialidad) {
        this.especialidad = especialidad;
    }

    public String getLicencia() {
        return licencia;
    }

    public void setLicencia(String licencia) {
        this.licencia = licencia;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }
}
