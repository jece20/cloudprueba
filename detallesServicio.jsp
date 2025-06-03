<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="conexion.jsp" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechService - Detalles del Servicio</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse">
                <div class="position-sticky pt-3">
                    <div class="text-center mb-4">
                        <h2 class="text-white">TechService</h2>
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="index.jsp">
                                <i class="bi bi-speedometer2 me-2"></i>
                                Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="formulario.jsp">
                                <i class="bi bi-file-earmark-plus me-2"></i>
                                Nuevo Servicio
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="detalles">Detalles del Servicio</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="index.jsp" class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-arrow-left"></i> Volver al Dashboard
                        </a>
                    </div>
                </div>

                <div class="card shadow">
                    <div class="card-body">
                        <%
                            int idDispositivo = Integer.parseInt(request.getParameter("id"));
                            try {
                                PreparedStatement ps = conexion.prepareStatement(
                                    "SELECT d.id_dispositivo, CONCAT(c.nombre, ' ', c.apellidos) AS cliente, c.telefono, c.email, c.direccion, c.ciudad, c.codigo_postal, " +
                                    "d.tipo_dispositivo, d.marca, d.modelo, d.numero_serie, d.problema_reportado, d.estado, " +
                                    "DATE_FORMAT(d.fecha_ingreso, '%d/%m/%Y') AS fecha_ingreso, s.descripcion_servicio, s.costo, s.tecnico_asignado, s.observaciones " +
                                    "FROM dispositivos d " +
                                    "JOIN clientes c ON d.id_cliente = c.id_cliente " +
                                    "LEFT JOIN servicios s ON d.id_dispositivo = s.id_dispositivo " +
                                    "WHERE d.id_dispositivo = ?"
                                );
                                ps.setInt(1, idDispositivo);
                                ResultSet rs = ps.executeQuery();

                                if (rs.next()) {
                        %>
                        <h3 class="mb-4">Información del Cliente</h3>
                        <ul class="list-group mb-4">
                            <li class="list-group-item"><strong>Nombre:</strong> <%= rs.getString("cliente") %></li>
                            <li class="list-group-item"><strong>Teléfono:</strong> <%= rs.getString("telefono") %></li>
                            <li class="list-group-item"><strong>Email:</strong> <%= rs.getString("email") %></li>
                            <li class="list-group-item"><strong>Dirección:</strong> <%= rs.getString("direccion") %>, <%= rs.getString("ciudad") %>, <%= rs.getString("codigo_postal") %></li>
                        </ul>

                        <h3 class="mb-4">Información del Dispositivo</h3>
                        <ul class="list-group mb-4">
                            <li class="list-group-item"><strong>Tipo:</strong> <%= rs.getString("tipo_dispositivo") %></li>
                            <li class="list-group-item"><strong>Marca:</strong> <%= rs.getString("marca") %></li>
                            <li class="list-group-item"><strong>Modelo:</strong> <%= rs.getString("modelo") %></li>
                            <li class="list-group-item"><strong>Número de Serie:</strong> <%= rs.getString("numero_serie") %></li>
                            <li class="list-group-item"><strong>Problema Reportado:</strong> <%= rs.getString("problema_reportado") %></li>
                            <li class="list-group-item"><strong>Estado:</strong> <%= rs.getString("estado") %></li>
                            <li class="list-group-item"><strong>Fecha de Ingreso:</strong> <%= rs.getString("fecha_ingreso") %></li>
                        </ul>

                        <h3 class="mb-4">Información del Servicio</h3>
                        <ul class="list-group mb-4">
                            <li class="list-group-item"><strong>Descripción:</strong> <%= rs.getString("descripcion_servicio") %></li>
                            <li class="list-group-item"><strong>Costo:</strong> $<%= rs.getDouble("costo") %></li>
                            <li class="list-group-item"><strong>Técnico Asignado:</strong> <%= rs.getString("tecnico_asignado") %></li>
                            <li class="list-group-item"><strong>Observaciones:</strong> <%= rs.getString("observaciones") %></li>
                        </ul>
                        <% 
                                } else {
                                    out.println("<div class='alert alert-danger'>No se encontraron detalles para el servicio solicitado.</div>");
                                }
                            } catch (Exception e) {
                                out.println("<div class='alert alert-danger'>Error al cargar los detalles: " + e.getMessage() + "</div>");
                            }
                        %>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>