-- 1. Campus
INSERT INTO Campus (nombre, ciudad, region, direccion) VALUES
('CampusLands', 'Bucaramanga', 'Santander', 'Zona Franca Santander');

-- 2. Estado_camper
INSERT INTO Estado_camper (descripcion, estado_camper) VALUES
('Iniciando proceso', 'En proceso de ingreso'),
('Inscrito en programa', 'Inscrito'),
('Aprobado para iniciar', 'Aprobado'),
('Actualmente estudiando', 'Cursando'),
('Finalización exitosa', 'Graduado'),
('Expulsión disciplinaria', 'Expulsado'),
('Retiro voluntario', 'Retirado');

-- 3. SistemaGestorBaseDatos
INSERT INTO SistemaGestorBaseDatos (nombre_sgdb, descripcion) VALUES
('MySQL', 'Sistema de gestión de bases de datos relacional'),
('MongoDB', 'Base de datos NoSQL orientada a documentos'),
('PostgreSQL', 'Sistema de gestión de bases de datos relacional-objeto');

-- 4. AreaEntrenamiento
INSERT INTO AreaEntrenamiento (nombre_area, descripcion) VALUES
('Desarrollo Backend', 'Programación del lado del servidor'),
('Desarrollo Frontend', 'Programación de interfaces de usuario'),
('Base de Datos', 'Gestión y administración de bases de datos'),
('Desarrollo Móvil', 'Programación de aplicaciones móviles');

-- 5. Salon
INSERT INTO Salon (nombre_salon, capacidad) VALUES
('Apolo', 33),
('Sputnik', 33),
('Artemis', 33);

-- 6. Horario_Clase
INSERT INTO Horario_Clase (hora_inicio, hora_fin) VALUES
('06:00:00', '10:00:00'),
('10:00:00', '14:00:00'),
('14:00:00', '18:00:00'),
('18:00:00', '22:00:00');

-- 7. Skill
INSERT INTO Skill (nombre_skill, descripcion) VALUES
('Fundamentos de Programación', 'Conceptos básicos de programación y lógica'),
('Desarrollo Web', 'Tecnologías y frameworks web'),
('Bases de Datos', 'Diseño y gestión de bases de datos'),
('Backend', 'Desarrollo del lado del servidor'),
('Frontend', 'Desarrollo de interfaces de usuario');

-- 8. Estado_Inscripcion
INSERT INTO Estado_Inscripcion (descripcion, estado_inscripcion) VALUES
('Inscripción en curso', 'Activa'),
('Inscripción finalizada', 'Completada'),
('Inscripción cancelada', 'Cancelada');

-- 9. Competencia
INSERT INTO Competencia (nombre_competencia, descripcion) VALUES
('Lógica de Programación', 'Capacidad de resolver problemas mediante algoritmos'),
('Diseño Web', 'Habilidades en diseño y desarrollo web'),
('Gestión de Datos', 'Manejo y administración de bases de datos'),
('Arquitectura Backend', 'Diseño de sistemas del lado del servidor');

-- 10. Usuario (incluyendo trainers y admin)
INSERT INTO Usuario (username, password, rol) VALUES
('admin', '$2a$12$LQV3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/vC5hpFm', 'admin'),
('trainer1', '$2a$12$LQV3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/vC5hpFm', 'trainer'),
('trainer2', '$2a$12$LQV3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/vC5hpFm', 'trainer');

-- 11. Entrenador
INSERT INTO Entrenador (nombres, apellidos, especialidad) VALUES
('Miguel', 'Hernández', 'Desarrollo Backend'),
('Ana', 'García', 'Desarrollo Frontend'),
('Carlos', 'Martínez', 'Base de Datos');

-- 12. RutaEntrenamiento
INSERT INTO RutaEntrenamiento (nombre_ruta, descripcion, id_sgdb_principal, id_sgdb_alternativo) VALUES
('NodeJS', 'Ruta de desarrollo backend con Node.js', 1, 2),
('Java Spring', 'Ruta de desarrollo backend con Java', 1, 3),
('Python Django', 'Ruta de desarrollo backend con Python', 3, 1);

-- Corrección de RutaEntrenamiento
INSERT INTO RutaEntrenamiento (nombre_ruta, descripcion, id_sgdb_principal, id_sgdb_alternativo) VALUES
('NodeJS', 'Desarrollo backend con Node.js y Express', 1, 2),
('NetCore', 'Desarrollo backend con .NET Core', 1, 3),
('Java Spring Boot', 'Desarrollo backend con Spring Boot', 1, 3);

-- Corrección de Entrenador
INSERT INTO Entrenador (nombres, apellidos, especialidad) VALUES
('Johlver', 'Pardo', 'Desarrollo Backend'),
('Miguel', 'Hernández', 'Desarrollo Backend'),
('Ana', 'García', 'Desarrollo Frontend');

-- Entrenador_Area
INSERT INTO Entrenador_Area (id_entrenador, id_area) VALUES
(1, 1), -- Johlver - Backend
(2, 1), -- Miguel - Backend
(3, 2); -- Ana - Frontend

-- Asignacion_Entrenador_Ruta
INSERT INTO Asignacion_Entrenador_Ruta (id_entrenador, id_ruta, id_horario) VALUES
(1, 1, 1), -- Johlver - NodeJS - 6:00-10:00
(1, 2, 2), -- Johlver - NetCore - 10:00-14:00
(2, 3, 3); -- Miguel - Spring Boot - 14:00-18:00

-- Asignacion_Salon_Horario
INSERT INTO Asignacion_Salon_Horario (id_salon, id_horario, id_area) VALUES
(1, 1, 1), -- Apolo - 6:00-10:00 - Backend
(2, 2, 1), -- Sputnik - 10:00-14:00 - Backend
(3, 3, 2); -- Artemis - 14:00-18:00 - Frontend

-- Disponibilidad_Entrenador
INSERT INTO Disponibilidad_Entrenador (id_entrenador, dia_semana, hora_inicio, hora_fin) VALUES
(1, 'Lunes', '06:00:00', '14:00:00'),
(1, 'Martes', '06:00:00', '14:00:00'),
(1, 'Miercoles', '06:00:00', '14:00:00'),
(1, 'Jueves', '06:00:00', '14:00:00'),
(1, 'Viernes', '06:00:00', '14:00:00'),
(2, 'Lunes', '14:00:00', '22:00:00'),
(2, 'Martes', '14:00:00', '22:00:00'),
(2, 'Miercoles', '14:00:00', '22:00:00');

-- Skills por ruta
INSERT INTO Skill (nombre_skill, descripcion) VALUES
('JavaScript Fundamentals', 'Fundamentos de JavaScript y ES6+'),
('Node.js Core', 'Conceptos core de Node.js'),
('Express.js', 'Framework web para Node.js'),
('C# Fundamentals', 'Fundamentos de C# y .NET'),
('ASP.NET Core', 'Framework web para .NET'),
('Java Core', 'Fundamentos de Java'),
('Spring Framework', 'Framework empresarial para Java'),
('Spring Boot', 'Framework simplificado de Spring');

-- Ruta_Skill (asociación de skills a rutas)
INSERT INTO Ruta_Skill (id_ruta, id_skill) VALUES
(1, 1), -- NodeJS - JavaScript Fundamentals
(1, 2), -- NodeJS - Node.js Core
(1, 3), -- NodeJS - Express.js
(2, 4), -- NetCore - C# Fundamentals
(2, 5), -- NetCore - ASP.NET Core
(3, 6), -- Spring Boot - Java Core
(3, 7), -- Spring Boot - Spring Framework
(3, 8); -- Spring Boot - Spring Boot

-- Módulos por Skill
INSERT INTO Modulo (id_skill, nombre_modulo, descripcion, duracion) VALUES
-- JavaScript/Node.js
(1, 'Introducción a JavaScript', 'Fundamentos del lenguaje', 40),
(1, 'ES6+ Features', 'Características modernas de JS', 30),
(2, 'Node.js Basics', 'Fundamentos de Node.js', 40),
(2, 'Async Programming', 'Programación asíncrona', 30),
(3, 'Express Basics', 'Fundamentos de Express', 40),
(3, 'REST APIs', 'Desarrollo de APIs REST', 30),

-- .NET
(4, 'C# Basics', 'Fundamentos de C#', 40),
(4, 'OOP in C#', 'Programación orientada a objetos', 30),
(5, 'ASP.NET Core Basics', 'Fundamentos de ASP.NET Core', 40),
(5, 'Web APIs', 'Desarrollo de APIs web', 30),

-- Java/Spring
(6, 'Java Basics', 'Fundamentos de Java', 40),
(6, 'Java OOP', 'Programación orientada a objetos', 30),
(7, 'Spring Core', 'Fundamentos de Spring', 40),
(8, 'Spring Boot Basics', 'Desarrollo con Spring Boot', 30);

-- Ejemplo de Grupo_Campers
INSERT INTO Grupo_Campers (nombre_grupo, id_ruta, fecha_creacion) VALUES
('Artemis 2024-1', 1, '2024-01-15'),
('Apolo 2024-1', 2, '2024-01-15'),
('Sputnik 2024-1', 3, '2024-01-15');

-- Campers con diferentes estados y niveles de riesgo
INSERT INTO Camper (numero_identificacion, nombres, apellidos, id_campus, id_estado, nivel_riesgo) VALUES
-- Campers Inscritos
('1001234567', 'Juan', 'Pérez', 1, 2, 'Bajo'),
('1001234568', 'María', 'González', 1, 2, 'Medio'),
('1001234569', 'Carlos', 'Rodríguez', 1, 2, 'Alto'),
-- Campers Aprobados
('1001234570', 'Ana', 'Martínez', 1, 3, 'Bajo'),
('1001234571', 'Luis', 'Sánchez', 1, 3, 'Medio'),
-- Campers Cursando
('1001234572', 'Pedro', 'López', 1, 4, 'Bajo'),
('1001234573', 'Laura', 'Torres', 1, 4, 'Alto'),
-- Campers Graduados
('1001234574', 'Diego', 'Ramírez', 1, 5, 'Bajo'),
('1001234575', 'Sofía', 'García', 1, 5, 'Bajo'),
-- Campers Expulsados/Retirados
('1001234576', 'Mario', 'Díaz', 1, 6, 'Alto'),
('1001234577', 'Carmen', 'Vargas', 1, 7, 'Alto'),
-- Campers sin ruta asignada
('1001234578', 'Felipe', 'Castro', 1, 1, 'Medio'),
('1001234579', 'Isabella', 'Morales', 1, 1, 'Bajo'),
-- Más campers cursando con diferentes niveles de riesgo
('1001234580', 'Ricardo', 'Gómez', 1, 4, 'Alto'),
('1001234581', 'Valentina', 'Herrera', 1, 4, 'Medio'),
('1001234582', 'Daniel', 'Parra', 1, 4, 'Bajo'),
-- Más graduados para estadísticas
('1001234583', 'Carolina', 'Rojas', 1, 5, 'Bajo'),
('1001234584', 'Andrés', 'Silva', 1, 5, 'Bajo'),
('1001234585', 'Camila', 'Ortiz', 1, 5, 'Bajo'),
-- Más casos de bajo rendimiento
('1001234586', 'Fernando', 'Ruiz', 1, 4, 'Alto'),
('1001234587', 'Patricia', 'Mendoza', 1, 4, 'Alto'),
('1001234588', 'Gabriel', 'Castro', 1, 4, 'Alto');

-- Acudientes
INSERT INTO Acudiente (id_camper, nombres, apellidos, telefono, email, parentesco) VALUES
(1, 'Jorge', 'Pérez', '3101234567', 'jorge.perez@email.com', 'Padre'),
(2, 'Rosa', 'González', '3101234568', 'rosa.gonzalez@email.com', 'Madre'),
(3, 'Manuel', 'Rodríguez', '3101234569', 'manuel.rodriguez@email.com', 'Tío'),
(4, 'Martha', 'Martínez', '3101234570', 'martha.martinez@email.com', 'Madre');

-- Teléfonos de Campers (algunos con múltiples números)
INSERT INTO Telefono_Camper (id_camper, numero, tipo, es_principal) VALUES
(1, '3201234567', 'movil', TRUE),
(1, '3201234568', 'fijo', FALSE),
(2, '3201234569', 'movil', TRUE),
(2, '3201234570', 'trabajo', FALSE),
(3, '3201234571', 'movil', TRUE);

-- Inscripciones
INSERT INTO Inscripcion (id_camper, id_ruta, fecha_inscripcion, id_estado_inscripcion) VALUES
-- NodeJS
(1, 1, '2024-01-15', 1),
(2, 1, '2024-01-15', 1),
-- NetCore
(3, 2, '2024-01-15', 1),
(4, 2, '2024-01-15', 1),
-- Spring Boot
(5, 3, '2024-01-15', 1),
(6, 3, '2024-01-15', 1);

-- Evaluaciones (con el sistema 30% teoría, 60% práctica, 10% quizzes)
INSERT INTO Evaluacion (id_inscripcion, id_modulo, fecha_evaluacion, nota_teorica, nota_practica, nota_trabajos_quizzes) VALUES
-- Camper 1 - NodeJS
(1, 1, '2024-02-01', 85, 78, 90), -- JavaScript Fundamentals
(1, 2, '2024-02-15', 75, 82, 85), -- ES6+ Features
-- Camper 2 - NodeJS
(2, 1, '2024-02-01', 55, 45, 60), -- JavaScript Fundamentals (bajo rendimiento)
(2, 2, '2024-02-15', 65, 58, 70), -- ES6+ Features
-- Camper 3 - NetCore
(3, 7, '2024-02-01', 90, 88, 95), -- C# Basics
(3, 8, '2024-02-15', 85, 92, 88), -- OOP in C#
-- Camper 4 - NetCore (bajo rendimiento)
(4, 7, '2024-02-01', 50, 55, 45),
(4, 8, '2024-02-15', 45, 52, 48),
-- Evaluaciones NodeJS (más detalladas)
(1, 3, '2024-03-01', 88, 92, 85), -- Express Basics
(1, 4, '2024-03-15', 82, 85, 88), -- Async Programming
(2, 3, '2024-03-01', 45, 52, 48), -- Express Basics (bajo rendimiento)
(2, 4, '2024-03-15', 55, 48, 50), -- Async Programming (bajo rendimiento)

-- Evaluaciones NetCore (rendimiento variado)
(3, 9, '2024-03-01', 95, 92, 98), -- ASP.NET Core Basics
(3, 10, '2024-03-15', 88, 90, 92), -- Web APIs
(4, 9, '2024-03-01', 58, 55, 52), -- ASP.NET Core Basics (bajo rendimiento)
(4, 10, '2024-03-15', 52, 48, 50), -- Web APIs (bajo rendimiento)

-- Evaluaciones Spring Boot
(5, 11, '2024-03-01', 78, 82, 80), -- Java Basics
(5, 12, '2024-03-15', 85, 88, 82), -- Java OOP
(6, 13, '2024-03-01', 92, 95, 90), -- Spring Core
(6, 14, '2024-03-15', 88, 92, 85); -- Spring Boot Basics

-- Grupo_Campers y asignaciones
INSERT INTO Grupo_Camper_Asignacion (id_grupo, id_camper, fecha_asignacion) VALUES
(1, 1, '2024-01-16'), -- Artemis 2024-1
(1, 2, '2024-01-16'),
(2, 3, '2024-01-16'), -- Apolo 2024-1
(2, 4, '2024-01-16'),
(3, 5, '2024-01-16'), -- Sputnik 2024-1
(3, 6, '2024-01-16');

-- Asignación de entrenadores a grupos
INSERT INTO Asignacion_Entrenador_Grupo (id_entrenador, id_grupo, id_area, fecha_inicio, fecha_fin) VALUES
(1, 1, 1, '2024-01-16', '2024-06-16'), -- Johlver - Artemis - Backend
(2, 2, 1, '2024-01-16', '2024-06-16'), -- Miguel - Apolo - Backend
(3, 3, 2, '2024-01-16', '2024-06-16'); -- Ana - Sputnik - Frontend

-- Material Educativo
INSERT INTO Material_Educativo (id_modulo, titulo, descripcion) VALUES
(1, 'Introducción a JavaScript', 'Fundamentos básicos de JS'),
(2, 'ES6+ Features', 'Características modernas de JS'),
(7, 'C# Basics', 'Fundamentos de C#'),
(8, 'OOP in C#', 'Programación orientada a objetos en C#'),
(3, 'Express.js Fundamentals', 'Conceptos básicos de Express'),
(4, 'Async JavaScript', 'Programación asíncrona en JS'),
(9, 'ASP.NET Core MVC', 'Desarrollo web con ASP.NET Core'),
(11, 'Java Fundamentals', 'Fundamentos de Java'),
(13, 'Spring Framework', 'Introducción a Spring');

-- Sesiones de clase
INSERT INTO Sesion_Clase (id_modulo, id_horario, fecha_sesion, tema) VALUES
(1, 1, '2024-02-01', 'Variables y tipos de datos en JS'),
(1, 1, '2024-02-02', 'Estructuras de control'),
(2, 2, '2024-02-15', 'Arrow functions y destructuring'),
(7, 3, '2024-02-01', 'Introducción a C#'),
(8, 3, '2024-02-15', 'Clases y objetos en C#'),
(3, 1, '2024-03-01', 'Routing en Express.js'),
(3, 1, '2024-03-02', 'Middleware en Express.js'),
(4, 2, '2024-03-15', 'Promises y Async/Await'),
(9, 3, '2024-03-01', 'Controllers en ASP.NET Core'),
(11, 1, '2024-03-01', 'POO en Java'),
(13, 2, '2024-03-15', 'Inyección de Dependencias en Spring');

-- Asistencia
INSERT INTO Asistencia (id_camper, id_sesion, fecha_registro, estado_asistencia, hora_llegada) VALUES
(1, 1, '2024-02-01 06:00:00', 'Presente', '06:00:00'),
(2, 1, '2024-02-01 06:15:00', 'Tardanza', '06:15:00'),
(3, 4, '2024-02-01 06:00:00', 'Presente', '06:00:00'),
(4, 4, '2024-02-01 06:00:00', 'Presente', '06:00:00'),
(5, 5, '2024-03-01 06:00:00', 'Presente', '06:00:00'),
(6, 5, '2024-03-01 06:00:00', 'Presente', '06:00:00'),
(7, 6, '2024-03-15 10:00:00', 'Tardanza', '10:15:00', 'Problemas de transporte'),
(8, 6, '2024-03-15 10:00:00', 'Ausente', NULL, 'Enfermedad');

-- Historial de estados para campers
INSERT INTO Historial_Estado_Camper (id_camper, id_estado, fecha_cambio) VALUES
(1, 1, '2024-01-01'), -- En proceso
(1, 2, '2024-01-10'), -- Inscrito
(1, 3, '2024-01-15'), -- Aprobado
(1, 4, '2024-01-20'), -- Cursando
(2, 1, '2024-01-01'),
(2, 2, '2024-01-10'),
(2, 3, '2024-01-15'),
(2, 4, '2024-01-20'),
(3, 1, '2024-01-01'),
(3, 2, '2024-01-10'),
(3, 6, '2024-02-01'); -- Expulsado

-- Más asignaciones de salones y horarios
INSERT INTO Asignacion_Salon_Horario (id_salon, id_horario, id_area) VALUES
(1, 2, 1), -- Apolo - 10:00-14:00 - Backend
(1, 3, 1), -- Apolo - 14:00-18:00 - Backend
(2, 1, 2), -- Sputnik - 06:00-10:00 - Frontend
(2, 3, 2), -- Sputnik - 14:00-18:00 - Frontend
(3, 1, 1), -- Artemis - 06:00-10:00 - Backend
(3, 2, 2); -- Artemis - 10:00-14:00 - Frontend

-- Competencias de entrenadores
INSERT INTO Entrenador_Competencia (id_entrenador, id_competencia) VALUES
(1, 1), -- Johlver - Lógica de Programación
(1, 2), -- Johlver - Diseño Web
(1, 3), -- Johlver - Gestión de Datos
(2, 1), -- Miguel - Lógica de Programación
(2, 4), -- Miguel - Arquitectura Backend
(3, 2); -- Ana - Diseño Web

-- Disponibilidad adicional de entrenadores
INSERT INTO Disponibilidad_Entrenador (id_entrenador, dia_semana, hora_inicio, hora_fin) VALUES
(1, 'Sabado', '08:00:00', '12:00:00'),
(2, 'Jueves', '14:00:00', '22:00:00'),
(2, 'Viernes', '14:00:00', '22:00:00'),
(3, 'Lunes', '06:00:00', '14:00:00'),
(3, 'Miercoles', '06:00:00', '14:00:00'),
(3, 'Viernes', '06:00:00', '14:00:00');

-- Notificaciones
INSERT INTO Notificacion (id_usuario, mensaje, fecha_notificacion, leido) VALUES
(1, 'Nuevo camper registrado en la ruta NodeJS', '2024-01-15 08:00:00', FALSE),
(2, 'Evaluación pendiente de revisión', '2024-02-01 10:00:00', TRUE),
(3, 'Recordatorio de entrega de proyecto', '2024-02-15 09:00:00', FALSE);

-- Notificaciones para trainers
INSERT INTO Notificacion_Trainer (id_entrenador, id_ruta, mensaje, fecha_notificacion, leido) VALUES
(1, 1, 'Bajo rendimiento detectado en módulo de Express', '2024-03-01 15:00:00', FALSE),
(2, 2, 'Actualización de contenido en módulo de C#', '2024-03-02 09:00:00', TRUE),
(3, 3, 'Nueva asignación de grupo', '2024-03-03 10:00:00', FALSE);

-- Corrección de Skills específicos por ruta
INSERT INTO Skill (nombre_skill, descripcion) VALUES
-- NodeJS
('JavaScript Core', 'Fundamentos de JavaScript y programación'),
('Node.js', 'Desarrollo backend con Node.js'),
('Express.js', 'Framework web para Node.js'),
('API Development', 'Desarrollo de APIs RESTful'),
-- NetCore
('C# Programming', 'Programación en C# y .NET'),
('ASP.NET Core', 'Desarrollo web con ASP.NET Core'),
('Entity Framework', 'ORM para .NET'),
-- Spring Boot
('Java Core', 'Fundamentos de Java y POO'),
('Spring Framework', 'Framework empresarial de Java'),
('Spring Boot', 'Framework Spring simplificado'),
('JPA & Hibernate', 'Persistencia de datos en Java');

-- Ruta_Skill (asociación correcta de skills a rutas)
INSERT INTO Ruta_Skill (id_ruta, id_skill) VALUES
-- NodeJS
(1, 1), -- JavaScript Core
(1, 2), -- Node.js
(1, 3), -- Express.js
(1, 4), -- API Development
-- NetCore
(2, 5), -- C# Programming
(2, 6), -- ASP.NET Core
(2, 7), -- Entity Framework
-- Spring Boot
(3, 8), -- Java Core
(3, 9), -- Spring Framework
(3, 10), -- Spring Boot
(3, 11); -- JPA & Hibernate

-- Más campers para cubrir todos los estados y situaciones
INSERT INTO Camper (numero_identificacion, nombres, apellidos, id_campus, id_estado, nivel_riesgo) VALUES
-- Campers en proceso de ingreso
('1001234590', 'Leonardo', 'Vargas', 1, 1, 'Bajo'),
('1001234591', 'Mariana', 'Ocampo', 1, 1, 'Bajo'),
-- Campers inscritos
('1001234592', 'Santiago', 'Pérez', 1, 2, 'Medio'),
('1001234593', 'Valentina', 'López', 1, 2, 'Bajo'),
-- Campers aprobados
('1001234594', 'Sebastián', 'García', 1, 3, 'Bajo'),
('1001234595', 'Isabella', 'Martínez', 1, 3, 'Medio'),
-- Campers cursando con diferentes niveles de riesgo
('1001234596', 'Mateo', 'González', 1, 4, 'Alto'),
('1001234597', 'Luciana', 'Rodríguez', 1, 4, 'Medio'),
('1001234598', 'Samuel', 'Torres', 1, 4, 'Bajo'),
-- Campers graduados
('1001234599', 'Valeria', 'Herrera', 1, 5, 'Bajo'),
('1001234600', 'Daniel', 'Ramírez', 1, 5, 'Bajo');

-- Inscripciones adicionales
INSERT INTO Inscripcion (id_camper, id_ruta, fecha_inscripcion, id_estado_inscripcion) VALUES
-- NodeJS
(7, 1, '2024-01-15', 1),
(8, 1, '2024-01-15', 1),
-- NetCore
(9, 2, '2024-01-15', 1),
(10, 2, '2024-01-15', 1),
-- Spring Boot
(11, 3, '2024-01-15', 1),
(12, 3, '2024-01-15', 1);

-- Evaluaciones adicionales con el sistema 30-60-10
INSERT INTO Evaluacion (id_inscripcion, id_modulo, fecha_evaluacion, nota_teorica, nota_practica, nota_trabajos_quizzes) VALUES
-- Evaluaciones NodeJS (rendimiento variado)
(7, 1, '2024-02-01', 85, 92, 88), -- Buen rendimiento
(7, 2, '2024-02-15', 78, 85, 82),
(8, 1, '2024-02-01', 55, 48, 52), -- Bajo rendimiento
(8, 2, '2024-02-15', 52, 45, 50),
-- Evaluaciones NetCore
(9, 5, '2024-02-01', 92, 95, 90), -- Excelente rendimiento
(9, 6, '2024-02-15', 88, 92, 85),
(10, 5, '2024-02-01', 58, 52, 55), -- Bajo rendimiento
(10, 6, '2024-02-15', 62, 58, 60),
-- Evaluaciones Spring Boot
(11, 8, '2024-02-01', 75, 82, 78), -- Rendimiento medio
(11, 9, '2024-02-15', 72, 78, 75),
(12, 8, '2024-02-01', 95, 98, 92), -- Rendimiento sobresaliente
(12, 9, '2024-02-15', 92, 95, 90);

-- Asignaciones adicionales a grupos
INSERT INTO Grupo_Camper_Asignacion (id_grupo, id_camper, fecha_asignacion) VALUES
(1, 7, '2024-01-16'),
(1, 8, '2024-01-16'),
(2, 9, '2024-01-16'),
(2, 10, '2024-01-16'),
(3, 11, '2024-01-16'),
(3, 12, '2024-01-16');

-- Más sesiones de clase para seguimiento
INSERT INTO Sesion_Clase (id_modulo, id_horario, fecha_sesion, tema) VALUES
(5, 1, '2024-03-01', 'Introducción a C# y .NET Core'),
(5, 1, '2024-03-02', 'Tipos de datos y estructuras'),
(6, 2, '2024-03-15', 'Controllers y Routing en ASP.NET'),
(8, 1, '2024-03-01', 'Fundamentos de Java'),
(9, 2, '2024-03-15', 'Spring Core Container');

-- Asistencia adicional
INSERT INTO Asistencia (id_camper, id_sesion, fecha_registro, estado_asistencia, hora_llegada, justificacion) VALUES
(9, 7, '2024-03-01 06:00:00', 'Presente', '06:00:00', NULL),
(10, 7, '2024-03-01 06:10:00', 'Tardanza', '06:10:00', 'Tráfico'),
(11, 8, '2024-03-15 10:00:00', 'Presente', '10:00:00', NULL),
(12, 8, '2024-03-15 10:00:00', 'Presente', '10:00:00', NULL);

-- Más material educativo
INSERT INTO Material_Educativo (id_modulo, titulo, descripcion, url_material) VALUES
(5, 'Fundamentos .NET Core', 'Introducción a .NET Core'),
(6, 'Web APIs en .NET', 'Desarrollo de APIs'),
(8, 'Java Básico', 'Fundamentos de Java'),
(9, 'Spring Core', 'Conceptos de Spring');

-- Notificaciones adicionales
INSERT INTO Notificacion (id_usuario, mensaje, fecha_notificacion, leido) VALUES
(1, 'Reporte mensual de rendimiento disponible', '2024-03-01 09:00:00', FALSE),
(2, 'Nuevos materiales agregados al módulo', '2024-03-02 11:00:00', FALSE),
(3, 'Recordatorio de evaluación pendiente', '2024-03-03 10:00:00', FALSE);

-- Notificaciones específicas para trainers
INSERT INTO Notificacion_Trainer (id_entrenador, id_ruta, mensaje, fecha_notificacion, leido) VALUES
(1, 1, 'Actualización de contenido Node.js', '2024-03-04 14:00:00', FALSE),
(2, 2, 'Reunión de seguimiento programada', '2024-03-05 09:00:00', FALSE),
(3, 3, 'Revisión de proyectos pendiente', '2024-03-06 11:00:00', FALSE);

