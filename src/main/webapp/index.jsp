<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Odontodiza - Bienvenida</title>
    <style>
        body {
            font-family: 'Inter', system-ui, -apple-system, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f5f5f5; /* Light background */
            color: #212121; /* Dark text */
        }
        .presentation-container {
            text-align: center;
            padding: 40px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            max-width: 600px;
        }
        .presentation-title {
            font-size: 2.5em;
            color: #009688; /* Primary Teal */
            margin-bottom: 20px;
        }
        .presentation-text {
            font-size: 1.1em;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        .button-group {
            display: flex;
            justify-content: center;
            gap: 20px;
        }
        .btn {
            display: inline-block;
            padding: 12px 25px;
            border-radius: 5px;
            font-weight: 600;
            text-decoration: none;
            transition: background-color 0.3s ease;
        }
        .btn-primary {
            background-color: #009688; /* Primary Teal */
            color: white;
        }
        .btn-primary:hover {
            background-color: #00796b; /* Darker Primary Teal on hover */
        }
        .btn-secondary {
            background-color: #ff5722; /* Accent Orange */
            color: white;
        }
        .btn-secondary:hover {
            background-color: #e64a19; /* Darker Accent Orange on hover */
        }
    </style>
</head>
<body>
    <div class="presentation-container">
        <h1 class="presentation-title">Bienvenido a Odontodiza</h1>
        <p class="presentation-text">
            Tu clínica dental de confianza. Agenda tus citas, gestiona tus tratamientos
            y mantén tu sonrisa sana y brillante con nuestros profesionales.
            ¡Empieza hoy tu camino hacia una salud bucal óptima!
        </p>
        <div class="button-group">
            <a href="<c:url value='/login'/>" class="btn btn-primary">Iniciar Sesión</a>
            <a href="<c:url value='/register'/>" class="btn btn-secondary">Registrarse</a>
        </div>
    </div>
</body>
</html>