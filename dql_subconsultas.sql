-- 1. Campers con la nota más alta en cada módulo
SELECT m.nombre_modulo, c.nombres, c.apellidos, e.nota_final
FROM Evaluacion e
INNER JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
INNER JOIN Camper c ON i.id_camper = c.id_camper
INNER JOIN Modulo m ON e.id_modulo = m.id_modulo
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
SELECT 
    r.nombre_ruta,
    ROUND(AVG(e.nota_final), 2) as promedio_ruta,
    ROUND(pg.promedio_global, 2) as promedio_global,
    ROUND(AVG(e.nota_final) - pg.promedio_global, 2) as diferencia
FROM RutaEntrenamiento r
INNER JOIN Inscripcion i ON r.id_ruta = i.id_ruta
INNER JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
CROSS JOIN PromedioGlobal pg
GROUP BY r.nombre_ruta, pg.promedio_global;

-- 3. Áreas con más del 80% de ocupación
SELECT 
    a.nombre_area,
    a.capacidad,
    COUNT(DISTINCT gca.id_camper) as ocupacion_actual,
    ROUND((COUNT(DISTINCT gca.id_camper) * 100.0 / a.capacidad), 2) as porcentaje_ocupacion
FROM AreaEntrenamiento a
INNER JOIN Asignacion_Salon_Horario ash ON a.id_area = ash.id_area
INNER JOIN Grupo_Campers g ON ash.id_salon = g.id_salon
INNER JOIN Grupo_Camper_Asignacion gca ON g.id_grupo = gca.id_grupo
GROUP BY a.nombre_area, a.capacidad
HAVING porcentaje_ocupacion > 80;

-- 4. Trainers con rendimiento menor al 70%
WITH RendimientoTrainer AS (
    SELECT 
        e.id_entrenador,
        ROUND(AVG(ev.nota_final), 2) as promedio_rendimiento
    FROM Entrenador e
    INNER JOIN Asignacion_Entrenador_Grupo aeg ON e.id_entrenador = aeg.id_entrenador
    INNER JOIN Grupo_Camper_Asignacion gca ON aeg.id_grupo = gca.id_grupo
    INNER JOIN Inscripcion i ON gca.id_camper = i.id_camper
    INNER JOIN Evaluacion ev ON i.id_inscripcion = ev.id_inscripcion
    GROUP BY e.id_entrenador
)
SELECT e.nombres, e.apellidos, rt.promedio_rendimiento
FROM Entrenador e
INNER JOIN RendimientoTrainer rt ON e.id_entrenador = rt.id_entrenador
WHERE rt.promedio_rendimiento < 70;

-- 5. Campers bajo el promedio general
WITH PromedioGeneral AS (
    SELECT AVG(nota_final) as promedio
    FROM Evaluacion
)
SELECT 
    c.nombres, 
    c.apellidos,
    ROUND(AVG(e.nota_final), 2) as promedio_camper,
    ROUND(pg.promedio, 2) as promedio_general
FROM Camper c
INNER JOIN Inscripcion i ON c.id_camper = i.id_camper
INNER JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
CROSS JOIN PromedioGeneral pg
GROUP BY c.id_camper, pg.promedio
HAVING AVG(e.nota_final) < pg.promedio;

-- 6. Módulos con menor tasa de aprobación
WITH EstadisticasModulo AS (
    SELECT 
        m.id_modulo,
        COUNT(*) as total_evaluaciones,
        SUM(CASE WHEN e.nota_final >= 60 THEN 1 ELSE 0 END) as aprobados
    FROM Modulo m
    INNER JOIN Evaluacion e ON m.id_modulo = e.id_modulo
    GROUP BY m.id_modulo
)
SELECT 
    m.nombre_modulo,
    em.total_evaluaciones,
    em.aprobados,
    ROUND((em.aprobados * 100.0 / em.total_evaluaciones), 2) as tasa_aprobacion
FROM Modulo m
INNER JOIN EstadisticasModulo em ON m.id_modulo = em.id_modulo
ORDER BY tasa_aprobacion ASC;

-- 7. Campers que han aprobado todos los módulos de su ruta
WITH ModulosPorRuta AS (
    SELECT r.id_ruta, COUNT(DISTINCT m.id_modulo) as total_modulos
    FROM RutaEntrenamiento r
    INNER JOIN Ruta_Skill rs ON r.id_ruta = rs.id_ruta
    INNER JOIN Modulo m ON rs.id_skill = m.id_skill
    GROUP BY r.id_ruta
),
ModulosAprobadosPorCamper AS (
    SELECT 
        i.id_camper,
        i.id_ruta,
        COUNT(DISTINCT e.id_modulo) as modulos_aprobados
    FROM Inscripcion i
    INNER JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
    WHERE e.nota_final >= 60
    GROUP BY i.id_camper, i.id_ruta
)
SELECT 
    c.nombres,
    c.apellidos,
    r.nombre_ruta,
    mac.modulos_aprobados,
    mpr.total_modulos
FROM Camper c
INNER JOIN ModulosAprobadosPorCamper mac ON c.id_camper = mac.id_camper
INNER JOIN ModulosPorRuta mpr ON mac.id_ruta = mpr.id_ruta
INNER JOIN RutaEntrenamiento r ON mpr.id_ruta = r.id_ruta
WHERE mac.modulos_aprobados = mpr.total_modulos;

-- 8. Rutas con más de 10 campers en bajo rendimiento
SELECT 
    r.nombre_ruta,
    COUNT(DISTINCT c.id_camper) as campers_bajo_rendimiento
FROM RutaEntrenamiento r
INNER JOIN Inscripcion i ON r.id_ruta = i.id_ruta
INNER JOIN Camper c ON i.id_camper = c.id_camper
INNER JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
WHERE e.nota_final < 60
GROUP BY r.id_ruta
HAVING COUNT(DISTINCT c.id_camper) > 10;

-- 9. Promedio de rendimiento por SGDB principal
SELECT 
    s.nombre_sgdb,
    ROUND(AVG(e.nota_final), 2) as promedio_rendimiento,
    COUNT(DISTINCT c.id_camper) as total_campers
FROM SistemaGestorBaseDatos s
INNER JOIN RutaEntrenamiento r ON s.id_sgdb = r.id_sgdb_principal
INNER JOIN Inscripcion i ON r.id_ruta = i.id_ruta
INNER JOIN Camper c ON i.id_camper = c.id_camper
INNER JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
GROUP BY s.id_sgdb;

-- 10. Módulos con al menos 30% de campers reprobados
WITH EstadisticasReprobacion AS (
    SELECT 
        m.id_modulo,
        COUNT(DISTINCT e.id_inscripcion) as total_campers,
        COUNT(DISTINCT CASE WHEN e.nota_final < 60 THEN e.id_inscripcion END) as reprobados
    FROM Modulo m
    INNER JOIN Evaluacion e ON m.id_modulo = e.id_modulo
    GROUP BY m.id_modulo
)
SELECT 
    m.nombre_modulo,
    er.total_campers,
    er.reprobados,
    ROUND((er.reprobados * 100.0 / er.total_campers), 2) as porcentaje_reprobados
FROM Modulo m
INNER JOIN EstadisticasReprobacion er ON m.id_modulo = er.id_modulo
WHERE (er.reprobados * 100.0 / er.total_campers) >= 30;

-- 11. Módulo más cursado por campers con riesgo alto
SELECT 
    m.nombre_modulo,
    COUNT(DISTINCT c.id_camper) as total_campers_alto_riesgo
FROM Modulo m
INNER JOIN Evaluacion e ON m.id_modulo = e.id_modulo
INNER JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
INNER JOIN Camper c ON i.id_camper = c.id_camper
WHERE c.nivel_riesgo = 'Alto'
GROUP BY m.id_modulo
ORDER BY total_campers_alto_riesgo DESC
LIMIT 1;

-- 12. Trainers con más de 3 rutas asignadas
SELECT 
    e.nombres,
    e.apellidos,
    COUNT(DISTINCT aer.id_ruta) as total_rutas,
    GROUP_CONCAT(DISTINCT r.nombre_ruta) as rutas_asignadas
FROM Entrenador e
INNER JOIN Asignacion_Entrenador_Ruta aer ON e.id_entrenador = aer.id_entrenador
INNER JOIN RutaEntrenamiento r ON aer.id_ruta = r.id_ruta
GROUP BY e.id_entrenador
HAVING COUNT(DISTINCT aer.id_ruta) > 3;

-- 13. Horarios más ocupados por áreas
SELECT 
    a.nombre_area,
    h.hora_inicio,
    h.hora_fin,
    COUNT(DISTINCT gca.id_camper) as total_campers
FROM AreaEntrenamiento a
INNER JOIN Asignacion_Salon_Horario ash ON a.id_area = ash.id_area
INNER JOIN Horario_Clase h ON ash.id_horario = h.id_horario
INNER JOIN Grupo_Campers g ON ash.id_salon = g.id_salon
INNER JOIN Grupo_Camper_Asignacion gca ON g.id_grupo = gca.id_grupo
GROUP BY a.id_area, h.id_horario
ORDER BY total_campers DESC;

-- 14. Rutas con mayor número de módulos
SELECT 
    r.nombre_ruta,
    COUNT(DISTINCT m.id_modulo) as total_modulos,
    GROUP_CONCAT(DISTINCT m.nombre_modulo) as modulos
FROM RutaEntrenamiento r
INNER JOIN Ruta_Skill rs ON r.id_ruta = rs.id_ruta
INNER JOIN Skill s ON rs.id_skill = s.id_skill
INNER JOIN Modulo m ON s.id_skill = m.id_skill
GROUP BY r.id_ruta
ORDER BY total_modulos DESC;

-- 15. Campers con más de un cambio de estado
SELECT 
    c.nombres,
    c.apellidos,
    COUNT(h.id_camper) as total_cambios,
    GROUP_CONCAT(DISTINCT ec.estado_camper) as estados
FROM Camper c
INNER JOIN Historial_Estado_Camper h ON c.id_camper = h.id_camper
INNER JOIN Estado_camper ec ON h.id_estado_nuevo = ec.id_estado
GROUP BY c.id_camper
HAVING COUNT(h.id_camper) > 1;

-- 16. Evaluaciones con nota teórica mayor a práctica
SELECT 
    c.nombres,
    c.apellidos,
    m.nombre_modulo,
    e.nota_teorica,
    e.nota_practica,
    (e.nota_teorica - e.nota_practica) as diferencia
FROM Evaluacion e
INNER JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
INNER JOIN Camper c ON i.id_camper = c.id_camper
INNER JOIN Modulo m ON e.id_modulo = m.id_modulo
WHERE e.nota_teorica > e.nota_practica;

-- 17. Módulos con media de quizzes superior a 90
SELECT 
    m.nombre_modulo,
    ROUND(AVG(e.nota_trabajos_quizzes), 2) as promedio_quizzes,
    COUNT(DISTINCT e.id_inscripcion) as total_evaluaciones
FROM Modulo m
INNER JOIN Evaluacion e ON m.id_modulo = e.id_modulo
GROUP BY m.id_modulo
HAVING AVG(e.nota_trabajos_quizzes) > 90;

-- 18. Ruta con mayor tasa de graduación
WITH EstadisticasGraduacion AS (
    SELECT 
        r.id_ruta,
        COUNT(DISTINCT i.id_camper) as total_inscritos,
        COUNT(DISTINCT CASE WHEN c.id_estado = (
            SELECT id_estado FROM Estado_camper WHERE estado_camper = 'Graduado'
        ) THEN c.id_camper END) as graduados
    FROM RutaEntrenamiento r
    INNER JOIN Inscripcion i ON r.id_ruta = i.id_ruta
    INNER JOIN Camper c ON i.id_camper = c.id_camper
    GROUP BY r.id_ruta
)
SELECT 
    r.nombre_ruta,
    eg.total_inscritos,
    eg.graduados,
    ROUND((eg.graduados * 100.0 / eg.total_inscritos), 2) as tasa_graduacion
FROM RutaEntrenamiento r
INNER JOIN EstadisticasGraduacion eg ON r.id_ruta = eg.id_ruta
ORDER BY tasa_graduacion DESC
LIMIT 1;

-- 19. Módulos cursados por campers de riesgo medio o alto
SELECT 
    m.nombre_modulo,
    COUNT(DISTINCT CASE WHEN c.nivel_riesgo = 'Alto' THEN c.id_camper END) as campers_alto_riesgo,
    COUNT(DISTINCT CASE WHEN c.nivel_riesgo = 'Medio' THEN c.id_camper END) as campers_medio_riesgo
FROM Modulo m
INNER JOIN Evaluacion e ON m.id_modulo = e.id_modulo
INNER JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
INNER JOIN Camper c ON i.id_camper = c.id_camper
WHERE c.nivel_riesgo IN ('Alto', 'Medio')
GROUP BY m.id_modulo;

-- 20. Diferencia entre capacidad y ocupación por área
SELECT 
    a.nombre_area,
    a.capacidad as capacidad_total,
    COUNT(DISTINCT gca.id_camper) as ocupacion_actual,
    (a.capacidad - COUNT(DISTINCT gca.id_camper)) as espacios_disponibles,
    ROUND((COUNT(DISTINCT gca.id_camper) * 100.0 / a.capacidad), 2) as porcentaje_ocupacion
FROM AreaEntrenamiento a
LEFT JOIN Asignacion_Salon_Horario ash ON a.id_area = ash.id_area
LEFT JOIN Grupo_Campers g ON ash.id_salon = g.id_salon
LEFT JOIN Grupo_Camper_Asignacion gca ON g.id_grupo = gca.id_grupo
GROUP BY a.id_area;