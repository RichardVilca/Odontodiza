<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- Bloque de seguridad --%>
<c:if test="${empty sessionScope.usuario || sessionScope.usuario.rol ne 'Odontologo'}">
    <c:redirect url="/login"/>
</c:if>

<c:set var="pageTitle" value="Historial del Paciente" scope="request"/>
<c:set var="pageName" value="pacientes" scope="request"/>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - ${paciente.usuario.persona.nombre} ${paciente.usuario.persona.apellido}</title>
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
        .container { max-width: 1200px; margin: 0 auto; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .page-title { font-size: 1.8rem; font-weight: 600; color: var(--text); }
        .grid-container { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; }
        .card { background: white; padding: 1.5rem; border-radius: 0.75rem; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .card-title { font-size: 1.1rem; font-weight: 600; margin-bottom: 1rem; border-bottom: 1px solid var(--border); padding-bottom: 0.75rem; color: var(--text); }
        .info-grid { display: grid; grid-template-columns: 120px 1fr; gap: 0.75rem; }
        .info-label { font-weight: 500; color: var(--gray-500); }
        .info-value { color: var(--text); }
        .full-width-card { grid-column: 1 / -1; }
        .table { width: 100%; border-collapse: collapse; }
        .table th, .table td { padding: 0.75rem 1rem; text-align: left; border-bottom: 1px solid var(--border); color: var(--text); }
        .table th { background-color: var(--gray-100); font-weight: 500; font-size: 0.875rem; }
        .empty-state { text-align: center; padding: 2rem; color: var(--gray-500); }
        .btn { display: inline-flex; align-items: center; gap: 0.5rem; padding: 0.5rem 1rem; border-radius: 0.5rem; font-size: 0.875rem; font-weight: 500; cursor: pointer; text-decoration: none; border: 1px solid transparent; }
        .btn-secondary { background-color: #ff5722; color: white; border-color: transparent; }
        .btn-secondary:hover { background-color: #e64a19; }
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
            <a href="<c:url value='/odontologo'/>" class="nav-link ${pageName == 'dashboard' ? 'active' : ''}"><span>Panel de Control</span></a>
            <a href="<c:url value='/listPatients'/>" class="nav-link ${pageName == 'pacientes' ? 'active' : ''}"><span>Pacientes</span></a>
            <a href="<c:url value='/listCitas'/>" class="nav-link ${pageName == 'citas' ? 'active' : ''}"><span>Citas</span></a>
            <a href="#" class="nav-link"><span>Historial</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">Historial de ${paciente.usuario.persona.nombre} ${paciente.usuario.persona.apellido}</h1>
                <a href="<c:url value='/listPatients'/>" class="btn btn-secondary">Volver a Pacientes</a>
            </div>

            <div class="grid-container">
                <!-- Información Personal -->
                <div class="card full-width-card">
                    <h2 class="card-title">Información Personal</h2>
                    <div class="info-grid" style="grid-template-columns: repeat(2, 120px 1fr);">
                        <span class="info-label">Nombre:</span>
                        <span class="info-value">${paciente.usuario.persona.nombre} ${paciente.usuario.persona.apellido}</span>
                        <span class="info-label">ID Paciente:</span>
                        <span class="info-value">PAC-00${paciente.id}</span>
                        <span class="info-label">Email:</span>
                        <span class="info-value">${paciente.usuario.persona.email}</span>
                        <span class="info-label">Teléfono:</span>
                        <span class="info-value">${paciente.usuario.persona.telefono}</span>
                        <span class="info-label">Fecha Nac.:</span>
                        <span class="info-value"><fmt:formatDate value="${paciente.usuario.persona.fechaNacimientoAsDate}" pattern="dd/MM/yyyy"/></span>
                        <span class="info-label">Género:</span>
                        <span class="info-value">${paciente.usuario.persona.genero}</span>
                        <span class="info-label">Dirección:</span>
                        <span class="info-value">${paciente.usuario.persona.direccion}</span>
                    </div>
                </div>

                <!-- Historial Dental -->
                <div class="card full-width-card">
                    <h2 class="card-title">Historial Dental</h2>
                    <div class="info-grid">
                        <span class="info-label">Condición Oral:</span>
                        <span class="info-value">${not empty paciente.historialDental.condicionGeneralOral ? paciente.historialDental.condicionGeneralOral : 'No especificado'}</span>
                        <span class="info-label">Observaciones:</span>
                        <span class="info-value">${not empty paciente.historialDental.observacionesGenerales ? paciente.historialDental.observacionesGenerales : 'No especificado'}</span>
                        <span class="info-label">Tratamientos Previos:</span>
                        <span class="info-value">${not empty paciente.historialDental.tratamientosPrevios ? paciente.historialDental.tratamientosPrevios : 'No especificado'}</span>
                        <span class="info-label">Alergias Dentales:</span>
                        <span class="info-value">${not empty paciente.historialDental.alergiasDentales ? paciente.historialDental.alergiasDentales : 'No especificado'}</span>
                        <span class="info-label">Medicamentos Actuales:</span>
                        <span class="info-value">${not empty paciente.historialDental.medicamentosActuales ? paciente.historialDental.medicamentosActuales : 'No especificado'}</span>
                    </div>
                </div>

                <!-- Tratamientos Odontológicos -->
                <div class="card full-width-card">
                    <h2 class="card-title">Tratamientos Odontológicos</h2>
                    <c:choose>
                        <c:when test="${not empty tratamientos}">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Tratamiento</th>
                                        <th>Descripción</th>
                                        <th>Fecha Inicio</th>
                                        <th>Fecha Fin</th>
                                        <th>Estado</th>
                                        <th>Costo</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="tratamiento" items="${tratamientos}">
                                        <tr>
                                            <td>${tratamiento.nombreTratamiento}</td>
                                            <td>${tratamiento.descripcion}</td>
                                            <td><fmt:formatDate value="${tratamiento.fechaInicio}" pattern="dd/MM/yyyy"/></td>
                                            <td><fmt:formatDate value="${tratamiento.fechaFin}" pattern="dd/MM/yyyy"/></td>
                                            <td>${tratamiento.estado}</td>
                                            <td>${tratamiento.costo}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <p class="empty-state">No hay tratamientos odontológicos registrados para este paciente.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
