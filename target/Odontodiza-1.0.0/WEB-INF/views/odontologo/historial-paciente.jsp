<%@ page contentType="text/html" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%-- Bloque de seguridad --%>
<c:if test="${empty sessionScope.usuario || sessionScope.usuario.rol ne 'Odontologo'}">
    <c:redirect url="/login"/>
</c:if>

<c:set var="pageTitle" value="Historial del Paciente" scope="request"/>
<c:set var="pageName" value="pacientes" scope="request"/>

<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="com.proyecto.odontodiza.model.TratamientoOdontologico" %>

<%
    // Procesar tratamientos para crear el mapa de estado de los dientes
    Map<Integer, String> toothStateMap = new HashMap<>();
    List<TratamientoOdontologico> tratamientos = (List<TratamientoOdontologico>) request.getAttribute("tratamientos");

    if (tratamientos != null) {
        // La lista viene ordenada por fecha descendente desde el DAO
        for (TratamientoOdontologico t : tratamientos) {
            if (t.getDientesAfectados() != null && !t.getDientesAfectados().isEmpty()) {
                String[] dientes = t.getDientesAfectados().split(",");
                for (String dienteStr : dientes) {
                    try {
                        Integer dienteNum = Integer.parseInt(dienteStr.trim());
                        // Solo se actualiza el estado si el diente no tiene ya un estado (el más reciente prevalece)
                        if (!toothStateMap.containsKey(dienteNum)) {
                            String estado = "sano"; // Por defecto
                            String nombreTratamiento = t.getNombreTratamiento().toLowerCase();
                            
                            if (nombreTratamiento.contains("caries") || nombreTratamiento.contains("obturación")) {
                                estado = "caries";
                            }
                            if (nombreTratamiento.contains("restauración") || nombreTratamiento.contains("corona")) {
                                estado = "restauracion";
                            }
                            if (nombreTratamiento.contains("extracción")) {
                                estado = "ausente";
                            }
                            if (t.getEstado().equalsIgnoreCase("Pendiente") && nombreTratamiento.contains("extracción")) {
                                estado = "extraccion"; // Marcar para extracción
                            }

                            toothStateMap.put(dienteNum, estado);
                        }
                    } catch (NumberFormatException e) {
                        // Ignorar si el valor en dientes_afectados no es un número
                    }
                }
            }
        }
    }
    pageContext.setAttribute("toothStateMap", toothStateMap);
%>

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
        .grid-container { display: grid; grid-template-columns: 1fr; gap: 1.5rem; }
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

        .form-input, .form-select, .form-textarea {
            width: 95%;
            padding: 0.75rem 1rem;
            border: 1px solid var(--border);
            border-radius: 0.375rem;
            font-size: 1rem;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(0, 150, 136, 0.2);
        }
        .form-textarea {
            resize: vertical;
            min-height: 80px;
        }

        /* Estilos del Odontograma */
        .odontograma {
            display: grid;
            grid-template-areas:
                "cuadrante2 cuadrante1"
                "cuadrante3 cuadrante4";
            gap: 10px;
            padding: 10px;
            background-color: #f0f2f4;
            border-radius: 8px;
            max-width: 600px;
            margin: 1rem auto;
        }
        .cuadrante {
            display: flex;
            flex-wrap: wrap;
            border: 1px solid #ccc;
            padding: 5px;
            background: #fff;
        }
        .cuadrante-1 { grid-area: cuadrante1; flex-direction: row-reverse; }
        .cuadrante-2 { grid-area: cuadrante2; }
        .cuadrante-3 { grid-area: cuadrante3; }
        .cuadrante-4 { grid-area: cuadrante4; flex-direction: row-reverse; }

        .diente {
            width: 35px;
            height: 35px;
            border: 1px solid #6c757d;
            margin: 2px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 0.8rem;
            font-weight: bold;
            cursor: pointer;
            border-radius: 4px;
            background-color: #fff;
            transition: background-color 0.2s;
        }
        .diente:hover { background-color: #e9ecef; }

        /* Estados del diente */
        .diente.sano { background-color: #c8e6c9; } /* Verde claro */
        .diente.caries { background-color: #f8d7da; } /* Rojo claro */
        .diente.restauracion { background-color: #bde0fe; } /* Azul claro */
        .diente.ausente {
            background-color: #6c757d;
            color: white;
            pointer-events: none;
        }
        .diente.extraccion {
            background-image: linear-gradient(to top right, transparent 47.5%, #d90429 47.5%, #d90429 52.5%, transparent 52.5%);
        }

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

            <c:if test="${param.update == 'success'}">
                <div class="success-message" style="background-color: var(--green-100); color: var(--green-800); padding: 1rem; border-radius: 0.5rem; margin-bottom: 1.5rem;">
                    El historial dental ha sido actualizado con éxito.
                </div>
            </c:if>

            <div class="grid-container">
                <!-- Odontograma -->
                <div class="card full-width-card">
                    <h2 class="card-title">Odontograma</h2>
                    <div class="odontograma">
                        <!-- Cuadrante 1 (Superior Derecho) -->
                        <div class="cuadrante cuadrante-1">
                            <c:forEach var="i" begin="11" end="18">
                                <div class="diente ${empty toothStateMap[i] ? 'sano' : toothStateMap[i]}">${i}</div>
                            </c:forEach>
                        </div>
                        <!-- Cuadrante 2 (Superior Izquierdo) -->
                        <div class="cuadrante cuadrante-2">
                            <c:forEach var="i" begin="21" end="28">
                                <div class="diente ${empty toothStateMap[i] ? 'sano' : toothStateMap[i]}">${i}</div>
                            </c:forEach>
                        </div>
                        <!-- Cuadrante 3 (Inferior Izquierdo) -->
                        <div class="cuadrante cuadrante-3">
                            <c:forEach var="i" begin="31" end="38">
                                <div class="diente ${empty toothStateMap[i] ? 'sano' : toothStateMap[i]}">${i}</div>
                            </c:forEach>
                        </div>
                        <!-- Cuadrante 4 (Inferior Derecho) -->
                        <div class="cuadrante cuadrante-4">
                            <c:forEach var="i" begin="41" end="48">
                                <div class="diente ${empty toothStateMap[i] ? 'sano' : toothStateMap[i]}">${i}</div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

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
                        <span class="info-value"><fmt:formatDate value="${paciente.usuario.persona.fechaNacimiento}" pattern="dd/MM/yyyy"/></span>
                        <span class="info-label">Género:</span>
                        <span class="info-value">${paciente.usuario.persona.genero}</span>
                        <span class="info-label">Dirección:</span>
                        <span class="info-value">${paciente.usuario.persona.direccion}</span>
                    </div>
                </div>

                <!-- Historial Dental (Editable) -->
                <div class="card full-width-card">
                    <form action="<c:url value='/actualizarHistorial'/>" method="POST">
                        <input type="hidden" name="historialId" value="${paciente.historialDental.id}"/>
                        <input type="hidden" name="pacienteId" value="${paciente.id}"/>
                        
                        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border); padding-bottom: 0.75rem; margin-bottom: 1rem;">
                            <h2 class="card-title" style="border: none; margin: 0;">Historial Dental</h2>
                            <button type="submit" class="btn btn-primary" style="padding: 0.5rem 1rem;">Guardar Cambios</button>
                        </div>

                        <div class="form-grid" style="grid-template-columns: 1fr; gap: 1rem;">
                            <div class="form-group">
                                <label for="condicionGeneralOral" class="form-label">Condición General Oral</label>
                                <textarea id="condicionGeneralOral" name="condicionGeneralOral" class="form-textarea" rows="3">${paciente.historialDental.condicionGeneralOral}</textarea>
                            </div>
                            <div class="form-group">
                                <label for="observacionesGenerales" class="form-label">Observaciones Generales</label>
                                <textarea id="observacionesGenerales" name="observacionesGenerales" class="form-textarea" rows="3">${paciente.historialDental.observacionesGenerales}</textarea>
                            </div>
                            <div class="form-group">
                                <label for="tratamientosPrevios" class="form-label">Tratamientos Previos</label>
                                <textarea id="tratamientosPrevios" name="tratamientosPrevios" class="form-textarea" rows="3">${paciente.historialDental.tratamientosPrevios}</textarea>
                            </div>
                            <div class="form-group">
                                <label for="alergiasDentales" class="form-label">Alergias Dentales</label>
                                <textarea id="alergiasDentales" name="alergiasDentales" class="form-textarea" rows="3">${paciente.historialDental.alergiasDentales}</textarea>
                            </div>
                            <div class="form-group">
                                <label for="medicamentosActuales" class="form-label">Medicamentos Actuales</label>
                                <textarea id="medicamentosActuales" name="medicamentosActuales" class="form-textarea" rows="3">${paciente.historialDental.medicamentosActuales}</textarea>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Tratamientos Odontológicos -->
                <div class="card full-width-card">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <h2 class="card-title" style="border: none; margin: 0;">Tratamientos Odontológicos</h2>
                        <button id="addTratamientoBtn" class="btn btn-primary" style="padding: 0.5rem 1rem;">Añadir Tratamiento</button>
                    </div>
                    <c:choose>
                        <c:when test="${not empty tratamientos}">
                            <table class="table" id="tratamientosTable" style="margin-top: 1rem;">
                                <thead>
                                    <tr>
                                        <th>Tratamiento</th>
                                        <th>Estado</th>
                                        <th>Fecha Inicio</th>
                                        <th>Fecha Fin</th>
                                        <th>Dientes</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="t" items="${tratamientos}">
                                        <tr data-dientes-afectados="${t.dientesAfectados}">
                                            <td>${t.nombreTratamiento}</td>
                                            <td>${t.estado}</td>
                                            <td><fmt:formatDate value="${t.fechaInicio}" pattern="dd/MM/yyyy"/></td>
                                            <td><fmt:formatDate value="${t.fechaFin}" pattern="dd/MM/yyyy"/></td>
                                            <td>${t.dientesAfectados}</td>
                                            <td>
                                                <button class="btn-icon edit-tratamiento-btn" 
                                                        data-id="${t.id}"
                                                        data-nombre="${t.nombreTratamiento}"
                                                        data-descripcion="${t.descripcion}"
                                                        data-fecha-inicio="<fmt:formatDate value='${t.fechaInicio}' pattern='yyyy-MM-dd'/>"
                                                        data-fecha-fin="<fmt:formatDate value='${t.fechaFin}' pattern='yyyy-MM-dd'/>"
                                                        data-estado="${t.estado}"
                                                        data-costo="${t.costo}"
                                                        data-observaciones="${t.observaciones}"
                                                        data-dientes-afectados="${t.dientesAfectados}"
                                                        title="Editar">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                                </button>
                                                <form action="<c:url value='/tratamiento'/>" method="POST" style="display: inline;" onsubmit="return confirm('¿Estás seguro de que quieres eliminar este tratamiento?');">
                                                    <input type="hidden" name="action" value="delete"/>
                                                    <input type="hidden" name="tratamientoId" value="${t.id}"/>
                                                    <input type="hidden" name="pacienteId" value="${paciente.id}"/>
                                                    <button type="submit" class="btn-icon" title="Eliminar">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
                                                    </button>
                                                </form>
                                            </td>
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

        <!-- Modal para Tratamientos -->
        <div id="tratamientoModal" class="modal-overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); justify-content: center; align-items: center; z-index: 1000;">
            <div class="modal-content" style="background: white; padding: 2rem; border-radius: 0.75rem; width: 90%; max-width: 600px;">
                <div class="modal-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                    <h2 id="modalTitle" class="modal-title" style="font-size: 1.5rem; font-weight: 600;">Añadir Nuevo Tratamiento</h2>
                    <button id="modalCloseBtn" class="modal-close-btn" style="background: none; border: none; font-size: 2rem; cursor: pointer;">&times;</button>
                </div>
                <form id="tratamientoForm" action="<c:url value='/tratamiento'/>" method="POST">
                    <input type="hidden" id="action" name="action" value="create">
                    <input type="hidden" id="tratamientoId" name="tratamientoId" value="">
                    <input type="hidden" name="pacienteId" value="${paciente.id}">
                    <input type="hidden" name="odontologoId" value="${sessionScope.odontologo.id}">
                    <input type="text" id="dientesAfectados" name="dientesAfectados" class="form-input" placeholder="Ej: 16,17,21">

                    <div class="form-grid" style="grid-template-columns: 1fr; gap: 1rem;">
                        <div class="form-group full-width">
                            <label for="nombreTratamiento" class="form-label">Nombre del Tratamiento</label>
                            <input type="text" id="nombreTratamiento" name="nombreTratamiento" class="form-input" required placeholder="Ej: Caries, Restauración, Extracción, Obturación, Corona">
                        </div>
                        <div class="form-group full-width">
                            <label for="descripcion" class="form-label">Descripción</label>
                            <textarea id="descripcion" name="descripcion" class="form-textarea" rows="3"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="fechaInicio" class="form-label">Fecha de Inicio</label>
                            <input type="date" id="fechaInicio" name="fechaInicio" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label for="fechaFin" class="form-label">Fecha de Fin</label>
                            <input type="date" id="fechaFin" name="fechaFin" class="form-input">
                        </div>
                        <div class="form-group">
                            <label for="estado" class="form-label">Estado</label>
                            <select id="estado" name="estado" class="form-select" style="width: 100%; padding: 0.75rem; border: 1px solid var(--border); border-radius: 0.5rem;">
                                <option value="Pendiente">Pendiente</option>
                                <option value="En Progreso">En Progreso</option>
                                <option value="Completado">Completado</option>
                                <option value="Cancelado">Cancelado</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="costo" class="form-label">Costo (S/)</label>
                            <input type="number" id="costo" name="costo" class="form-input" step="0.01">
                        </div>
                        <div class="form-group full-width">
                            <label for="observaciones" class="form-label">Observaciones</label>
                            <textarea id="observaciones" name="observaciones" class="form-textarea" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-actions" style="display: flex; justify-content: flex-end; gap: 1rem; margin-top: 1.5rem;">
                        <button type="button" id="modalCancelBtn" class="btn btn-secondary">Cancelar</button>
                        <button type="submit" class="btn btn-primary">Guardar Tratamiento</button>
                    </div>
                </form>
            </div>
        </div>
    </main>

<script>
document.addEventListener('DOMContentLoaded', () => {
    // --- Lógica del Modal ---
    const modal = document.getElementById('tratamientoModal');
    const modalTitle = document.getElementById('modalTitle');
    const addBtn = document.getElementById('addTratamientoBtn');
    const closeBtn = document.getElementById('modalCloseBtn');
    const cancelBtn = document.getElementById('modalCancelBtn');
    const form = document.getElementById('tratamientoForm');
    const dientesAfectadosInput = document.getElementById('dientesAfectados');

    const openModal = () => modal.style.display = 'flex';
    const closeModal = () => {
        modal.style.display = 'none';
        form.reset();
    };

    addBtn.addEventListener('click', () => {
        modalTitle.textContent = 'Añadir Nuevo Tratamiento';
        form.querySelector('#action').value = 'create';
        form.querySelector('#tratamientoId').value = '';
        dientesAfectadosInput.value = ''; // Limpiar al añadir nuevo
        openModal();
    });

    document.querySelectorAll('.edit-tratamiento-btn').forEach(button => {
        button.addEventListener('click', () => {
            modalTitle.textContent = 'Editar Tratamiento';
            form.querySelector('#action').value = 'update';
            
            const dataset = button.dataset;
            form.querySelector('#tratamientoId').value = dataset.id;
            form.querySelector('#nombreTratamiento').value = dataset.nombre;
            form.querySelector('#descripcion').value = dataset.descripcion;
            form.querySelector('#fechaInicio').value = dataset.fechaInicio;
            form.querySelector('#fechaFin').value = dataset.fechaFin;
            form.querySelector('#estado').value = dataset.estado;
            form.querySelector('#costo').value = dataset.costo;
            form.querySelector('#observaciones').value = dataset.observaciones;
            dientesAfectadosInput.value = dataset.dientesAfectados; // Cargar dientes afectados
            
            openModal();
        });
    });

    closeBtn.addEventListener('click', closeModal);
    cancelBtn.addEventListener('click', closeModal);
    modal.addEventListener('click', (event) => {
        if (event.target === modal) {
            closeModal();
        }
    });
});
</script>
</body>
</html>