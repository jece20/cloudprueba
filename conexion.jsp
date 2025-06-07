<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Configuración de la conexión a la base de datos
    Connection conexion = null;
    
    try {
        // Cargar el driver de MySQL
        Class.forName("com.mysql.jdbc.Driver");
        // Establecer la conexión local
        /*
        String url = "jdbc:mysql://localhost:3306/servicio_mantenimiento";
        String usuario = "root";
        String password = "";
        */
        
        // Establecer la conexión online clever cloud
        String url = "jdbc:mysql://br4en9dxfl3m20e3tpod-mysql.services.clever-cloud.com:3306/br4en9dxfl3m20e3tpod";
        String usuario = "ueo7xtdwubyezxwo";
        String password = "KN8GU2gECoVJX6k6lrw6";

        conexion = DriverManager.getConnection(url, usuario, password);
        
    } catch (ClassNotFoundException e) {
        out.println("Error: No se encontró el driver de MySQL.");
        e.printStackTrace();
    } catch (SQLException e) {
        out.println("Error: No se pudo conectar a la base de datos.");
        e.printStackTrace();
    }
%>