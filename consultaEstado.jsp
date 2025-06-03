<%@ page import="java.sql.*" %>
<%@ include file="conexion.jsp" %>
<%
    String nombre = request.getParameter("nombre");
    String telefono = request.getParameter("telefono");
    if (nombre == null || telefono == null || nombre.trim().isEmpty() || telefono.trim().isEmpty()) {
        out.println("<div class='alert alert-warning'>Debes ingresar nombre y teléfono.</div>");
        return;
    }
    try {
        PreparedStatement ps = conexion.prepareStatement(
            "SELECT d.id_dispositivo, d.tipo_dispositivo, d.marca, d.modelo, d.estado " +
            "FROM dispositivos d JOIN clientes c ON d.id_cliente = c.id_cliente " +
            "WHERE c.nombre = ? AND c.telefono = ?"
        );
        ps.setString(1, nombre);
        ps.setString(2, telefono);
        ResultSet rs = ps.executeQuery();
        boolean hayResultados = false;
        while (rs.next()) {
            hayResultados = true;
%>
<div class="alert alert-info mb-2">
    <strong>Equipo:</strong> <%= rs.getString("tipo_dispositivo") %> <%= rs.getString("marca") %> <%= rs.getString("modelo") %><br>
    <strong>Estado:</strong> <span class="badge bg-primary"><%= rs.getString("estado") %></span>
</div>
<%
        }
        if (!hayResultados) {
            out.println("<div class='alert alert-warning'>No se encontró ningún equipo con esos datos.</div>");
        }
    } catch(Exception e) {
        out.println("<div class='alert alert-danger'>Error al consultar: " + e.getMessage() + "</div>");
    }
%>