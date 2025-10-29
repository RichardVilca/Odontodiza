package com.proyecto.odontodiza.model;

import com.proyecto.odontodiza.model.Odontologo;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class HorarioDisponible {
    private int id;
    private int odontologoId;
    private Odontologo odontologo; // New field
    private LocalDateTime fechaHoraInicio;
    private int duracionMinutos;
    private String estado;
    private String tipoAtencion;

    // Nuevo método para compatibilidad con JSTL
    public Date getFechaHoraInicioAsDate() {
        if (this.fechaHoraInicio == null) {
            return null;
        }
        return Date.from(this.fechaHoraInicio.atZone(ZoneId.systemDefault()).toInstant());
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOdontologoId() {
        return odontologoId;
    }

    public void setOdontologoId(int odontologoId) {
        this.odontologoId = odontologoId;
    }

    // New getter and setter for Odontologo
    public Odontologo getOdontologo() {
        return odontologo;
    }

    public void setOdontologo(Odontologo odontologo) {
        this.odontologo = odontologo;
    }

    public LocalDateTime getFechaHoraInicio() {
        return fechaHoraInicio;
    }

    public void setFechaHoraInicio(LocalDateTime fechaHoraInicio) {
        this.fechaHoraInicio = fechaHoraInicio;
    }

    public int getDuracionMinutos() {
        return duracionMinutos;
    }

    public void setDuracionMinutos(int duracionMinutos) {
        this.duracionMinutos = duracionMinutos;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getTipoAtencion() {
        return tipoAtencion;
    }

    public void setTipoAtencion(String tipoAtencion) {
        this.tipoAtencion = tipoAtencion;
    }
}
