package com.proyecto.odontodiza.model;

import java.util.Date;

public class HistorialDental {

    private int id;
    private Date fechaCreacion;
    private Date ultimaActualizacion;
    private String condicionGeneralOral;
    private String observacionesGenerales;
    private String tratamientosPrevios;
    private String alergiasDentales;
    private String medicamentosActuales;

    public HistorialDental() {
    }

    public HistorialDental(int id, Date fechaCreacion, Date ultimaActualizacion, String condicionGeneralOral, String observacionesGenerales, String tratamientosPrevios, String alergiasDentales, String medicamentosActuales) {
        this.id = id;
        this.fechaCreacion = fechaCreacion;
        this.ultimaActualizacion = ultimaActualizacion;
        this.condicionGeneralOral = condicionGeneralOral;
        this.observacionesGenerales = observacionesGenerales;
        this.tratamientosPrevios = tratamientosPrevios;
        this.alergiasDentales = alergiasDentales;
        this.medicamentosActuales = medicamentosActuales;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(Date fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public Date getUltimaActualizacion() {
        return ultimaActualizacion;
    }

    public void setUltimaActualizacion(Date ultimaActualizacion) {
        this.ultimaActualizacion = ultimaActualizacion;
    }

    public String getCondicionGeneralOral() {
        return condicionGeneralOral;
    }

    public void setCondicionGeneralOral(String condicionGeneralOral) {
        this.condicionGeneralOral = condicionGeneralOral;
    }

    public String getObservacionesGenerales() {
        return observacionesGenerales;
    }

    public void setObservacionesGenerales(String observacionesGenerales) {
        this.observacionesGenerales = observacionesGenerales;
    }

    public String getTratamientosPrevios() {
        return tratamientosPrevios;
    }

    public void setTratamientosPrevios(String tratamientosPrevios) {
        this.tratamientosPrevios = tratamientosPrevios;
    }

    public String getAlergiasDentales() {
        return alergiasDentales;
    }

    public void setAlergiasDentales(String alergiasDentales) {
        this.alergiasDentales = alergiasDentales;
    }

    public String getMedicamentosActuales() {
        return medicamentosActuales;
    }

    public void setMedicamentosActuales(String medicamentosActuales) {
        this.medicamentosActuales = medicamentosActuales;
    }
}
