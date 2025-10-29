<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%-- Seguridad --%>
<c:if test="${empty sessionScope.usuario || sessionScope.usuario.rol ne 'Paciente'}">
    <c:redirect url="/login"/>
</c:if>

<c:set var="pageTitle" value="Editar Perfil" scope="request"/>

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
        .main-content { max-width: 800px; margin: 2rem auto; padding: 0 2rem; }
        .form-container { background: white; padding: 2rem; border-radius: 0.75rem; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .form-header { margin-bottom: 2rem; }
        .form-title { font-size: 1.5rem; font-weight: 600; color: var(--text); }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; }
        .form-group { margin-bottom: 1rem; }
        .form-group.full-width { grid-column: 1 / -1; }
        .form-label { display: block; margin-bottom: 0.5rem; font-weight: 500; font-size: 0.875rem; color: var(--text); }
        .form-input { width: 100%; padding: 0.75rem; border: 1px solid var(--border); border-radius: 0.5rem; font-size: 0.875rem; }
        .form-input:focus {
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
        .error-message { color: var(--red-800); background-color: var(--red-100); padding: 1rem; border-radius: 0.5rem; margin-bottom: 1.5rem; }
    </style>
</head>
<body>
    <header>
        <a href="<c:url value='/paciente'/>" class="logo-container">
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
        <div class="form-container">
            <div class="form-header">
                <h1 class="form-title">Editar Mi Perfil</h1>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="error-message">${errorMessage}</div>
            </c:if>

            <form action="<c:url value='/editarPerfilPaciente'/>" method="POST">
                <div class="form-grid">
                    
                    <div class="form-group">
                        <label for="nombre" class="form-label">Nombre</label>
                        <input type="text" id="nombre" name="nombre" class="form-input" value="<c:out value='${persona.nombre}'/>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="apellido" class="form-label">Apellido</label>
                        <input type="text" id="apellido" name="apellido" class="form-input" value="<c:out value='${persona.apellido}'/>" required>
                    </div>

                    <div class="form-group full-width">
                        <label for="email" class="form-label">Correo Electrónico</label>
                        <input type="email" id="email" name="email" class="form-input" value="<c:out value='${persona.email}'/>" required>
                    </div>

                    <div class="form-group">
                        <label for="telefono" class="form-label">Teléfono</label>
                        <input type="tel" id="telefono" name="telefono" class="form-input" value="<c:out value='${persona.telefono}'/>">
                    </div>

                    <div class="form-group">
                        <label for="fechaNacimiento" class="form-label">Fecha de Nacimiento</label>
                        <input type="date" id="fechaNacimiento" name="fechaNacimiento" class="form-input" value="<fmt:formatDate value='${persona.fechaNacimiento}' pattern='yyyy-MM-dd'/>" required>
                    </div>

                    <div class="form-group">
                        <label for="genero" class="form-label">Género</label>
                        <input type="text" id="genero" name="genero" class="form-input" value="<c:out value='${persona.genero}'/>">
                    </div>

                    <div class="form-group full-width">
                        <label for="direccion" class="form-label">Dirección</label>
                        <input type="text" id="direccion" name="direccion" class="form-input" value="<c:out value='${persona.direccion}'/>">
                    </div>

                    <div class="form-actions">
                        <a href="<c:url value='/paciente'/>" class="btn btn-secondary">Cancelar</a>
                        <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                    </div>
                </div>
            </form>
        </div>
    </main>
</body>
</html>
