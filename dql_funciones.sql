-- 1. Calcular promedio ponderado de evaluaciones
DELIMITER //
CREATE FUNCTION calcular_promedio_ponderado(id_camper INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    SELECT AVG(nota_final) INTO promedio
    FROM Evaluacion e
    JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
    WHERE i.id_camper = id_camper;
    RETURN promedio;
END //
DELIMITER ;

-- 2. Determinar aprobación de módulo
DELIMITER //
CREATE FUNCTION aprobo_modulo(id_camper INT, id_modulo INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE nota DECIMAL(5,2);
    SELECT nota_final INTO nota
    FROM Evaluacion e
    JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
    WHERE i.id_camper = id_camper AND e.id_modulo = id_modulo;
    RETURN nota >= 60;
END //
DELIMITER ;

-- 3. Evaluar nivel de riesgo
DELIMITER //
CREATE FUNCTION evaluar_nivel_riesgo(id_camper INT) 
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    SELECT AVG(nota_final) INTO promedio
    FROM Evaluacion e
    JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
    WHERE i.id_camper = id_camper;
    RETURN CASE
        WHEN promedio < 60 THEN 'Alto'
        WHEN promedio < 75 THEN 'Medio'
        ELSE 'Bajo'
    END;
END //
DELIMITER ;

-- 4. Total de campers en ruta
DELIMITER //
CREATE FUNCTION total_campers_ruta(id_ruta INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(DISTINCT id_camper) INTO total
    FROM Inscripcion
    WHERE id_ruta = id_ruta;
    RETURN total;
END //
DELIMITER ;

-- 5. Módulos aprobados por camper
DELIMITER //
CREATE FUNCTION modulos_aprobados_camper(id_camper INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM Evaluacion e
    JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
    WHERE i.id_camper = id_camper AND e.nota_final >= 60;
    RETURN total;
END //
DELIMITER ;

-- 6. Validar cupos disponibles
DELIMITER //
CREATE FUNCTION hay_cupos_area(id_area INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE capacidad INT;
    DECLARE ocupados INT;
    
    SELECT SUM(s.capacidad) INTO capacidad
    FROM Salon s
    JOIN Asignacion_Salon_Horario ash ON s.id_salon = ash.id_salon
    WHERE ash.id_area = id_area;
    
    SELECT COUNT(DISTINCT gca.id_camper) INTO ocupados
    FROM Grupo_Camper_Asignacion gca
    JOIN Grupo_Campers g ON gca.id_grupo = g.id_grupo
    JOIN Asignacion_Entrenador_Grupo aeg ON g.id_grupo = aeg.id_grupo
    WHERE aeg.id_area = id_area;
    
    RETURN ocupados < capacidad;
END //
DELIMITER ;

-- 7. Calcular porcentaje ocupación
DELIMITER //
CREATE FUNCTION calcular_ocupacion_area(id_area INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE capacidad INT;
    DECLARE ocupados INT;
    
    SELECT SUM(s.capacidad) INTO capacidad
    FROM Salon s
    JOIN Asignacion_Salon_Horario ash ON s.id_salon = ash.id_salon
    WHERE ash.id_area = id_area;
    
    SELECT COUNT(DISTINCT gca.id_camper) INTO ocupados
    FROM Grupo_Camper_Asignacion gca
    JOIN Grupo_Campers g ON gca.id_grupo = g.id_grupo
    JOIN Asignacion_Entrenador_Grupo aeg ON g.id_grupo = aeg.id_grupo
    WHERE aeg.id_area = id_area;
    
    RETURN (ocupados * 100.0) / capacidad;
END //
DELIMITER ;

-- 8. Nota más alta del módulo
DELIMITER //
CREATE FUNCTION nota_maxima_modulo(id_modulo INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE max_nota DECIMAL(5,2);
    SELECT MAX(nota_final) INTO max_nota
    FROM Evaluacion
    WHERE id_modulo = id_modulo;
    RETURN max_nota;
END //
DELIMITER ;

-- 9. Tasa de aprobación de ruta
DELIMITER //
CREATE FUNCTION tasa_aprobacion_ruta(id_ruta INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE total INT;
    DECLARE aprobados INT;
    
    SELECT COUNT(DISTINCT i.id_camper) INTO total
    FROM Inscripcion i
    WHERE i.id_ruta = id_ruta;
    
    SELECT COUNT(DISTINCT i.id_camper) INTO aprobados
    FROM Inscripcion i
    JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
    WHERE i.id_ruta = id_ruta AND e.nota_final >= 60;
    
    RETURN (aprobados * 100.0) / total;
END //
DELIMITER ;

-- 10. Verificar disponibilidad de trainer
DELIMITER //
CREATE FUNCTION trainer_disponible(id_entrenador INT, hora_inicio TIME, hora_fin TIME) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE ocupado INT;
    
    SELECT COUNT(*) INTO ocupado
    FROM Disponibilidad_Entrenador
    WHERE id_entrenador = id_entrenador
    AND hora_inicio <= hora_fin
    AND hora_fin >= hora_inicio;
    
    RETURN ocupado = 0;
END //
DELIMITER ;

-- 11. Promedio de notas por ruta
DELIMITER //
CREATE FUNCTION promedio_ruta(id_ruta INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    SELECT AVG(e.nota_final) INTO promedio
    FROM Inscripcion i
    JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
    WHERE i.id_ruta = id_ruta;
    RETURN promedio;
END //
DELIMITER ;

-- 12. Rutas asignadas a trainer
DELIMITER //
CREATE FUNCTION rutas_trainer(id_entrenador INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(DISTINCT id_ruta) INTO total
    FROM Asignacion_Entrenador_Ruta
    WHERE id_entrenador = id_entrenador;
    RETURN total;
END //
DELIMITER ;

-- 13. Verificar si puede graduarse
DELIMITER //
CREATE FUNCTION puede_graduarse(id_camper INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE total_modulos INT;
    DECLARE modulos_aprobados INT;
    
    SELECT COUNT(DISTINCT m.id_modulo) INTO total_modulos
    FROM Inscripcion i
    JOIN RutaEntrenamiento r ON i.id_ruta = r.id_ruta
    JOIN Ruta_Skill rs ON r.id_ruta = rs.id_ruta
    JOIN Modulo m ON rs.id_skill = m.id_skill
    WHERE i.id_camper = id_camper;
    
    SELECT COUNT(*) INTO modulos_aprobados
    FROM Evaluacion e
    JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
    WHERE i.id_camper = id_camper AND e.nota_final >= 60;
    
    RETURN modulos_aprobados >= total_modulos;
END //
DELIMITER ;

-- 14. Estado actual según evaluaciones
DELIMITER //
CREATE FUNCTION estado_segun_evaluaciones(id_camper INT) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    
    SELECT AVG(nota_final) INTO promedio
    FROM Evaluacion e
    JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
    WHERE i.id_camper = id_camper;
    
    RETURN CASE
        WHEN promedio >= 60 THEN 'Regular'
        ELSE 'Bajo Rendimiento'
    END;
END //
DELIMITER ;

-- 15. Carga horaria semanal
DELIMITER //
CREATE FUNCTION carga_horaria_trainer(id_entrenador INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_horas INT;
    
    SELECT SUM(HOUR(TIMEDIFF(hora_fin, hora_inicio))) INTO total_horas
    FROM Disponibilidad_Entrenador
    WHERE id_entrenador = id_entrenador;
    
    RETURN total_horas;
END //
DELIMITER ;

-- 16. Módulos pendientes en ruta
DELIMITER //
CREATE FUNCTION tiene_modulos_pendientes(id_ruta INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE total_modulos INT;
    DECLARE modulos_evaluados INT;
    
    SELECT COUNT(DISTINCT m.id_modulo) INTO total_modulos
    FROM Ruta_Skill rs
    JOIN Modulo m ON rs.id_skill = m.id_skill
    WHERE rs.id_ruta = id_ruta;
    
    SELECT COUNT(DISTINCT e.id_modulo) INTO modulos_evaluados
    FROM Inscripcion i
    JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
    WHERE i.id_ruta = id_ruta;
    
    RETURN modulos_evaluados < total_modulos;
END //
DELIMITER ;

-- 17. Promedio general del programa
DELIMITER //
CREATE FUNCTION promedio_general_programa() 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    SELECT AVG(nota_final) INTO promedio
    FROM Evaluacion;
    RETURN promedio;
END //
DELIMITER ;

-- 18. Verificar choque de horarios
DELIMITER //
CREATE FUNCTION hay_choque_horarios(id_entrenador INT, hora_inicio TIME, hora_fin TIME) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE choques INT;
    
    SELECT COUNT(*) INTO choques
    FROM Disponibilidad_Entrenador
    WHERE id_entrenador = id_entrenador
    AND ((hora_inicio BETWEEN hora_inicio AND hora_fin)
    OR (hora_fin BETWEEN hora_inicio AND hora_fin));
    
    RETURN choques > 0;
END //
DELIMITER ;

-- 19. Campers en riesgo por ruta
DELIMITER //
CREATE FUNCTION campers_en_riesgo_ruta(id_ruta INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(DISTINCT i.id_camper) INTO total
    FROM Inscripcion i
    JOIN Camper c ON i.id_camper = c.id_camper
    WHERE i.id_ruta = id_ruta AND c.nivel_riesgo = 'Alto';
    
    RETURN total;
END //
DELIMITER ;

-- 20. Módulos evaluados por camper
DELIMITER //
CREATE FUNCTION modulos_evaluados_camper(id_camper INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(DISTINCT e.id_modulo) INTO total
    FROM Inscripcion i
    JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
    WHERE i.id_camper = id_camper;
    
    RETURN total;
END //
DELIMITER ;
