<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="conexion.jsp" %>
<%
    boolean exito = false;
    String mensaje = "";
    int idClienteInsertado = 0;
    int idDispositivoInsertado = 0;

    try {
        boolean esClienteExistente = request.getParameter("id_cliente_existente") != null && !request.getParameter("id_cliente_existente").trim().isEmpty();
        int idCliente = 0;

        conexion.setAutoCommit(false);

        // 1. Cliente
        if (esClienteExistente) {
            idCliente = Integer.parseInt(request.getParameter("id_cliente_existente"));
        } else {
            String nombre = request.getParameter("nombre");
            String apellidos = request.getParameter("apellidos");
            String telefono = request.getParameter("telefono");
            String direccion = request.getParameter("direccion");
            String ciudad = request.getParameter("ciudad");
            if (nombre == null || apellidos == null || telefono == null || direccion == null || ciudad == null ||
                nombre.trim().isEmpty() || apellidos.trim().isEmpty() || telefono.trim().isEmpty() || direccion.trim().isEmpty() || ciudad.trim().isEmpty()) {
                throw new Exception("Faltan datos obligatorios del cliente.");
            }
            String email = request.getParameter("email") != null ? request.getParameter("email") : "";
            String codigoPostal = request.getParameter("codigo_postal") != null ? request.getParameter("codigo_postal") : "";

            PreparedStatement psCliente = conexion.prepareStatement(
                "INSERT INTO clientes (nombre, apellidos, telefono, email, direccion, ciudad, codigo_postal) VALUES (?, ?, ?, ?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );
            psCliente.setString(1, nombre);
            psCliente.setString(2, apellidos);
            psCliente.setString(3, telefono);
            psCliente.setString(4, email);
            psCliente.setString(5, direccion);
            psCliente.setString(6, ciudad);
            psCliente.setString(7, codigoPostal);
            psCliente.executeUpdate();
            ResultSet rsCliente = psCliente.getGeneratedKeys();
            if (rsCliente.next()) {
                idCliente = rsCliente.getInt(1);
                idClienteInsertado = idCliente;
            } else {
                throw new SQLException("Error al crear cliente, no se generó ID.");
            }
        }

        // 2. Dispositivo
        String tipoDispositivo = request.getParameter("tipo_dispositivo");
        String marca = request.getParameter("marca");
        String modelo = request.getParameter("modelo");
        String numeroSerie = request.getParameter("numero_serie") != null ? request.getParameter("numero_serie") : "";
        String problemaReportado = request.getParameter("problema_reportado");
        if (tipoDispositivo == null || tipoDispositivo.trim().isEmpty() ||
            marca == null || marca.trim().isEmpty() ||
            modelo == null || modelo.trim().isEmpty() ||
            problemaReportado == null || problemaReportado.trim().isEmpty()) {
            throw new Exception("Faltan datos obligatorios del dispositivo.");
        }

        PreparedStatement psDispositivo = conexion.prepareStatement(
            "INSERT INTO dispositivos (id_cliente, tipo_dispositivo, marca, modelo, numero_serie, problema_reportado) VALUES (?, ?, ?, ?, ?, ?)",
            Statement.RETURN_GENERATED_KEYS
        );
        psDispositivo.setInt(1, idCliente);
        psDispositivo.setString(2, tipoDispositivo);
        psDispositivo.setString(3, marca);
        psDispositivo.setString(4, modelo);
        psDispositivo.setString(5, numeroSerie);
        psDispositivo.setString(6, problemaReportado);
        psDispositivo.executeUpdate();

        ResultSet rsDispositivo = psDispositivo.getGeneratedKeys();
        if (rsDispositivo.next()) {
            int idDispositivo = rsDispositivo.getInt(1);
            idDispositivoInsertado = idDispositivo;

            // 3. Servicio
            String descripcionServicio = request.getParameter("descripcion_servicio");
            String costoStr = request.getParameter("costo");
            double costo = 0;
            try { costo = Double.parseDouble(costoStr); } catch (Exception ex) { costo = 0; }
            String tecnicoAsignado = request.getParameter("tecnico_asignado") != null ? request.getParameter("tecnico_asignado") : "";
            String observaciones = request.getParameter("observaciones") != null ? request.getParameter("observaciones") : "";

            if (descripcionServicio == null || descripcionServicio.trim().isEmpty() || costoStr == null || costoStr.trim().isEmpty()) {
                throw new Exception("Faltan datos obligatorios del servicio.");
            }

            PreparedStatement psServicio = conexion.prepareStatement(
                "INSERT INTO servicios (id_dispositivo, descripcion_servicio, costo, tecnico_asignado, observaciones) VALUES (?, ?, ?, ?, ?)"
            );
            psServicio.setInt(1, idDispositivo);
            psServicio.setString(2, descripcionServicio);
            psServicio.setDouble(3, costo);
            psServicio.setString(4, tecnicoAsignado);
            psServicio.setString(5, observaciones);
            psServicio.executeUpdate();

            conexion.commit();
            exito = true;
            mensaje = "¡Servicio registrado exitosamente!";
        } else {
            throw new SQLException("Error al registrar dispositivo, no se generó ID.");
        }

    } catch (Exception e) {
        try { if (conexion != null) conexion.rollback(); } catch (SQLException se) { se.printStackTrace(); }
        exito = false;
        mensaje = "Error al procesar el formulario: " + e.getMessage();
    } finally {
        try { if (conexion != null) conexion.setAutoCommit(true); } catch (SQLException se) { se.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechService - Resultado del Registro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/styles.css">
    <meta http-equiv="refresh" content="5;url=index.jsp">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
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
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Resultado del Registro</h1>
                </div>
                <div class="card shadow">
                    <div class="card-body text-center py-5">
                        <% if (exito) { %>
                            <div class="mb-4">
                                <i class="bi bi-check-circle-fill text-success" style="font-size: 5rem;"></i>
                            </div>
                            <h2 class="mb-3">¡Registro Exitoso!</h2>
                            <p class="lead"><%= mensaje %></p>
                            <div class="alert alert-info mt-4">
                                <p class="mb-0">ID de Servicio: <%= idDispositivoInsertado %></p>
                                <% if (idClienteInsertado > 0) { %>
                                <p class="mb-0">Se ha registrado un nuevo cliente con ID: <%= idClienteInsertado %></p>
                                <% } %>
                            </div>
                            <div class="mt-4">
                                <p>Redirigiendo al Dashboard en 5 segundos...</p>
                                <div class="progress" style="height: 10px;">
                                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-success" role="progressbar" style="width: 100%;" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                            <div class="mt-4">
                                <a href="index.jsp" class="btn btn-primary">Ir al Dashboard</a>
                                <a href="formulario.jsp" class="btn btn-outline-primary ms-2">Registrar Otro Servicio</a>
                            </div>
                        <% } else { %>
                            <div class="mb-4">
                                <i class="bi bi-exclamation-triangle-fill text-danger" style="font-size: 5rem;"></i>
                            </div>
                            <h2 class="mb-3">¡Error en el Registro!</h2>
                            <p class="lead"><%= mensaje %></p>
                            <div class="mt-4">
                                <p>Redirigiendo al formulario en 5 segundos...</p>
                                <div class="progress" style="height: 10px;">
                                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-danger" role="progressbar" style="width: 100%;" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                            </div>
                            <div class="mt-4">
                                <a href="formulario.jsp" class="btn btn-primary">Volver al Formulario</a>
                                <a href="index.jsp" class="btn btn-outline-primary ms-2">Ir al Dashboard</a>
                            </div>
                        <% } %>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>