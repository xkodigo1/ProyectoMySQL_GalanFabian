-- A. Triggers sobre Evaluacion

-- 1. Calcular nota final automáticamente (BEFORE INSERT en Evaluacion)
DELIMITER //
CREATE TRIGGER calcular_nota_final
BEFORE INSERT ON Evaluacion
FOR EACH ROW
BEGIN
    SET NEW.nota_final = (NEW.nota_teorica * 0.3) + 
                         (NEW.nota_practica * 0.6) + 
                         (NEW.nota_trabajos_quizzes * 0.1);
END //
DELIMITER ;

-- 2. Marcar bajo rendimiento (AFTER INSERT en Evaluacion)
DELIMITER //
CREATE TRIGGER marcar_bajo_rendimiento
AFTER INSERT ON Evaluacion
FOR EACH ROW
BEGIN
    IF NEW.nota_final < 60 THEN
        UPDATE Camper c
        JOIN Inscripcion i ON c.id_camper = i.id_camper
        SET c.nivel_riesgo = 'Alto'
        WHERE i.id_inscripcion = NEW.id_inscripcion;
    END IF;
END //
DELIMITER ;

-- 3. Verificar aprobación del módulo (AFTER UPDATE en Evaluacion)
DELIMITER //
CREATE TRIGGER verificar_aprobacion
AFTER UPDATE ON Evaluacion
FOR EACH ROW
BEGIN
    IF NEW.nota_final >= 60 THEN
        UPDATE Inscripcion 
        SET estado_modulo = 'Aprobado'
        WHERE id_inscripcion = NEW.id_inscripcion;
    ELSE
        UPDATE Inscripcion 
        SET estado_modulo = 'Reprobado'
        WHERE id_inscripcion = NEW.id_inscripcion;
    END IF;
END //
DELIMITER ;

-- 4. Recalcular promedio al actualizar evaluación (AFTER UPDATE en Evaluacion)
DELIMITER //
CREATE TRIGGER actualizar_promedio
AFTER UPDATE ON Evaluacion
FOR EACH ROW
BEGIN
    DECLARE promedio DECIMAL(5,2);
    
    SELECT AVG(nota_final) INTO promedio
    FROM Evaluacion
    WHERE id_inscripcion = NEW.id_inscripcion;
    
    UPDATE Inscripcion
    SET promedio_actual = promedio
    WHERE id_inscripcion = NEW.id_inscripcion;
END //
DELIMITER ;

-- B. Triggers sobre Inscripcion

-- 5. Actualizar estado al inscribir (AFTER INSERT en Inscripcion)
DELIMITER //
CREATE TRIGGER actualizar_estado_inscripcion
AFTER INSERT ON Inscripcion
FOR EACH ROW
BEGIN
    UPDATE Camper
    SET id_estado = (SELECT id_estado FROM Estado_camper WHERE estado_camper = 'Inscrito')
    WHERE id_camper = NEW.id_camper;
END //
DELIMITER ;

-- 6. Marcar como retirado (AFTER DELETE en Inscripcion)
DELIMITER //
CREATE TRIGGER marcar_retirado
AFTER DELETE ON Inscripcion
FOR EACH ROW
BEGIN
    UPDATE Camper
    SET id_estado = (SELECT id_estado FROM Estado_camper WHERE estado_camper = 'Retirado')
    WHERE id_camper = OLD.id_camper;
END //
DELIMITER ;

-- 7. Actualizar módulos al cambiar ruta (AFTER UPDATE en Inscripcion)
DELIMITER //
CREATE TRIGGER actualizar_modulos_ruta
AFTER UPDATE ON Inscripcion
FOR EACH ROW
BEGIN
    IF NEW.id_ruta != OLD.id_ruta THEN
        DELETE FROM Evaluacion WHERE id_inscripcion = NEW.id_inscripcion;
        INSERT INTO Evaluacion (id_inscripcion, id_modulo)
        SELECT NEW.id_inscripcion, m.id_modulo
        FROM Modulo m
        JOIN Ruta_Skill rs ON m.id_skill = rs.id_skill
        WHERE rs.id_ruta = NEW.id_ruta;
    END IF;
END //
DELIMITER ;

-- C. Trigger sobre Camper

-- 8. Mover a egresados (AFTER UPDATE en Camper)
DELIMITER //
CREATE TRIGGER mover_a_egresados
AFTER UPDATE ON Camper
FOR EACH ROW
BEGIN
    IF NEW.id_estado = (SELECT id_estado FROM Estado_camper WHERE estado_camper = 'Graduado')
       AND OLD.id_estado != NEW.id_estado THEN
        INSERT INTO Egresado (id_camper, fecha_graduacion)
        VALUES (NEW.id_camper, CURRENT_DATE());
    END IF;
END //
DELIMITER ;

-- D. Triggers sobre Entrenador

-- 9. Verificar duplicados de trainer (BEFORE INSERT en Entrenador)
DELIMITER //
CREATE TRIGGER verificar_trainer_duplicado
BEFORE INSERT ON Entrenador
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Entrenador WHERE numero_identificacion = NEW.numero_identificacion) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe un trainer con este número de identificación';
    END IF;
END //
DELIMITER ;

-- 10. Liberar horarios al eliminar trainer (BEFORE DELETE en Entrenador)
DELIMITER //
CREATE TRIGGER liberar_asignaciones_trainer
BEFORE DELETE ON Entrenador
FOR EACH ROW
BEGIN
    DELETE FROM Disponibilidad_Entrenador WHERE id_entrenador = OLD.id_entrenador;
    DELETE FROM Asignacion_Entrenador_Ruta WHERE id_entrenador = OLD.id_entrenador;
END //
DELIMITER ;

-- E. Trigger sobre Disponibilidad_Entrenador

-- 11. Verificar solapamiento de horarios (BEFORE INSERT en Disponibilidad_Entrenador)
DELIMITER //
CREATE TRIGGER verificar_solapamiento
BEFORE INSERT ON Disponibilidad_Entrenador
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM Disponibilidad_Entrenador
        WHERE id_entrenador = NEW.id_entrenador
          AND ((NEW.hora_inicio BETWEEN hora_inicio AND hora_fin)
            OR (NEW.hora_fin BETWEEN hora_inicio AND hora_fin))
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Existe solapamiento de horarios';
    END IF;
END //
DELIMITER ;

-- F. Trigger sobre Modulo

-- 12. Registrar SGDB asociado (AFTER INSERT en Modulo)
DELIMITER //
CREATE TRIGGER registrar_sgdb_modulo
AFTER INSERT ON Modulo
FOR EACH ROW
BEGIN
    INSERT INTO Modulo_SGDB (id_modulo, id_sgdb, es_principal)
    SELECT NEW.id_modulo, id_sgdb, TRUE
    FROM SistemaGestorBaseDatos
    WHERE es_default = TRUE
    LIMIT 1;
END //
DELIMITER ;

-- G. Trigger sobre RutaEntrenamiento

-- 13. Notificar cambios en ruta (AFTER UPDATE en RutaEntrenamiento)
DELIMITER //
CREATE TRIGGER notificar_cambios_ruta
AFTER UPDATE ON RutaEntrenamiento
FOR EACH ROW
BEGIN
    INSERT INTO Notificacion_Cambio_Ruta (id_ruta, tipo_cambio, descripcion)
    VALUES (NEW.id_ruta, 'Actualización', CONCAT('Se actualizó la ruta: ', NEW.nombre_ruta));
END //
DELIMITER ;
