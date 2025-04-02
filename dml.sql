INSERT INTO Campus (nombre, ciudad, region, direccion) VALUES 
('Campuslands Bucaramanga', 'Bucaramanga', 'Santander', 'Calle Principal Bucaramanga'),
('Campuslands Tibú', 'Tibú', 'Norte de Santander', 'Sede Tibú'),
('Campuslands Bogotá', 'Bogotá', 'Cundinamarca', 'Sede Bogotá'),
('Campuslands Cúcuta', 'Cúcuta', 'Norte de Santander', 'Sede Cúcuta');

INSERT INTO Salon (nombre_salon, capacidad) VALUES 
-- Bucaramanga
('Apolo', 33),
('Artemis', 33),
('Sputnik', 33),
-- Bogotá
('Orion', 33),
('Perseo', 33),
-- Cúcuta
('Andromeda', 33),
('Fenix', 33),
-- Tibú
('Pegaso', 33);

INSERT INTO Horario_Clase (hora_inicio, hora_fin) VALUES 
('06:00:00', '10:00:00'),  -- Horario 1
('10:00:00', '14:00:00'),  -- Horario 2
('14:00:00', '18:00:00'),  -- Horario 3
('18:00:00', '22:00:00');  -- Horario 4

INSERT INTO Skill (nombre_skill, descripcion) VALUES 
('Fundamentos de Programación', 'Introducción a la algoritmia, PSeInt y Python'),
('Programación Web', 'HTML, CSS y Bootstrap'),
('Programación Formal', 'Java, JavaScript, C#'),
('Bases de Datos', 'MySQL, MongoDB y PostgreSQL'),
('Backend', 'NetCore, Spring Boot, NodeJS y Express');

INSERT INTO Modulo (nombre_modulo, id_skill, duracion_horas) VALUES 
-- Fundamentos
('Introducción a la Algoritmia', 1, 40),
('PSeInt', 1, 40),
('Python Básico', 1, 60),
-- Web
('HTML y CSS', 2, 40),
('Bootstrap', 2, 40),
('JavaScript Frontend', 2, 60),
-- Programación Formal
('Java Fundamentals', 3, 80),
('C# Básico', 3, 80),
('JavaScript Backend', 3, 60),
-- Bases de Datos
('MySQL', 4, 60),
('MongoDB', 4, 40),
('PostgreSQL', 4, 40),
-- Backend
('Spring Boot', 5, 80),
('NodeJS & Express', 5, 80),
('.NET Core', 5, 80);

INSERT INTO SistemaGestorBaseDatos (nombre_sgdb, descripcion) VALUES 
('MySQL', 'Sistema de gestión de bases de datos relacional'),
('MongoDB', 'Base de datos NoSQL orientada a documentos'),
('PostgreSQL', 'Sistema de gestión de bases de datos objeto-relacional');

INSERT INTO Entrenador (numero_identificacion, nombres, apellidos, especialidad) VALUES 
('1234567890', 'Johlver', 'Jose Pardo', 'Desarrollo Backend'),
('2345678901', 'Miguel', 'Niño', 'Desarrollo Frontend'),
('3456789012', 'Carolina', 'Forero', 'Bases de Datos'),
('4567890123', 'Ricardo', 'Rueda', 'Desarrollo FullStack'),
('5678901234', 'Sandra', 'Ruiz', 'Frontend y UX');

INSERT INTO Conocimiento_Trainer (id_entrenador, id_modulo, nivel_experiencia, fecha_certificacion) VALUES 
(1, 10, 'Avanzado', '2023-01-15'),  -- Johlver - MySQL
(1, 12, 'Avanzado', '2023-02-20'),  -- Johlver - PostgreSQL
(1, 13, 'Avanzado', '2023-03-10'),  -- Johlver - Spring Boot
(1, 3, 'Avanzado', '2023-04-05');   -- Johlver - Python

INSERT INTO RutaEntrenamiento (nombre_ruta, descripcion, id_sgdb_principal, id_sgdb_alternativo) VALUES 
('Ruta Backend Java', 'Especialización backend con Java y Spring', 1, 3),
('Ruta Frontend', 'Especialización en desarrollo frontend', 1, 2),
('Ruta FullStack JavaScript', 'Desarrollo full stack con JavaScript', 1, 2),
('Ruta .NET', 'Especialización en desarrollo .NET', 1, 3);

INSERT INTO Asignacion_Entrenador_Ruta (id_entrenador, id_ruta, id_horario) VALUES 
(1, 1, 1),  -- Johlver - Backend - Mañana
(1, 1, 2),  -- Johlver - Backend - Tarde
(2, 2, 1),  -- Miguel - Frontend - Mañana
(3, 1, 3),  -- Carolina - Backend - Tarde
(4, 3, 4);  -- Ricardo - FullStack - Noche

INSERT INTO AreaEntrenamiento (nombre_area, descripcion, capacidad) VALUES 
('Backend', 'Desarrollo backend y bases de datos', 33),
('Frontend', 'Desarrollo frontend y UX', 33),
('FullStack', 'Desarrollo full stack', 33),
('DevOps', 'Infraestructura y despliegue', 33);

INSERT INTO Estado_camper (descripcion, estado_camper) VALUES 
('Iniciando proceso', 'En proceso de ingreso'),
('Inscrito en el programa', 'Inscrito'),
('Aprobado para iniciar', 'Aprobado'),
('Actualmente estudiando', 'Cursando'),
('Finalización exitosa', 'Graduado'),
('Expulsión del programa', 'Expulsado'),
('Retiro voluntario', 'Retirado'),
('Rendimiento insuficiente', 'Bajo_Rendimiento'),
('En riesgo académico', 'En_Riesgo');

INSERT INTO Estado_Inscripcion (descripcion, estado_inscripcion) VALUES 
('Inscripción activa y en curso', 'Activa'),
('Inscripción finalizada', 'Completada'),
('Inscripción cancelada', 'Cancelada');

INSERT INTO Competencia (nombre_competencia, descripcion) VALUES 
('Resolución de Problemas', 'Capacidad para resolver problemas complejos'),
('Trabajo en Equipo', 'Habilidad para trabajar colaborativamente'),
('Comunicación Efectiva', 'Capacidad de comunicación clara'),
('Pensamiento Lógico', 'Habilidad de pensamiento estructurado'),
('Gestión del Tiempo', 'Manejo eficiente del tiempo');

INSERT INTO Usuario (username, password, rol) VALUES 
('johlver.pardo', SHA2('password123', 256), 'trainer'),
('admin.campus', SHA2('admin456', 256), 'admin'),
('camper.ejemplo', SHA2('camper789', 256), 'camper');

INSERT INTO Camper (numero_identificacion, nombres, apellidos, id_campus, id_estado, nivel_riesgo, id_usuario) VALUES 
('1001234567', 'Ana María', 'González', 1, 4, 'Bajo', 3),
('1001234568', 'Carlos', 'Rodríguez', 1, 4, 'Bajo', NULL),
('1001234569', 'Laura', 'Martínez', 1, 4, 'Medio', NULL),
('1001234570', 'Juan', 'Pérez', 2, 4, 'Bajo', NULL),
('1001234571', 'María', 'López', 2, 4, 'Alto', NULL),
('1001234572', 'Diego', 'Sánchez', 3, 4, 'Bajo', NULL),
('1001234573', 'Valentina', 'Torres', 3, 4, 'Medio', NULL),
('1001234574', 'Andrés', 'Ramírez', 4, 4, 'Bajo', NULL);

INSERT INTO Acudiente (id_camper, nombres, apellidos, telefono, email) VALUES 
(1, 'Pedro', 'González', '3101234567', 'pedro.g@email.com'),
(2, 'Martha', 'Rodríguez', '3112345678', 'martha.r@email.com'),
(3, 'José', 'Martínez', '3123456789', 'jose.m@email.com'),
(4, 'Carmen', 'Pérez', '3134567890', 'carmen.p@email.com');

INSERT INTO Direccion (id_camper, calle, ciudad, departamento, codigo_postal, pais) VALUES 
(1, 'Calle 123', 'Bucaramanga', 'Santander', '680001', 'Colombia'),
(2, 'Carrera 45', 'Bucaramanga', 'Santander', '680002', 'Colombia'),
(3, 'Avenida 67', 'Tibú', 'Norte de Santander', '540001', 'Colombia'),
(4, 'Calle 89', 'Bogotá', 'Cundinamarca', '110111', 'Colombia');

INSERT INTO Inscripcion (id_camper, id_ruta, fecha_inscripcion, id_estado_inscripcion, promedio_general) VALUES 
(1, 1, '2024-01-15', 1, 85.5),
(2, 2, '2024-01-15', 1, 78.3),
(3, 3, '2024-01-16', 1, 92.0),
(4, 4, '2024-01-16', 1, 88.7);

INSERT INTO Grupo_Campers (nombre_grupo, id_ruta, fecha_creacion) VALUES 
('J1', 1, '2024-01-15'),
('J2', 1, '2024-01-15'),
('J3', 2, '2024-01-15'),
('J4', 2, '2024-01-15');

INSERT INTO Telefono_Camper (id_camper, numero, tipo, es_principal) VALUES 
(1, '3201234567', 'movil', TRUE),
(1, '6017654321', 'fijo', FALSE),
(2, '3212345678', 'movil', TRUE),
(3, '3223456789', 'movil', TRUE),
(4, '3234567890', 'movil', TRUE);

INSERT INTO Telefono_Entrenador (id_entrenador, numero, tipo, es_principal) VALUES 
(1, '3101234567', 'movil', TRUE),
(2, '3112345678', 'movil', TRUE),
(3, '3123456789', 'movil', TRUE),
(4, '3134567890', 'movil', TRUE),
(5, '3145678901', 'movil', TRUE);

INSERT INTO Historial_Estado_Camper (id_camper, id_estado_anterior, id_estado_nuevo, fecha_cambio, motivo) VALUES 
(1, 1, 4, '2024-01-15', 'Inicio de clases'),
(2, 1, 4, '2024-01-15', 'Inicio de clases'),
(3, 1, 4, '2024-01-16', 'Inicio de clases'),
(4, 1, 4, '2024-01-16', 'Inicio de clases');

INSERT INTO Asignacion_Salon_Horario (id_salon, id_horario, id_area) VALUES 
(1, 1, 1),  -- Apolo - Mañana - Backend
(2, 2, 2),  -- Artemis - Tarde - Frontend
(3, 3, 3),  -- Sputnik - Tarde - FullStack
(4, 4, 1);  -- Orion - Noche - Backend

INSERT INTO Evaluacion (id_inscripcion, id_modulo, nota_teorica, nota_practica, nota_trabajos_quizzes, nota_final) VALUES 
(1, 1, 85, 88, 90, 87.5),
(1, 2, 90, 92, 88, 90.8),
(2, 4, 78, 82, 85, 81.3),
(2, 5, 88, 85, 90, 86.7);

INSERT INTO Camper (numero_identificacion, nombres, apellidos, id_campus, id_estado, nivel_riesgo) VALUES 
('1001', 'Juan', 'Pérez', 1, 2, 'Bajo'),    -- Inscrito
('1002', 'María', 'López', 1, 3, 'Bajo'),    -- Aprobado
('1003', 'Carlos', 'Ruiz', 1, 4, 'Alto'),    -- Cursando
('1004', 'Ana', 'García', 1, 5, 'Bajo'),     -- Graduado
('1005', 'Pedro', 'Martínez', 1, 6, 'Medio'), -- Expulsado
('1006', 'Laura', 'Sánchez', 1, 7, 'Alto');   -- Retirado

INSERT INTO Grupo_Campers (nombre_grupo, id_ruta) VALUES 
('J1', 1),
('J2', 1),
('J3', 2),
('J4', 3);

INSERT INTO Grupo_Camper_Asignacion (id_grupo, id_camper) VALUES 
(1, 1),
(1, 2),
(2, 3),
(2, 4);

INSERT INTO Disponibilidad_Entrenador (id_entrenador, hora_inicio, hora_fin, dia_semana) VALUES 
(1, '06:00:00', '10:00:00', 'Lunes'),
(1, '10:00:00', '14:00:00', 'Martes'),
(2, '14:00:00', '18:00:00', 'Lunes'),
(3, '18:00:00', '22:00:00', 'Miércoles');

INSERT INTO Evaluacion (id_inscripcion, id_modulo, nota_teorica, nota_practica, nota_trabajos_quizzes, nota_final) VALUES 
(1, 1, 80, 85, 90, 84.5),
(1, 2, 75, 88, 92, 84.1),
(2, 1, 95, 92, 88, 92.3),
(2, 2, 70, 65, 60, 66.0);

INSERT INTO Inscripcion (id_camper, id_ruta, fecha_inscripcion, id_estado_inscripcion) VALUES 
(1, 1, '2024-01-15', 1),
(2, 1, '2024-01-15', 1),
(3, 2, '2024-01-16', 1),
(4, 3, '2024-01-16', 1);

INSERT INTO Telefono_Camper (id_camper, numero, tipo, es_principal) VALUES 
(1, '3001234567', 'movil', TRUE),
(1, '3011234567', 'fijo', FALSE),
(2, '3021234567', 'movil', TRUE),
(3, '3031234567', 'movil', TRUE);

INSERT INTO Acudiente (id_camper, nombres, apellidos, telefono, email) VALUES 
(1, 'Roberto', 'Pérez', '3101234567', 'roberto@email.com'),
(2, 'Carmen', 'López', '3111234567', 'carmen@email.com'),
(3, 'Jorge', 'Ruiz', '3121234567', 'jorge@email.com');

INSERT INTO Entrenador_Area (id_entrenador, id_area) VALUES 
(1, 1),  -- Johlver - Backend
(2, 2),  -- Miguel - Frontend
(3, 1),  -- Carolina - Backend
(4, 3);  -- Ricardo - FullStack

INSERT INTO Asignacion_Entrenador_Grupo (id_entrenador, id_grupo) VALUES 
(1, 1),
(1, 2),
(2, 3),
(3, 4);

-- Ruta_Skill (para relacionar rutas con skills/módulos)
INSERT INTO Ruta_Skill (id_ruta, id_skill) VALUES
(1, 3),  -- Ruta Backend Java - Programación Formal
(1, 4),  -- Ruta Backend Java - Bases de Datos
(1, 5),  -- Ruta Backend Java - Backend
(2, 2),  -- Ruta Frontend - Programación Web
(3, 2),  -- Ruta FullStack - Programación Web
(3, 3),  -- Ruta FullStack - Programación Formal
(3, 5);  -- Ruta FullStack - Backend

-- Actualizar Grupo_Campers para incluir id_salon
ALTER TABLE Grupo_Campers ADD COLUMN id_salon INT;
UPDATE Grupo_Campers SET id_salon = 1 WHERE nombre_grupo = 'J1';
UPDATE Grupo_Campers SET id_salon = 2 WHERE nombre_grupo = 'J2';
UPDATE Grupo_Campers SET id_salon = 3 WHERE nombre_grupo = 'J3';
UPDATE Grupo_Campers SET id_salon = 4 WHERE nombre_grupo = 'J4';

-- Más evaluaciones para tener mejor distribución de notas
INSERT INTO Evaluacion (id_inscripcion, id_modulo, nota_teorica, nota_practica, nota_trabajos_quizzes, nota_final) VALUES 
(3, 1, 55, 58, 52, 55.0),
(3, 2, 45, 48, 52, 48.0),
(4, 1, 95, 98, 92, 95.0),
(4, 2, 88, 92, 90, 90.0),
(1, 3, 72, 68, 70, 70.0),
(2, 3, 58, 52, 55, 55.0);

-- Más campers con diferentes niveles de riesgo
INSERT INTO Camper (numero_identificacion, nombres, apellidos, id_campus, id_estado, nivel_riesgo) VALUES 
('1007', 'Diego', 'Ramírez', 1, 4, 'Alto'),
('1008', 'Sofia', 'Torres', 1, 4, 'Medio'),
('1009', 'Lucas', 'Vargas', 1, 4, 'Alto'),
('1010', 'Valentina', 'Castro', 1, 4, 'Medio');

-- Más registros de historial de estados
INSERT INTO Historial_Estado_Camper (id_camper, id_estado_anterior, id_estado_nuevo, fecha_cambio, motivo) VALUES 
(5, 1, 2, '2024-01-15', 'Inscripción completada'),
(5, 2, 4, '2024-01-20', 'Inicio de clases'),
(5, 4, 8, '2024-02-15', 'Bajo rendimiento'),
(6, 1, 2, '2024-01-15', 'Inscripción completada'),
(6, 2, 4, '2024-01-20', 'Inicio de clases'),
(6, 4, 7, '2024-02-10', 'Retiro voluntario');

-- Más inscripciones
INSERT INTO Inscripcion (id_camper, id_ruta, fecha_inscripcion, id_estado_inscripcion) VALUES 
(5, 1, '2024-01-15', 1),
(6, 2, '2024-01-15', 1),
(7, 1, '2024-01-16', 1),
(8, 2, '2024-01-16', 1);

-- Más asignaciones a grupos
INSERT INTO Grupo_Camper_Asignacion (id_grupo, id_camper) VALUES 
(3, 5),
(3, 6),
(4, 7),
(4, 8);

-- Más evaluaciones para los nuevos campers
INSERT INTO Evaluacion (id_inscripcion, id_modulo, nota_teorica, nota_practica, nota_trabajos_quizzes, nota_final) VALUES 
(5, 1, 45, 48, 52, 48.0),
(5, 2, 55, 52, 58, 55.0),
(6, 1, 92, 88, 95, 91.7),
(6, 2, 85, 88, 82, 85.0),
(7, 1, 78, 82, 75, 78.3),
(8, 1, 68, 72, 65, 68.3);