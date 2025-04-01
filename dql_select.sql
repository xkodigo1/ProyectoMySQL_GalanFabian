-- 👥 CONSULTAS DE CAMPERS

-- 1. Obtener todos los campers inscritos actualmente
SELECT c.numero_identificacion, c.nombres, c.apellidos
FROM Camper c
JOIN Estado_camper e ON c.id_estado = e.id_estado
WHERE e.estado_camper = 'Inscrito';

-- 2. Listar los campers con estado "Aprobado"
SELECT c.numero_identificacion, c.nombres, c.apellidos
FROM Camper c
JOIN Estado_camper e ON c.id_estado = e.id_estado
WHERE e.estado_camper = 'Aprobado';

-- 3. Mostrar los campers que ya están cursando alguna ruta
SELECT DISTINCT c.numero_identificacion, c.nombres, c.apellidos, r.nombre_ruta
FROM Camper c
JOIN Inscripcion i ON c.id_camper = i.id_camper
JOIN RutaEntrenamiento r ON i.id_ruta = r.id_ruta
JOIN Estado_camper e ON c.id_estado = e.id_estado
WHERE e.estado_camper = 'Cursando';

-- 4. Consultar los campers graduados por cada ruta
SELECT r.nombre_ruta, COUNT(c.id_camper) as total_graduados
FROM RutaEntrenamiento r
JOIN Inscripcion i ON r.id_ruta = i.id_ruta
JOIN Camper c ON i.id_camper = c.id_camper
JOIN Estado_camper e ON c.id_estado = e.id_estado
WHERE e.estado_camper = 'Graduado'
GROUP BY r.nombre_ruta;

-- 5. Obtener los campers en estado "Expulsado" o "Retirado"
SELECT c.numero_identificacion, c.nombres, c.apellidos, e.estado_camper
FROM Camper c
JOIN Estado_camper e ON c.id_estado = e.id_estado
WHERE e.estado_camper IN ('Expulsado', 'Retirado');

-- 6. Listar campers con nivel de riesgo "Alto"
SELECT numero_identificacion, nombres, apellidos
FROM Camper
WHERE nivel_riesgo = 'Alto';

-- 7. Mostrar el total de campers por cada nivel de riesgo
SELECT nivel_riesgo, COUNT(*) as total_campers
FROM Camper
GROUP BY nivel_riesgo;

-- 8. Obtener campers con más de un número telefónico
SELECT c.numero_identificacion, c.nombres, COUNT(t.id_telefono) as total_telefonos
FROM Camper c
JOIN Telefono_Camper t ON c.id_camper = t.id_camper
GROUP BY c.id_camper
HAVING COUNT(t.id_telefono) > 1;

-- 9. Listar campers con acudientes y teléfonos
SELECT c.nombres, c.apellidos, a.nombres as nombre_acudiente, tc.numero
FROM Camper c
LEFT JOIN Acudiente a ON c.id_camper = a.id_camper
LEFT JOIN Telefono_Camper tc ON c.id_camper = tc.id_camper;

-- 10. Campers sin ruta asignada
SELECT c.numero_identificacion, c.nombres, c.apellidos
FROM Camper c
LEFT JOIN Inscripcion i ON c.id_camper = i.id_camper
WHERE i.id_inscripcion IS NULL;

-- 📊 CONSULTAS DE EVALUACIONES

-- 1. Notas por componente
SELECT c.nombres, c.apellidos, m.nombre_modulo, e.nota_teorica, e.nota_practica, e.nota_trabajos_quizzes
FROM Camper c
JOIN Inscripcion i ON c.id_camper = i.id_camper
JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
JOIN Modulo m ON e.id_modulo = m.id_modulo;

-- 2. Nota final por módulo
SELECT c.nombres, c.apellidos, m.nombre_modulo, e.nota_final
FROM Camper c
JOIN Inscripcion i ON c.id_camper = i.id_camper
JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
JOIN Modulo m ON e.id_modulo = m.id_modulo;

-- 3. Campers que reprobaron módulos
SELECT c.nombres, c.apellidos, m.nombre_modulo, e.nota_final
FROM Camper c
JOIN Inscripcion i ON c.id_camper = i.id_camper
JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
JOIN Modulo m ON e.id_modulo = m.id_modulo
WHERE e.nota_final < 60;

-- 4. Módulos con bajo rendimiento
SELECT m.nombre_modulo, COUNT(*) as reprobados
FROM Modulo m
JOIN Evaluacion e ON m.id_modulo = e.id_modulo
WHERE e.nota_final < 60
GROUP BY m.nombre_modulo;

-- 5. Promedio por módulo
SELECT m.nombre_modulo, AVG(e.nota_final) as promedio
FROM Modulo m
JOIN Evaluacion e ON m.id_modulo = e.id_modulo
GROUP BY m.nombre_modulo;

-- 👨‍🏫 CONSULTAS DE TRAINERS

-- 1. Listar todos los entrenadores
SELECT nombres, apellidos, especialidad
FROM Entrenador;

-- 2. Trainers con horarios asignados
SELECT e.nombres, e.apellidos, h.hora_inicio, h.hora_fin
FROM Entrenador e
JOIN Asignacion_Entrenador_Ruta aer ON e.id_entrenador = aer.id_entrenador
JOIN Horario_Clase h ON aer.id_horario = h.id_horario;

-- 3. Trainers con múltiples rutas
SELECT e.nombres, e.apellidos, COUNT(aer.id_ruta) as total_rutas
FROM Entrenador e
JOIN Asignacion_Entrenador_Ruta aer ON e.id_entrenador = aer.id_entrenador
GROUP BY e.id_entrenador
HAVING COUNT(aer.id_ruta) > 1;

-- 4. Campers por trainer
SELECT e.nombres, e.apellidos, COUNT(DISTINCT gca.id_camper) as total_campers
FROM Entrenador e
JOIN Asignacion_Entrenador_Grupo aeg ON e.id_entrenador = aeg.id_entrenador
JOIN Grupo_Camper_Asignacion gca ON aeg.id_grupo = gca.id_grupo
GROUP BY e.id_entrenador;

-- 5. Áreas por trainer
SELECT e.nombres, e.apellidos, a.nombre_area
FROM Entrenador e
JOIN Entrenador_Area ea ON e.id_entrenador = ea.id_entrenador
JOIN AreaEntrenamiento a ON ea.id_area = a.id_area;

-- 6. Trainers sin asignaciones
SELECT e.nombres, e.apellidos
FROM Entrenador e
LEFT JOIN Entrenador_Area ea ON e.id_entrenador = ea.id_entrenador
LEFT JOIN Asignacion_Entrenador_Ruta aer ON e.id_entrenador = aer.id_entrenador
WHERE ea.id_entrenador IS NULL AND aer.id_entrenador IS NULL;

-- 7. Módulos por trainer
SELECT e.nombres, e.apellidos, COUNT(DISTINCT m.id_modulo) as total_modulos
FROM Entrenador e
JOIN Asignacion_Entrenador_Ruta aer ON e.id_entrenador = aer.id_entrenador
JOIN RutaEntrenamiento r ON aer.id_ruta = r.id_ruta
JOIN Ruta_Skill rs ON r.id_ruta = rs.id_ruta
JOIN Modulo m ON rs.id_skill = m.id_skill
GROUP BY e.id_entrenador;

-- 8. Rendimiento promedio por trainer
SELECT e.nombres, e.apellidos, AVG(ev.nota_final) as promedio_rendimiento
FROM Entrenador e
JOIN Asignacion_Entrenador_Grupo aeg ON e.id_entrenador = aeg.id_entrenador
JOIN Grupo_Camper_Asignacion gca ON aeg.id_grupo = gca.id_grupo
JOIN Inscripcion i ON gca.id_camper = i.id_camper
JOIN Evaluacion ev ON i.id_inscripcion = ev.id_inscripcion
GROUP BY e.id_entrenador;

-- 9. Horarios ocupados por trainer
SELECT e.nombres, e.apellidos, h.hora_inicio, h.hora_fin
FROM Entrenador e
JOIN Disponibilidad_Entrenador de ON e.id_entrenador = de.id_entrenador
JOIN Horario_Clase h ON de.hora_inicio = h.hora_inicio;

-- 10. Disponibilidad semanal
SELECT e.nombres, e.apellidos, 
       de.dia_semana, de.hora_inicio, de.hora_fin
FROM Entrenador e
JOIN Disponibilidad_Entrenador de ON e.id_entrenador = de.id_entrenador
ORDER BY e.nombres, de.dia_semana;
