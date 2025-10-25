package com.proyecto.odontodiza.model;

import java.util.Date;

public class Cita {

    private int id;
    private Paciente paciente;
    private HorarioDisponible horario;
    private String motivo;
    private String estado;

    // Getters y Setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Paciente getPaciente() {
        return paciente;
    }

    public void setPaciente(Paciente paciente) {
        this.paciente = paciente;
    }

    public HorarioDisponible getHorario() {
        return horario;
    }

    public void setHorario(HorarioDisponible horario) {
        this.horario = horario;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}
