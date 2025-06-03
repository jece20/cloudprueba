<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="conexion.jsp" %>
<%
    boolean exito = false;
    String mensaje = "";
    try {
        int idDispositivo = Integer.parseInt(request.getParameter("id_dispositivo"));
        int idCliente = Integer.parseInt(request.getParameter("id_cliente"));
        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String telefono = request.getParameter("telefono");
        String email = request.getParameter("email");
        String direccion = request.getParameter("direccion");
        String ciudad = request.getParameter("ciudad");
        String codigo_postal = request.getParameter("codigo_postal");
        String tipo_dispositivo = request.getParameter("tipo_dispositivo");
        String marca = request.getParameter("marca");
        String modelo = request.getParameter("modelo");
        String numero_serie = request.getParameter("numero_serie");
        String problema_reportado = request.getParameter("problema_reportado");
        String descripcion_servicio = request.getParameter("descripcion_servicio");
        double costo = Double.parseDouble(request.getParameter("costo"));
        String tecnico_asignado = request.getParameter("tecnico_asignado");
        String observaciones = request.getParameter("observaciones");

        conexion.setAutoCommit(false);

        // Actualizar cliente
        PreparedStatement psCliente = conexion.prepareStatement(
            "UPDATE clientes SET nombre=?, apellidos=?, telefono=?, email=?, direccion=?, ciudad=?, codigo_postal=? WHERE id_cliente=?"
        );
        psCliente.setString(1, nombre);
        psCliente.setString(2, apellidos);
        psCliente.setString(3, telefono);
        psCliente.setString(4, email);
        psCliente.setString(5, direccion);
        psCliente.setString(6, ciudad);
        psCliente.setString(7, codigo_postal);
        psCliente.setInt(8, idCliente);
        psCliente.executeUpdate();

        // Actualizar dispositivo
        PreparedStatement psDisp = conexion.prepareStatement(
            "UPDATE dispositivos SET tipo_dispositivo=?, marca=?, modelo=?, numero_serie=?, problema_reportado=? WHERE id_dispositivo=?"
        );
        psDisp.setString(1, tipo_dispositivo);
        psDisp.setString(2, marca);
        psDisp.setString(3, modelo);
        psDisp.setString(4, numero_serie);
        psDisp.setString(5, problema_reportado);
        psDisp.setInt(6, idDispositivo);
        psDisp.executeUpdate();

        // Actualizar servicio
        PreparedStatement psServ = conexion.prepareStatement(
            "UPDATE servicios SET descripcion_servicio=?, costo=?, tecnico_asignado=?, observaciones=? WHERE id_dispositivo=?"
        );
        psServ.setString(1, descripcion_servicio);
        psServ.setDouble(2, costo);
        psServ.setString(3, tecnico_asignado);
        psServ.setString(4, observaciones);
        psServ.setInt(5, idDispositivo);
        psServ.executeUpdate();

        conexion.commit();
        exito = true;
        mensaje = "Servicio actualizado correctamente.";
    } catch (Exception e) {
        try { conexion.rollback(); } catch(Exception ex) {}
        mensaje = "Error al actualizar: " + e.getMessage();
    } finally {
        try { conexion.setAutoCommit(true); } catch(Exception ex) {}
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Resultado de Edición</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <meta http-equiv="refresh" content="3;url=index.jsp">
</head>
<body>
<div class="container mt-5">
    <div class="alert <%= exito ? "alert-success" : "alert-danger" %>">
        <%= mensaje %>
    </div>
    <a href="index.jsp" class="btn btn-primary">Volver al Dashboard</a>
</div>
</body>
</html>