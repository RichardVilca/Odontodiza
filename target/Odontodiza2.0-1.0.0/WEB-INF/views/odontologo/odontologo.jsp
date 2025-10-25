<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<%-- Bloque de seguridad: solo nutricionistas pueden acceder --%>
<c:if test="${empty sessionScope.usuario || sessionScope.usuario.rol ne 'Odontologo'}">
    <c:redirect url="/login"/>
</c:if>

<%-- Variables de la página --%>
<c:set var="pageTitle" value="Panel de Control" scope="request"/>
<c:set var="pageName" value="dashboard" scope="request"/>

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
    
    .patients-container, .citas-container, .historial-container, .perfil-container, .dashboard-container {
      /* max-width: 1200px; */ /* Removed to allow full width */
      /* margin: 0 auto; */ /* Removed to allow full width */
      width: 100%; /* Ensure it takes full width */
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

    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    .stat-card {
        background-color: white;
        padding: 1.5rem;
        border-radius: 0.75rem;
        border: 1px solid var(--border);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08);
        transition: all 0.3s ease;
        border-left: 5px solid var(--primary); /* Striking left border */
    }

    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
    }

    .stat-value {
        font-size: 2.5rem; /* Slightly larger */
        font-weight: 700; /* Bolder */
        color: #ff5722; /* Accent Orange */
    }

    .stat-label {
        font-size: 0.95rem; /* Slightly larger */
        color: var(--gray-600); /* Darker gray for label */
        margin-top: 0.5rem;
    }

    .dashboard-grid {
        display: grid;
        grid-template-columns: 1fr 1fr; /* Balanced columns */
        gap: 2rem;
    }

    /* Responsive adjustments for smaller screens */
    @media (max-width: 1024px) {
        .dashboard-grid {
            grid-template-columns: 1fr; /* Stack on smaller screens */
        }
    }

    .calendar-section, .appointments-panel {
        background-color: white;
        border-radius: 0.75rem;
        border: 1px solid var(--border);
        padding: 1.5rem;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08);
        border-left: 5px solid var(--primary); /* Striking left border */
    }

    .calendar-header, .appointments-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1.5rem;
    }

    .calendar-navigation .calendar-nav-btn {
        background-color: var(--primary); /* Primary Teal background */
        border: none;
        padding: 0.5rem 1rem;
        border-radius: 0.5rem;
        cursor: pointer;
        text-decoration: none;
        color: white; /* White text */
        transition: background-color 0.3s ease;
    }
    .calendar-navigation .calendar-nav-btn:hover {
        background-color: #00796b; /* Darker Primary Teal on hover */
    }

    .appointments-date {
        font-weight: 600;
        color: var(--text);
    }

    .appointment-list {
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    .appointment-card {
        padding: 1rem;
        border-left: 4px solid var(--primary);
        background-color: var(--gray-100);
        border-radius: 0 0.5rem 0.5rem 0;
        transition: transform 0.2s ease;
    }
    .appointment-card:hover {
        transform: translateX(5px);
    }

    .appointment-time {
        font-weight: 500;
        margin-bottom: 0.25rem;
        color: var(--text);
    }

    .appointment-patient, .appointment-type {
        font-size: 0.875rem;
        color: var(--gray-600);
    }

    .quick-actions {
        margin-top: 1.5rem;
        text-align: center;
    }

    .action-btn {
        color: var(--primary);
        text-decoration: none;
        font-weight: 500;
    }
    .calendar-grid {
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        gap: 0.5rem;
        text-align: center;
    }
    .calendar-weekday {
        font-weight: 600;
        color: var(--gray-600);
        font-size: 0.875rem;
        padding-bottom: 0.5rem;
    }
    .calendar-day {
        padding: 0.75rem 0.25rem;
        border-radius: 0.5rem;
        cursor: pointer;
        border: 1px solid transparent;
        transition: background-color 0.2s ease;
    }
    .calendar-day:hover {
        background-color: rgba(0, 150, 136, 0.1); /* Light primary teal on hover */
    }
    .calendar-day.today {
        border-color: var(--primary); /* Primary Teal border */
        background-color: rgba(0, 150, 136, 0.2); /* Light transparent primary */
    }
    .day-number {
        font-weight: 500;
        color: var(--text);
    }
    .appointments-for-day {
        font-size: 0.7rem;
        margin-top: 0.5rem;
        display: flex;
        flex-direction: column;
        gap: 0.2rem;
    }
    .appointment-item {
        background-color: var(--primary); /* Primary Teal background */
        color: white;
        border-radius: 0.3rem;
        padding: 0.2rem 0.4rem;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .appointment-time {
        font-weight: 600;
    }
    .appointment-patient-name {
        margin-left: 0.2rem;
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
        border-left-color: #22c55e;
    }
    .status-cancelada {
        background-color: var(--red-100);
        color: var(--red-800);
        border-left-color: #ef4444;
    }
    .status-completada {
        background-color: var(--gray-100);
        color: var(--gray-600);
        border-left-color: var(--gray-400);
    }

    /* Estilos del Modal */
    .modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        display: none; /* Oculto por defecto */
        justify-content: center;
        align-items: center;
        z-index: 1000;
    }
    .modal-content {
        background: white;
        padding: 2rem;
        border-radius: 0.75rem;
        width: 90%;
        max-width: 500px;
        box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1);
    }
    .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1rem;
        padding-bottom: 1rem;
        border-bottom: 1px solid var(--border);
    }
    .modal-title { font-size: 1.25rem; font-weight: 600; }
    .modal-close-btn { background: none; border: none; font-size: 1.5rem; cursor: pointer; color: var(--gray-400); }
    .modal-body .info-group { margin-bottom: 1rem; }
    .modal-body .info-label { font-weight: 500; color: var(--gray-500); }
    .modal-body .info-data { font-size: 1.1rem; }
    .modal-actions { margin-top: 2rem; display: flex; justify-content: flex-end; gap: 1rem; }

    /* Estilos para el gráfico de citas semanales */
    .chart-container {
        background-color: white;
        border-radius: 0.75rem;
        border: 1px solid var(--border);
        padding: 1.5rem;
        grid-column: 1 / -1; /* Ocupa todo el ancho en el dashboard-grid */
    }
    .chart-title {
        font-size: 1.25rem;
        font-weight: 600;
        margin-bottom: 1.5rem;
    }
    .bar-chart {
        display: flex;
        justify-content: space-around;
        align-items: flex-end;
        height: 150px;
        gap: 0.5rem;
        border-bottom: 1px solid var(--border);
        padding-bottom: 0.5rem;
    }
    .bar-wrapper {
        display: flex;
        flex-direction: column;
        align-items: center;
        flex-grow: 1;
        height: 100%;
        justify-content: flex-end;
    }
    .bar {
        width: 80%;
        background-color: var(--primary);
        border-radius: 0.25rem 0.25rem 0 0;
        transition: height 0.3s ease-in-out;
        display: flex;
        justify-content: center;
        align-items: flex-start;
        color: white;
        font-size: 0.75rem;
        font-weight: 500;
        padding-top: 0.2rem;
    }
    .bar-label {
        font-size: 0.75rem;
        color: var(--gray-500);
        margin-top: 0.5rem;
        text-align: center;
    }
  </style>
</head>

<body>
  <!-- ... (sidebar sin cambios) ... -->
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

  <main class="main-content">
    <!-- Mensaje de Bienvenida -->
    <div style="margin-bottom: 2rem; text-align: left;">
        <h1 class="welcome-title" style="font-size: 1.8rem; font-weight: 600;">Bienvenido de nuevo, ${sessionScope.usuario.persona.nombre}</h1>
        <p class="welcome-subtitle" style="font-size: 1rem; color: var(--gray-500);">Aquí tienes un resumen de tu actividad hoy.</p>
    </div>

    <!-- Estadísticas rápidas -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-value">${citasHoy}</div>
            <div class="stat-label">Citas Hoy</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">${nuevosPacientesMes}</div>
            <div class="stat-label">Nuevos Pacientes (Mes)</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">${citasSemana}</div>
            <div class="stat-label">Citas en la Semana</div>
        </div>

        <div class="stat-card">
            <div class="stat-value">${pacientesSinCitaProxima}</div>
            <div class="stat-label">Pacientes sin Cita Próxima</div>
        </div>
    </div>

    <div class="dashboard-grid">
        <!-- Sección del Calendario -->
        <section class="calendar-section">
            <div class="calendar-header">
                <h2>
                    Semana del ${firstDayFormatted} al ${lastDayFormatted}
                </h2>
                <div class="calendar-navigation">
                    <a href="<c:url value='/odontologo?week=${previousWeek}'/>" class="calendar-nav-btn">Anterior</a>
                    <a href="<c:url value='/odontologo?week=${nextWeek}'/>" class="calendar-nav-btn">Siguiente</a>
                </div>
            </div>
            <div class="calendar-grid">
                <div class="calendar-weekday">Lun</div>
                <div class="calendar-weekday">Mar</div>
                <div class="calendar-weekday">Mié</div>
                <div class="calendar-weekday">Jue</div>
                <div class="calendar-weekday">Vie</div>
                <div class="calendar-weekday">Sáb</div>
                <div class="calendar-weekday">Dom</div>

                <c:forEach var="day" items="${weekDays}">
                    <div class="calendar-day ${day.equals(today) ? 'today' : ''}">
                        <div class="day-number">${day.dayOfMonth}</div>
                        <div class="appointments-for-day">
                            <c:set var="dayAppointments" value="${citasPorDia.get(day)}"/>
                            <c:if test="${not empty dayAppointments}">
                                <c:forEach var="cita" items="${dayAppointments}">
                                    <div class="appointment-item">
                                        <span class="appointment-time"><fmt:formatDate value="${cita.horario.fechaHoraInicioAsDate}" pattern="HH:mm"/></span>
                                        <span class="appointment-patient-name">${cita.paciente.usuario.persona.nombre}</span>
                                    </div>
                                </c:forEach>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>

        <!-- Panel de Citas -->
        <aside class="appointments-panel">
            <div class="appointments-header">
                <h3 class="appointments-date">Citas de Hoy</h3>
            </div>
            <div class="appointment-list">
                <c:choose>
                    <c:when test="${not empty citasDelDia}">
                        <c:forEach var="cita" items="${citasDelDia}">
                            <div class="appointment-card clickable-cita status-${fn:toLowerCase(cita.estado)}" 
                                 data-cita-id="${cita.id}" 
                                 data-cita-time="<fmt:formatDate value="${cita.horario.fechaHoraInicioAsDate}" pattern="HH:mm"/>" 
                                 data-cita-patient="${cita.paciente.usuario.persona.nombre} ${cita.paciente.usuario.persona.apellido}" 
                                 data-cita-patient-id="${cita.paciente.id}"
                                 data-cita-status="${cita.estado}">
                                <div class="appointment-time"><fmt:formatDate value="${cita.horario.fechaHoraInicioAsDate}" pattern="HH:mm"/></div>
                                <div class="appointment-patient">${cita.paciente.usuario.persona.nombre} ${cita.paciente.usuario.persona.apellido}</div>
                                <div class="appointment-type">${cita.estado}</div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p style="text-align: center; color: var(--gray-500);">No hay citas programadas para hoy.</p>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="quick-actions">
                 <a href="<c:url value='/listCitas'/>" class="action-btn">Ver todas las citas</a>
            </div>
        </aside>

        <!-- Gráfico de Citas Semanales -->
        

    <!-- Estructura del Modal (oculto por defecto) -->
    <div id="citaModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle" class="modal-title">Detalles de la Cita</h2>
                <button id="modalCloseBtn" class="modal-close-btn">&times;</button>
            </div>
            <div id="modalBody" class="modal-body">
                <div class="info-group">
                    <span class="info-label">Paciente:</span>
                    <p id="modalPatientName" class="info-data"></p>
                </div>
                <div class="info-group">
                    <span class="info-label">Estado:</span>
                    <p id="modalCitaStatus" class="info-data"></p>
                </div>
            </div>
            <div id="modalActions" class="modal-actions">
                <!-- Botones de acción se generarán con JS -->
            </div>
        </div>
    </div>

  </main>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const modal = document.getElementById('citaModal');
        const modalCloseBtn = document.getElementById('modalCloseBtn');
        const modalTitle = document.getElementById('modalTitle');
        const modalPatientName = document.getElementById('modalPatientName');
        const modalCitaStatus = document.getElementById('modalCitaStatus');
        const modalActions = document.getElementById('modalActions');

        // Listener para abrir el modal
        document.body.addEventListener('click', function(event) {
            const citaCard = event.target.closest('.clickable-cita');
            if (citaCard) {
                // Leer datos de la tarjeta
                const time = citaCard.dataset.citaTime;
                const patient = citaCard.dataset.citaPatient;
                const status = citaCard.dataset.citaStatus;
                const citaId = citaCard.dataset.citaId;
                const patientId = citaCard.dataset.citaPatientId;

                // Poblar el modal
                modalTitle.textContent = `Cita a las ${time}`;
                modalPatientName.textContent = patient;
                modalCitaStatus.textContent = status;

                // Limpiar acciones anteriores y generar nuevas
                modalActions.innerHTML = '';

                // Botón Ver Historial
                const historialLink = document.createElement('a');
                historialLink.href = `<c:url value='/historialPaciente?pacienteId='/>${patientId}`;
                historialLink.className = 'btn btn-primary';
                historialLink.textContent = 'Ver Historial';
                modalActions.appendChild(historialLink);

                // Botón y formulario de Cancelar (si la cita está programada)
                if (status === 'Programada') {
                    const cancelForm = document.createElement('form');
                    cancelForm.action = `<c:url value='/updateCitaStatus'/>`;
                    cancelForm.method = 'POST';
                    cancelForm.style.display = 'inline';

                    const citaIdInput = document.createElement('input');
                    citaIdInput.type = 'hidden';
                    citaIdInput.name = 'citaId';
                    citaIdInput.value = citaId;

                    const statusInput = document.createElement('input');
                    statusInput.type = 'hidden';
                    statusInput.name = 'status';
                    statusInput.value = 'Cancelada';

                    const cancelBtn = document.createElement('button');
                    cancelBtn.type = 'submit';
                    cancelBtn.className = 'btn btn-secondary';
                    cancelBtn.textContent = 'Cancelar Cita';
                    
                    cancelForm.appendChild(citaIdInput);
                    cancelForm.appendChild(statusInput);
                    cancelForm.appendChild(cancelBtn);
                    modalActions.appendChild(cancelForm);
                }

                // Mostrar modal
                modal.style.display = 'flex';
            }
        });

        // Función para cerrar el modal
        const closeModal = () => {
            modal.style.display = 'none';
        };

        // Listeners para cerrar el modal
        modalCloseBtn.addEventListener('click', closeModal);
        modal.addEventListener('click', function(event) {
            if (event.target === modal) {
                closeModal();
            }
        });
    });
</script>

</body>
</html>