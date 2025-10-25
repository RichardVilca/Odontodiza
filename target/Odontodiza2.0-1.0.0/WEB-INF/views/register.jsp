<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="preconnect" href="https://fonts.gstatic.com/" crossorigin />
  <link rel="stylesheet" as="style" onload="this.rel='stylesheet'"
    href="https://fonts.googleapis.com/css2?display=swap&family=Inter:wght@400;500;700;900&family=Noto+Sans:wght@400;500;700;900" />
  <title>Registrarse - Odontodiza</title>
  <style>
    /* Estilos del register.html original */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: Inter, "Noto Sans", sans-serif;
    }

    body {
      background-color: #f5f5f5; /* Light background */
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 2rem 1rem;
    }

    .content-container {
      width: 100%;
      max-width: 500px;
      padding: 2rem;
      background-color: white;
      border-radius: 1rem;
      box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
    }

    .title {
      color: #212121; /* Dark text */
      font-size: 1.5rem;
      font-weight: 700;
      text-align: center;
      margin-bottom: 1.5rem;
    }
    
    .error-message {
        background-color: #ffe0b2; /* Light orange for error */
        color: #e64a19; /* Dark orange for error text */
        padding: 1rem;
        border-radius: 0.5rem;
        margin-bottom: 1.5rem;
      text-align: center;
    }

    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 1rem;
      margin-bottom: 1.25rem;
    }

    .form-group {
      margin-bottom: 1.25rem;
    }

    .form-label {
      display: block;
      margin-bottom: 0.5rem;
      font-size: 0.875rem;
      font-weight: 500;
      color: #212121; /* Dark text */
    }

    .form-input {
      width: 100%;
      height: 40px;
      padding: 0.5rem 1rem;
      font-size: 0.875rem;
      border: 1px solid #bdbdbd; /* Neutral gray border */
      border-radius: 0.5rem;
    }

    .form-input:focus {
      outline: none;
      border-color: #009688; /* Primary Teal on focus */
    }

    .button {
      width: 100%;
      height: 40px;
      padding: 0 1rem;
      cursor: pointer;
      border-radius: 0.5rem;
      font-size: 0.875rem;
      font-weight: 700;
      border: none;
    }

    .button-primary {
      background-color: #009688; /* Primary Teal */
      color: white;
    }

    .button-primary:hover {
      background-color: #00796b; /* Darker Primary Teal on hover */
    }

    .form-footer {
      margin-top: 1.5rem;
      text-align: center;
      font-size: 0.875rem;
      color: #9e9e9e; /* Neutral gray */
    }

    .form-footer a {
      color: #009688; /* Primary Teal */
      text-decoration: none;
      font-weight: 500;
    }
  </style>
</head>

<body>
  <div class="content-container">
    <h1 class="title">Crear una cuenta</h1>
    
    <c:if test="${not empty error}">
        <div class="error-message">
            <p>${error}</p>
        </div>
    </c:if>

    <form id="registerForm" method="post" action="<c:url value='/register'/>">
      <div class="form-row">
        <div class="form-group" style="grid-column: 1 / 2;">
          <label class="form-label" for="nombre">Nombre</label>
          <input type="text" id="nombre" name="nombre" class="form-input" required placeholder="Tu nombre">
        </div>
        <div class="form-group" style="grid-column: 2 / 3;">
          <label class="form-label" for="apellido">Apellidos</label>
          <input type="text" id="apellido" name="apellido" class="form-input" required placeholder="Tus apellidos">
        </div>
      </div>

      <div class="form-group">
        <label class="form-label" for="email">Correo electrónico</label>
        <input type="email" id="email" name="email" class="form-input" required placeholder="ejemplo@correo.com">
      </div>

      <div class="form-row">
        <div class="form-group" style="grid-column: 1 / 2;">
          <label class="form-label" for="password">Contraseña</label>
          <input type="password" id="password" name="password" class="form-input" required placeholder="Crea una contraseña">
        </div>
        <div class="form-group" style="grid-column: 2 / 3;">
          <label class="form-label" for="confirmPassword">Confirmar contraseña</label>
          <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" required placeholder="Repite la contraseña">
        </div>
      </div>

      <div class="form-group">
        <label class="form-label" for="telefono">Teléfono</label>
        <input type="tel" id="telefono" name="telefono" class="form-input" required placeholder="Tu número">
      </div>
      <div class="form-group">
        <label class="form-label" for="fechaNacimiento">Fecha de nacimiento</label>
        <input type="date" id="fechaNacimiento" name="fechaNacimiento" class="form-input" required>
      </div>
    
    <div class="form-group">
        <label class="form-label" for="genero">Género</label>
        <input type="text" id="genero" name="genero" class="form-input" required placeholder="Ej: Masculino, Femenino">
    </div>
    
    <div class="form-group">
        <label class="form-label" for="direccion">Dirección</label>
        <input type="text" id="direccion" name="direccion" class="form-input" required placeholder="Tu dirección">
    </div>

    <div class="form-group">
        <label class="form-label" for="userType">Tipo de usuario</label>
        <select id="userType" name="userType" class="form-input" required onchange="handleRoleTypeChange()">
            <option value="Paciente">Paciente</option>
            <option value="Odontologo">Odontologo</option>
        </select>
    </div>

    <div id="odontologoFields" style="display: none;">
        <div class="form-group">
            <label class="form-label" for="especialidad">Especialidad</label>
            <input type="text" id="especialidad" name="especialidad" class="form-input" placeholder="Ej: Odontología General">
        </div>
        <div class="form-group">
            <label class="form-label" for="licencia">Número de Licencia</label>
            <input type="text" id="licencia" name="licencia" class="form-input" placeholder="Ej: LIC-12345">
        </div>
        <div class="form-group">
            <label class="form-label" for="verificationCode">Código de verificación</label>
            <input type="text" id="verificationCode" name="verificationCode" class="form-input" placeholder="Código para Odontólogos">
            <small style="color: #6b7280; font-size: 0.75rem; margin-top: 0.25rem; display: block;">
              * Requerido para registro como Odontologo
            </small>
        </div>
    </div>

        <button type="submit" class="button button-primary">Crear cuenta</button>
    
        <div class="form-footer">
          <p>¿Ya tienes una cuenta? <a href="<c:url value='/login'/>">Inicia sesión aquí</a></p>
        </div>
      </form>
    </div>
    
    <script>
        function handleRoleTypeChange() {
            const userType = document.getElementById('userType').value;
            const odontologoFields = document.getElementById('odontologoFields');
            const especialidadInput = document.getElementById('especialidad');
            const licenciaInput = document.getElementById('licencia');
            const verificationCodeInput = document.getElementById('verificationCode');
    
            if (userType === 'Odontologo') {
                odontologoFields.style.display = 'block';
                especialidadInput.required = true;
                licenciaInput.required = true;
                verificationCodeInput.required = true;
            } else {
                odontologoFields.style.display = 'none';
                especialidadInput.required = false;
                licenciaInput.required = false;
                verificationCodeInput.required = false;
                // Limpiar valores cuando se ocultan los campos
                especialidadInput.value = '';
                licenciaInput.value = '';
                verificationCodeInput.value = '';
            }
        }
    
        // Ejecutar al cargar la página para establecer el estado inicial
        document.addEventListener('DOMContentLoaded', handleRoleTypeChange);
    </script>
    </body>
    
    </html>