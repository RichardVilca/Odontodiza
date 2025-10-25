<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<%-- Bloque de seguridad: solo nutricionistas pueden acceder --%>
<c:if test="${empty sessionScope.usuario || sessionScope.usuario.rol ne 'Odontologo'}">
    <c:redirect url="/login"/>
</c:if>

<%-- Variables de la página --%>
<c:set var="pageTitle" value="Gestión de Citas" scope="request"/>
<c:set var="pageName" value="citas" scope="request"/>


<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${pageTitle}</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    /* Variables y estilos base */
    :root {
      --primary: #009688; /* Primary Teal */
      --background: #f5f5f5; /* Light background */
      --text: #212121; /* Dark text */
      --border: #bdbdbd; /* Neutral gray border */
      --border-light: #e0e0e0; /* Lighter border */
      --gray-100: #f5f5f5;
      --gray-400: #9e9e9e;
      --gray-500: #757575;
      --gray-600: #616161;
      --green-100: #c8e6c9; /* Light green for success */
      --green-800: #388e3c; /* Dark green for success text */
      --red-100: #ffcdd2; /* Light red for error */
      --red-800: #d32f2f; /* Dark red for error text */
    }

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Inter', sans-serif;
    }

    body {
      background-color: var(--background);
      color: var(--text);
      min-height: 100vh;
      display: flex;
      line-height: 1.5;
    }

    /* Estructura principal */
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

    /* Encabezado y logo */
    .sidebar-header {
      padding: 1.5rem;
      display: flex;
      flex-direction: column;
      gap: 0.5rem;
    }

    .logo-container {
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .logo-icon {
      width: 2rem;
      height: 2rem;
      color: #009688; /* Primary Teal */
    }

    .logo-text {
      font-size: 1.125rem;
      font-weight: 700;
      color: white; /* White text for contrast */
    }

    .sidebar-subtitle {
      font-size: 0.875rem;
      color: #b0bec5; /* Light gray for subtitle */
    }

    /* Navegación */
    .nav-menu {
      flex: 1;
      padding: 0.5rem 1rem;
      overflow-y: auto;
    }

    .nav-item {
      margin-bottom: 0.5rem;
    }

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

    .nav-link:hover {
      background-color: #37474f; /* Darker gray on hover */
    }

    .nav-link.active {
      background-color: rgba(0, 150, 136, 0.2); /* Primary Teal with transparency */
      color: white; /* White text for active link */
    }

    .nav-icon {
      width: 1.25rem;
      height: 1.25rem;
      color: #e0e0e0; /* Light gray for icons */
    }

    /* Sección de usuario */
    .user-section {
      padding: 1rem;
      border-top: 1px solid #455a64; /* Darker border */
    }

    .user-info {
      display: flex;
      align-items: center;
      gap: 0.75rem;
    }

    .user-details {
      flex: 1;
      min-width: 0;
    }

    .user-name {
      font-size: 0.875rem;
      font-weight: 500;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      color: white; /* White text for user name */
    }

    .user-role {
      font-size: 0.75rem;
      color: #b0bec5; /* Light gray for user role */
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .logout-btn {
      color: #b0bec5; /* Light gray for logout button */
      background: none;
      border: none;
      cursor: pointer;
      padding: 0.25rem;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .logout-btn:hover {
      color: white; /* White on hover */
    }

    .main-content {
      flex: 1;
      margin-left: 16rem;
      padding: 2rem;
    }
    
    /* Estilos adicionales que pueden ser necesarios en otras páginas */
    .patients-container, .citas-container, .historial-container, .perfil-container, .dashboard-container {
      max-width: 1200px;
      margin: 0 auto;
    }

    .patients-header, .citas-header, .historial-header, .perfil-header, .dashboard-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 2rem;
    }

    .patients-title, .citas-title, .historial-title, .perfil-title, .dashboard-title {
      font-size: 1.5rem;
      font-weight: 600;
    }

    .btn {
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0.75rem 1.5rem;
      border-radius: 0.5rem;
      font-size: 0.875rem;
      font-weight: 500;
      cursor: pointer;
      transition: all 0.2s;
      text-decoration: none;
    }

    .btn-primary {
      background-color: var(--primary);
      color: white;
      border: none;
    }

    .btn-primary:hover {
      opacity: 0.9;
    }
    
    .form-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 1rem;
    }

    .form-group {
      margin-bottom: 1rem;
    }

    .form-group.full-width {
      grid-column: span 2;
    }

    .form-label {
      display: block;
      margin-bottom: 0.5rem;
      font-weight: 500;
      font-size: 0.875rem;
      color: var(--text);
    }

    .form-input {
      width: 100%;
      padding: 0.75rem;
      border: 1px solid var(--border);
      border-radius: 0.5rem;
      font-size: 0.875rem;
    }

    .form-input:focus {
      outline: none;
      border-color: var(--primary);
      box-shadow: 0 0 0 2px rgba(19, 138, 236, 0.1);
    }
    .appointments-table {
      width: 100%;
      background: white;
      border-radius: 0.75rem;
      border: 1px solid var(--border);
      border-collapse: collapse;
      overflow: hidden;
    }
    .appointments-table th, .appointments-table td {
      padding: 1rem;
      text-align: left;
      border-bottom: 1px solid var(--border);
    }
    .appointments-table th {
      background-color: var(--gray-100);
    }
    .status-badge {
        display: inline-block;
        padding: 0.25rem 0.75rem;
        border-radius: 999px;
        font-weight: 500;
        font-size: 0.75rem;
    }
    .status-programada {
        background-color: var(--green-100);
        color: var(--green-800);
    }
    .status-cancelada {
        background-color: var(--red-100);
        color: var(--red-800);
    }
  </style>
</head>

<body>
  <!-- Barra lateral -->
  <aside class="sidebar">
    <div class="sidebar-header">
      <div class="logo-container">
        <svg class="logo-icon" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 640 640" fill="currentColor"><path d="M241 69.7L320 96L399 69.7C410.3 65.9 422 64 433.9 64C494.7 64 544 113.3 544 174.1L544 242.6C544 272 534.5 300.7 516.8 324.2L515.7 325.7C502.8 342.9 494.4 363.1 491.4 384.4L469.7 535.9C466.4 558.9 446.7 576 423.5 576C400.7 576 381.2 559.5 377.5 537L357.3 415.6C354.3 397.4 338.5 384 320 384C301.5 384 285.8 397.4 282.7 415.6L262.5 537C258.7 559.5 239.3 576 216.5 576C193.3 576 173.6 558.9 170.3 535.9L148.6 384.5C145.6 363.2 137.2 343 124.3 325.8L123.2 324.3C105.5 300.7 96 272.1 96 242.7L96 174.2C96 113.3 145.3 64 206.1 64C218 64 229.7 65.9 241 69.7z"/></svg>
        <span class="logo-text">Odontodiza</span>
      </div>
      <p class="sidebar-subtitle">Panel de Odontólogo</p>
    </div>

    <nav class="nav-menu">
      <div class="nav-item">
        <a href="<c:url value='/odontologo'/>" class="nav-link ${pageName == 'dashboard' ? 'active' : ''}">
          <svg class="nav-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
          <span>Panel de Control</span>
        </a>
      </div>

      <div class="nav-item">
        <a href="<c:url value='/listPatients'/>" class="nav-link ${pageName == 'pacientes' ? 'active' : ''}">
          <svg class="nav-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M22 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
          <span>Pacientes</span>
        </a>
      </div>

      <div class="nav-item">
        <a href="<c:url value='/listCitas'/>" class="nav-link ${pageName == 'citas' ? 'active' : ''}">
          <svg class="nav-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" x2="16" y1="2" y2="6"></line><line x1="8" x2="8" y1="2" y2="6"></line><line x1="3" x2="21" y1="10" y2="10"></line></svg>
          <span>Citas</span>
        </a>
      </div>

      <div class="nav-item">
        <a href="<c:url value='/gestionarHorarios'/>" class="nav-link ${pageName == 'horarios' ? 'active' : ''}">
          <svg class="nav-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M8 2v4"></path><path d="M16 2v4"></path><rect width="18" height="18" x="3" y="4" rx="2"></rect><path d="M3 10h18"></path><path d="M8 14h.01"></path><path d="M12 14h.01"></path><path d="M16 14h.01"></path><path d="M8 18h.01"></path><path d="M12 18h.01"></path><path d="M16 18h.01"></path></svg>
          <span>Gestionar Horarios</span>
        </a>
      </div>
    </nav>

    <div class="user-section">
      <div class="user-info">
        <div class="user-details">
          <p class="user-name">${sessionScope.usuario.persona.nombre}</p>
          <p class="user-role">${sessionScope.usuario.rol}</p>
        </div>
        <a href="<c:url value='/logout'/>" class="logout-btn" title="Cerrar Sesión">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" x2="9" y1="12" y2="12"></line></svg>
        </a>
      </div>
    </div>
  </aside>

  <!-- Contenido principal -->
  <main class="main-content">

<div class="citas-container">
    <div class="citas-header">
        <h1 class="citas-title">Gestión de Citas</h1>
        <a href="<c:url value='/gestionarHorarios'/>" class="btn btn-primary">Gestionar Horarios</a>
    </div>

    <c:if test="${param.update == 'success'}">
        <div class="success-message" style="margin-bottom: 1.5rem; background-color: var(--green-100); color: var(--green-800);">
            Estado de la cita actualizado con éxito.
        </div>
    </c:if>

    <table class="appointments-table">
        <thead>
            <tr>
                <th>Fecha y Hora</th>
                <th>Paciente</th>
                <th>Odontólogo</th>
                <th>Duración</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="cita" items="${requestScope.citas}">
                <tr>
                                            <td>
                                                <fmt:formatDate value="${cita.horario.fechaHoraInicioAsDate}" pattern="dd/MM/yyyy 'a las' HH:mm"/>
                                            </td>                    <td>
                        <a href="<c:url value='/historialPaciente?pacienteId=${cita.paciente.id}'/>" style="text-decoration: none; color: var(--primary);">${cita.paciente.usuario.persona.nombre} ${cita.paciente.usuario.persona.apellido}</a>
                    </td>
                    <td>${cita.horario.odontologo.usuario.persona.nombre} ${cita.horario.odontologo.usuario.persona.apellido}</td>
                    <td>${cita.horario.duracionMinutos} min</td>
                    <td>
                        <span class="status-badge status-${fn:toLowerCase(cita.estado)}">${cita.estado}</span>
                    </td>
                    <td>
                        <c:if test="${cita.estado == 'Programada'}">
                            <form action="<c:url value='/updateCitaStatus'/>" method="POST" style="display: inline;">
                                <input type="hidden" name="citaId" value="${cita.id}">
                                <input type="hidden" name="status" value="Cancelada">
                                <button type="submit" class="btn" style="padding: 0.25rem 0.5rem; font-size: 0.75rem; background-color: var(--red-100); color: var(--red-800);">Cancelar</button>
                            </form>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty requestScope.citas}">
                <tr>
                    <td colspan="6" style="text-align: center; padding: 2rem;">No hay citas programadas.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

  </main>
</body>
</html>