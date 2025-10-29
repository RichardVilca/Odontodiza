<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%-- Bloque de seguridad: solo nutricionistas pueden acceder --%>
<c:if test="${empty sessionScope.usuario || sessionScope.usuario.rol ne 'Odontologo'}">
    <c:redirect url="/login"/>
</c:if>

<%-- Variables de la página --%>
<c:set var="pageTitle" value="Gestión de Pacientes" scope="request"/>
<c:set var="pageName" value="pacientes" scope="request"/>


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
        --gray-500: #757575; /* Neutral gray */
        --gray-600: #616161; /* Darker gray */
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
      
      .patients-container {
        max-width: 1200px;
        margin: 0 auto;
      }
  
      .patients-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
      }
  
      .patients-title {
        font-size: 1.5rem;
        font-weight: 600;
        color: var(--text);
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
        background-color: #00796b;
      }
  
      /* Estilos específicos para la tabla de pacientes */
      .patients-table {
        width: 100%;
        background: white;
        border-radius: 0.75rem;
        border: 1px solid var(--border);
        border-collapse: collapse;
        overflow: hidden;
      }
  
      .patients-table th,
      .patients-table td {
        padding: 1rem;
        text-align: left;
        border-bottom: 1px solid var(--border);
        color: var(--text);
      }
  
      .patients-table th {
        background-color: var(--gray-100);
        font-weight: 500;
        color: var(--gray-600);
        font-size: 0.875rem;
      }
  
      .patients-table tbody tr:hover {
        background-color: var(--gray-100);
      }
  
      .patient-name {
        font-weight: 500;
        color: var(--text);
      }
  
      .patient-info {
        font-size: 0.875rem;
        color: var(--gray-500);
      }
  
      .patient-actions {
        display: flex;
        gap: 0.5rem;
      }
  
      .action-btn {
        padding: 0.5rem;
        border-radius: 0.375rem;
        border: none;
        background: none;
        color: var(--gray-500);
        cursor: pointer;
        transition: all 0.2s;
      }
  
      .action-btn:hover {
        background-color: var(--gray-100);
        color: var(--text);
      }
  
      /* Estilos de Paginación */
      .pagination-container {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 0.5rem;
        margin-top: 2rem;
      }
      .pagination-btn {
        padding: 0.5rem 1rem;
        border-radius: 0.5rem;
        text-decoration: none;
        color: var(--gray-600);
        background-color: white;
        border: 1px solid var(--border);
        font-size: 0.875rem;
        font-weight: 500;
        transition: all 0.2s;
      }
      .pagination-btn:hover {
        background-color: var(--gray-100);
      }
      .pagination-btn.active {
        background-color: var(--primary);
        color: white;
        border-color: var(--primary);
      }
    </style></head>

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

<div class="patients-container">
    <div class="patients-header">
        <h1 class="patients-title">Gestión de Pacientes</h1>
        <div>
            <a href="<c:url value='/nuevoPaciente'/>" class="btn btn-primary">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                Nuevo Paciente
            </a>
            <a href="<c:url value='/exportarPacientes'/>" class="btn btn-secondary" style="margin-left: 1rem;">
                Exportar a Excel
            </a>
        </div>
    </div>

    <c:if test="${param.success == 'true'}">
        <div class="success-message" style="margin-bottom: 1.5rem;">
            Paciente creado con éxito.
        </div>
    </c:if>
    <c:if test="${param.successUpdate == 'true'}">
        <div class="success-message" style="margin-bottom: 1.5rem;">
            Paciente actualizado con éxito.
        </div>
    </c:if>

    <!-- Formulario de Búsqueda -->
    <div class="search-container" style="margin-bottom: 2rem;">
        <form action="<c:url value='/listPatients'/>" method="GET">
            <div style="display: flex; gap: 0.5rem;">
                <input type="search" name="search" class="form-input" placeholder="Buscar por nombre o apellido..." value="<c:out value='${searchTerm}'/>" style="flex-grow: 1;">
                <button type="submit" class="btn btn-primary">Buscar</button>
            </div>
        </form>
    </div>

    <table class="patients-table">
        <thead>
            <tr>
                <th>Paciente</th>
                <th>Contacto</th>
                <th>Condición Oral</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="paciente" items="${requestScope.patients}">
                <tr>
                    <td>
                        <div class="patient-name">${paciente.usuario.persona.nombre} ${paciente.usuario.persona.apellido}</div>
                        <div class="patient-info">ID: PAC-00${paciente.id}</div>
                    </td>
                    <td>
                        <div class="patient-info">${paciente.usuario.persona.email}</div>
                        <div class="patient-info">${paciente.usuario.persona.telefono}</div>
                    </td>
                    <td>
                        <div class="patient-info">
                            <c:choose>
                                <c:when test="${not empty paciente.historialDental.condicionGeneralOral}">
                                    ${paciente.historialDental.condicionGeneralOral}
                                </c:when>
                                <c:otherwise>
                                    No especificado
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </td>
                    <td>
                        <div class="patient-actions">
                            <a href="<c:url value='/editarPaciente?pacienteId=${paciente.id}'/>" class="action-btn" title="Editar">
                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                            </a>
                            <a href="<c:url value='/historialPaciente?pacienteId=${paciente.id}'/>" class="action-btn" title="Ver Historial">
                                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><path d="M14 2v4a2 2 0 0 0 2 2h4"></path><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                            </a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
             <c:if test="${empty requestScope.patients}">
                <tr>
                    <td colspan="4" style="text-align: center; padding: 2rem;">No se encontraron pacientes.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <!-- Paginación -->
    <c:if test="${totalPages > 1}">
        <div class="pagination-container">
            <c:if test="${currentPage > 1}">
                <a href="<c:url value='/listPatients?page=${currentPage - 1}&search=${searchTerm}'/>" class="pagination-btn">Anterior</a>
            </c:if>

            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="<c:url value='/listPatients?page=${i}&search=${searchTerm}'/>" class="pagination-btn ${i == currentPage ? 'active' : ''}">${i}</a>
            </c:forEach>

            <c:if test="${currentPage < totalPages}">
                <a href="<c:url value='/listPatients?page=${currentPage + 1}&search=${searchTerm}'/>" class="pagination-btn">Siguiente</a>
            </c:if>
        </div>
    </c:if>
</div>

  </main>
</body>
</html>