<%@ page contentType="text/html" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

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
        }
        body { background-color: var(--background); font-family: 'Inter', sans-serif; color: var(--text); display: flex; margin: 0; }
        .sidebar {
            width: 16rem;
            background-color: #263238; /* Dark background for sidebar */
            border-right: 1px solid #455a64; /* Darker border */
            height: 100vh;
            position: fixed;
            left: 0; top: 0;
            display: flex; flex-direction: column;
        }
        .sidebar-header, .user-section { padding: 1.5rem; }
        .nav-menu { flex: 1; padding: 0.5rem 1rem; }
        .nav-link { display: flex; align-items: center; gap: 0.75rem; padding: 0.5rem 0.75rem; border-radius: 0.5rem; color: #e0e0e0; text-decoration: none; font-size: 0.875rem; font-weight: 500; transition: all 0.2s; }
        .nav-link.active, .nav-link:hover { background-color: rgba(0, 150, 136, 0.2); color: white; }
        .main-content { flex: 1; margin-left: 16rem; padding: 2rem; }
        .form-container { max-width: 800px; margin: 0 auto; background: white; padding: 2rem; border-radius: 0.75rem; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .form-header { margin-bottom: 2rem; }
        .form-title { font-size: 1.5rem; font-weight: 600; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; }
        .form-group { margin-bottom: 1rem; }
        .form-group.full-width { grid-column: 1 / -1; }
        .form-label { display: block; margin-bottom: 0.5rem; font-weight: 500; font-size: 0.875rem; }
        .form-input, .form-textarea { width: 100%; padding: 0.75rem; border: 1px solid var(--border); border-radius: 0.5rem; font-size: 0.875rem; }
        .form-textarea { min-height: 100px; resize: vertical; }
        .form-actions { grid-column: 1 / -1; display: flex; justify-content: flex-end; gap: 1rem; margin-top: 1rem; }
        .btn { padding: 0.75rem 1.5rem; border-radius: 0.5rem; font-size: 0.875rem; font-weight: 500; cursor: pointer; text-decoration: none; border: 1px solid transparent; }
        .btn-primary { background-color: var(--primary); color: white; }
        .btn-secondary { background-color: #e0e0e0; color: var(--text); border-color: var(--border); }
    </style>
</head>
<body>
    <aside class="sidebar">
        <!-- ... (sidebar HTML) ... -->
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
                        <input type="text" id="nombre" name="nombre" class="form-input" value="${paciente.usuario.persona.nombre}" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="apellido" class="form-label">Apellido</label>
                        <input type="text" id="apellido" name="apellido" class="form-input" value="${paciente.usuario.persona.apellido}" required>
                    </div>

                    <div class="form-group full-width">
                        <label for="email" class="form-label">Correo Electrónico</label>
                        <input type="email" id="email" name="email" class="form-input" value="${paciente.usuario.persona.email}" required>
                    </div>

                    <div class="form-group">
                        <label for="telefono" class="form-label">Teléfono</label>
                        <input type="tel" id="telefono" name="telefono" class="form-input" value="${paciente.usuario.persona.telefono}">
                    </div>

                    <div class="form-group">
                        <label for="fechaNacimiento" class="form-label">Fecha de Nacimiento</label>
                        <input type="date" id="fechaNacimiento" name="fechaNacimiento" class="form-input" value="<fmt:formatDate value='${paciente.usuario.persona.fechaNacimiento}' pattern='yyyy-MM-dd'/>" required>
                    </div>

                    <div class="form-group">
                        <label for="genero" class="form-label">Género</label>
                        <input type="text" id="genero" name="genero" class="form-input" value="${paciente.usuario.persona.genero}">
                    </div>

                    <div class="form-group full-width">
                        <label for="direccion" class="form-label">Dirección</label>
                        <input type="text" id="direccion" name="direccion" class="form-input" value="${paciente.usuario.persona.direccion}">
                    </div>

                    <div class="form-group full-width">
                        <label for="condicionGeneralOral" class="form-label">Condición General Oral</label>
                        <textarea id="condicionGeneralOral" name="condicionGeneralOral" class="form-textarea" rows="3">${paciente.historialDental.condicionGeneralOral}</textarea>
                    </div>

                    <div class="form-group full-width">
                        <label for="observacionesGenerales" class="form-label">Observaciones Generales</label>
                        <textarea id="observacionesGenerales" name="observacionesGenerales" class="form-textarea" rows="3">${paciente.historialDental.observacionesGenerales}</textarea>
                    </div>

                    <div class="form-group full-width">
                        <label for="tratamientosPrevios" class="form-label">Tratamientos Previos</label>
                        <textarea id="tratamientosPrevios" name="tratamientosPrevios" class="form-textarea" rows="3">${paciente.historialDental.tratamientosPrevios}</textarea>
                    </div>

                    <div class="form-group full-width">
                        <label for="alergiasDentales" class="form-label">Alergias Dentales</label>
                        <textarea id="alergiasDentales" name="alergiasDentales" class="form-textarea" rows="3">${paciente.historialDental.alergiasDentales}</textarea>
                    </div>

                    <div class="form-group full-width">
                        <label for="medicamentosActuales" class="form-label">Medicamentos Actuales</label>
                        <textarea id="medicamentosActuales" name="medicamentosActuales" class="form-textarea" rows="3">${paciente.historialDental.medicamentosActuales}</textarea>
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