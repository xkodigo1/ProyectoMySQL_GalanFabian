-- 1. Campers con nota más alta por módulo
SELECT m.nombre_modulo, c.nombres, c.apellidos, e.nota_final
FROM Evaluacion e
JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
JOIN Camper c ON i.id_camper = c.id_camper
JOIN Modulo m ON e.id_modulo = m.id_modulo
WHERE (e.id_modulo, e.nota_final) IN (
    SELECT id_modulo, MAX(nota_final)
    FROM Evaluacion
    GROUP BY id_modulo
);

-- 2. Promedio por ruta vs promedio global
WITH PromedioGlobal AS (
    SELECT AVG(nota_final) as promedio_global
    FROM Evaluacion
)
SELECT r.nombre_ruta, 
       AVG(e.nota_final) as promedio_ruta,
       pg.promedio_global,
       AVG(e.nota_final) - pg.promedio_global as diferencia
FROM RutaEntrenamiento r
JOIN Inscripcion i ON r.id_ruta = i.id_ruta
JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
CROSS JOIN PromedioGlobal pg
GROUP BY r.nombre_ruta, pg.promedio_global;

-- 3. Áreas con más del 80% de ocupación
SELECT a.nombre_area,
       a.capacidad,
       COUNT(DISTINCT gca.id_camper) as ocupacion_actual,
       (COUNT(DISTINCT gca.id_camper) * 100.0 / a.capacidad) as porcentaje_ocupacion
FROM AreaEntrenamiento a
JOIN Asignacion_Salon_Horario ash ON a.id_area = ash.id_area
JOIN Grupo_Campers g ON ash.id_salon = g.id_salon
JOIN Grupo_Camper_Asignacion gca ON g.id_grupo = gca.id_grupo
GROUP BY a.nombre_area, a.capacidad
HAVING (COUNT(DISTINCT gca.id_camper) * 100.0 / a.capacidad) > 80;

-- 4. Trainers con rendimiento menor al 70%
WITH RendimientoTrainer AS (
    SELECT e.id_entrenador, AVG(ev.nota_final) as promedio_rendimiento
    FROM Entrenador e
    JOIN Asignacion_Entrenador_Grupo aeg ON e.id_entrenador = aeg.id_entrenador
    JOIN Grupo_Camper_Asignacion gca ON aeg.id_grupo = gca.id_grupo
    JOIN Inscripcion i ON gca.id_camper = i.id_camper
    JOIN Evaluacion ev ON i.id_inscripcion = ev.id_inscripcion
    GROUP BY e.id_entrenador
)
SELECT e.nombres, e.apellidos, rt.promedio_rendimiento
FROM Entrenador e
JOIN RendimientoTrainer rt ON e.id_entrenador = rt.id_entrenador
WHERE rt.promedio_rendimiento < 70;

-- 5. Campers bajo el promedio general
WITH PromedioGeneral AS (
    SELECT AVG(nota_final) as promedio
    FROM Evaluacion
)
SELECT c.nombres, c.apellidos, AVG(e.nota_final) as promedio_camper
FROM Camper c
JOIN Inscripcion i ON c.id_camper = i.id_camper
JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
CROSS JOIN PromedioGeneral pg
GROUP BY c.id_camper, c.nombres, c.apellidos, pg.promedio
HAVING AVG(e.nota_final) < pg.promedio;

-- 6. Módulos con menor tasa de aprobación
SELECT m.nombre_modulo,
       COUNT(CASE WHEN e.nota_final >= 60 THEN 1 END) * 100.0 / COUNT(*) as tasa_aprobacion
FROM Modulo m
JOIN Evaluacion e ON m.id_modulo = e.id_modulo
GROUP BY m.nombre_modulo
ORDER BY tasa_aprobacion ASC
LIMIT 5;

-- 7. Campers que aprobaron todos sus módulos
SELECT c.nombres, c.apellidos
FROM Camper c
WHERE NOT EXISTS (
    SELECT 1
    FROM Inscripcion i
    JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
    WHERE i.id_camper = c.id_camper
    AND e.nota_final < 60
);

-- 8. Rutas con más de 10 campers en bajo rendimiento
SELECT r.nombre_ruta, COUNT(DISTINCT c.id_camper) as campers_bajo_rendimiento
FROM RutaEntrenamiento r
JOIN Inscripcion i ON r.id_ruta = i.id_ruta
JOIN Camper c ON i.id_camper = c.id_camper
JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
WHERE e.nota_final < 60
GROUP BY r.id_ruta, r.nombre_ruta
HAVING COUNT(DISTINCT c.id_camper) > 10;

-- 9. Promedio por SGDB principal
SELECT sg.nombre_sgdb,
       AVG(e.nota_final) as promedio_rendimiento
FROM SistemaGestorBaseDatos sg
JOIN RutaEntrenamiento r ON sg.id_sgdb = r.id_sgdb_principal
JOIN Inscripcion i ON r.id_ruta = i.id_ruta
JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
GROUP BY sg.id_sgdb, sg.nombre_sgdb;

-- 10. Módulos con 30% o más de reprobados
SELECT m.nombre_modulo,
       COUNT(CASE WHEN e.nota_final < 60 THEN 1 END) * 100.0 / COUNT(*) as porcentaje_reprobados
FROM Modulo m
JOIN Evaluacion e ON m.id_modulo = e.id_modulo
GROUP BY m.id_modulo, m.nombre_modulo
HAVING (COUNT(CASE WHEN e.nota_final < 60 THEN 1 END) * 100.0 / COUNT(*)) >= 30;

-- 11. Módulo más cursado por campers de riesgo alto
SELECT m.nombre_modulo, COUNT(*) as total_campers
FROM Modulo m
JOIN Evaluacion e ON m.id_modulo = e.id_modulo
JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
JOIN Camper c ON i.id_camper = c.id_camper
WHERE c.nivel_riesgo = 'Alto'
GROUP BY m.id_modulo, m.nombre_modulo
ORDER BY total_campers DESC
LIMIT 1;

-- 12. Trainers con más de 3 rutas
SELECT e.nombres, e.apellidos, COUNT(DISTINCT aer.id_ruta) as total_rutas
FROM Entrenador e
JOIN Asignacion_Entrenador_Ruta aer ON e.id_entrenador = aer.id_entrenador
GROUP BY e.id_entrenador, e.nombres, e.apellidos
HAVING COUNT(DISTINCT aer.id_ruta) > 3;

-- 13. Horarios más ocupados por área
SELECT a.nombre_area, h.hora_inicio, h.hora_fin,
       COUNT(DISTINCT g.id_grupo) as grupos_asignados
FROM AreaEntrenamiento a
JOIN Asignacion_Salon_Horario ash ON a.id_area = ash.id_area
JOIN Horario_Clase h ON ash.id_horario = h.id_horario
JOIN Grupo_Campers g ON ash.id_salon = g.id_salon
GROUP BY a.id_area, a.nombre_area, h.hora_inicio, h.hora_fin
ORDER BY grupos_asignados DESC;

-- 14. Rutas con mayor número de módulos
SELECT r.nombre_ruta, COUNT(DISTINCT m.id_modulo) as total_modulos
FROM RutaEntrenamiento r
JOIN Ruta_Skill rs ON r.id_ruta = rs.id_ruta
JOIN Skill s ON rs.id_skill = s.id_skill
JOIN Modulo m ON s.id_skill = m.id_skill
GROUP BY r.id_ruta, r.nombre_ruta
ORDER BY total_modulos DESC;

-- 15. Campers con múltiples cambios de estado
SELECT c.nombres, c.apellidos, COUNT(*) as cambios_estado
FROM Camper c
JOIN Historial_Estado_Camper hec ON c.id_camper = hec.id_camper
GROUP BY c.id_camper, c.nombres, c.apellidos
HAVING COUNT(*) > 1;

-- 16. Evaluaciones con nota teórica mayor a práctica
SELECT c.nombres, c.apellidos, m.nombre_modulo,
       e.nota_teorica, e.nota_practica,
       (e.nota_teorica - e.nota_practica) as diferencia
FROM Evaluacion e
JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
JOIN Camper c ON i.id_camper = c.id_camper
JOIN Modulo m ON e.id_modulo = m.id_modulo
WHERE e.nota_teorica > e.nota_practica;

-- 17. Módulos con promedio de quizzes superior a 9
SELECT m.nombre_modulo, AVG(e.nota_trabajos_quizzes) as promedio_quizzes
FROM Modulo m
JOIN Evaluacion e ON m.id_modulo = e.id_modulo
GROUP BY m.id_modulo, m.nombre_modulo
HAVING AVG(e.nota_trabajos_quizzes) > 90;

-- 18. Ruta con mayor tasa de graduación
WITH TasaGraduacion AS (
    SELECT r.id_ruta, r.nombre_ruta,
           COUNT(CASE WHEN ec.estado_camper = 'Graduado' THEN 1 END) * 100.0 / COUNT(*) as tasa
    FROM RutaEntrenamiento r
    JOIN Inscripcion i ON r.id_ruta = i.id_ruta
    JOIN Camper c ON i.id_camper = c.id_camper
    JOIN Estado_camper ec ON c.id_estado = ec.id_estado
    GROUP BY r.id_ruta, r.nombre_ruta
)
SELECT nombre_ruta, tasa
FROM TasaGraduacion
WHERE tasa = (SELECT MAX(tasa) FROM TasaGraduacion);

-- 19. Módulos cursados por campers de riesgo medio o alto
SELECT DISTINCT m.nombre_modulo, c.nivel_riesgo
FROM Modulo m
JOIN Evaluacion e ON m.id_modulo = e.id_modulo
JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
JOIN Camper c ON i.id_camper = c.id_camper
WHERE c.nivel_riesgo IN ('Medio', 'Alto')
ORDER BY m.nombre_modulo;

-- 20. Diferencia entre capacidad y ocupación por área
SELECT a.nombre_area,
       a.capacidad as capacidad_total,
       COUNT(DISTINCT gca.id_camper) as ocupacion_actual,
       a.capacidad - COUNT(DISTINCT gca.id_camper) as espacios_disponibles
FROM AreaEntrenamiento a
LEFT JOIN Asignacion_Salon_Horario ash ON a.id_area = ash.id_area
LEFT JOIN Grupo_Campers g ON ash.id_salon = g.id_salon
LEFT JOIN Grupo_Camper_Asignacion gca ON g.id_grupo = gca.id_grupo
GROUP BY a.id_area, a.nombre_area, a.capacidad;
