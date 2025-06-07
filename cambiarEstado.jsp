<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="conexion.jsp" %>

<%
    String id = request.getParameter("id");
    String nuevoEstado = request.getParameter("estado");

    String respuesta = "ERROR";
    if (id != null && nuevoEstado != null) {
        try {
            // Obtener estado anterior
            String estadoAnterior = null;
            PreparedStatement psConsulta = conexion.prepareStatement("SELECT estado FROM dispositivos WHERE id_dispositivo = ?");
            psConsulta.setInt(1, Integer.parseInt(id));
            ResultSet rs = psConsulta.executeQuery();
            if (rs.next()) {
                estadoAnterior = rs.getString("estado");
            }

            // Actualizar estado
            PreparedStatement ps = conexion.prepareStatement("UPDATE dispositivos SET estado = ? WHERE id_dispositivo = ?");
            ps.setString(1, nuevoEstado);
            ps.setInt(2, Integer.parseInt(id));
            int filas = ps.executeUpdate();

            // Insertar en historial si hubo cambio
            if (filas > 0 && estadoAnterior != null && !estadoAnterior.equals(nuevoEstado)) {
                PreparedStatement psHistorial = conexion.prepareStatement(
                    "INSERT INTO historial_estados (id_dispositivo, estado_anterior, estado_nuevo, usuario) VALUES (?, ?, ?, ?)"
                );
                psHistorial.setInt(1, Integer.parseInt(id));
                psHistorial.setString(2, estadoAnterior);
                psHistorial.setString(3, nuevoEstado);
                psHistorial.setString(4, "Sistema");
                psHistorial.executeUpdate();
            }

            respuesta = "OK";

        } catch (Exception e) {
            respuesta = "ERROR: " + e.getMessage();
        }
    }

    out.print(respuesta);
%>
