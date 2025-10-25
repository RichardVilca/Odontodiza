package com.proyecto.odontodiza.model;

import java.util.Date;

public class TratamientoOdontologico {

    private int id;
    private Paciente paciente;
    private Odontologo odontologo;
    private String nombreTratamiento;
    private String descripcion;
    private Date fechaInicio;
    private Date fechaFin;
    private String estado;
    private double costo;
    private String observaciones;

    public TratamientoOdontologico() {
    }

    public TratamientoOdontologico(int id, Paciente paciente, Odontologo odontologo, String nombreTratamiento, String descripcion, Date fechaInicio, Date fechaFin, String estado, double costo, String observaciones) {
        this.id = id;
        this.paciente = paciente;
        this.odontologo = odontologo;
        this.nombreTratamiento = nombreTratamiento;
        this.descripcion = descripcion;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
        this.estado = estado;
        this.costo = costo;
        this.observaciones = observaciones;
    }

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

    public Odontologo getOdontologo() {
        return odontologo;
    }

    public void setOdontologo(Odontologo odontologo) {
        this.odontologo = odontologo;
    }

    public String getNombreTratamiento() {
        return nombreTratamiento;
    }

    public void setNombreTratamiento(String nombreTratamiento) {
        this.nombreTratamiento = nombreTratamiento;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Date getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public Date getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public double getCosto() {
        return costo;
    }

    public void setCosto(double costo) {
        this.costo = costo;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }
}
