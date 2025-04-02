-- 1. Registrar nuevo camper
DELIMITER //
CREATE PROCEDURE sp_registrar_camper(
    IN p_numero_identificacion VARCHAR(20),
    IN p_nombres VARCHAR(50),
    IN p_apellidos VARCHAR(50),
    IN p_id_campus INT,
    IN p_telefono VARCHAR(15),
    IN p_email VARCHAR(100),
    IN p_direccion VARCHAR(100),
    IN p_acudiente_nombre VARCHAR(100),
    IN p_acudiente_telefono VARCHAR(15)
)
BEGIN
    DECLARE v_id_camper INT;
    DECLARE v_id_estado INT;
    
    SELECT id_estado INTO v_id_estado 
    FROM Estado_camper 
    WHERE estado_camper = 'En proceso de ingreso' LIMIT 1;
    
    START TRANSACTION;
    
    INSERT INTO Camper (
        numero_identificacion, 
        nombres, 
        apellidos, 
        id_campus, 
        id_estado, 
        nivel_riesgo
    )
    VALUES (
        p_numero_identificacion, 
        p_nombres, 
        p_apellidos, 
        p_id_campus, 
        v_id_estado, 
        'Bajo'
    );
    
    SET v_id_camper = LAST_INSERT_ID();
    
    INSERT INTO Telefono_Camper (id_camper, numero, tipo, es_principal)
    VALUES (v_id_camper, p_telefono, 'movil', TRUE);
    
    INSERT INTO Acudiente (id_camper, nombres, telefono, email)
    VALUES (v_id_camper, p_acudiente_nombre, p_acudiente_telefono, p_email);
    
    COMMIT;
END //
DELIMITER ;

-- 2. Actualizar estado de camper
DELIMITER //
CREATE PROCEDURE sp_actualizar_estado_camper(
    IN p_id_camper INT,
    IN p_nuevo_estado VARCHAR(50),
    IN p_motivo VARCHAR(255)
)
BEGIN
    DECLARE v_estado_anterior INT;
    DECLARE v_estado_nuevo INT;
    
    SELECT id_estado INTO v_estado_anterior
    FROM Camper WHERE id_camper = p_id_camper;
    
    SELECT id_estado INTO v_estado_nuevo
    FROM Estado_camper WHERE estado_camper = p_nuevo_estado;
    
    START TRANSACTION;
    
    UPDATE Camper 
    SET id_estado = v_estado_nuevo
    WHERE id_camper = p_id_camper;
    
    INSERT INTO Historial_Estado_Camper 
    (id_camper, id_estado_anterior, id_estado_nuevo, fecha_cambio, motivo)
    VALUES (p_id_camper, v_estado_anterior, v_estado_nuevo, NOW(), p_motivo);
    
    COMMIT;
END //
DELIMITER ;

-- 3. Procesar inscripción
DELIMITER //
CREATE PROCEDURE sp_inscribir_camper(
    IN p_id_camper INT,
    IN p_id_ruta INT
)
BEGIN
    DECLARE v_cupos_disponibles INT;
    
    SELECT (a.capacidad - COUNT(DISTINCT gca.id_camper)) INTO v_cupos_disponibles
    FROM AreaEntrenamiento a
    JOIN Asignacion_Salon_Horario ash ON a.id_area = ash.id_area
    JOIN Grupo_Campers gc ON ash.id_salon = gc.id_salon
    LEFT JOIN Grupo_Camper_Asignacion gca ON gc.id_grupo = gca.id_grupo
    WHERE gc.id_ruta = p_id_ruta
    GROUP BY a.id_area;
    
    IF v_cupos_disponibles > 0 THEN
        START TRANSACTION;
        
        INSERT INTO Inscripcion (
            id_camper, 
            id_ruta, 
            fecha_inscripcion, 
            id_estado_inscripcion
        )
        VALUES (
            p_id_camper, 
            p_id_ruta, 
            NOW(), 
            1
        );
        
        CALL sp_actualizar_estado_camper(p_id_camper, 'Inscrito', 'Inscripción procesada');
        
        COMMIT;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay cupos disponibles en esta ruta';
    END IF;
END //
DELIMITER ;

-- 4. Registrar evaluación
DELIMITER //
CREATE PROCEDURE sp_registrar_evaluacion(
    IN p_id_inscripcion INT,
    IN p_id_modulo INT,
    IN p_nota_teorica DECIMAL(5,2),
    IN p_nota_practica DECIMAL(5,2),
    IN p_nota_quizzes DECIMAL(5,2)
)
BEGIN
    DECLARE v_nota_final DECIMAL(5,2);
    
    SET v_nota_final = (p_nota_teorica * 0.3) + (p_nota_practica * 0.4) + (p_nota_quizzes * 0.3);
    
    INSERT INTO Evaluacion (
        id_inscripcion,
        id_modulo,
        nota_teorica,
        nota_practica,
        nota_trabajos_quizzes,
        nota_final
    )
    VALUES (
        p_id_inscripcion,
        p_id_modulo,
        p_nota_teorica,
        p_nota_practica,
        p_nota_quizzes,
        v_nota_final
    );
    
    -- Actualizar nivel de riesgo del camper
    UPDATE Camper c
    JOIN Inscripcion i ON c.id_camper = i.id_camper
    SET c.nivel_riesgo = CASE
        WHEN v_nota_final < 60 THEN 'Alto'
        WHEN v_nota_final < 75 THEN 'Medio'
        ELSE 'Bajo'
    END
    WHERE i.id_inscripcion = p_id_inscripcion;
END //
DELIMITER ;

-- 5. Calcular nota final automáticamente
DELIMITER //
CREATE PROCEDURE sp_calcular_nota_final_modulo(
    IN p_id_inscripcion INT,
    IN p_id_modulo INT
)
BEGIN
    DECLARE v_nota_final DECIMAL(5,2);
    
    SELECT 
        (nota_teorica * 0.3 + nota_practica * 0.4 + nota_trabajos_quizzes * 0.3)
    INTO v_nota_final
    FROM Evaluacion
    WHERE id_inscripcion = p_id_inscripcion 
    AND id_modulo = p_id_modulo;
    
    UPDATE Evaluacion
    SET nota_final = v_nota_final
    WHERE id_inscripcion = p_id_inscripcion 
    AND id_modulo = p_id_modulo;
END //
DELIMITER ;

-- 6. Asignar campers a ruta
DELIMITER //
CREATE PROCEDURE sp_asignar_campers_ruta(
    IN p_id_ruta INT
)
BEGIN
    DECLARE v_area_id INT;
    DECLARE v_grupo_id INT;
    
    -- Crear nuevo grupo si es necesario
    INSERT INTO Grupo_Campers (id_ruta, fecha_creacion)
    VALUES (p_id_ruta, NOW());
    
    SET v_grupo_id = LAST_INSERT_ID();
    
    -- Asignar campers aprobados al grupo
    INSERT INTO Grupo_Camper_Asignacion (id_grupo, id_camper)
    SELECT v_grupo_id, c.id_camper
    FROM Camper c
    JOIN Inscripcion i ON c.id_camper = i.id_camper
    WHERE i.id_ruta = p_id_ruta
    AND c.id_estado = (SELECT id_estado FROM Estado_camper WHERE estado_camper = 'Aprobado');
END //
DELIMITER ;

-- 7. Asignar trainer a ruta
DELIMITER //
CREATE PROCEDURE sp_asignar_trainer_ruta(
    IN p_id_entrenador INT,
    IN p_id_ruta INT,
    IN p_id_area INT,
    IN p_hora_inicio TIME,
    IN p_hora_fin TIME
)
BEGIN
    DECLARE v_choque_horario BOOLEAN;
    
    -- Verificar choque de horarios
    SELECT COUNT(*) > 0 INTO v_choque_horario
    FROM Asignacion_Entrenador_Ruta aer
    JOIN Horario_Clase h ON aer.id_horario = h.id_horario
    WHERE aer.id_entrenador = p_id_entrenador
    AND ((p_hora_inicio BETWEEN h.hora_inicio AND h.hora_fin)
    OR (p_hora_fin BETWEEN h.hora_inicio AND h.hora_fin));
    
    IF NOT v_choque_horario THEN
        INSERT INTO Asignacion_Entrenador_Ruta (
            id_entrenador,
            id_ruta,
            id_area,
            fecha_asignacion
        )
        VALUES (
            p_id_entrenador,
            p_id_ruta,
            p_id_area,
            NOW()
        );
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Existe un choque de horarios para este trainer';
    END IF;
END //
DELIMITER ;

-- 8. Registrar nueva ruta
DELIMITER //
CREATE PROCEDURE sp_registrar_ruta(
    IN p_nombre_ruta VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_id_sgdb_principal INT
)
BEGIN
    DECLARE v_id_ruta INT;
    
    START TRANSACTION;
    
    INSERT INTO RutaEntrenamiento (
        nombre_ruta,
        descripcion,
        id_sgdb_principal
    )
    VALUES (
        p_nombre_ruta,
        p_descripcion,
        p_id_sgdb_principal
    );
    
    SET v_id_ruta = LAST_INSERT_ID();
    
    COMMIT;
END //
DELIMITER ;

-- 9. Registrar área de entrenamiento
DELIMITER //
CREATE PROCEDURE sp_registrar_area(
    IN p_nombre_area VARCHAR(100),
    IN p_capacidad INT,
    IN p_descripcion TEXT
)
BEGIN
    INSERT INTO AreaEntrenamiento (
        nombre_area,
        capacidad,
        descripcion
    )
    VALUES (
        p_nombre_area,
        p_capacidad,
        p_descripcion
    );
END //
DELIMITER ;

-- 10. Consultar disponibilidad de área
DELIMITER //
CREATE PROCEDURE sp_consultar_disponibilidad_area(
    IN p_id_area INT,
    IN p_fecha DATE
)
BEGIN
    SELECT 
        h.hora_inicio,
        h.hora_fin,
        CASE 
            WHEN ash.id_salon IS NULL THEN 'Disponible'
            ELSE 'Ocupado'
        END as estado
    FROM Horario_Clase h
    LEFT JOIN Asignacion_Salon_Horario ash ON h.id_horario = ash.id_horario
    AND ash.id_area = p_id_area
    AND ash.fecha = p_fecha
    ORDER BY h.hora_inicio;
END //
DELIMITER ;

-- 11. Reasignar camper por bajo rendimiento
DELIMITER //
CREATE PROCEDURE sp_reasignar_camper_bajo_rendimiento(
    IN p_id_camper INT,
    IN p_nueva_ruta INT
)
BEGIN
    DECLARE v_promedio DECIMAL(5,2);
    
    SELECT AVG(nota_final) INTO v_promedio
    FROM Evaluacion e
    JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
    WHERE i.id_camper = p_id_camper;
    
    IF v_promedio < 60 THEN
        START TRANSACTION;
        
        -- Actualizar inscripción actual
        UPDATE Inscripcion
        SET fecha_fin = NOW()
        WHERE id_camper = p_id_camper
        AND fecha_fin IS NULL;
        
        -- Crear nueva inscripción
        INSERT INTO Inscripcion (
            id_camper,
            id_ruta,
            fecha_inscripcion,
            id_estado_inscripcion
        )
        VALUES (
            p_id_camper,
            p_nueva_ruta,
            NOW(),
            1
        );
        
        COMMIT;
    END IF;
END //
DELIMITER ;

-- 12. Graduar camper
DELIMITER //
CREATE PROCEDURE sp_graduar_camper(
    IN p_id_camper INT
)
BEGIN
    DECLARE v_modulos_totales INT;
    DECLARE v_modulos_aprobados INT;
    
    SELECT COUNT(DISTINCT m.id_modulo) INTO v_modulos_totales
    FROM Inscripcion i
    JOIN RutaEntrenamiento r ON i.id_ruta = r.id_ruta
    JOIN Ruta_Skill rs ON r.id_ruta = rs.id_ruta
    JOIN Modulo m ON rs.id_skill = m.id_skill
    WHERE i.id_camper = p_id_camper;
    
    SELECT COUNT(DISTINCT e.id_modulo) INTO v_modulos_aprobados
    FROM Evaluacion e
    JOIN Inscripcion i ON e.id_inscripcion = i.id_inscripcion
    WHERE i.id_camper = p_id_camper
    AND e.nota_final >= 60;
    
    IF v_modulos_aprobados = v_modulos_totales THEN
        CALL sp_actualizar_estado_camper(p_id_camper, 'Graduado', 'Completó todos los módulos');
    END IF;
END //
DELIMITER ;

-- 13. Exportar rendimiento camper
DELIMITER //
CREATE PROCEDURE sp_exportar_rendimiento_camper(
    IN p_id_camper INT
)
BEGIN
    SELECT 
        c.nombres,
        c.apellidos,
        r.nombre_ruta,
        m.nombre_modulo,
        e.nota_teorica,
        e.nota_practica,
        e.nota_trabajos_quizzes,
        e.nota_final,
        e.fecha_evaluacion
    FROM Camper c
    JOIN Inscripcion i ON c.id_camper = i.id_camper
    JOIN RutaEntrenamiento r ON i.id_ruta = r.id_ruta
    JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
    JOIN Modulo m ON e.id_modulo = m.id_modulo
    WHERE c.id_camper = p_id_camper
    ORDER BY e.fecha_evaluacion;
END //
DELIMITER ;

-- 14. Registrar asistencia
DELIMITER //
CREATE PROCEDURE sp_registrar_asistencia(
    IN p_id_camper INT,
    IN p_id_area INT,
    IN p_fecha DATE,
    IN p_asistio BOOLEAN
)
BEGIN
    INSERT INTO Asistencia (
        id_camper,
        id_area,
        fecha,
        asistio
    )
    VALUES (
        p_id_camper,
        p_id_area,
        p_fecha,
        p_asistio
    );
END //
DELIMITER ;

-- 15. Generar reporte mensual
DELIMITER //
CREATE PROCEDURE sp_reporte_mensual_notas(
    IN p_id_ruta INT,
    IN p_mes INT,
    IN p_año INT
)
BEGIN
    SELECT 
        r.nombre_ruta,
        m.nombre_modulo,
        COUNT(DISTINCT e.id_inscripcion) as total_evaluaciones,
        AVG(e.nota_final) as promedio,
        MIN(e.nota_final) as nota_minima,
        MAX(e.nota_final) as nota_maxima
    FROM RutaEntrenamiento r
    JOIN Inscripcion i ON r.id_ruta = i.id_ruta
    JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
    JOIN Modulo m ON e.id_modulo = m.id_modulo
    WHERE r.id_ruta = p_id_ruta
    AND MONTH(e.fecha_evaluacion) = p_mes
    AND YEAR(e.fecha_evaluacion) = p_año
    GROUP BY r.nombre_ruta, m.nombre_modulo;
END //
DELIMITER ;

-- 16. Asignar salón
DELIMITER //
CREATE PROCEDURE sp_asignar_salon(
    IN p_id_ruta INT,
    IN p_id_salon INT
)
BEGIN
    DECLARE v_capacidad_salon INT;
    DECLARE v_campers_inscritos INT;
    
    SELECT capacidad INTO v_capacidad_salon
    FROM Salon
    WHERE id_salon = p_id_salon;
    
    SELECT COUNT(*) INTO v_campers_inscritos
    FROM Inscripcion
    WHERE id_ruta = p_id_ruta
    AND fecha_fin IS NULL;
    
    IF v_campers_inscritos <= v_capacidad_salon THEN
        INSERT INTO Asignacion_Salon_Horario (
            id_salon,
            id_ruta,
            fecha_asignacion
        )
        VALUES (
            p_id_salon,
            p_id_ruta,
            NOW()
        );
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La capacidad del salón es insuficiente';
    END IF;
END //
DELIMITER ;

-- 17. Cambiar horario trainer
DELIMITER //
CREATE PROCEDURE sp_cambiar_horario_trainer(
    IN p_id_entrenador INT,
    IN p_id_horario_actual INT,
    IN p_id_horario_nuevo INT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM Asignacion_Entrenador_Ruta 
        WHERE id_entrenador = p_id_entrenador 
        AND id_horario = p_id_horario_nuevo
    ) THEN
        UPDATE Asignacion_Entrenador_Ruta
        SET id_horario = p_id_horario_nuevo
        WHERE id_entrenador = p_id_entrenador
        AND id_horario = p_id_horario_actual;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El trainer ya tiene asignado este horario';
    END IF;
END //
DELIMITER ;

-- 18. Eliminar inscripción
DELIMITER //
CREATE PROCEDURE sp_eliminar_inscripcion(
    IN p_id_camper INT,
    IN p_motivo VARCHAR(255)
)
BEGIN
    START TRANSACTION;
    
    UPDATE Inscripcion
    SET fecha_fin = NOW(),
        motivo_retiro = p_motivo
    WHERE id_camper = p_id_camper
    AND fecha_fin IS NULL;
    
    CALL sp_actualizar_estado_camper(p_id_camper, 'Retirado', p_motivo);
    
    COMMIT;
END //
DELIMITER ;

-- 19. Recalcular estados
DELIMITER //
CREATE PROCEDURE sp_recalcular_estados_campers()
BEGIN
    UPDATE Camper c
    JOIN (
        SELECT 
            i.id_camper,
            AVG(e.nota_final) as promedio
        FROM Inscripcion i
        JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
        GROUP BY i.id_camper
    ) notas ON c.id_camper = notas.id_camper
    SET c.nivel_riesgo = CASE
        WHEN notas.promedio < 60 THEN 'Alto'
        WHEN notas.promedio < 75 THEN 'Medio'
        ELSE 'Bajo'
    END;
END //
DELIMITER ;

-- 20. Asignar horarios automáticamente
DELIMITER //
CREATE PROCEDURE sp_asignar_horarios_automaticos(
    IN p_id_ruta INT
)
BEGIN
    DECLARE v_id_entrenador INT;
    DECLARE v_id_horario INT;
    
    -- Seleccionar trainer disponible
    SELECT e.id_entrenador INTO v_id_entrenador
    FROM Entrenador e
    LEFT JOIN Asignacion_Entrenador_Ruta aer ON e.id_entrenador = aer.id_entrenador
    GROUP BY e.id_entrenador
    HAVING COUNT(aer.id_ruta) < 3
    LIMIT 1;
    
    -- Seleccionar horario disponible
    SELECT h.id_horario INTO v_id_horario
    FROM Horario_Clase h
    LEFT JOIN Asignacion_Entrenador_Ruta aer ON h.id_horario = aer.id_horario
    WHERE aer.id_horario IS NULL
    LIMIT 1;
    
    IF v_id_entrenador IS NOT NULL AND v_id_horario IS NOT NULL THEN
        INSERT INTO Asignacion_Entrenador_Ruta (
            id_entrenador,
            id_ruta,
            id_horario,
            fecha_asignacion
        )
        VALUES (
            v_id_entrenador,
            p_id_ruta,
            v_id_horario,
            NOW()
        );
    END IF;
END //
DELIMITER ;
