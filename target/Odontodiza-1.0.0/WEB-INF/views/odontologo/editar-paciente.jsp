<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%-- Bloque de seguridad --%>
<c:if test="${empty sessionScope.usuario || sessionScope.usuario.rol ne 'Odontologo'}">
    <c:redirect url="/login"/>
</c:if>

<c:set var="pageTitle" value="Editar Paciente" scope="request"/>
<c:set var="pageName" value="pacientes" scope="request"/>

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
        .form-container { max-width: 800px; margin: 0 auto; background: white; padding: 2rem; border-radius: 0.75rem; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .form-header { margin-bottom: 2rem; }
        .form-title { font-size: 1.5rem; font-weight: 600; color: var(--text); }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; }
        .form-group { margin-bottom: 1rem; }
        .form-group.full-width { grid-column: 1 / -1; }
        .form-label { display: block; margin-bottom: 0.5rem; font-weight: 500; font-size: 0.875rem; color: var(--text); }
        .form-input, .form-textarea { width: 100%; padding: 0.75rem; border: 1px solid var(--border); border-radius: 0.5rem; font-size: 0.875rem; }
        .form-textarea { min-height: 100px; resize: vertical; }
        .form-input:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(0, 150, 136, 0.2);
        }
        .form-actions { grid-column: 1 / -1; display: flex; justify-content: flex-end; gap: 1rem; margin-top: 1rem; }
        .btn { padding: 0.75rem 1.5rem; border-radius: 0.5rem; font-size: 0.875rem; font-weight: 500; cursor: pointer; text-decoration: none; border: 1px solid transparent; }
        .btn-primary { background-color: var(--primary); color: white; }
        .btn-primary:hover { background-color: #00796b; }
        .btn-secondary { background-color: #ff5722; color: white; border-color: transparent; }
        .btn-secondary:hover { background-color: #e64a19; }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div class="sidebar-header">
             <a href="<c:url value='/medico'/>" style="text-decoration: none; color: inherit;">
                <div style="display: flex; align-items: center; gap: 0.5rem;">
                    <svg style="width: 2rem; height: 2rem; color: var(--primary);" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 640 640" fill="currentColor"><path d="M241 69.7L320 96L399 69.7C410.3 65.9 422 64 433.9 64C494.7 64 544 113.3 544 174.1L544 242.6C544 272 534.5 300.7 516.8 324.2L515.7 325.7C502.8 342.9 494.4 363.1 491.4 384.4L469.7 535.9C466.4 558.9 446.7 576 423.5 576C400.7 576 381.2 559.5 377.5 537L357.3 415.6C354.3 397.4 338.5 384 320 384C301.5 384 285.8 397.4 282.7 415.6L262.5 537C258.7 559.5 239.3 576 216.5 576C193.3 576 173.6 558.9 170.3 535.9L148.6 384.5C145.6 363.2 137.2 343 124.3 325.8L123.2 324.3C105.5 300.7 96 272.1 96 242.7L96 174.2C96 113.3 145.3 64 206.1 64C218 64 229.7 65.9 241 69.7z"/></svg>
                    <span style="font-size: 1.125rem; font-weight: 700;">Odontodiza</span>
                </div>
            </a>
            <p style="font-size: 0.875rem; color: var(--gray-500);">Panel de Odontólogo</p>
        </div>
        <nav class="nav-menu">
            <a href="<c:url value='/odontologo'/>" class="nav-link"><span>Panel de Control</span></a>
            <a href="<c:url value='/listPatients'/>" class="nav-link active"><span>Pacientes</span></a>
            <a href="<c:url value='/listCitas'/>" class="nav-link"><span>Citas</span></a>
            <a href="#" class="nav-link"><span>Historial</span></a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="form-container">
            <div class="form-header">
                <h1 class="form-title">Editando a ${paciente.usuario.persona.nombre} ${paciente.usuario.persona.apellido}</h1>
            </div>

            <form action="<c:url value='/editarPaciente'/>" method="POST">
                <input type="hidden" name="pacienteId" value="${paciente.id}">
                <div class="form-grid">
                    
                    <div class="form-group">
                        <label for="nombre" class="form-label">Nombre</label>
                        <input type="text" id="nombre" name="nombre" class="form-input" value="<c:out value='${paciente.usuario.persona.nombre}'/>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="apellido" class="form-label">Apellido</label>
                        <input type="text" id="apellido" name="apellido" class="form-input" value="<c:out value='${paciente.usuario.persona.apellido}'/>" required>
                    </div>

                    <div class="form-group full-width">
                        <label for="email" class="form-label">Correo Electrónico</label>
                        <input type="email" id="email" name="email" class="form-input" value="<c:out value='${paciente.usuario.persona.email}'/>" required>
                    </div>

                    <div class="form-group">
                        <label for="telefono" class="form-label">Teléfono</label>
                        <input type="tel" id="telefono" name="telefono" class="form-input" value="<c:out value='${paciente.usuario.persona.telefono}'/>">
                    </div>

                    <div class="form-group">
                        <label for="fechaNacimiento" class="form-label">Fecha de Nacimiento</label>
                        <input type="date" id="fechaNacimiento" name="fechaNacimiento" class="form-input" value="<c:out value='${paciente.usuario.persona.fechaNacimiento}'/>" required>
                    </div>

                    <div class="form-group">
                        <label for="genero" class="form-label">Género</label>
                        <input type="text" id="genero" name="genero" class="form-input" value="<c:out value='${paciente.usuario.persona.genero}'/>">
                    </div>

                    <div class="form-group full-width">
                        <label for="direccion" class="form-label">Dirección</label>
                        <input type="text" id="direccion" name="direccion" class="form-input" value="<c:out value='${paciente.usuario.persona.direccion}'/>">
                    </div>

                    <div class="form-group full-width">
                        <label for="alergiasDentales" class="form-label">Alergias Dentales</label>
                        <textarea id="alergiasDentales" name="alergiasDentales" class="form-textarea" rows="3"><c:out value='${paciente.historialDental.alergiasDentales}'/></textarea>
                    </div>

                    <div class="form-group full-width">
                        <label for="condicionGeneralOral" class="form-label">Condición General Oral</label>
                        <textarea id="condicionGeneralOral" name="condicionGeneralOral" class="form-textarea" rows="3"><c:out value='${paciente.historialDental.condicionGeneralOral}'/></textarea>
                    </div>

                    <div class="form-group full-width">
                        <label for="medicamentosActuales" class="form-label">Medicamentos Actuales</label>
                        <textarea id="medicamentosActuales" name="medicamentosActuales" class="form-textarea" rows="3"><c:out value='${paciente.historialDental.medicamentosActuales}'/></textarea>
                    </div>

                    <div class="form-group full-width">
                        <label for="tratamientosPrevios" class="form-label">Tratamientos Previos</label>
                        <textarea id="tratamientosPrevios" name="tratamientosPrevios" class="form-textarea" rows="3"><c:out value='${paciente.historialDental.tratamientosPrevios}'/></textarea>
                    </div>

                    <div class="form-actions">
                        <a href="<c:url value='/listPatients'/>" class="btn btn-secondary">Cancelar</a>
                        <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                    </div>
                </div>
            </form>
        </div>
    </main>
</body>
</html>
