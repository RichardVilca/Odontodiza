<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%-- Seguridad --%>
<c:if test="${empty sessionScope.usuario || sessionScope.usuario.rol ne 'Odontologo'}">
    <c:redirect url="/login"/>
</c:if>

<c:set var="pageTitle" value="Gestionar Horarios" scope="request"/>
<c:set var="pageName" value="horarios" scope="request"/>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #009688; /* Primary Teal */
            --background: #f5f5f5; /* Light background */
            --text: #212121; /* Dark text */
            --border: #bdbdbd; /* Neutral gray border */
            --gray-100: #f5f5f5;
            --gray-500: #757575; /* Neutral gray */
            --gray-600: #616161; /* Darker gray */
            --red-500: #f44336; /* Error Red */
            --green-100: #c8e6c9; /* Light green for success */
            --green-800: #388e3c; /* Dark green for success text */
            --red-100: #ffcdd2; /* Light red for error */
            --red-800: #d32f2f; /* Dark red for error text */
        }
        body { background-color: var(--background); font-family: 'Inter', sans-serif; color: var(--text); display: flex; margin: 0; }
        .sidebar {
            width: 16rem;
            background-color: #263238; /* Dark background for sidebar */
            border-right: 1px solid #455a64; /* Darker border */
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            display: flex;
            flex-direction: column;
        }
        .sidebar-header, .user-section { padding: 1.5rem; }
        .sidebar-header {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        .sidebar-header a {
            text-decoration: none;
            color: inherit;
        }
        .sidebar-header .logo-container {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .sidebar-header .logo-icon {
            width: 2rem;
            height: 2rem;
            color: #009688; /* Primary Teal */
        }
        .sidebar-header .logo-text {
            font-size: 1.125rem;
            font-weight: 700;
            color: white; /* White text for contrast */
        }
        .sidebar-header p {
            font-size: 0.875rem;
            color: #b0bec5; /* Light gray for subtitle */
        }
        .nav-menu { flex: 1; padding: 0.5rem 1rem; }
        .nav-link {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.5rem 0.75rem;
            border-radius: 0.5rem;
            color: #e0e0e0; /* Light gray for nav links */
            text-decoration: none;
            font-size: 0.875rem;
            font-weight: 500;
            transition: all 0.2s;
        }
        .nav-link.active {
            background-color: rgba(0, 150, 136, 0.2); /* Primary Teal with transparency */
            color: white; /* White text for active link */
        }
        .nav-link:hover {
            background-color: #37474f; /* Darker gray on hover */
        }
        .main-content { flex: 1; margin-left: 16rem; padding: 2rem; }
        .container { max-width: 1000px; margin: 0 auto; }
        .page-header { margin-bottom: 2rem; }
        .page-title { font-size: 1.8rem; font-weight: 600; color: var(--text); }
        .grid-container { display: grid; grid-template-columns: 1fr 2fr; gap: 2rem; }
        .card { background: white; padding: 1.5rem; border-radius: 0.75rem; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .card-title { font-size: 1.25rem; font-weight: 600; margin-bottom: 1.5rem; color: var(--text); }
        .form-group { margin-bottom: 1.5rem; }
        .form-label { display: block; margin-bottom: 0.5rem; font-weight: 500; font-size: 0.875rem; color: var(--text); }
        .form-input, .form-select { width: 100%; padding: 0.75rem; border: 1px solid var(--border); border-radius: 0.5rem; font-size: 0.875rem; }
        .form-input:focus, .form-select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(0, 150, 136, 0.2);
        }
        .btn { padding: 0.75rem 1.5rem; border-radius: 0.5rem; font-size: 0.875rem; font-weight: 500; cursor: pointer; text-decoration: none; border: 1px solid transparent; }
        .btn-primary { background-color: var(--primary); color: white; width: 100%; }
        .btn-primary:hover { background-color: #00796b; }
        .horarios-list { list-style: none; padding: 0; }
        .horario-item { display: flex; justify-content: space-between; align-items: center; padding: 1rem; border-bottom: 1px solid var(--border); color: var(--text); }
        .horario-item:last-child { border-bottom: none; }
        .delete-btn { background: none; border: none; color: var(--red-500); cursor: pointer; font-size: 1rem; }
        .delete-btn:hover { color: #d32f2f; }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div class="sidebar-header">
             <a href="<c:url value='/odontologo'/>" style="text-decoration: none; color: inherit;">
                <div style="display: flex; align-items: center; gap: 0.5rem;">
                    <svg style="width: 2rem; height: 2rem; color: var(--primary);" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 640 640" fill="currentColor"><path d="M241 69.7L320 96L399 69.7C410.3 65.9 422 64 433.9 64C494.7 64 544 113.3 544 174.1L544 242.6C544 272 534.5 300.7 516.8 324.2L515.7 325.7C502.8 342.9 494.4 363.1 491.4 384.4L469.7 535.9C466.4 558.9 446.7 576 423.5 576C400.7 576 381.2 559.5 377.5 537L357.3 415.6C354.3 397.4 338.5 384 320 384C301.5 384 285.8 397.4 282.7 415.6L262.5 537C258.7 559.5 239.3 576 216.5 576C193.3 576 173.6 558.9 170.3 535.9L148.6 384.5C145.6 363.2 137.2 343 124.3 325.8L123.2 324.3C105.5 300.7 96 272.1 96 242.7L96 174.2C96 113.3 145.3 64 206.1 64C218 64 229.7 65.9 241 69.7z"/></svg>
                    <span style="font-size: 1.125rem; font-weight: 700;">Odontodiza</span>
                </div>
            </a>
            <p style="font-size: 0.875rem; color: var(--gray-500);">Panel de Odontólogo</p>
        </div>
        <nav class="nav-menu">
            <a href="<c:url value='/odontologo'/>" class="nav-link"><span>Panel de Control</span></a>
            <a href="<c:url value='/listPatients'/>" class="nav-link"><span>Pacientes</span></a>
            <a href="<c:url value='/listCitas'/>" class="nav-link"><span>Citas</span></a>
            <a href="<c:url value='/gestionarHorarios'/>" class="nav-link active"><span>Gestionar Horarios</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">Gestionar Horarios Disponibles</h1>
            </div>

            <div class="grid-container">
                <div class="card">
                    <h2 class="card-title">Añadir Nuevo Horario</h2>
                    <form action="<c:url value='/gestionarHorarios'/>" method="POST">
                        <div class="form-group">
                            <label for="fechaHora" class="form-label">Fecha y Hora de Inicio</label>
                            <input type="datetime-local" id="fechaHora" name="fechaHora" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label for="duracion" class="form-label">Duración</label>
                            <select id="duracion" name="duracion" class="form-select" required>
                                <option value="30">30 minutos</option>
                                <option value="45">45 minutos</option>
                                <option value="60" selected>60 minutos</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">Añadir Horario</button>
                    </form>
                </div>

                <div class="card">
                    <h2 class="card-title">Mis Horarios Disponibles</h2>
                    <ul class="horarios-list">
                        <c:choose>
                            <c:when test="${not empty horarios}">
                                <c:forEach var="h" items="${horarios}">
                                    <li class="horario-item">
                                        <span>
                                            <fmt:formatDate value="${h.fechaHoraInicioAsDate}" pattern="EEE, d MMM yyyy, HH:mm"/> - ${h.duracionMinutos} min (${h.estado})
                                        </span>
                                        <c:if test="${h.estado == 'Disponible'}">
                                            <form action="<c:url value='/gestionarHorarios'/>" method="POST" onsubmit="return confirm('¿Estás seguro de que quieres eliminar este horario?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="horarioId" value="${h.id}">
                                                <button type="submit" class="delete-btn" title="Eliminar horario">&times;</button>
                                            </form>
                                        </c:if>
                                    </li>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <li style="text-align: center; color: var(--gray-500); padding: 1rem;">No tienes horarios disponibles creados.</li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
