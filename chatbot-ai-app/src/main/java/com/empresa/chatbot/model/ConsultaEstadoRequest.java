package com.empresa.chatbot.model;

public class ConsultaEstadoRequest {
    private String idEquipo;

    public ConsultaEstadoRequest() {
    }

    public ConsultaEstadoRequest(String idEquipo) {
        this.idEquipo = idEquipo;
    }

    public String getIdEquipo() {
        return idEquipo;
    }

    public void setIdEquipo(String idEquipo) {
        this.idEquipo = idEquipo;
    }
}