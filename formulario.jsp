<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="conexion.jsp" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechService - Formulario de Servicio</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 d-md-block sidebar collapse">
                <div class="position-sticky pt-3">
                    <div class="text-center mb-4">
                        <h2 class="title">TechService</h2>
                        <img class="logo img-fluid" src="img/log.jpg" alt="Logo de TechService">
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link" href="index.jsp">
                                <i class="bi bi-speedometer2 me-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="formulario.jsp">
                                <i class="bi bi-file-earmark-plus me-2"></i> Nuevo Servicio
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="nueser">Nuevo Servicio de Mantenimiento</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="index.jsp" class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-arrow-left"></i> Volver al Dashboard
                        </a>
                    </div>
                </div>

                <div class="card shadow">
                    <div class="card-body">
                        <div class="progress mb-4" style="height: 30px;">
                            <div id="formProgress" class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">0%</div>
                        </div>
                        
                        <form id="servicioForm" action="procesarFormulario.jsp" method="post" class="needs-validation" novalidate>
                            <!-- PASO 1: Información del Cliente -->
                            <div class="form-section" id="paso1">
                                <h3 class="mb-4">Información del Cliente</h3>
                                <div class="alert alert-info">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="clienteExistente">
                                        <label class="form-check-label" for="clienteExistente">
                                            Cliente existente
                                        </label>
                                    </div>
                                </div>
                                <div id="seleccionClienteExistente" style="display: none;">
                                    <div class="mb-3">
                                        <label for="clienteSelect" class="form-label">Seleccionar Cliente</label>
                                        <select class="form-select" id="clienteSelect" name="id_cliente_existente">
                                            <option value="">Seleccione un cliente...</option>
                                            <%
                                                try {
                                                    Statement st = conexion.createStatement();
                                                    ResultSet rs = st.executeQuery("SELECT id_cliente, nombre, apellidos, telefono FROM clientes ORDER BY nombre");
                                                    while (rs.next()) {
                                            %>
                                            <option value="<%= rs.getInt("id_cliente") %>">
                                                <%= rs.getString("nombre") %> <%= rs.getString("apellidos") %> - <%= rs.getString("telefono") %>
                                            </option>
                                            <%
                                                    }
                                                } catch (Exception e) { }
                                            %>
                                        </select>
                                        <div class="invalid-feedback">Seleccione un cliente existente.</div>
                                    </div>
                                </div>
                                <div id="nuevoClienteForm">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="nombre" class="form-label">Nombre <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="nombre" name="nombre" required>
                                            <div class="invalid-feedback">Ingrese el nombre.</div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="apellidos" class="form-label">Apellidos <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="apellidos" name="apellidos" required>
                                            <div class="invalid-feedback">Ingrese los apellidos.</div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="telefono" class="form-label">Teléfono <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="telefono" name="telefono" required>
                                            <div class="invalid-feedback">Ingrese el teléfono.</div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="email" class="form-label">Email</label>
                                            <input type="email" class="form-control" id="email" name="email">
                                            <div class="invalid-feedback">Ingrese un email válido.</div>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="direccion" class="form-label">Dirección <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="direccion" name="direccion" required>
                                        <div class="invalid-feedback">Ingrese la dirección.</div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="ciudad" class="form-label">Ciudad <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="ciudad" name="ciudad" required>
                                            <div class="invalid-feedback">Ingrese la ciudad.</div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="codigo_postal" class="form-label">Código Postal</label>
                                            <input type="text" class="form-control" id="codigo_postal" name="codigo_postal">
                                        </div>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-end mt-4">
                                    <button type="button" class="btn btn-primary next-btn">Siguiente <i class="bi bi-arrow-right"></i></button>
                                </div>
                            </div>
                            <!-- PASO 2: Información del Dispositivo -->
                            <div class="form-section" id="paso2" style="display: none;">
                                <h3 class="mb-4">Información del Dispositivo</h3>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="tipo_dispositivo" class="form-label">Tipo de Dispositivo <span class="text-danger">*</span></label>
                                        <select class="form-select" id="tipo_dispositivo" name="tipo_dispositivo" required>
                                            <option value="">Seleccione...</option>
                                            <option value="PC">PC</option>
                                            <option value="Laptop">Laptop</option>
                                            <option value="Tablet">Tablet</option>
                                            <option value="Impresora">Impresora</option>
                                            <option value="Monitor">Monitor</option>
                                            <option value="Otro">Otro</option>
                                        </select>
                                        <div class="invalid-feedback">Seleccione el tipo de dispositivo.</div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="marca" class="form-label">Marca <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="marca" name="marca" required>
                                        <div class="invalid-feedback">Ingrese la marca.</div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="modelo" class="form-label">Modelo <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="modelo" name="modelo" required>
                                        <div class="invalid-feedback">Ingrese el modelo.</div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="numero_serie" class="form-label">Número de Serie</label>
                                        <input type="text" class="form-control" id="numero_serie" name="numero_serie">
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="problema_reportado" class="form-label">Problema Reportado <span class="text-danger">*</span></label>
                                    <textarea class="form-control" id="problema_reportado" name="problema_reportado" rows="3" required></textarea>
                                    <div class="invalid-feedback">Describa el problema reportado.</div>
                                </div>
                                <div class="d-flex justify-content-between mt-4">
                                    <button type="button" class="btn btn-secondary prev-btn"><i class="bi bi-arrow-left"></i> Anterior</button>
                                    <button type="button" class="btn btn-primary next-btn">Siguiente <i class="bi bi-arrow-right"></i></button>
                                </div>
                            </div>
                            <!-- PASO 3: Información del Servicio -->
                            <div class="form-section" id="paso3" style="display: none;">
                                <h3 class="mb-4">Información del Servicio</h3>
                                <div class="mb-3">
                                    <label for="descripcion_servicio" class="form-label">Descripción del Servicio <span class="text-danger">*</span></label>
                                    <textarea class="form-control" id="descripcion_servicio" name="descripcion_servicio" rows="3" required></textarea>
                                    <div class="invalid-feedback">Describa el servicio a realizar.</div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="costo" class="form-label">Costo ($) <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" id="costo" name="costo" min="0" step="0.01" required>
                                        <div class="invalid-feedback">Ingrese el costo.</div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="tecnico_asignado" class="form-label">Técnico Asignado</label>
                                        <input type="text" class="form-control" id="tecnico_asignado" name="tecnico_asignado">
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="observaciones" class="form-label">Observaciones</label>
                                    <textarea class="form-control" id="observaciones" name="observaciones" rows="2"></textarea>
                                </div>
                                <div class="d-flex justify-content-between mt-4">
                                    <button type="button" class="btn btn-secondary prev-btn"><i class="bi bi-arrow-left"></i> Anterior</button>
                                    <button type="submit" class="btn btn-success">Registrar Servicio <i class="bi bi-check-circle"></i></button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/scripts.js"></script>
</body>
</html>