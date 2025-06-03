<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String usuario = request.getParameter("usuario");
    String password = request.getParameter("password");
    String rol = "";

    // Credenciales ficticias
    if ("admin".equals(usuario) && "admin123".equals(password)) {
        rol = "admin";
    } else if ("tecnico".equals(usuario) && "tec123".equals(password)) {
        rol = "tecnico";
    } else if ("cliente".equals(usuario) && "cli123".equals(password)) {
        rol = "cliente";
    }

    if (!rol.isEmpty()) {
        session.setAttribute("usuario", usuario);
        session.setAttribute("rol", rol);
        response.sendRedirect("index.jsp");
    } else {
        response.sendRedirect("login.jsp?error=1");
    }
%>