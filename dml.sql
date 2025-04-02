-- 1. Tablas sin dependencias
INSERT INTO Campus (nombre, ciudad, region, direccion) VALUES 
('Campuslands Bucaramanga', 'Bucaramanga', 'Santander', 'Calle Principal #123'),
('Campuslands Bogotá', 'Bogotá', 'Cundinamarca', 'Carrera 7 #456');

INSERT INTO Salon (nombre_salon, capacidad) VALUES 
('Apolo', 33),
('Artemis', 33),
('Sputnik', 33),
('Orion', 33);

INSERT INTO Horario_Clase (hora_inicio, hora_fin) VALUES 
('06:00:00', '10:00:00'),
('10:00:00', '14:00:00'),
('14:00:00', '18:00:00'),
('18:00:00', '22:00:00');

INSERT INTO Estado_camper (descripcion, estado_camper) VALUES 
('Iniciando proceso', 'En proceso de ingreso'),
('Inscrito en el programa', 'Inscrito'),
('Aprobado para iniciar', 'Aprobado'),
('Actualmente estudiando', 'Cursando'),
('Finalización exitosa', 'Graduado'),
('Expulsión del programa', 'Expulsado'),
('Retiro voluntario', 'Retirado'),
('Bajo rendimiento', 'Bajo_Rendimiento');

INSERT INTO Estado_Inscripcion (descripcion, estado_inscripcion) VALUES 
('Inscripción activa', 'Activa'),
('Inscripción completada', 'Completada'),
('Inscripción cancelada', 'Cancelada');

INSERT INTO AreaEntrenamiento (nombre_area, descripcion, capacidad) VALUES 
('Backend', 'Desarrollo backend y bases de datos', 33),
('Frontend', 'Desarrollo frontend y UX', 33),
('FullStack', 'Desarrollo full stack', 33);

INSERT INTO Skill (nombre_skill, descripcion) VALUES 
('Fundamentos', 'Fundamentos de programación'),
('Frontend', 'Desarrollo frontend'),
('Backend', 'Desarrollo backend'),
('Bases de Datos', 'Gestión de bases de datos'),
('DevOps', 'Infraestructura y despliegue');

-- 2. Tablas con dependencias primarias
INSERT INTO Modulo (nombre_modulo, id_skill) VALUES 
('Introducción a la programación', 1),
('HTML y CSS', 2),
('JavaScript Básico', 2),
('Java Fundamentals', 3),
('SQL Básico', 4);

INSERT INTO SistemaGestorBaseDatos (nombre_sgdb, descripcion) VALUES 
('MySQL', 'Sistema de gestión de bases de datos relacional'),
('PostgreSQL', 'Sistema de gestión de bases de datos objeto-relacional'),
('MongoDB', 'Base de datos NoSQL orientada a documentos');

INSERT INTO RutaEntrenamiento (nombre_ruta, descripcion, id_sgdb_principal, id_sgdb_alternativo) VALUES 
('Ruta Backend Java', 'Especialización en desarrollo backend', 1, 2),
('Ruta Frontend', 'Especialización en desarrollo frontend', 1, 3),
('Ruta FullStack', 'Desarrollo full stack', 1, 2);

INSERT INTO Entrenador (numero_identificacion, nombres, apellidos, especialidad) VALUES 
('1001', 'Juan', 'Pérez', 'Backend'),
('1002', 'María', 'González', 'Frontend'),
('1003', 'Carlos', 'Rodríguez', 'FullStack');

-- 3. Tablas con dependencias secundarias
INSERT INTO Camper (numero_identificacion, nombres, apellidos, id_campus, id_estado, nivel_riesgo) VALUES 
('2001', 'Ana', 'Martínez', 1, 1, 'Bajo'),
('2002', 'Luis', 'García', 1, 2, 'Medio'),
('2003', 'Sofia', 'López', 2, 3, 'Bajo');

INSERT INTO Grupo_Campers (nombre_grupo, id_ruta, fecha_creacion, id_salon) VALUES 
('Grupo-1', 1, CURDATE(), 1),
('Grupo-2', 2, CURDATE(), 2),
('Grupo-3', 3, CURDATE(), 3);

INSERT INTO Inscripcion (id_camper, id_ruta, fecha_inscripcion, id_estado_inscripcion) VALUES 
(1, 1, CURDATE(), 1),
(2, 2, CURDATE(), 1),
(3, 3, CURDATE(), 1);

-- 4. Tablas con dependencias terciarias
INSERT INTO Conocimiento_Trainer (id_entrenador, id_modulo, nivel_experiencia, fecha_certificacion) VALUES 
(1, 4, 'Avanzado', '2023-01-15'),  -- Juan - Java
(2, 2, 'Avanzado', '2023-01-15'),  -- María - HTML/CSS
(3, 3, 'Avanzado', '2023-01-15');  -- Carlos - JavaScript

INSERT INTO Entrenador_Area (id_entrenador, id_area) VALUES 
(1, 1),  -- Juan - Backend
(2, 2),  -- María - Frontend
(3, 3);  -- Carlos - FullStack

INSERT INTO Asignacion_Entrenador_Ruta (id_entrenador, id_ruta, id_horario) VALUES 
(1, 1, 1),  -- Juan - Backend - Mañana
(2, 2, 2),  -- María - Frontend - Tarde
(3, 3, 3);  -- Carlos - FullStack - Tarde

INSERT INTO Asignacion_Salon_Horario (id_salon, id_horario, id_area) VALUES 
(1, 1, 1),  -- Apolo - Mañana - Backend
(2, 2, 2),  -- Artemis - Tarde - Frontend
(3, 3, 3);  -- Sputnik - Tarde - FullStack

INSERT INTO Grupo_Camper_Asignacion (id_grupo, id_camper) VALUES 
(1, 1),  -- Grupo-1 - Ana
(2, 2),  -- Grupo-2 - Luis
(3, 3);  -- Grupo-3 - Sofia

INSERT INTO Asignacion_Entrenador_Grupo (id_entrenador, id_grupo, id_area, fecha_inicio) VALUES 
(1, 1, 1, CURDATE()),  -- Juan - Grupo-1 - Backend
(2, 2, 2, CURDATE()),  -- María - Grupo-2 - Frontend
(3, 3, 3, CURDATE());  -- Carlos - Grupo-3 - FullStack

INSERT INTO Evaluacion (
    id_inscripcion, 
    id_modulo, 
    fecha_evaluacion,
    nota_teorica, 
    nota_practica, 
    nota_trabajos_quizzes
) VALUES 
(1, 1, CURDATE(), 85, 90, 88),  -- Ana - Fundamentos
(2, 2, CURDATE(), 92, 88, 95),  -- Luis - HTML/CSS
(3, 3, CURDATE(), 78, 82, 80);  -- Sofia - JavaScript

INSERT INTO Telefono_Camper (id_camper, numero, tipo, es_principal) VALUES 
(1, '3001234567', 'movil', TRUE),
(2, '3011234567', 'movil', TRUE),
(3, '3021234567', 'movil', TRUE);

INSERT INTO Telefono_Entrenador (id_entrenador, numero, tipo, es_principal) VALUES 
(1, '3101234567', 'movil', TRUE),
(2, '3111234567', 'movil', TRUE),
(3, '3121234567', 'movil', TRUE);

INSERT INTO Historial_Estado_Camper (id_camper, id_estado_anterior, id_estado_nuevo, fecha_cambio, motivo) VALUES 
(1, 1, 2, CURDATE(), 'Inscripción completada'),
(2, 1, 2, CURDATE(), 'Inscripción completada'),
(3, 1, 2, CURDATE(), 'Inscripción completada');

-------

-- Agregar más campers con diferentes estados y niveles de riesgo
INSERT INTO Camper (numero_identificacion, nombres, apellidos, id_campus, id_estado, nivel_riesgo) VALUES 
('2004', 'Pedro', 'Sánchez', 1, 4, 'Alto'),    -- Cursando con riesgo alto
('2005', 'Laura', 'Ramírez', 1, 5, 'Bajo'),    -- Graduado
('2006', 'Carlos', 'Díaz', 2, 6, 'Alto'),      -- Expulsado
('2007', 'Diana', 'Torres', 2, 7, 'Medio'),    -- Retirado
('2008', 'Miguel', 'Vargas', 1, 8, 'Alto'),    -- Bajo rendimiento
('2009', 'Andrea', 'Ruiz', 1, 4, 'Medio'),     -- Cursando
('2010', 'José', 'Castro', 2, 4, 'Bajo');      -- Cursando

-- Agregar más inscripciones para los nuevos campers
INSERT INTO Inscripcion (id_camper, id_ruta, fecha_inscripcion, id_estado_inscripcion) VALUES 
(4, 1, DATE_SUB(CURDATE(), INTERVAL 15 DAY), 1),
(5, 2, DATE_SUB(CURDATE(), INTERVAL 60 DAY), 2),
(6, 3, DATE_SUB(CURDATE(), INTERVAL 45 DAY), 3),
(7, 1, DATE_SUB(CURDATE(), INTERVAL 30 DAY), 3),
(8, 2, DATE_SUB(CURDATE(), INTERVAL 20 DAY), 1),
(9, 3, DATE_SUB(CURDATE(), INTERVAL 10 DAY), 1),
(10, 1, CURDATE(), 1);

-- Agregar más evaluaciones con diferentes notas
INSERT INTO Evaluacion (
    id_inscripcion, 
    id_modulo, 
    fecha_evaluacion,
    nota_teorica, 
    nota_practica, 
    nota_trabajos_quizzes
) VALUES 
-- Evaluaciones con notas bajas (reprobadas)
(4, 1, CURDATE(), 45, 55, 50),  -- Pedro - Fundamentos
(4, 2, CURDATE(), 52, 58, 55),  -- Pedro - HTML/CSS
(8, 1, CURDATE(), 48, 52, 50),  -- Miguel - Fundamentos
-- Evaluaciones con notas altas
(5, 2, CURDATE(), 95, 98, 96),  -- Laura - HTML/CSS
(5, 3, CURDATE(), 92, 95, 94),  -- Laura - JavaScript
-- Evaluaciones mixtas
(9, 3, CURDATE(), 75, 82, 78),  -- Andrea - JavaScript
(10, 1, CURDATE(), 88, 85, 82); -- José - Fundamentos

-- Agregar más teléfonos para campers (algunos con múltiples números)
INSERT INTO Telefono_Camper (id_camper, numero, tipo, es_principal) VALUES 
(4, '3031234567', 'movil', TRUE),
(4, '6017654321', 'fijo', FALSE),    -- Pedro tiene dos números
(5, '3041234567', 'movil', TRUE),
(5, '3051234567', 'trabajo', FALSE), -- Laura tiene dos números
(6, '3061234567', 'movil', TRUE),
(7, '3071234567', 'movil', TRUE),
(8, '3081234567', 'movil', TRUE),
(9, '3091234567', 'movil', TRUE),
(10, '3101234567', 'movil', TRUE);

-- Agregar acudientes para los campers
INSERT INTO Acudiente (id_camper, nombres, apellidos, telefono, email) VALUES 
(4, 'María', 'Sánchez', '3151234567', 'maria@email.com'),
(5, 'Jorge', 'Ramírez', '3161234567', 'jorge@email.com'),
(6, 'Ana', 'Díaz', '3171234567', 'ana@email.com'),
(7, 'Luis', 'Torres', '3181234567', 'luis@email.com'),
(8, 'Carmen', 'Vargas', '3191234567', 'carmen@email.com'),
(9, 'Pablo', 'Ruiz', '3201234567', 'pablo@email.com'),
(10, 'Elena', 'Castro', '3211234567', 'elena@email.com');

-- Agregar más grupos
INSERT INTO Grupo_Campers (nombre_grupo, id_ruta, fecha_creacion, id_salon) VALUES 
('Grupo-4', 1, CURDATE(), 4),
('Grupo-5', 2, CURDATE(), 1),
('Grupo-6', 3, CURDATE(), 2);

-- Asignar campers a grupos
INSERT INTO Grupo_Camper_Asignacion (id_grupo, id_camper) VALUES 
(4, 4),
(4, 5),
(5, 6),
(5, 7),
(6, 8),
(6, 9),
(6, 10);

-- Agregar más asignaciones de entrenadores a grupos
INSERT INTO Asignacion_Entrenador_Grupo (id_entrenador, id_grupo, id_area, fecha_inicio) VALUES 
(1, 4, 1, CURDATE()),
(2, 5, 2, CURDATE()),
(3, 6, 3, CURDATE());

-- Agregar disponibilidad de entrenadores
INSERT INTO Disponibilidad_Entrenador (id_entrenador, hora_inicio, hora_fin, dia_semana) VALUES 
(1, '06:00:00', '10:00:00', 'Lunes'),
(1, '10:00:00', '14:00:00', 'Martes'),
(2, '14:00:00', '18:00:00', 'Lunes'),
(2, '14:00:00', '18:00:00', 'Miércoles'),
(3, '18:00:00', '22:00:00', 'Martes'),
(3, '18:00:00', '22:00:00', 'Jueves');

-- Agregar más conocimientos de trainers
INSERT INTO Conocimiento_Trainer (id_entrenador, id_modulo, nivel_experiencia, fecha_certificacion) VALUES 
(1, 5, 'Avanzado', '2023-02-15'),  -- Juan - SQL
(2, 3, 'Intermedio', '2023-03-15'), -- María - JavaScript
(3, 1, 'Avanzado', '2023-04-15');  -- Carlos - Fundamentos

-- Agregar más asignaciones de rutas con skills
INSERT INTO Ruta_Skill (id_ruta, id_skill) VALUES 
(1, 1), -- Backend - Fundamentos
(1, 3), -- Backend - Backend
(1, 4), -- Backend - Bases de Datos
(2, 1), -- Frontend - Fundamentos
(2, 2), -- Frontend - Frontend
(3, 1), -- FullStack - Fundamentos
(3, 2), -- FullStack - Frontend
(3, 3); -- FullStack - Backend