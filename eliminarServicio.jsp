<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="conexion.jsp" %>

<%
    // Configurar headers para respuesta JSON y evitar cache
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // Variables de respuesta
    boolean exito = false;
    String mensaje = "";
    
    try {
        String idParam = request.getParameter("id");
        
        // Validar parámetro ID
        if (idParam == null || idParam.trim().isEmpty()) {
            mensaje = "Error: ID de servicio no proporcionado";
        } else {
            int id = Integer.parseInt(idParam.trim());
            
            // Verificar conexión
            if (conexion == null) {
                mensaje = "Error: No se pudo conectar a la base de datos";
            } else {
                // Iniciar transacción
                conexion.setAutoCommit(false);
                
                try {
                    // 1. Verificar que el dispositivo existe y obtener información
                    String sqlCheck = "SELECT d.id_dispositivo, d.tipo_dispositivo, c.nombre as cliente " +
                                     "FROM dispositivos d " +
                                     "LEFT JOIN clientes c ON d.id_cliente = c.id_cliente " +
                                     "WHERE d.id_dispositivo = ?";
                    
                    PreparedStatement psCheck = conexion.prepareStatement(sqlCheck);
                    psCheck.setInt(1, id);
                    ResultSet rsCheck = psCheck.executeQuery();
                    
                    if (!rsCheck.next()) {
                        mensaje = "Error: El servicio con ID " + id + " no existe";
                        rsCheck.close();
                        psCheck.close();
                    } else {
                        String tipoDispositivo = rsCheck.getString("tipo_dispositivo");
                        String nombreCliente = rsCheck.getString("cliente");
                        rsCheck.close();
                        psCheck.close();
                        
                        // 2. Eliminar registros relacionados en orden correcto
                        
                        // Eliminar historial de estados
                        String sqlHistorial = "DELETE FROM historial_estados WHERE id_dispositivo = ?";
                        PreparedStatement psHistorial = conexion.prepareStatement(sqlHistorial);
                        psHistorial.setInt(1, id);
                        int historialEliminado = psHistorial.executeUpdate();
                        psHistorial.close();
                        
                        // Eliminar servicios asociados
                        String sqlServicios = "DELETE FROM servicios WHERE id_dispositivo = ?";
                        PreparedStatement psServicios = conexion.prepareStatement(sqlServicios);
                        psServicios.setInt(1, id);
                        int serviciosEliminados = psServicios.executeUpdate();
                        psServicios.close();
                        
                        // Eliminar el dispositivo principal
                        String sqlDispositivo = "DELETE FROM dispositivos WHERE id_dispositivo = ?";
                        PreparedStatement psDispositivo = conexion.prepareStatement(sqlDispositivo);
                        psDispositivo.setInt(1, id);
                        int dispositivosEliminados = psDispositivo.executeUpdate();
                        psDispositivo.close();
                        
                        if (dispositivosEliminados > 0) {
                            // Confirmar transacción
                            conexion.commit();
                            exito = true;
                            mensaje = "Servicio eliminado correctamente. " +
                                    "Cliente: " + (nombreCliente != null ? nombreCliente : "N/A") + 
                                    ", Dispositivo: " + (tipoDispositivo != null ? tipoDispositivo : "N/A") +
                                    " (ID: " + id + ")";
                        } else {
                            conexion.rollback();
                            mensaje = "Error: No se pudo eliminar el dispositivo";
                        }
                    }
                    
                } catch (SQLException sqlEx) {
                    // Revertir transacción
                    try {
                        conexion.rollback();
                    } catch (SQLException rollbackEx) {
                        // Log error de rollback si es necesario
                    }
                    mensaje = "Error en base de datos: " + sqlEx.getMessage();
                } finally {
                    // Restaurar autocommit
                    try {
                        conexion.setAutoCommit(true);
                    } catch (SQLException autoCommitEx) {
                        // Log error si es necesario
                    }
                }
            }
        }
        
    } catch (NumberFormatException nfe) {
        mensaje = "Error: ID de servicio inválido. Debe ser un número";
    } catch (Exception e) {
        mensaje = "Error del sistema: " + e.getMessage();
    }
    
    // Limpiar mensaje para JSON
    mensaje = mensaje.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
%>

{
    "exito": <%= exito %>,
    "mensaje": "<%= mensaje %>",
    "timestamp": "<%= new java.util.Date() %>"
}