-- 1. Campers con sus rutas de entrenamiento
SELECT c.nombres, c.apellidos, r.nombre_ruta
FROM Camper c
INNER JOIN Inscripcion i ON c.id_camper = i.id_camper
INNER JOIN RutaEntrenamiento r ON i.id_ruta = r.id_ruta;

-- 2. Campers con sus evaluaciones por módulo
SELECT 
    c.nombres, 
    c.apellidos, 
    m.nombre_modulo,
    e.nota_teorica,
    e.nota_practica,
    e.nota_trabajos_quizzes,
    e.nota_final
FROM Camper c
INNER JOIN Inscripcion i ON c.id_camper = i.id_camper
INNER JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
INNER JOIN Modulo m ON e.id_modulo = m.id_modulo;

-- 3. Módulos por ruta de entrenamiento
SELECT 
    r.nombre_ruta,
    s.nombre_skill,
    m.nombre_modulo,
    m.duracion_horas
FROM RutaEntrenamiento r
INNER JOIN Ruta_Skill rs ON r.id_ruta = rs.id_ruta
INNER JOIN Skill s ON rs.id_skill = s.id_skill
INNER JOIN Modulo m ON s.id_skill = m.id_skill
ORDER BY r.nombre_ruta, s.nombre_skill;

-- 4. Rutas con trainers y áreas
SELECT 
    r.nombre_ruta,
    e.nombres AS nombre_trainer,
    e.apellidos AS apellido_trainer,
    a.nombre_area
FROM RutaEntrenamiento r
INNER JOIN Asignacion_Entrenador_Ruta aer ON r.id_ruta = aer.id_ruta
INNER JOIN Entrenador e ON aer.id_entrenador = e.id_entrenador
INNER JOIN Entrenador_Area ea ON e.id_entrenador = ea.id_entrenador
INNER JOIN AreaEntrenamiento a ON ea.id_area = a.id_area;

-- 5. Campers con sus trainers asignados
SELECT 
    c.nombres AS nombre_camper,
    c.apellidos AS apellido_camper,
    e.nombres AS nombre_trainer,
    e.apellidos AS apellido_trainer,
    r.nombre_ruta
FROM Camper c
INNER JOIN Inscripcion i ON c.id_camper = i.id_camper
INNER JOIN RutaEntrenamiento r ON i.id_ruta = r.id_ruta
INNER JOIN Asignacion_Entrenador_Ruta aer ON r.id_ruta = aer.id_ruta
INNER JOIN Entrenador e ON aer.id_entrenador = e.id_entrenador;

-- 6. Evaluaciones con detalles completos
SELECT 
    c.nombres,
    c.apellidos,
    m.nombre_modulo,
    r.nombre_ruta,
    e.nota_final
FROM Evaluacion e
INNER JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
INNER JOIN Camper c ON i.id_camper = c.id_camper
INNER JOIN Modulo m ON e.id_modulo = m.id_modulo
INNER JOIN RutaEntrenamiento r ON i.id_ruta = r.id_ruta;

-- 7. Trainers con horarios y áreas
SELECT 
    e.nombres,
    e.apellidos,
    a.nombre_area,
    h.hora_inicio,
    h.hora_fin
FROM Entrenador e
INNER JOIN Entrenador_Area ea ON e.id_entrenador = ea.id_entrenador
INNER JOIN AreaEntrenamiento a ON ea.id_area = a.id_area
INNER JOIN Asignacion_Salon_Horario ash ON a.id_area = ash.id_area
INNER JOIN Horario_Clase h ON ash.id_horario = h.id_horario;

-- 8. Campers con estado y nivel de riesgo
SELECT 
    c.nombres,
    c.apellidos,
    ec.estado_camper,
    c.nivel_riesgo
FROM Camper c
LEFT JOIN Estado_camper ec ON c.id_estado = ec.id_estado;

-- 9. Módulos de ruta con porcentajes de evaluación
SELECT 
    r.nombre_ruta,
    m.nombre_modulo,
    AVG(e.nota_teorica) as promedio_teorico,
    AVG(e.nota_practica) as promedio_practico,
    AVG(e.nota_trabajos_quizzes) as promedio_quizzes
FROM RutaEntrenamiento r
INNER JOIN Ruta_Skill rs ON r.id_ruta = rs.id_ruta
INNER JOIN Skill s ON rs.id_skill = s.id_skill
INNER JOIN Modulo m ON s.id_skill = m.id_skill
LEFT JOIN Evaluacion e ON m.id_modulo = e.id_modulo
GROUP BY r.nombre_ruta, m.nombre_modulo;

-- 10. Áreas con campers asistentes
SELECT 
    a.nombre_area,
    c.nombres,
    c.apellidos,
    gc.nombre_grupo
FROM AreaEntrenamiento a
INNER JOIN Asignacion_Salon_Horario ash ON a.id_area = ash.id_area
INNER JOIN Grupo_Campers gc ON ash.id_salon = gc.id_salon
INNER JOIN Grupo_Camper_Asignacion gca ON gc.id_grupo = gca.id_grupo
INNER JOIN Camper c ON gca.id_camper = c.id_camper
ORDER BY a.nombre_area, gc.nombre_grupo;

-- 1. Campers que han aprobado todos sus módulos
SELECT 
    c.nombres, 
    c.apellidos,
    r.nombre_ruta,
    MIN(e.nota_final) as nota_minima
FROM Camper c
INNER JOIN Inscripcion i ON c.id_camper = i.id_camper
INNER JOIN RutaEntrenamiento r ON i.id_ruta = r.id_ruta
INNER JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
GROUP BY c.id_camper, c.nombres, c.apellidos, r.nombre_ruta
HAVING MIN(e.nota_final) >= 60;

-- 2. Rutas con más de 10 campers inscritos
SELECT 
    r.nombre_ruta,
    COUNT(DISTINCT i.id_camper) as total_campers
FROM RutaEntrenamiento r
INNER JOIN Inscripcion i ON r.id_ruta = i.id_ruta
INNER JOIN Estado_Inscripcion ei ON i.id_estado_inscripcion = ei.id_estado_inscripcion
WHERE ei.estado_inscripcion = 'Activa'
GROUP BY r.id_ruta, r.nombre_ruta
HAVING COUNT(DISTINCT i.id_camper) > 10;

-- 3. Áreas con ocupación mayor al 80%
SELECT 
    a.nombre_area,
    a.capacidad as capacidad_total,
    COUNT(DISTINCT gca.id_camper) as campers_actuales,
    (COUNT(DISTINCT gca.id_camper) * 100.0 / a.capacidad) as porcentaje_ocupacion
FROM AreaEntrenamiento a
INNER JOIN Asignacion_Salon_Horario ash ON a.id_area = ash.id_area
INNER JOIN Grupo_Campers gc ON ash.id_salon = gc.id_salon
INNER JOIN Grupo_Camper_Asignacion gca ON gc.id_grupo = gca.id_grupo
GROUP BY a.id_area, a.nombre_area, a.capacidad
HAVING (COUNT(DISTINCT gca.id_camper) * 100.0 / a.capacidad) > 80;

-- 4. Trainers con múltiples rutas
SELECT 
    e.nombres,
    e.apellidos,
    COUNT(DISTINCT aer.id_ruta) as total_rutas,
    GROUP_CONCAT(r.nombre_ruta) as rutas_asignadas
FROM Entrenador e
INNER JOIN Asignacion_Entrenador_Ruta aer ON e.id_entrenador = aer.id_entrenador
INNER JOIN RutaEntrenamiento r ON aer.id_ruta = r.id_ruta
GROUP BY e.id_entrenador, e.nombres, e.apellidos
HAVING COUNT(DISTINCT aer.id_ruta) > 1;

-- 5. Evaluaciones con nota práctica mayor a teórica
SELECT 
    c.nombres,
    c.apellidos,
    m.nombre_modulo,
    e.nota_teorica,
    e.nota_practica,
    (e.nota_practica - e.nota_teorica) as diferencia
FROM Evaluacion e
INNER JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
INNER JOIN Camper c ON i.id_camper = c.id_camper
INNER JOIN Modulo m ON e.id_modulo = m.id_modulo
WHERE e.nota_practica > e.nota_teorica;

-- 6. Campers en rutas con MySQL como SGDB principal
SELECT 
    c.nombres,
    c.apellidos,
    r.nombre_ruta,
    sg.nombre_sgdb
FROM Camper c
INNER JOIN Inscripcion i ON c.id_camper = i.id_camper
INNER JOIN RutaEntrenamiento r ON i.id_ruta = r.id_ruta
INNER JOIN SistemaGestorBaseDatos sg ON r.id_sgdb_principal = sg.id_sgdb
WHERE sg.nombre_sgdb = 'MySQL';

-- 7. Módulos con bajo rendimiento
SELECT 
    m.nombre_modulo,
    COUNT(*) as total_evaluaciones,
    COUNT(CASE WHEN e.nota_final < 60 THEN 1 END) as reprobados,
    AVG(e.nota_final) as promedio_general
FROM Modulo m
INNER JOIN Evaluacion e ON m.id_modulo = e.id_modulo
GROUP BY m.id_modulo, m.nombre_modulo
HAVING COUNT(CASE WHEN e.nota_final < 60 THEN 1 END) > 0;

-- 8. Rutas con más de 3 módulos
SELECT 
    r.nombre_ruta,
    COUNT(DISTINCT m.id_modulo) as total_modulos
FROM RutaEntrenamiento r
INNER JOIN Ruta_Skill rs ON r.id_ruta = rs.id_ruta
INNER JOIN Skill s ON rs.id_skill = s.id_skill
INNER JOIN Modulo m ON s.id_skill = m.id_skill
GROUP BY r.id_ruta, r.nombre_ruta
HAVING COUNT(DISTINCT m.id_modulo) > 3;

-- 9. Inscripciones últimos 30 días
SELECT 
    c.nombres,
    c.apellidos,
    r.nombre_ruta,
    i.fecha_inscripcion,
    ei.estado_inscripcion
FROM Inscripcion i
INNER JOIN Camper c ON i.id_camper = c.id_camper
INNER JOIN RutaEntrenamiento r ON i.id_ruta = r.id_ruta
INNER JOIN Estado_Inscripcion ei ON i.id_estado_inscripcion = ei.id_estado_inscripcion
WHERE i.fecha_inscripcion >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- 10. Trainers con campers en alto riesgo
SELECT DISTINCT
    e.nombres as nombre_trainer,
    e.apellidos as apellido_trainer,
    COUNT(DISTINCT c.id_camper) as campers_alto_riesgo
FROM Entrenador e
INNER JOIN Asignacion_Entrenador_Ruta aer ON e.id_entrenador = aer.id_entrenador
INNER JOIN RutaEntrenamiento r ON aer.id_ruta = r.id_ruta
INNER JOIN Inscripcion i ON r.id_ruta = i.id_ruta
INNER JOIN Camper c ON i.id_camper = c.id_camper
WHERE c.nivel_riesgo = 'Alto'
GROUP BY e.id_entrenador, e.nombres, e.apellidos
HAVING COUNT(DISTINCT c.id_camper) > 0;

-- 1. Promedio de nota final por módulo
SELECT 
    m.nombre_modulo,
    COUNT(e.id_evaluacion) as total_evaluaciones,
    ROUND(AVG(e.nota_final), 2) as promedio_final,
    MIN(e.nota_final) as nota_minima,
    MAX(e.nota_final) as nota_maxima
FROM Modulo m
LEFT JOIN Evaluacion e ON m.id_modulo = e.id_modulo
GROUP BY m.id_modulo, m.nombre_modulo
ORDER BY promedio_final DESC;

-- 2. Total de campers por ruta
SELECT 
    r.nombre_ruta,
    COUNT(DISTINCT i.id_camper) as total_campers,
    COUNT(DISTINCT gc.id_grupo) as total_grupos
FROM RutaEntrenamiento r
LEFT JOIN Inscripcion i ON r.id_ruta = i.id_ruta
LEFT JOIN Grupo_Campers gc ON r.id_ruta = gc.id_ruta
GROUP BY r.id_ruta, r.nombre_ruta
ORDER BY total_campers DESC;

-- 3. Evaluaciones por trainer
SELECT 
    e.nombres,
    e.apellidos,
    COUNT(DISTINCT ev.id_evaluacion) as total_evaluaciones,
    COUNT(DISTINCT i.id_camper) as total_campers_evaluados
FROM Entrenador e
JOIN Asignacion_Entrenador_Ruta aer ON e.id_entrenador = aer.id_entrenador
JOIN Inscripcion i ON aer.id_ruta = i.id_ruta
JOIN Evaluacion ev ON i.id_inscripcion = ev.id_inscripcion
GROUP BY e.id_entrenador, e.nombres, e.apellidos;

-- 4. Promedio de rendimiento por área
SELECT 
    a.nombre_area,
    COUNT(DISTINCT gca.id_camper) as total_campers,
    ROUND(AVG(e.nota_final), 2) as promedio_rendimiento
FROM AreaEntrenamiento a
JOIN Asignacion_Salon_Horario ash ON a.id_area = ash.id_area
JOIN Grupo_Campers gc ON ash.id_salon = gc.id_salon
JOIN Grupo_Camper_Asignacion gca ON gc.id_grupo = gca.id_grupo
JOIN Inscripcion i ON gca.id_camper = i.id_camper
JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
GROUP BY a.id_area, a.nombre_area;

-- 5. Módulos por ruta
SELECT 
    r.nombre_ruta,
    COUNT(DISTINCT m.id_modulo) as total_modulos,
    SUM(m.duracion_horas) as total_horas
FROM RutaEntrenamiento r
JOIN Ruta_Skill rs ON r.id_ruta = rs.id_ruta
JOIN Skill s ON rs.id_skill = s.id_skill
JOIN Modulo m ON s.id_skill = m.id_skill
GROUP BY r.id_ruta, r.nombre_ruta;

-- 6. Promedio de campers cursando
SELECT 
    ec.estado_camper,
    COUNT(DISTINCT c.id_camper) as total_campers,
    ROUND(AVG(e.nota_final), 2) as promedio_general
FROM Camper c
JOIN Estado_camper ec ON c.id_estado = ec.id_estado
JOIN Inscripcion i ON c.id_camper = i.id_camper
JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
WHERE ec.estado_camper = 'Cursando'
GROUP BY ec.id_estado, ec.estado_camper;

-- 7. Campers evaluados por módulo
SELECT 
    m.nombre_modulo,
    COUNT(DISTINCT e.id_inscripcion) as total_evaluaciones,
    COUNT(DISTINCT i.id_camper) as total_campers_evaluados
FROM Modulo m
LEFT JOIN Evaluacion e ON m.id_modulo = e.id_modulo
LEFT JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
GROUP BY m.id_modulo, m.nombre_modulo;

-- 8. Porcentaje de ocupación por área
SELECT 
    a.nombre_area,
    a.capacidad as capacidad_total,
    COUNT(DISTINCT gca.id_camper) as ocupacion_actual,
    ROUND((COUNT(DISTINCT gca.id_camper) * 100.0 / a.capacidad), 2) as porcentaje_ocupacion
FROM AreaEntrenamiento a
LEFT JOIN Asignacion_Salon_Horario ash ON a.id_area = ash.id_area
LEFT JOIN Grupo_Campers gc ON ash.id_salon = gc.id_salon
LEFT JOIN Grupo_Camper_Asignacion gca ON gc.id_grupo = gca.id_grupo
GROUP BY a.id_area, a.nombre_area, a.capacidad;

-- 9. Trainers por área
SELECT 
    a.nombre_area,
    COUNT(DISTINCT ea.id_entrenador) as total_trainers,
    STRING_AGG(e.nombres + ' ' + e.apellidos, ', ') as trainers
FROM AreaEntrenamiento a
LEFT JOIN Entrenador_Area ea ON a.id_area = ea.id_area
LEFT JOIN Entrenador e ON ea.id_entrenador = e.id_entrenador
GROUP BY a.id_area, a.nombre_area;

-- 10. Rutas con campers en riesgo alto
SELECT 
    r.nombre_ruta,
    COUNT(DISTINCT c.id_camper) as total_campers_riesgo_alto,
    ROUND((COUNT(DISTINCT CASE WHEN c.nivel_riesgo = 'Alto' THEN c.id_camper END) * 100.0 / 
           COUNT(DISTINCT c.id_camper)), 2) as porcentaje_riesgo_alto
FROM RutaEntrenamiento r
JOIN Inscripcion i ON r.id_ruta = i.id_ruta
JOIN Camper c ON i.id_camper = c.id_camper
GROUP BY r.id_ruta, r.nombre_ruta
HAVING COUNT(DISTINCT CASE WHEN c.nivel_riesgo = 'Alto' THEN c.id_camper END) > 0
ORDER BY total_campers_riesgo_alto DESC;
