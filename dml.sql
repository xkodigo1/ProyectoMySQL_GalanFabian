-- USE campusmanagement;

-- 1. Campus
INSERT INTO Campus (nombre, ciudad, region, direccion) 
VALUES 
('Campus Bucaramanga', 'Bucaramanga', 'Santander', 'Zona Franca de Santander'),
('Campus Tibú', 'Tibú', 'Norte de Santander', 'Calle Principal #45'),
('Campus Bogotá', 'Bogotá', 'Cundinamarca', 'Avenida El Dorado #85-20');

-- 2. Estados de Camper
INSERT INTO Estado_camper (descripcion, estado_camper) 
VALUES 
('Estudiante activo en formación', 'Cursando'),
('En proceso inicial de selección', 'En proceso de ingreso'),
('Aceptado y pendiente de iniciar', 'Inscrito'),
('Aprobado para comenzar formación', 'Aprobado'),
('Completó programa exitosamente', 'Graduado'),
('Retirado voluntariamente', 'Retirado'),
('Expulsado por bajo rendimiento', 'Expulsado');

-- 3. SGBDs
INSERT INTO SistemaGestorBaseDatos (nombre_sgdb, descripcion) 
VALUES 
('SQL Server', 'SGBD principal para ruta C#'),
('MySQL', 'SGBD principal para ruta Java'),
('MongoDB', 'SGBD principal para ruta Node.js'),
('PostgreSQL', 'SGBD alternativo para todas las rutas');

-- 4. Rutas de Entrenamiento
INSERT INTO RutaEntrenamiento (nombre_ruta, descripcion, id_sgdb_principal, id_sgdb_alternativo) 
VALUES 
('C#', 'Desarrollo de aplicaciones con C# y .NET Framework', 1, 4),
('Java', 'Desarrollo de aplicaciones con Java y Spring Boot', 2, 4),
('Node.js', 'Desarrollo web con JavaScript y Node.js', 3, 4);

-- 5. Módulos para todas las rutas (compartidos y específicos)
-- Módulos compartidos primero
INSERT INTO Modulo (id_ruta, nombre_modulo, descripcion, duracion, secuencia) 
VALUES
-- Módulos compartidos para ruta C# (id_ruta = 1)
(1, 'Introducción a la programación', 'Conceptos básicos de algoritmos y lógica', 2, 1),
(1, 'Python', 'Fundamentos de programación con Python', 4, 2),
(1, 'HTML + CSS', 'Fundamentos de desarrollo web front-end', 4, 3),
(1, 'Scrum y metodologías ágiles', 'Gestión de proyectos con metodologías ágiles', 1, 4),
(1, 'GitHub y control de versiones', 'Gestión de código fuente y colaboración', 1, 5),
(1, 'JavaScript básico', 'Programación web del lado del cliente', 4, 6),
(1, 'Introducción al backend', 'Conceptos fundamentales de backend', 2, 7),
(1, 'MySQL I', 'Fundamentos de bases de datos relacionales', 4, 8),
(1, 'MySQL II', 'Consultas avanzadas y optimización', 4, 9),
(1, 'C#', 'Programación orientada a objetos con C#', 4, 10),
(1, 'PostgreSQL', 'Base de datos alternativa para .NET', 4, 11),
(1, '.NET', 'Desarrollo de aplicaciones con .NET Framework', 4, 12),

-- Módulos compartidos para ruta Java (id_ruta = 2)
(2, 'Introducción a la programación', 'Conceptos básicos de algoritmos y lógica', 2, 1),
(2, 'Python', 'Fundamentos de programación con Python', 4, 2),
(2, 'HTML + CSS', 'Fundamentos de desarrollo web front-end', 4, 3),
(2, 'Scrum y metodologías ágiles', 'Gestión de proyectos con metodologías ágiles', 1, 4),
(2, 'GitHub y control de versiones', 'Gestión de código fuente y colaboración', 1, 5),
(2, 'JavaScript básico', 'Programación web del lado del cliente', 4, 6),
(2, 'Introducción al backend', 'Conceptos fundamentales de backend', 2, 7),
(2, 'MySQL I', 'Fundamentos de bases de datos relacionales', 4, 8),
(2, 'MySQL II', 'Consultas avanzadas y optimización', 4, 9),
(2, 'Java', 'Programación orientada a objetos con Java', 4, 10),
(2, 'PostgreSQL', 'Base de datos alternativa para Java', 4, 11),
(2, 'Spring Boot', 'Desarrollo de aplicaciones con Spring Boot', 4, 12),

-- Módulos compartidos para ruta Node.js (id_ruta = 3)
(3, 'Introducción a la programación', 'Conceptos básicos de algoritmos y lógica', 2, 1),
(3, 'Python', 'Fundamentos de programación con Python', 4, 2),
(3, 'HTML + CSS', 'Fundamentos de desarrollo web front-end', 4, 3),
(3, 'Scrum y metodologías ágiles', 'Gestión de proyectos con metodologías ágiles', 1, 4),
(3, 'GitHub y control de versiones', 'Gestión de código fuente y colaboración', 1, 5),
(3, 'JavaScript básico', 'Programación web del lado del cliente', 4, 6),
(3, 'Introducción al backend', 'Conceptos fundamentales de backend', 2, 7),
(3, 'MySQL I', 'Fundamentos de bases de datos relacionales', 4, 8),
(3, 'MySQL II', 'Consultas avanzadas y optimización', 4, 9),
(3, 'JavaScript avanzado', 'Programación avanzada con JavaScript', 4, 10),
(3, 'MongoDB', 'Base de datos NoSQL para aplicaciones web', 4, 11),
(3, 'Node.js y Express', 'Desarrollo backend con Node.js', 4, 12);

-- 6. Salones
INSERT INTO Salon (nombre_salon, ubicacion) 
VALUES 
('Sputnik', 'Edificio principal, primer piso'),
('Apolo', 'Edificio principal, segundo piso'),
('Artemis', 'Edificio anexo, primer piso'),
('Orion', 'Edificio anexo, segundo piso'),
('Voyager', 'Edificio principal, tercer piso');

-- 7. Horarios de Clase
INSERT INTO Horario_Clase (descripcion, hora_inicio, hora_fin, dia_semana) 
VALUES 
('Mañana temprano', '06:00:00', '09:00:00', 'Lunes'),
('Mañana temprano', '06:00:00', '09:00:00', 'Martes'),
('Mañana temprano', '06:00:00', '09:00:00', 'Miercoles'),
('Mañana temprano', '06:00:00', '09:00:00', 'Jueves'),
('Mañana temprano', '06:00:00', '09:00:00', 'Viernes'),
('Medio día', '11:00:00', '14:00:00', 'Lunes'),
('Medio día', '11:00:00', '14:00:00', 'Martes'),
('Medio día', '11:00:00', '14:00:00', 'Miercoles'),
('Medio día', '11:00:00', '14:00:00', 'Jueves'),
('Medio día', '11:00:00', '14:00:00', 'Viernes');

-- 8. Áreas de Entrenamiento
INSERT INTO AreaEntrenamiento (nombre_area, descripcion, capacidad_maxima, estado, ocupacion_actual) 
VALUES 
('Área desarrollo .NET', 'Especialización en C# y .NET', 33, 'Activo', 25),
('Área desarrollo Java', 'Especialización en Java y Spring', 33, 'Activo', 30),
('Área desarrollo NodeJS', 'Especialización en JavaScript y Node', 33, 'Activo', 28),
('Área Data Science', 'Especialización en análisis de datos', 33, 'Activo', 20),
('Área DevOps', 'Especialización en CI/CD y Cloud', 33, 'Inactivo', 0);

-- 9. Competencias
INSERT INTO Competencia (nombre_competencia, descripcion) 
VALUES 
('C#', 'Dominio de lenguaje C# y POO'),
('.NET', 'Experiencia en desarrollo con .NET Framework'),
('Java', 'Dominio del lenguaje Java y POO'),
('Spring Boot', 'Desarrollo de aplicaciones con Spring'),
('JavaScript', 'Programación frontend y backend con JavaScript'),
('Node.js', 'Desarrollo de APIs con Express y Node'),
('SQL Server', 'Administración y desarrollo con SQL Server'),
('MySQL', 'Diseño y optimización de bases de datos MySQL'),
('MongoDB', 'Desarrollo con bases de datos NoSQL'),
('PostgreSQL', 'Conocimientos avanzados en PostgreSQL'),
('Metodologías Ágiles', 'Implementación de Scrum y Kanban'),
('AWS', 'Despliegue de aplicaciones en la nube'),
('Azure', 'Servicios cloud de Microsoft'),
('DevOps', 'Integración y despliegue continuo');

-- 10. Entrenadores
INSERT INTO Entrenador (nombres, apellidos, email, id_campus) 
VALUES 
('Johlver Jose', 'Pardo', 'johlver.pardo@campuslands.com', 1),
('Miguel', 'Martinez Lopez', 'miguel.martinez@campuslands.com', 1),
('Carolina', 'Sanchez Ruiz', 'carolina.sanchez@campuslands.com', 1),
('Fernando', 'Gomez Diaz', 'fernando.gomez@campuslands.com', 1),
('Veronica', 'Rodriguez Perez', 'veronica.rodriguez@campuslands.com', 2),
('Juan Carlos', 'Torres Silva', 'juan.torres@campuslands.com', 3);

-- 11. Teléfonos de Entrenadores
INSERT INTO Telefono_Entrenador (id_entrenador, numero, tipo, es_principal) 
VALUES 
(1, '3151234567', 'movil', TRUE),
(1, '6076123456', 'fijo', FALSE),
(2, '3162345678', 'movil', TRUE),
(3, '3173456789', 'movil', TRUE),
(4, '3184567890', 'movil', TRUE),
(5, '3195678901', 'movil', TRUE),
(6, '3206789012', 'movil', TRUE);

-- 12. Competencias de Entrenadores
INSERT INTO Entrenador_Competencia (id_entrenador, id_competencia) 
VALUES 
-- Johlver - especialista en .NET
(1, 1), (1, 2), (1, 7), (1, 10), (1, 11),
-- Miguel - especialista en Java
(2, 3), (2, 4), (2, 8), (2, 10), (2, 11),
-- Carolina - especialista en Node.js
(3, 5), (3, 6), (3, 9), (3, 11), (3, 12),
-- Fernando - especialista en .NET y Azure
(4, 1), (4, 2), (4, 7), (4, 11), (4, 13),
-- Veronica - especialista en Java y AWS
(5, 3), (5, 4), (5, 8), (5, 11), (5, 12),
-- Juan Carlos - especialista en Node.js y DevOps
(6, 5), (6, 6), (6, 9), (6, 11), (6, 14);

-- 13. Estado de Inscripción
INSERT INTO Estado_Inscripcion (descripcion, estado_inscripcion) 
VALUES 
('Inscripción activa, camper cursando', 'Activa'),
('Inscripción completada exitosamente', 'Completada'),
('Inscripción cancelada', 'Cancelada');

-- 14. Grupos de Campers
INSERT INTO Grupo_Campers (nombre_grupo, id_ruta, fecha_creacion) 
VALUES 
('J1', 1, '2023-10-01'), -- Grupo de C#
('J2', 1, '2023-10-01'), -- Grupo de C#
('J3', 2, '2023-10-01'), -- Grupo de Java
('J4', 2, '2023-10-01'), -- Grupo de Java
('N1', 3, '2023-10-01'), -- Grupo de Node.js
('N2', 3, '2023-10-01'); -- Grupo de Node.js

-- 15. Asignación de Entrenadores a Áreas
INSERT INTO Entrenador_Area (id_entrenador, id_area) 
VALUES 
(1, 1), -- Johlver - Área .NET
(2, 2), -- Miguel - Área Java
(3, 3), -- Carolina - Área Node.js
(4, 1), -- Fernando - Área .NET
(5, 2), -- Veronica - Área Java
(6, 3); -- Juan Carlos - Área Node.js

-- 16. Asignación de Entrenadores a Rutas
INSERT INTO Asignacion_Entrenador_Ruta (id_entrenador, id_ruta, id_horario) 
VALUES 
(1, 1, 1), -- Johlver - Ruta C# - Mañana lunes
(1, 1, 2), -- Johlver - Ruta C# - Mañana martes
(1, 1, 3), -- Johlver - Ruta C# - Mañana miércoles
(1, 1, 4), -- Johlver - Ruta C# - Mañana jueves
(1, 1, 5), -- Johlver - Ruta C# - Mañana viernes
(2, 2, 1), -- Miguel - Ruta Java - Mañana lunes
(3, 3, 6); -- Carolina - Ruta Node.js - Medio día lunes

-- 17. Asignación de salones
INSERT INTO Asignacion_Salon_Horario (id_salon, id_horario, id_area) 
VALUES 
(2, 1, 1), -- Apolo - Mañana lunes - Área .NET
(2, 2, 1), -- Apolo - Mañana martes - Área .NET
(2, 3, 1), -- Apolo - Mañana miércoles - Área .NET
(2, 4, 1), -- Apolo - Mañana jueves - Área .NET
(2, 5, 1), -- Apolo - Mañana viernes - Área .NET
(1, 1, 2), -- Sputnik - Mañana lunes - Área Java
(3, 6, 3); -- Artemis - Medio día lunes - Área Node.js

-- 18. Disponibilidad de Entrenadores
INSERT INTO Disponibilidad_Entrenador (id_entrenador, dia_semana, hora_inicio, hora_fin) 
VALUES 
(1, 'Lunes', '06:00:00', '15:00:00'),
(1, 'Martes', '06:00:00', '15:00:00'),
(1, 'Miercoles', '06:00:00', '15:00:00'),
(1, 'Jueves', '06:00:00', '15:00:00'),
(1, 'Viernes', '06:00:00', '15:00:00'),
(2, 'Lunes', '06:00:00', '15:00:00'),
(3, 'Lunes', '10:00:00', '18:00:00');

-- 19. Asignaciones Entrenador-Grupo
INSERT INTO Asignacion_Entrenador_Grupo (id_entrenador, id_grupo, id_area, fecha_inicio) 
VALUES 
(1, 1, 1, '2023-10-01'), -- Johlver - J1 (C#) - Área .NET
(4, 2, 1, '2023-10-01'), -- Fernando - J2 (C#) - Área .NET
(2, 3, 2, '2023-10-01'), -- Miguel - J3 (Java) - Área Java
(5, 4, 2, '2023-10-01'), -- Veronica - J4 (Java) - Área Java
(3, 5, 3, '2023-10-01'), -- Carolina - N1 (Node.js) - Área Node.js
(6, 6, 3, '2023-10-01'); -- Juan Carlos - N2 (Node.js) - Área Node.js

-- 20. Campers (incluyendo a Fabian)
INSERT INTO Camper (numero_identificacion, nombres, apellidos, id_campus, id_estado, nivel_riesgo) 
VALUES 
-- Grupo J1 (C#)
('1099739979', 'Fabian Alexander', 'Galan Calderon', 1, 1, 'Bajo'),
('1095123456', 'Laura Patricia', 'Mendez Suarez', 1, 1, 'Bajo'),
('1097234567', 'Carlos Andres', 'Perez Rodriguez', 1, 1, 'Medio'),
('1098345678', 'Maria Alejandra', 'Garcia Torres', 1, 1, 'Bajo'),
('1099456789', 'Daniel Eduardo', 'Martinez Lopez', 1, 1, 'Bajo'),
-- Grupo J2 (C#)
('1095567890', 'Valentina', 'Hernandez Diaz', 1, 1, 'Bajo'),
('1096678901', 'Juan Sebastian', 'Gomez Vargas', 1, 1, 'Alto'),
('1097789012', 'Sofia', 'Torres Ruiz', 1, 1, 'Bajo'),
('1098890123', 'Diego Alejandro', 'Ramirez Ochoa', 1, 1, 'Medio'),
('1099901234', 'Isabella', 'Sanchez Moreno', 1, 1, 'Bajo'),
-- Grupo J3 (Java)
('1095012345', 'Santiago', 'Rodriguez Parra', 1, 1, 'Bajo'),
('1096123456', 'Gabriela', 'Jimenez Carvajal', 1, 1, 'Medio'),
('1097234567', 'Nicolas', 'Ortiz Quintero', 1, 1, 'Bajo'),
('1098345678', 'Valeria', 'Castro Bernal', 1, 1, 'Bajo'),
('1099456789', 'Mateo', 'Rios Camacho', 1, 1, 'Bajo');

-- 21. Acudientes
INSERT INTO Acudiente (id_camper, nombres, apellidos, telefono, email, parentesco) 
VALUES 
(1, 'Otilia', 'Calderon Celis', '3027215931', 'printart2008@gmail.com', 'madre'),
(2, 'Jorge', 'Mendez Roa', '3151234567', 'jorge.mendez@gmail.com', 'padre'),
(3, 'Clara', 'Rodriguez Gomez', '3162345678', 'clara.rodriguez@gmail.com', 'madre'),
(4, 'Mario', 'Garcia Polo', '3173456789', 'mario.garcia@gmail.com', 'padre'),
(5, 'Lucia', 'Lopez Mora', '3184567890', 'lucia.lopez@gmail.com', 'madre');

-- 22. Direcciones
INSERT INTO Direccion (id_camper, calle, ciudad, departamento, codigo_postal, pais) 
VALUES 
(1, 'Calle 56 #23-45', 'Bucaramanga', 'Santander', '680001', 'Colombia'),
(2, 'Carrera 27 #15-30', 'Bucaramanga', 'Santander', '680002', 'Colombia'),
(3, 'Avenida 33 #45-67', 'Bucaramanga', 'Santander', '680003', 'Colombia'),
(4, 'Calle 45 #12-34', 'Bucaramanga', 'Santander', '680004', 'Colombia'),
(5, 'Carrera 15 #56-78', 'Bucaramanga', 'Santander', '680005', 'Colombia');

-- 23. Teléfonos de Campers
INSERT INTO Telefono_Camper (id_camper, numero, tipo, es_principal) 
VALUES 
(1, '3157891234', 'movil', TRUE),
(1, '6076123456', 'fijo', FALSE),
(2, '3168902345', 'movil', TRUE),
(3, '3179013456', 'movil', TRUE),
(4, '3180124567', 'movil', TRUE),
(5, '3191235678', 'movil', TRUE);

-- 24. Asignación de Campers a Grupos
INSERT INTO Grupo_Camper_Asignacion (id_grupo, id_camper) 
VALUES 
(1, 1), -- Fabian en grupo J1
(1, 2), -- Laura en grupo J1
(1, 3), -- Carlos en grupo J1
(1, 4), -- Maria en grupo J1
(1, 5), -- Daniel en grupo J1
(2, 6), -- Valentina en grupo J2
(2, 7), -- Juan en grupo J2
(2, 8), -- Sofia en grupo J2
(2, 9), -- Diego en grupo J2
(2, 10), -- Isabella en grupo J2
(3, 11), -- Santiago en grupo J3
(3, 12), -- Gabriela en grupo J3
(3, 13), -- Nicolas en grupo J3
(3, 14), -- Valeria en grupo J3
(3, 15); -- Mateo en grupo J3

-- 25. Inscripciones
INSERT INTO Inscripcion (id_camper, id_ruta, fecha_inscripcion, id_estado_inscripcion) 
VALUES 
(1, 1, '2023-09-15', 1), -- Fabian - C#
(2, 1, '2023-09-15', 1), -- Laura - C#
(3, 1, '2023-09-16', 1), -- Carlos - C#
(4, 1, '2023-09-16', 1), -- Maria - C#
(5, 1, '2023-09-17', 1), -- Daniel - C#
(6, 1, '2023-09-17', 1), -- Valentina - C#
(7, 1, '2023-09-18', 1), -- Juan - C#
(8, 1, '2023-09-18', 1), -- Sofia - C#
(9, 1, '2023-09-19', 1), -- Diego - C#
(10, 1, '2023-09-19', 1), -- Isabella - C#
(11, 2, '2023-09-15', 1), -- Santiago - Java
(12, 2, '2023-09-15', 1), -- Gabriela - Java
(13, 2, '2023-09-16', 1), -- Nicolas - Java
(14, 2, '2023-09-16', 1), -- Valeria - Java
(15, 2, '2023-09-17', 1); -- Mateo - Java

-- 26. Historial de Estado Camper
INSERT INTO Historial_Estado_Camper (id_camper, id_estado, fecha_cambio, observaciones) 
VALUES 
(1, 2, '2023-09-01', 'Inicio proceso de selección'),
(1, 3, '2023-09-10', 'Inscrito tras prueba de admisión'),
(1, 1, '2023-10-01', 'Inicio de clases'),
(2, 2, '2023-09-01', 'Inicio proceso de selección'),
(2, 3, '2023-09-10', 'Inscrito tras prueba de admisión'),
(2, 1, '2023-10-01', 'Inicio de clases');

-- 27. Sesiones de Clase (para primeros módulos)
INSERT INTO Sesion_Clase (id_modulo, id_horario, fecha_sesion, tema) 
VALUES 
-- Introducción a la programación (C#)
(1, 1, '2023-10-02', 'Introducción al pensamiento algorítmico'),
(1, 2, '2023-10-03', 'Estructuras de control'),
(1, 3, '2023-10-04', 'Estructuras de datos básicas'),
(1, 4, '2023-10-05', 'Funciones y procedimientos'),
(1, 5, '2023-10-06', 'Evaluación final módulo'),
-- Python (C#)
(2, 1, '2023-10-09', 'Introducción a Python'),
(2, 2, '2023-10-10', 'Variables y tipos de datos'),
(2, 3, '2023-10-11', 'Estructuras de control en Python'),
(2, 4, '2023-10-12', 'Colecciones: listas y diccionarios'),
(2, 5, '2023-10-13', 'Funciones en Python');

-- 28. Material Educativo
INSERT INTO Material_Educativo (id_modulo, titulo, descripcion, url_material) 
VALUES 
(1, 'Fundamentos de algoritmos', 'Introducción a algoritmos y pensamiento lógico', 'https://campuslands.com/materiales/intro/algoritmos.pdf'),
(1, 'Diagramas de flujo', 'Representación gráfica de algoritmos', 'https://campuslands.com/materiales/intro/diagramas_flujo.pdf'),
(2, 'Introducción a Python', 'Conceptos básicos del lenguaje Python', 'https://campuslands.com/materiales/python/introduccion.pdf'),
(2, 'Estructuras de datos en Python', 'Listas, tuplas y diccionarios', 'https://campuslands.com/materiales/python/estructuras_datos.pdf'),
(10, 'Fundamentos de C#', 'Introducción a C# y .NET', 'https://campuslands.com/materiales/csharp/fundamentos.pdf');

-- 29. Evaluaciones (módulos iniciales)
INSERT INTO Evaluacion (id_inscripcion, id_modulo, fecha_evaluacion, nota_teorica, nota_practica, nota_trabajos_quizzes, calificacion_final) 
VALUES 
-- Fabian
(1, 1, '2023-10-06', 85.00, 80.00, 90.00, 82.50), -- Intro programación
(1, 2, '2023-11-03', 90.00, 85.00, 95.00, 87.50), -- Python
-- Laura
(2, 1, '2023-10-06', 95.00, 90.00, 95.00, 92.00), -- Intro programación
(2, 2, '2023-11-03', 90.00, 88.00, 92.00, 89.20); -- Python

-- 30. Usuarios
INSERT INTO Usuario (nombre_usuario, contrasena, rol, email) 
VALUES 
('fabian.galan', '$2a$12$AbCdEfGhIjKlMnOpQrStUvWxYz012345678901234', 'camper', 'fabian.galan@campuslands.edu.co'),
('laura.mendez', '$2a$12$AbCdEfGhIjKlMnOpQrStUvWxYz023456789012345', 'camper', 'laura.mendez@campuslands.edu.co'),
('johlver.pardo', '$2a$12$AbCdEfGhIjKlMnOpQrStUvWxYz098765432109876', 'entrenador', 'johlver.pardo@campuslands.com'),
('miguel.martinez', '$2a$12$AbCdEfGhIjKlMnOpQrStUvWxYz087654321098765', 'entrenador', 'miguel.martinez@campuslands.com'),
('admin', '$2a$12$AbCdEfGhIjKlMnOpQrStUvWxYz076543210987654', 'admin', 'admin@campuslands.com');

-- 31. Notificaciones
INSERT INTO Notificacion (id_usuario, mensaje, fecha_notificacion, leido) 
VALUES 
(1, 'Bienvenido a CampusLands. Tu camino hacia el desarrollo de software comienza ahora.', '2023-10-01 08:00:00', TRUE),
(1, 'Recuerda completar el cuestionario inicial antes del viernes.', '2023-10-02 09:30:00', TRUE),
(1, 'El material del módulo de Python ya está disponible en la plataforma.', '2023-10-09 08:15:00', TRUE),
(1, 'Evaluación de Python programada para el 3 de noviembre.', '2023-10-27 10:00:00', FALSE),
(2, 'Bienvenida a CampusLands. Tu camino hacia el desarrollo de software comienza ahora.', '2023-10-01 08:00:00', TRUE);

-- 32. Notificaciones para Trainers
INSERT INTO Notificacion_Trainer (id_entrenador, id_ruta, mensaje, fecha_notificacion, leido) 
VALUES 
(1, 1, 'Asignación confirmada para grupo J1 en ruta C#.', '2023-09-25 10:00:00', TRUE),
(1, 1, 'Por favor suba el material para el módulo de Python antes del viernes.', '2023-10-04 08:30:00', TRUE),
(1, 1, 'Reunión de seguimiento el lunes 16 de octubre a las 3:00 PM.', '2023-10-13 14:00:00', FALSE),
(2, 2, 'Asignación confirmada para grupo J3 en ruta Java.', '2023-09-25 10:15:00', TRUE);

-- 33. Asistencia (para sesiones recientes)
INSERT INTO Asistencia (id_camper, id_sesion, fecha_registro, estado_asistencia, hora_llegada) 
VALUES 
-- Fabian
(1, 1, '2023-10-02 05:58:00', 'Presente', '05:58:00'),
(1, 2, '2023-10-03 06:05:00', 'Presente', '06:05:00'),
(1, 3, '2023-10-04 06:20:00', 'Tardanza', '06:20:00'),
(1, 4, '2023-10-05 05:55:00', 'Presente', '05:55:00'),
(1, 5, '2023-10-06 05:50:00', 'Presente', '05:50:00'),
(1, 6, '2023-10-09 05:57:00', 'Presente', '05:57:00'),
-- Laura
(2, 1, '2023-10-02 05:45:00', 'Presente', '05:45:00'),
(2, 2, '2023-10-03 05:50:00', 'Presente', '05:50:00'),
(2, 3, '2023-10-04 05:55:00', 'Presente', '05:55:00'),
(2, 4, '2023-10-05 05:45:00', 'Presente', '05:45:00'),
(2, 5, '2023-10-06 05:40:00', 'Presente', '05:40:00'),
(2, 6, '2023-10-09 05:47:00', 'Presente', '05:47:00');

-- 34. Egresados (para campers que ya completaron el programa)
INSERT INTO Egresado (id_camper, fecha_graduacion, comentarios) 
VALUES 
(5, '2024-05-15', 'Excelente desempeño, contratado por empresa asociada.');