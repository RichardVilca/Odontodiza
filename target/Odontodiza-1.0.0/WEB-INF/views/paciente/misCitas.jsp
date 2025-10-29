<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<%-- Seguridad --%>
<c:if test="${empty sessionScope.usuario || sessionScope.usuario.rol ne 'Paciente'}">
    <c:redirect url="/login"/>
</c:if>

<c:set var="pageTitle" value="Mis Citas" scope="request"/>

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
            --red-100: #ffcdd2; /* Light red for error */
            --red-800: #d32f2f; /* Dark red for error text */
            --green-100: #c8e6c9; /* Light green for success */
            --green-800: #388e3c; /* Dark green for success text */
        }
        body { background-color: var(--background); font-family: 'Inter', sans-serif; color: var(--text); margin: 0; }
        header { background-color: #e0f2f1; /* Very light primary teal */ border-bottom: 1px solid #80cbc4; /* Slightly darker teal border */ padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .logo-container { display: flex; align-items: center; gap: 1rem; text-decoration: none; color: var(--text); }
        .logo-text { font-size: 1.25rem; font-weight: 700; }
        .nav-links { display: flex; gap: 1.5rem; }
        .nav-links a { text-decoration: none; color: var(--gray-500); font-weight: 500; font-size: 0.9rem; transition: color 0.2s; }
        .nav-links a:hover { color: var(--primary); }
        .user-menu { display: flex; align-items: center; gap: 1rem; }
        .user-info { text-align: right; }
        .user-name { font-weight: 600; font-size: 0.875rem; color: var(--text); }
        .user-role { color: var(--gray-500); font-size: 0.75rem; }
        .logout-btn { color: var(--gray-500); background: none; border: none; cursor: pointer; padding: 0.25rem; }
        .logout-btn:hover { color: var(--text); }
        .main-content { max-width: 1000px; margin: 2rem auto; padding: 0 2rem; }
        .citas-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .citas-title { font-size: 1.8rem; font-weight: 600; color: var(--text); }
        .btn { display: inline-block; padding: 0.75rem 1.5rem; border-radius: 0.5rem; font-weight: 600; text-decoration: none; background-color: var(--primary); color: white; border: none; }
        .btn:hover { background-color: #00796b; }
        .appointments-table { width: 100%; background: white; border-radius: 0.75rem; border-collapse: collapse; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .appointments-table th, .appointments-table td { padding: 1rem; text-align: left; border-bottom: 1px solid var(--border); color: var(--text); }
        .appointments-table th { background-color: var(--gray-100); }
        .status-badge { display: inline-block; padding: 0.25rem 0.75rem; border-radius: 999px; font-weight: 500; font-size: 0.75rem; }
        .status-programada { background-color: var(--green-100); color: var(--green-800); }
        .status-cancelada { background-color: var(--red-100); color: var(--red-800); }
        .status-completada { background-color: var(--gray-100); color: var(--gray-600); }
    </style>
</head>
<body>
    <header>
        <a href="<c:url value='/paciente'/>" class="logo-container">
            <svg class="logo-icon" width="32" height="32" viewBox="0 0 640 640" fill="currentColor"><path d="M241 69.7L320 96L399 69.7C410.3 65.9 422 64 433.9 64C494.7 64 544 113.3 544 174.1L544 242.6C544 272 534.5 300.7 516.8 324.2L515.7 325.7C502.8 342.9 494.4 363.1 491.4 384.4L469.7 535.9C466.4 558.9 446.7 576 423.5 576C400.7 576 381.2 559.5 377.5 537L357.3 415.6C354.3 397.4 338.5 384 320 384C301.5 384 285.8 397.4 282.7 415.6L262.5 537C258.7 559.5 239.3 576 216.5 576C193.3 576 173.6 558.9 170.3 535.9L148.6 384.5C145.6 363.2 137.2 343 124.3 325.8L123.2 324.3C105.5 300.7 96 272.1 96 242.7L96 174.2C96 113.3 145.3 64 206.1 64C218 64 229.7 65.9 241 69.7z"/></svg>
            <span class="logo-text">Odontodiza</span>
        </a>
        <nav class="nav-links">
            <a href="<c:url value='/paciente'/>">Mi Panel</a>
            <a href="<c:url value='/misCitas'/>">Mis Citas</a>
            <a href="<c:url value='/reservarCita'/>">Agendar Cita</a>

        </nav>
        <div class="user-menu">
            <div class="user-info">
                <div class="user-name">${sessionScope.usuario.persona.nombre} ${sessionScope.usuario.persona.apellido}</div>
                <div class="user-role">Paciente</div>
            </div>
            <a href="<c:url value='/logout'/>" class="logout-btn" title="Cerrar Sesión"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" x2="9" y1="12" y2="12"></line></svg></a>
        </div>
    </header>

    <main class="main-content">
        <div class="citas-header">
            <h1 class="citas-title">Mis Citas</h1>
            <a href="<c:url value='/reservarCita'/>" class="btn">Agendar Nueva Cita</a>
        </div>

        <table class="appointments-table">
            <thead>
                <tr>
                    <th>Fecha y Hora</th>
                    <th>Odontólogo</th>
                    <th>Duración</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="cita" items="${citas}">
                    <tr>
                        <td><fmt:formatDate value="${cita.horario.fechaHoraInicioAsDate}" pattern="dd/MM/yyyy 'a las' HH:mm"/></td>
                        <td>${cita.horario.odontologo.usuario.persona.nombre} ${cita.horario.odontologo.usuario.persona.apellido}</td>
                        <td>${cita.horario.duracionMinutos} min</td>
                        <td><span class="status-badge status-${fn:toLowerCase(cita.estado)}">${cita.estado}</span></td>
                        <td>
                            <c:if test="${cita.estado == 'Programada'}">
                                <a href="<c:url value='/misCitas?accion=cancelar&id=${cita.id}'/>">Cancelar</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty citas}">
                    <tr>
                        <td colspan="5" style="text-align: center; padding: 2rem;">No tienes citas programadas.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </main>
</body>
</html>
