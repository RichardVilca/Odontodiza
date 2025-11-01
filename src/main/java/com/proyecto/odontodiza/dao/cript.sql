DROP DATABASE if EXISTS odontodiza_db;
-- Create the database
CREATE DATABASE IF NOT EXISTS odontodiza_db;

-- Use the database
USE odontodiza_db;

-- Table: personas
CREATE TABLE personas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE, -- Changed to DATE type
    genero VARCHAR(50),
    direccion VARCHAR(255),
    telefono VARCHAR(50),
    email VARCHAR(255) UNIQUE
);

-- Table: usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(255) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    rol VARCHAR(50) NOT NULL, -- 'paciente', 'odontologo', 'admin'
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    persona_id INT,
    FOREIGN KEY (persona_id) REFERENCES personas(id)
);

-- Table: historiales_dentales (formerly historiales_clinicos)
CREATE TABLE historiales_dentales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    condicion_general_oral TEXT,
    observaciones_generales TEXT,
    tratamientos_previos TEXT,
    alergias_dentales TEXT,
    medicamentos_actuales TEXT
);

-- Table: pacientes
CREATE TABLE pacientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    historial_dental_id INT, -- Changed to historial_dental_id
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (historial_dental_id) REFERENCES historiales_dentales(id)
);

-- Table: odontologos (formerly nutricionistas)
CREATE TABLE odontologos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    especialidad VARCHAR(255), -- e.g., 'Odontología General', 'Ortodoncia', 'Endodoncia'
    licencia VARCHAR(255),
    usuario_id INT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Table: horarios_disponibles
CREATE TABLE horarios_disponibles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    odontologo_id INT NOT NULL, -- Changed to odontologo_id
    fecha_hora_inicio DATETIME NOT NULL,
    duracion_minutos INT NOT NULL, -- 30, 45, 60
    tipo_atencion VARCHAR(255) NOT NULL, -- e.g., 'Consulta General', 'Limpieza Dental'
    estado VARCHAR(50) DEFAULT 'Disponible', -- Disponible, Reservado
    FOREIGN KEY (odontologo_id) REFERENCES odontologos(id)
);

-- Table: citas
CREATE TABLE citas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    horario_id INT NOT NULL,
    motivo TEXT, -- e.g., 'Revisión', 'Limpieza', 'Empaste'
    estado VARCHAR(50) NOT NULL, -- Programada, Cancelada, Completada
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    FOREIGN KEY (horario_id) REFERENCES horarios_disponibles(id)
);

-- Table: tratamientos_odontologicos (new table, replaces planes_nutricionales)
CREATE TABLE tratamientos_odontologicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    odontologo_id INT NOT NULL,
    nombre_tratamiento VARCHAR(255) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE,
    estado VARCHAR(50) DEFAULT 'Pendiente', -- Pendiente, En Progreso, Completado, Cancelado
    costo DECIMAL(10, 2),
    observaciones TEXT,
    dientes_afectados VARCHAR(255), -- Lista de números de dientes, ej: "11,12,23"
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    FOREIGN KEY (odontologo_id) REFERENCES odontologos(id)
);

-- Table: notificaciones (assuming it exists and is generic)
CREATE TABLE notificaciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    mensaje TEXT NOT NULL,
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    leida BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Table: reportes (assuming it exists and is generic)
CREATE TABLE reportes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_reporte VARCHAR(255) NOT NULL,
    fecha_generacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    contenido TEXT,
    generado_por_usuario_id INT,
    FOREIGN KEY (generado_por_usuario_id) REFERENCES usuarios(id)
);


-- Insert Test Data

-- Personas y Usuarios
INSERT INTO personas (nombre, apellido, fecha_nacimiento, genero, direccion, telefono, email) VALUES
('Juan', 'Perez', '1990-05-15', 'Masculino', 'Calle Falsa 123', '555-1234', 'juan.perez@example.com'),
('Maria', 'Gomez', '1988-11-22', 'Femenino', 'Avenida Siempre Viva 742', '555-5678', 'maria.gomez@example.com'),
('Ana', 'Lopez', '1992-08-20', 'Femenino', 'Plaza Central 10', '555-4321', 'ana.lopez@example.com'),
('Carlos', 'Ruiz', '1985-03-10', 'Masculino', 'Calle del Sol 5', '555-9999', 'carlos.ruiz@example.com'), -- Odontólogo
('Laura', 'Diaz', '1995-01-20', 'Femenino', 'Calle Nueva 456', '555-3333', 'laura.diaz@example.com'); -- Paciente

INSERT INTO usuarios (nombre_usuario, contrasena, rol, persona_id) VALUES
('juan.perez@example.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'paciente', 1),
('maria.gomez@example.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'paciente', 2),
('ana.lopez@example.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'paciente', 3),
('carlos.ruiz@example.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'odontologo', 4),
('laura.diaz@example.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'paciente', 5);

-- Historiales Dentales
INSERT INTO historiales_dentales (condicion_general_oral, observaciones_generales, tratamientos_previos, alergias_dentales, medicamentos_actuales) VALUES
('Buena higiene, sin caries activas.', 'Revisión anual recomendada.', 'Limpieza hace 6 meses.', 'Ninguna', 'Ninguno'),
('Gingivitis leve, una caries en molar.', 'Necesita limpieza profunda y empaste.', 'Empaste en incisivo.', 'Anestesia local', 'Ibuprofeno'),
('Sensibilidad dental, sin caries.', 'Recomendar pasta para sensibilidad.', 'Blanqueamiento dental.', 'Ninguna', 'Ninguno'),
('Caries profunda en premolar, posible endodoncia.', 'Derivar a endodoncista.', 'Extracción de muela del juicio.', 'Penicilina', 'Amoxicilina');

-- Pacientes
INSERT INTO pacientes (usuario_id, historial_dental_id) VALUES (1, 1), (2, 2), (3, 3), (5, 4);

-- Odontologos
INSERT INTO odontologos (especialidad, licencia, usuario_id) VALUES ('Odontología General', 'LIC-12345', 4);

-- Horarios Disponibles creados por el Odontólogo (ID=1)
INSERT INTO horarios_disponibles (odontologo_id, fecha_hora_inicio, duracion_minutos, tipo_atencion, estado) VALUES
(1, '2025-10-20 09:00:00', 60, 'Limpieza Dental', 'Reservado'), -- Este será para la cita 1
(1, '2025-10-20 10:00:00', 60, 'Consulta General', 'Reservado'), -- Este será para la cita 2
(1, '2025-10-21 11:00:00', 30, 'Consulta General', 'Disponible'),
(1, '2025-10-21 11:30:00', 30, 'Consulta General', 'Disponible'),
(1, '2025-10-22 16:00:00', 60, 'Blanqueamiento Dental', 'Reservado'); -- Este será para la cita 3

-- Citas (vinculadas a los horarios reservados)
INSERT INTO citas (paciente_id, horario_id, motivo, estado) VALUES
(1, 1, 'Revisión y limpieza', 'Programada'),   -- Juan Perez reserva el horario 1
(2, 2, 'Consulta por dolor', 'Programada'), -- Maria Gomez reserva el horario 2
(4, 5, 'Empaste dental', 'Programada'); -- Laura Diaz reserva el horario 5

-- Tratamientos Odontológicos
INSERT INTO tratamientos_odontologicos (paciente_id, odontologo_id, nombre_tratamiento, descripcion, fecha_inicio, fecha_fin, estado, costo, observaciones, dientes_afectados) VALUES
(1, 1, 'Limpieza Dental', 'Limpieza profunda y pulido.', '2025-10-20', '2025-10-20', 'Completado', 80.00, 'Paciente con buena higiene.', NULL),
(2, 1, 'Empaste Molar', 'Empaste de resina en molar superior derecho.', '2025-10-20', NULL, 'En Progreso', 120.00, 'Se requiere una segunda sesión.', '16'),
(4, 1, 'Extracción de Muela del Juicio', 'Extracción de muela del juicio inferior izquierda.', '2025-10-22', '2025-10-22', 'Completado', 250.00, 'Sin complicaciones post-operatorias.', '38');

-- Notificaciones (ejemplo)
INSERT INTO notificaciones (usuario_id, mensaje, leida) VALUES
(1, 'Su cita para el 20 de octubre ha sido confirmada.', FALSE),
(4, 'Tiene una nueva cita programada para el 20 de octubre.', FALSE);

-- Reportes (ejemplo)
INSERT INTO reportes (tipo_reporte, contenido, generado_por_usuario_id) VALUES
('Citas del Día', 'Reporte de citas para el 2025-10-20: Juan Perez, Maria Gomez.', 4);


-- Consultas de ejemplo para verificar los datos

-- 1. Seleccionar todos los odontólogos con sus datos de usuario y persona
SELECT
    o.id AS odontologo_id,
    o.especialidad,
    o.licencia,
    u.nombre_usuario AS usuario_email,
    p.nombre AS persona_nombre,
    p.apellido AS persona_apellido,
    p.telefono,
    p.email
FROM odontologos o
JOIN usuarios u ON o.usuario_id = u.id
JOIN personas p ON u.persona_id = p.id;

-- 2. Seleccionar todos los pacientes con sus datos de usuario, persona e historial dental
SELECT
    pa.id AS paciente_id,
    u.nombre_usuario AS usuario_email,
    p.nombre AS persona_nombre,
    p.apellido AS persona_apellido,
    p.telefono,
    p.email,
    hd.condicion_general_oral,
    hd.tratamientos_previos,
    hd.alergias_dentales
FROM pacientes pa
JOIN usuarios u ON pa.usuario_id = u.id
JOIN personas p ON u.persona_id = p.id
JOIN historiales_dentales hd ON pa.historial_dental_id = hd.id;

-- 3. Seleccionar todas las citas con detalles del paciente, odontólogo y horario
SELECT
    c.id AS cita_id,
    c.motivo,
    c.estado AS estado_cita,
    hd.fecha_hora_inicio,
    hd.duracion_minutos,
    p_paciente.nombre AS paciente_nombre,
    p_paciente.apellido AS paciente_apellido,
    p_odontologo.nombre AS odontologo_nombre,
    p_odontologo.apellido AS odontologo_apellido,
    o.especialidad AS odontologo_especialidad
FROM citas c
JOIN horarios_disponibles hd ON c.horario_id = hd.id
JOIN pacientes pa ON c.paciente_id = pa.id
JOIN usuarios u_paciente ON pa.usuario_id = u_paciente.id
JOIN personas p_paciente ON u_paciente.persona_id = p_paciente.id
JOIN odontologos o ON hd.odontologo_id = o.id
JOIN usuarios u_odontologo ON o.usuario_id = u_odontologo.id
JOIN personas p_odontologo ON u_odontologo.persona_id = p_odontologo.id;

-- 4. Seleccionar tratamientos odontológicos de un paciente específico (ej. paciente_id = 1)
SELECT
    tr.id AS tratamiento_id,
    tr.nombre_tratamiento,
    tr.descripcion,
    tr.fecha_inicio,
    tr.estado,
    p_paciente.nombre AS paciente_nombre,
    p_paciente.apellido AS paciente_apellido,
    p_odontologo.nombre AS odontologo_nombre,
    p_odontologo.apellido AS odontologo_apellido
FROM tratamientos_odontologicos tr
JOIN pacientes pa ON tr.paciente_id = pa.id
JOIN personas p_paciente ON pa.usuario_id = p_paciente.id
JOIN odontologos o ON tr.odontologo_id = o.id
JOIN personas p_odontologo ON o.usuario_id = p_odontologo.id
WHERE tr.paciente_id = 1;
