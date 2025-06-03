<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="conexion.jsp" %>
<%
    String idParam = request.getParameter("id");
    int idDispositivo = 0;
    if (idParam != null && !idParam.trim().isEmpty()) {
        idDispositivo = Integer.parseInt(idParam);
    } else {
        out.println("<div class='alert alert-danger'>ID de dispositivo no proporcionado.</div>");
        return;
    }

    // Variables para precargar datos
    int idCliente = 0;
    String nombre = "", apellidos = "", telefono = "", email = "", direccion = "", ciudad = "", codigo_postal = "";
    String tipo_dispositivo = "", marca = "", modelo = "", numero_serie = "", problema_reportado = "";
    String descripcion_servicio = "", tecnico_asignado = "", observaciones = "";
    double costo = 0;

    try {
        PreparedStatement ps = conexion.prepareStatement(
            "SELECT c.*, d.*, s.descripcion_servicio, s.costo, s.tecnico_asignado, s.observaciones " +
            "FROM dispositivos d " +
            "JOIN clientes c ON d.id_cliente = c.id_cliente " +
            "LEFT JOIN servicios s ON d.id_dispositivo = s.id_dispositivo " +
            "WHERE d.id_dispositivo = ?"
        );
        ps.setInt(1, idDispositivo);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            idCliente = rs.getInt("id_cliente");
            nombre = rs.getString("nombre");
            apellidos = rs.getString("apellidos");
            telefono = rs.getString("telefono");
            email = rs.getString("email");
            direccion = rs.getString("direccion");
            ciudad = rs.getString("ciudad");
            codigo_postal = rs.getString("codigo_postal");
            tipo_dispositivo = rs.getString("tipo_dispositivo");
            marca = rs.getString("marca");
            modelo = rs.getString("modelo");
            numero_serie = rs.getString("numero_serie");
            problema_reportado = rs.getString("problema_reportado");
            descripcion_servicio = rs.getString("descripcion_servicio");
            costo = rs.getDouble("costo");
            tecnico_asignado = rs.getString("tecnico_asignado");
            observaciones = rs.getString("observaciones");
        } else {
            out.println("<div class='alert alert-danger'>No se encontraron datos para el dispositivo.</div>");
            return;
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error al cargar datos: " + e.getMessage() + "</div>");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Servicio</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
<div class="container mt-4 mb-5">
    <div class="row justify-content-center">
        <div class="col-lg-10 col-xl-8">
            <div class="card shadow-lg border-0">
                <div class="card-header bg-primary text-white d-flex align-items-center">
                    <i class="bi bi-pencil-square me-2 fs-4"></i>
                    <h3 class="mb-0">Editar Servicio</h3>
                </div>
                <div class="card-body">
                    <form action="procesarEdicionServicio.jsp" method="post" class="needs-validation" novalidate>
                        <input type="hidden" name="id_dispositivo" value="<%= idDispositivo %>">
                        <input type="hidden" name="id_cliente" value="<%= idCliente %>">

                        <!-- Datos del Cliente -->
                        <div class="mb-4">
                            <h5 class="text-primary mb-3"><i class="bi bi-person-circle me-2"></i>Datos del Cliente</h5>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Nombre</label>
                                    <input type="text" class="form-control" name="nombre" value="<%= nombre %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Apellidos</label>
                                    <input type="text" class="form-control" name="apellidos" value="<%= apellidos %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Teléfono</label>
                                    <input type="text" class="form-control" name="telefono" value="<%= telefono %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Email</label>
                                    <input type="email" class="form-control" name="email" value="<%= email %>">
                                </div>
                                <div class="col-md-8">
                                    <label class="form-label">Dirección</label>
                                    <input type="text" class="form-control" name="direccion" value="<%= direccion %>" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Ciudad</label>
                                    <input type="text" class="form-control" name="ciudad" value="<%= ciudad %>" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Código Postal</label>
                                    <input type="text" class="form-control" name="codigo_postal" value="<%= codigo_postal %>">
                                </div>
                            </div>
                        </div>
                        <hr class="my-4">

                        <!-- Datos del Dispositivo -->
                        <div class="mb-4">
                            <h5 class="text-primary mb-3"><i class="bi bi-pc-display me-2"></i>Datos del Dispositivo</h5>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Tipo de Dispositivo</label>
                                    <select class="form-select" name="tipo_dispositivo" required>
                                        <option value="">Seleccione...</option>
                                        <option value="PC" <%= tipo_dispositivo.equals("PC") ? "selected" : "" %>>PC</option>
                                        <option value="Laptop" <%= tipo_dispositivo.equals("Laptop") ? "selected" : "" %>>Laptop</option>
                                        <option value="Tablet" <%= tipo_dispositivo.equals("Tablet") ? "selected" : "" %>>Tablet</option>
                                        <option value="Impresora" <%= tipo_dispositivo.equals("Impresora") ? "selected" : "" %>>Impresora</option>
                                        <option value="Monitor" <%= tipo_dispositivo.equals("Monitor") ? "selected" : "" %>>Monitor</option>
                                        <option value="Otro" <%= tipo_dispositivo.equals("Otro") ? "selected" : "" %>>Otro</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Marca</label>
                                    <input type="text" class="form-control" name="marca" value="<%= marca %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Modelo</label>
                                    <input type="text" class="form-control" name="modelo" value="<%= modelo %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Número de Serie</label>
                                    <input type="text" class="form-control" name="numero_serie" value="<%= numero_serie %>">
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Problema Reportado</label>
                                    <textarea class="form-control" name="problema_reportado" rows="2" required><%= problema_reportado %></textarea>
                                </div>
                            </div>
                        </div>
                        <hr class="my-4">

                        <!-- Datos del Servicio -->
                        <div class="mb-4">
                            <h5 class="text-primary mb-3"><i class="bi bi-clipboard-data me-2"></i>Datos del Servicio</h5>
                            <div class="row g-3">
                                <div class="col-12">
                                    <label class="form-label">Descripción del Servicio</label>
                                    <textarea class="form-control" name="descripcion_servicio" rows="2" required><%= descripcion_servicio %></textarea>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Costo ($)</label>
                                    <input type="number" class="form-control" name="costo" min="0" step="0.01" value="<%= costo %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Técnico Asignado</label>
                                    <input type="text" class="form-control" name="tecnico_asignado" value="<%= tecnico_asignado %>">
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Observaciones</label>
                                    <textarea class="form-control" name="observaciones" rows="2"><%= observaciones %></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex justify-content-end gap-2">
                            <button type="submit" class="btn btn-success px-4">
                                <i class="bi bi-save me-1"></i> Guardar Cambios
                            </button>
                            <a href="index.jsp" class="btn btn-secondary px-4">
                                <i class="bi bi-x-circle me-1"></i> Cancelar
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>