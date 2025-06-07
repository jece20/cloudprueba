<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="conexion.jsp" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechService - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
    <%-- Proteger acceso solo para usuarios logueados --%>
    <%
        String usuario = (String) session.getAttribute("usuario");
        String rol = (String) session.getAttribute("rol");
        if (usuario == null || rol == null) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 d-md-block sidebar collapse">
                <div class="position-sticky pt-3">
                    <div class="text-center mb-4">
                        <h2 class="title">Multitintas INK</h2>
                        <img class="logo img-fluid" src="img/log.jpg" alt="Logo de TechService">
                    </div>
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="index.jsp">
                                <i class="bi bi-speedometer2 me-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="formulario.jsp">
                                <i class="bi bi-file-earmark-plus me-2"></i> Nuevo Servicio
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <!-- Botones de usuario y salir debajo de la tabla -->
                <div class="d-flex justify-content-end align-items-center gap-2 mt-3 mb-2">
                    <span class="d-flex align-items-center px-2 py-1 rounded-pill bg-white shadow-sm" style="font-size: 0.98rem; font-weight: 350; color: #1e3c72;">
                        <i class="bi bi-person-circle me-2 fs-5 text-primary"></i>
                        <span><%= usuario %></span>
                        <span class="badge bg-primary ms-2" style="font-size: 0.85em;"><%= rol.toUpperCase() %></span>
                    </span>
                    <a href="logout.jsp" class="btn btn-danger btn-sm px-3 py-1 rounded-pill shadow-sm d-flex align-items-center" style="font-size: 0.98rem;">
                        <i class="bi bi-box-arrow-right me-2 fs-6"></i> Salir
                    </a>
                </div>

                <!-- Statistics -->
                <div class="row my-4">
                    <%
                        try {
                            Statement statTotal = conexion.createStatement();
                            ResultSet rsTotal = statTotal.executeQuery("SELECT COUNT(*) as total FROM dispositivos");
                            rsTotal.next();
                            int totalServicios = rsTotal.getInt("total");

                            Statement statPending = conexion.createStatement();
                            ResultSet rsPending = statPending.executeQuery("SELECT COUNT(*) as pendientes FROM dispositivos WHERE estado != 'Entregado'");
                            rsPending.next();
                            int serviciosPendientes = rsPending.getInt("pendientes");

                            Statement statCompleted = conexion.createStatement();
                            ResultSet rsCompleted = statCompleted.executeQuery("SELECT COUNT(*) as completados FROM dispositivos WHERE estado = 'Entregado'");
                            rsCompleted.next();
                            int serviciosCompletados = rsCompleted.getInt("completados");
                    %>
                    <div class="col-md-4">
                        <div class="card card-total text-white mb-4">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h4 class="mb-0"><%= totalServicios %></h4>
                                        <div>Total Servicios</div>
                                    </div>
                                    <i class="bi bi-tools fs-1"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card card-pendientes text-white mb-4">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h4 class="mb-0"><%= serviciosPendientes %></h4>
                                        <div>Servicios Pendientes</div>
                                    </div>
                                    <i class="bi bi-clock-history fs-1"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card card-completados text-white mb-4">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h4 class="mb-0"><%= serviciosCompletados %></h4>
                                        <div>Servicios Completados</div>
                                    </div>
                                    <i class="bi bi-check-circle fs-1"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% 
                        } catch(Exception e) {
                            out.println("<div class='alert alert-danger'>Error al cargar estadísticas: " + e.getMessage() + "</div>");
                        }
                    %>
                </div>
                    
                <!-- Recent Services Table -->
                <h2>Servicios Recientes</h2>
                <!-- Botón para consultar estado de equipo -->
                <div class="mb-3 text-end">
                    <button class="btn btn-info" data-bs-toggle="modal" data-bs-target="#chatbotModal">
                        <i class="bi bi-robot me-1"></i> Consultar Estado de Equipo
                    </button>
                </div>
                <div class="table-responsive">
                    <table class="table table-striped table-hover table-sm">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Cliente</th>
                                <th>Dispositivo</th>
                                <th>Problema</th>
                                <th>Estado</th>
                                <th>Fecha Ingreso</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try {
                                    Statement stat = conexion.createStatement();
                                    ResultSet rs = stat.executeQuery(
                                        "SELECT d.id_dispositivo, CONCAT(c.nombre, ' ', c.apellidos) AS cliente, " +
                                        "d.tipo_dispositivo, d.marca, d.modelo, d.problema_reportado, d.estado, " +
                                        "DATE_FORMAT(d.fecha_ingreso, '%d/%m/%Y') AS fecha " +
                                        "FROM dispositivos d JOIN clientes c ON d.id_cliente = c.id_cliente " +
                                        "ORDER BY d.fecha_ingreso DESC LIMIT 10"
                                    );

                                    while(rs.next()) {
                                        String estadoClass = "";
                                        String estadoIcono = "";
                                        switch(rs.getString("estado")) {
                                            case "Recibido": 
                                                estadoClass = "badge bg-info"; 
                                                estadoIcono = "bi-clipboard-check";
                                                break;
                                            case "En diagnóstico": 
                                                estadoClass = "badge bg-warning"; 
                                                estadoIcono = "bi-search";
                                                break;
                                            case "En reparación": 
                                                estadoClass = "badge bg-primary"; 
                                                estadoIcono = "bi-tools";
                                                break;
                                            case "Reparado": 
                                                estadoClass = "badge bg-success"; 
                                                estadoIcono = "bi-check-circle";
                                                break;
                                            case "Entregado": 
                                                estadoClass = "badge bg-secondary"; 
                                                estadoIcono = "bi-box-arrow-right";
                                                break;
                                            default: 
                                                estadoClass = "badge bg-light text-dark";
                                                estadoIcono = "bi-question-circle";
                                        }
                            %>
                            <tr>
                                <td><%= rs.getInt("id_dispositivo") %></td>
                                <td><%= rs.getString("cliente") %></td>
                                <td><%= rs.getString("tipo_dispositivo") %> <%= rs.getString("marca") %> <%= rs.getString("modelo") %></td>
                                <td><%= rs.getString("problema_reportado").length() > 30 ? rs.getString("problema_reportado").substring(0, 30) + "..." : rs.getString("problema_reportado") %></td>
                                <td class="celda-estado"><span class="<%= estadoClass %>"><i class="bi <%= estadoIcono %>"></i> <%= rs.getString("estado") %></span></td>
                                <td><%= rs.getString("fecha") %></td>
                                <td>
                                    <!-- Botón para ver detalles del servicio (ojito) -->
                                    <a href="detallesServicio.jsp?id=<%= rs.getInt("id_dispositivo") %>" 
                                       class="btn btn-sm btn-outline-info me-1" 
                                       title="Ver detalles del servicio">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <!-- Botón para abrir el modal de estados -->
                                    <button type="button" 
                                            class="btn btn-sm btn-outline-primary btn-estado-modal"
                                            data-id="<%= rs.getInt("id_dispositivo") %>"
                                            data-estado-actual="<%= rs.getString("estado") %>"
                                            title="Cambiar estado del dispositivo">
                                        <i class="bi bi-pencil-square me-1"></i>Cambiar Estado
                                    </button>
                                    <!-- Botón para editar servicio -->
                                    <a href="editarServicio.jsp?id=<%= rs.getInt("id_dispositivo") %>" 
                                    class="btn btn-sm btn-outline-warning me-1" 
                                    title="Editar servicio">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <!-- Botón para eliminar servicio -->
                                    <button type="button" 
                                            class="btn btn-sm btn-outline-danger btn-eliminar-servicio"
                                            data-id="<%= rs.getInt("id_dispositivo") %>"
                                            title="Eliminar servicio">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch(Exception e) {
                                    out.println("<tr><td colspan='7' class='text-center text-danger'>Error al cargar datos: " + e.getMessage() + "</td></tr>");
                                }
                            %>
                        </tbody>
                        
                    </table>
                </div>

    <!-- Modal para confirmar la finalización del servicio -->
    <div class="modal fade" id="confirmacionModal" tabindex="-1" aria-labelledby="confirmacionModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="confirmacionModalLabel">
                        <i class="bi bi-check-circle-fill me-2"></i> Estado Actualizado
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body text-center">
                    <p id="mensajeConfirmacion" class="fs-5 text-secondary">El estado ha sido actualizado correctamente.</p>
                </div>
                <div class="modal-footer justify-content-center">
                    <button type="button" class="btn btn-success px-4" data-bs-dismiss="modal">Aceptar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal para elegir estado (solo uno en toda la página) -->
    <div class="modal fade" id="modalEstados" tabindex="-1" aria-labelledby="modalEstadosLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="modalEstadosLabel">Seleccionar Estado</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
          </div>
          <div class="modal-body">
            <div id="listaEstados" class="d-grid gap-2"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal para el Chatbot de Consulta de Estado -->
    <div class="modal fade" id="chatbotModal" tabindex="-1" aria-labelledby="chatbotModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header bg-info text-white">
            <h5 class="modal-title" id="chatbotModalLabel">
              <i class="bi bi-robot me-2"></i> Consulta el Estado de tu Equipo
            </h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
          </div>
          <div class="modal-body">
            <form id="consultaEstadoForm">
              <div class="mb-3">
                <label for="nombreConsulta" class="form-label">Nombre</label>
                <input type="text" class="form-control" id="nombreConsulta" required>
              </div>
              <div class="mb-3">
                <label for="telefonoConsulta" class="form-label">Teléfono</label>
                <input type="text" class="form-control" id="telefonoConsulta" required>
              </div>
              <button type="submit" class="btn btn-info w-100">
                <i class="bi bi-search me-1"></i> Consultar Estado
              </button>
            </form>
            <div id="resultadoConsulta" class="mt-4"></div>
          </div>
        </div>
      </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/scripts.js"></script>
</body>
</html>