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
  <title>Iniciar Sesión - Odontodiza</title>
  <style>
    /* ... (Estilos CSS del login.html original) ... */
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
      overflow-x: hidden;
    }

    header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0.75rem 2.5rem;
      border-bottom: 1px solid #e0e0e0; /* Lighter border */
      white-space: nowrap;
    }

    .header-logo {
      display: flex;
      align-items: center;
      gap: 1rem;
      color: #212121; /* Dark text */
      text-decoration: none;
    }

    .header-logo h2 {
      font-size: 1.125rem;
      font-weight: 700;
      line-height: 1.2;
      letter-spacing: -0.015em;
    }

    .nav-links {
      display: flex;
      align-items: center;
      gap: 2.25rem;
      margin-left: auto;
      margin-right: 2rem;
    }

    .nav-links a {
      color: #212121; /* Dark text */
      font-size: 0.875rem;
      font-weight: 500;
      line-height: 1.5;
      text-decoration: none;
    }

    .button {
      display: inline-flex;
      min-width: 84px;
      max-width: 480px;
      height: 40px;
      padding: 0 1rem;
      cursor: pointer;
      align-items: center;
      justify-content: center;
      border-radius: 0.5rem;
      font-size: 0.875rem;
      font-weight: 700;
      line-height: 1.5;
      letter-spacing: 0.015em;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      border: none;
      text-decoration: none;
    }

    .button-primary {
      background-color: #009688; /* Primary Teal */
      color: white;
      width: 100%;
    }

    .button-primary:hover {
      background-color: #00796b; /* Darker Primary Teal on hover */
    }

    .button-secondary {
      background-color: #ff5722; /* Accent Orange */
      color: white;
    }

    .button-secondary:hover {
      background-color: #e64a19; /* Darker Accent Orange on hover */
    }

    .main-content {
      padding: 1.25rem 2rem;
      display: flex;
      flex: 1;
      justify-content: center;
      align-items: center;
    }

    .content-container {
      display: flex;
      flex-direction: column;
      width: 100%;
      max-width: 400px;
      padding: 2rem;
      background-color: white;
      border-radius: 1rem;
      box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
    }

    .title {
      color: #212121; /* Dark text */
      font-size: 1.5rem;
      font-weight: 700;
      line-height: 1.2;
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
    
    .success-message {
        background-color: #c8e6c9; /* Light green for success */
        color: #388e3c; /* Dark green for success text */
        padding: 1rem;
        border-radius: 0.5rem;
        margin-bottom: 1.5rem;
        text-align: center;
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
      transition: border-color 0.2s;
    }

    .form-input:focus {
      outline: none;
      border-color: #009688; /* Primary Teal on focus */
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

    .form-footer a:hover {
      text-decoration: underline;
    }
  </style>
</head>

<body>
  <div class="app-container">
    <header>
      <a href="<c:url value='/index.jsp'/>" class="header-logo">
        <div class="logo-icon">
          <svg viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M39.5563 34.1455V13.8546C39.5563 15.708 36.8773 17.3437 32.7927 18.3189C30.2914 18.916 27.263 19.2655 24 19.2655C20.737 19.2655 17.7086 18.916 15.2073 18.3189C11.1227 17.3437 8.44365 15.708 8.44365 13.8546V34.1455C8.44365 35.9988 11.1227 37.6346 15.2073 38.6098C17.7086 39.2069 20.737 39.5564 24 39.5564C27.263 39.5564 30.2914 39.2069 32.7927 38.6098C36.8773 37.6346 39.5563 35.9988 39.5563 34.1455Z" fill="currentColor"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M10.4485 13.8519C10.4749 13.9271 10.6203 14.246 11.379 14.7361C12.298 15.3298 13.7492 15.9145 15.6717 16.3735C18.0007 16.9296 20.8712 17.2655 24 17.2655C27.1288 17.2655 29.9993 16.9296 32.3283 16.3735C34.2508 15.9145 35.702 15.3298 36.621 14.7361C37.3796 14.246 37.5251 13.9271 37.5515 13.8519C37.5287 13.7876 37.4333 13.5973 37.0635 13.2931C36.5266 12.8516 35.6288 12.3647 34.343 11.9175C31.79 11.0295 28.1333 10.4437 24 10.4437C19.8667 10.4437 16.2099 11.0295 13.657 11.9175C12.3712 12.3647 11.4734 12.8516 10.9365 13.2931C10.5667 13.5973 10.4713 13.7876 10.4485 13.8519ZM37.5563 18.7877C36.3176 19.3925 34.8502 19.8839 33.2571 20.2642C30.5836 20.9025 27.3973 21.2655 24 21.2655C20.6027 21.2655 17.4164 20.9025 14.7429 20.2642C13.1498 19.8839 11.6824 19.3925 10.4436 18.7877V34.1275C10.4515 34.1545 10.5427 34.4867 11.379 35.027C12.298 35.6207 13.7492 36.2054 15.6717 36.6644C18.0007 37.2205 20.8712 37.5564 24 37.5564C27.1288 37.5564 29.9993 37.2205 32.3283 36.6644C34.2508 36.2054 35.702 35.6207 36.621 35.027C37.4573 34.4867 37.5485 34.1546 37.5563 34.1275V18.7877ZM41.5563 13.8546V34.1455C41.5563 36.1078 40.158 37.5042 38.7915 38.3869C37.3498 39.3182 35.4192 40.0389 33.2571 40.5551C30.5836 41.1934 27.3973 41.5564 24 41.5564C20.6027 41.5564 17.4164 41.1934 14.7429 40.5551C12.5808 40.0389 10.6502 39.3182 9.20848 38.3869C7.84205 37.5042 6.44365 36.1078 6.44365 34.1455L6.44365 13.8546C6.44365 12.2684 7.37223 11.0454 8.39581 10.2036C9.43325 9.3505 10.8137 8.67141 12.343 8.13948C15.4203 7.06909 19.5418 6.44366 24 6.44366C28.4582 6.44366 32.5797 7.06909 35.657 8.13948C37.1863 8.67141 38.5667 9.3505 39.6042 10.2036C40.6278 11.0454 41.5563 12.2684 41.5563 13.8546Z" fill="currentColor"></path></svg>
        </div>
        <h2>Odontodiza</h2>
      </a>
      <nav class="nav-links">
        <a href="<c:url value='/index.jsp'/>">Inicio</a>
        <a href="#">Servicios</a>
        <a href="#">Nosotros</a>
        <a href="#">Contacto</a>
      </nav>
      <div class="button-group">
        <a href="<c:url value='/register.jsp'/>" class="button button-secondary">Registrarse</a>
      </div>
    </header>

    <main class="main-content">
      <div class="content-container">
        <h1 class="title">Iniciar Sesión</h1>
        
        <c:if test="${param.registro == 'exitoso'}">
          <div class="success-message">
            <p>¡Registro exitoso! Ahora puedes iniciar sesión.</p>
          </div>
        </c:if>

        <c:if test="${not empty error}">
          <div class="error-message">
            <p>${error}</p>
          </div>
        </c:if>

        <form id="loginForm" method="post" action="<c:url value='/login'/>">
          <div class="form-group">
            <label class="form-label" for="email">Correo electrónico</label>
            <input type="email" id="email" name="email" class="form-input" required placeholder="ejemplo@correo.com">
          </div>
          <div class="form-group">
            <label class="form-label" for="password">Contraseña</label>
            <input type="password" id="password" name="password" class="form-input" required placeholder="Ingresa tu contraseña">
          </div>
          <button type="submit" class="button button-primary">Iniciar Sesión</button>
          <div class="form-footer">
            <p>¿No tienes una cuenta? <a href="<c:url value='/register'/>">Regístrate aquí</a></p>
          </div>
        </form>
      </div>
    </main>
  </div>
</body>

</html>
