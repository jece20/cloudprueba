<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión - TechService</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, rgb(152, 187, 196) 0%, rgb(73, 84, 104) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        h2 {
            font-size: 2.8rem;
            margin-bottom: 0.5rem;
        }
        
        .login-card {
            border-radius: 1.5rem;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            background: rgb(227, 243, 255);
        }
        .brand-logo {
            width: 90px;
            height: 90px;
            object-fit: cover;
            border-radius: 50%;
            box-shadow: 0 2px 8px rgba(30,60,114,0.2);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card login-card p-4">
                    <div class="text-center mb-4">
                        <img src="img/log.jpg" alt="Logo" class="brand-logo mb-2">
                        <h2 class="fw-bold text-primary">TechService</h2>
                        <p class="text-secondary mb-0">Inicia sesión para continuar</p>
                    </div>
                    <% if ("1".equals(error)) { %>
                        <div class="alert alert-danger text-center py-2">
                            <i class="bi bi-exclamation-triangle me-1"></i> Credenciales incorrectas.
                        </div>
                    <% } %>
                    <form action="loginProcess.jsp" method="post" autocomplete="off">
                        <div class="mb-3">
                            <label class="form-label">Usuario</label>
                            <input type="text" name="usuario" class="form-control" required autofocus>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Contraseña</label>
                            <input type="password" name="password" class="form-control" required>
                        </div>
                        <button class="btn btn-primary w-100 mb-2" type="submit">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Ingresar
                        </button>
                    </form>
                    <div class="text-center mt-2">
                        <small class="text-muted">Admin: <b>admin</b> / <b>admin123</b><br>
                        Técnico: <b>tecnico</b> / <b>tec123</b><br>
                        Cliente: <b>cliente</b> / <b>cli123</b></small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>