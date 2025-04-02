CREATE DATABASE IF NOT EXISTS campus_db;
USE campus_db;

-- ======================================================
-- 1. TABLAS BASE (Sin dependencias)
-- ======================================================

-- 1.1 Campus
CREATE TABLE IF NOT EXISTS Campus (
    id_campus INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    region VARCHAR(50),
    direccion VARCHAR(150)
);

-- 1.2 Estado_camper
CREATE TABLE IF NOT EXISTS Estado_camper (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL,
    estado_camper ENUM(
        'En proceso de ingreso', 'Inscrito', 'Aprobado', 'Cursando', 
        'Graduado', 'Expulsado', 'Retirado', 'Bajo_Rendimiento', 'En_Riesgo'
    )
);

-- 1.3 SistemaGestorBaseDatos
CREATE TABLE IF NOT EXISTS SistemaGestorBaseDatos (
    id_sgdb INT AUTO_INCREMENT PRIMARY KEY,
    nombre_sgdb VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150)
);

-- 1.4 AreaEntrenamiento
CREATE TABLE IF NOT EXISTS AreaEntrenamiento (
    id_area INT AUTO_INCREMENT PRIMARY KEY,
    nombre_area VARCHAR(50) NOT NULL,
    descripcion TEXT,
    capacidad INT NOT NULL DEFAULT 33,
    estado ENUM('Activo', 'Inactivo') DEFAULT 'Activo'
);

-- 1.5 Salon
CREATE TABLE IF NOT EXISTS Salon (
    id_salon INT AUTO_INCREMENT PRIMARY KEY,
    nombre_salon VARCHAR(50) NOT NULL,
    capacidad INT NOT NULL,
    CONSTRAINT chk_capacidad CHECK (capacidad > 0)
);

-- 1.6 Horario_Clase
CREATE TABLE IF NOT EXISTS Horario_Clase (
    id_horario INT AUTO_INCREMENT PRIMARY KEY,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    CONSTRAINT chk_horario CHECK (hora_fin > hora_inicio)
);

-- 1.7 Skill
CREATE TABLE IF NOT EXISTS Skill (
    id_skill INT AUTO_INCREMENT PRIMARY KEY,
    nombre_skill VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- 1.8 Estado_Inscripcion
CREATE TABLE IF NOT EXISTS Estado_Inscripcion (
    id_estado_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL,
    estado_inscripcion ENUM('Activa', 'Completada', 'Cancelada') DEFAULT 'Activa'
);

-- 1.9 Competencia
CREATE TABLE IF NOT EXISTS Competencia (
    id_competencia INT AUTO_INCREMENT PRIMARY KEY,
    nombre_competencia VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(200)
);

-- 1.10 Usuario
CREATE TABLE IF NOT EXISTS Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol ENUM('admin', 'trainer', 'camper') NOT NULL
);

-- 1.11 Plantilla_Ruta
CREATE TABLE IF NOT EXISTS Plantilla_Ruta (
    id_plantilla INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT,
    estado ENUM('Activa', 'Inactiva') DEFAULT 'Activa'
);

-- ======================================================
-- 2. TABLAS CON DEPENDENCIAS PRIMARIAS
-- ======================================================

-- 2.1 Camper
CREATE TABLE IF NOT EXISTS Camper (
    id_camper INT AUTO_INCREMENT PRIMARY KEY,
    numero_identificacion VARCHAR(20) NOT NULL UNIQUE,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    id_campus INT,
    id_estado INT,
    nivel_riesgo ENUM('Bajo', 'Medio', 'Alto') DEFAULT 'Bajo',
    CONSTRAINT fk_camper_campus FOREIGN KEY (id_campus) REFERENCES Campus(id_campus),
    CONSTRAINT fk_camper_estado FOREIGN KEY (id_estado) REFERENCES Estado_camper(id_estado)
);

-- 2.2 Entrenador
CREATE TABLE IF NOT EXISTS Entrenador (
    id_entrenador INT AUTO_INCREMENT PRIMARY KEY,
    numero_identificacion VARCHAR(20) NOT NULL UNIQUE,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    especialidad VARCHAR(100)
);

-- 2.3 RutaEntrenamiento
CREATE TABLE IF NOT EXISTS RutaEntrenamiento (
    id_ruta INT AUTO_INCREMENT PRIMARY KEY,
    nombre_ruta VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    id_sgdb_principal INT,
    id_sgdb_alternativo INT,
    CONSTRAINT fk_ruta_sgdb_principal FOREIGN KEY (id_sgdb_principal) REFERENCES SistemaGestorBaseDatos(id_sgdb),
    CONSTRAINT fk_ruta_sgdb_alternativo FOREIGN KEY (id_sgdb_alternativo) REFERENCES SistemaGestorBaseDatos(id_sgdb)
);

-- ======================================================
-- 3. TABLAS CON DEPENDENCIAS SECUNDARIAS
-- ======================================================

-- 3.1 Modulo
CREATE TABLE IF NOT EXISTS Modulo (
    id_modulo INT AUTO_INCREMENT PRIMARY KEY,
    id_skill INT,
    nombre_modulo VARCHAR(100) NOT NULL,
    descripcion TEXT,
    duracion INT,
    estado ENUM('Activo', 'Inactivo', 'En_Revision') DEFAULT 'Activo',
    CONSTRAINT fk_modulo_skill FOREIGN KEY (id_skill) REFERENCES Skill(id_skill)
);

-- 3.2 Acudiente
CREATE TABLE IF NOT EXISTS Acudiente (
    id_acudiente INT AUTO_INCREMENT PRIMARY KEY,
    id_camper INT,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(80),
    parentesco VARCHAR(30),
    CONSTRAINT fk_acudiente_camper FOREIGN KEY (id_camper) REFERENCES Camper(id_camper) ON DELETE CASCADE
);

-- 3.3 Direccion
CREATE TABLE IF NOT EXISTS Direccion (
    id_direccion INT AUTO_INCREMENT PRIMARY KEY,
    id_camper INT,
    calle VARCHAR(100),
    ciudad VARCHAR(50),
    departamento VARCHAR(50),
    codigo_postal VARCHAR(10),
    pais VARCHAR(30),
    CONSTRAINT fk_direccion_camper FOREIGN KEY (id_camper) REFERENCES Camper(id_camper) ON DELETE CASCADE
);

-- 3.4 Inscripcion
CREATE TABLE IF NOT EXISTS Inscripcion (
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_camper INT,
    id_ruta INT,
    fecha_inscripcion DATE,
    id_estado_inscripcion INT,
    promedio_general DECIMAL(5,2),
    CONSTRAINT fk_inscripcion_camper FOREIGN KEY (id_camper) REFERENCES Camper(id_camper),
    CONSTRAINT fk_inscripcion_ruta FOREIGN KEY (id_ruta) REFERENCES RutaEntrenamiento(id_ruta),
    CONSTRAINT fk_inscripcion_estado FOREIGN KEY (id_estado_inscripcion) REFERENCES Estado_Inscripcion(id_estado_inscripcion)
);

-- 3.5 Grupo_Campers
CREATE TABLE IF NOT EXISTS Grupo_Campers (
    id_grupo INT AUTO_INCREMENT PRIMARY KEY,
    nombre_grupo VARCHAR(50) NOT NULL,
    id_ruta INT NOT NULL,
    fecha_creacion DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_grupo_ruta FOREIGN KEY (id_ruta) REFERENCES RutaEntrenamiento(id_ruta)
);

-- 3.6 Telefono_Camper
CREATE TABLE IF NOT EXISTS Telefono_Camper (
    id_telefono INT AUTO_INCREMENT PRIMARY KEY,
    id_camper INT,
    numero VARCHAR(20) NOT NULL,
    tipo ENUM('movil', 'fijo', 'trabajo', 'otro') DEFAULT 'movil',
    es_principal BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_telefono_camper FOREIGN KEY (id_camper) REFERENCES Camper(id_camper) ON DELETE CASCADE
);

-- 3.7 Telefono_Entrenador
CREATE TABLE IF NOT EXISTS Telefono_Entrenador (
    id_telefono INT AUTO_INCREMENT PRIMARY KEY,
    id_entrenador INT,
    numero VARCHAR(20) NOT NULL,
    tipo ENUM('movil', 'fijo', 'trabajo', 'otro') DEFAULT 'movil',
    es_principal BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_telefono_entrenador FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id_entrenador)
);

-- 3.8 Historial_Estado_Camper
CREATE TABLE IF NOT EXISTS Historial_Estado_Camper (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_camper INT,
    id_estado_anterior INT,
    id_estado_nuevo INT,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    motivo TEXT,
    CONSTRAINT fk_historial_camper FOREIGN KEY (id_camper) REFERENCES Camper(id_camper),
    CONSTRAINT fk_historial_estado_anterior FOREIGN KEY (id_estado_anterior) REFERENCES Estado_camper(id_estado),
    CONSTRAINT fk_historial_estado_nuevo FOREIGN KEY (id_estado_nuevo) REFERENCES Estado_camper(id_estado)
);

-- 3.9 Entrenador_Area
CREATE TABLE IF NOT EXISTS Entrenador_Area (
    id_entrenador INT,
    id_area INT,
    PRIMARY KEY (id_entrenador, id_area),
    CONSTRAINT fk_entrenador_area_entrenador FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id_entrenador),
    CONSTRAINT fk_entrenador_area_area FOREIGN KEY (id_area) REFERENCES AreaEntrenamiento(id_area)
);

-- 3.10 Asignacion_Entrenador_Ruta
CREATE TABLE IF NOT EXISTS Asignacion_Entrenador_Ruta (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_entrenador INT,
    id_ruta INT,
    id_horario INT,
    CONSTRAINT fk_asignacion_entrenador FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id_entrenador),
    CONSTRAINT fk_asignacion_ruta FOREIGN KEY (id_ruta) REFERENCES RutaEntrenamiento(id_ruta),
    CONSTRAINT fk_asignacion_horario FOREIGN KEY (id_horario) REFERENCES Horario_Clase(id_horario)
);

-- 3.11 Asignacion_Salon_Horario
CREATE TABLE IF NOT EXISTS Asignacion_Salon_Horario (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_salon INT,
    id_horario INT,
    id_area INT,
    CONSTRAINT fk_asignacion_salon FOREIGN KEY (id_salon) REFERENCES Salon(id_salon),
    CONSTRAINT fk_asignacion_horario_clase FOREIGN KEY (id_horario) REFERENCES Horario_Clase(id_horario),
    CONSTRAINT fk_asignacion_area FOREIGN KEY (id_area) REFERENCES AreaEntrenamiento(id_area)
);

-- ======================================================
-- 4. TABLAS CON DEPENDENCIAS TERCIARIAS
-- ======================================================

-- 4.1 Evaluacion
CREATE TABLE IF NOT EXISTS Evaluacion (
    id_evaluacion INT AUTO_INCREMENT PRIMARY KEY,
    id_inscripcion INT,
    id_modulo INT,
    fecha_evaluacion DATE,
    nota_teorica DECIMAL(5,2),
    nota_practica DECIMAL(5,2),
    nota_trabajos_quizzes DECIMAL(5,2),
    nota_final DECIMAL(5,2) AS (nota_teorica * 0.3 + nota_practica * 0.6 + nota_trabajos_quizzes * 0.1) STORED,
    CONSTRAINT fk_evaluacion_inscripcion FOREIGN KEY (id_inscripcion) REFERENCES Inscripcion(id_inscripcion),
    CONSTRAINT fk_evaluacion_modulo FOREIGN KEY (id_modulo) REFERENCES Modulo(id_modulo),
    CONSTRAINT chk_nota_teorica CHECK (nota_teorica >= 0 AND nota_teorica <= 100),
    CONSTRAINT chk_nota_practica CHECK (nota_practica >= 0 AND nota_practica <= 100),
    CONSTRAINT chk_nota_quizzes CHECK (nota_trabajos_quizzes >= 0 AND nota_trabajos_quizzes <= 100)
);

-- 4.2 Seccion
CREATE TABLE IF NOT EXISTS Seccion (
    id_seccion INT AUTO_INCREMENT PRIMARY KEY,
    id_modulo INT,
    nombre_seccion VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha DATE,
    hora_inicio TIME,
    duracion DECIMAL(5,2),
    CONSTRAINT fk_seccion_modulo FOREIGN KEY (id_modulo) REFERENCES Modulo(id_modulo)
);

-- 4.3 Material_Educativo
CREATE TABLE IF NOT EXISTS Material_Educativo (
    id_material INT AUTO_INCREMENT PRIMARY KEY,
    id_modulo INT,
    titulo VARCHAR(150),
    descripcion TEXT,
    url_material VARCHAR(255),
    CONSTRAINT fk_material_modulo FOREIGN KEY (id_modulo) REFERENCES Modulo(id_modulo)
);

-- 4.4 Sesion_Clase
CREATE TABLE IF NOT EXISTS Sesion_Clase (
    id_sesion INT AUTO_INCREMENT PRIMARY KEY,
    id_modulo INT,
    id_horario INT,
    fecha_sesion DATE,
    tema VARCHAR(150),
    CONSTRAINT fk_sesion_modulo FOREIGN KEY (id_modulo) REFERENCES Modulo(id_modulo),
    CONSTRAINT fk_sesion_horario FOREIGN KEY (id_horario) REFERENCES Horario_Clase(id_horario)
);

-- 4.5 Asistencia
CREATE TABLE IF NOT EXISTS Asistencia (
    id_asistencia INT AUTO_INCREMENT PRIMARY KEY,
    id_camper INT,
    id_sesion INT,
    fecha_registro DATETIME,
    estado_asistencia ENUM('Presente', 'Ausente', 'Tardanza') DEFAULT 'Ausente',
    hora_llegada TIME NULL,
    justificacion TEXT,
    url_evidencia VARCHAR(255),
    CONSTRAINT fk_asistencia_camper FOREIGN KEY (id_camper) REFERENCES Camper(id_camper),
    CONSTRAINT fk_asistencia_sesion FOREIGN KEY (id_sesion) REFERENCES Sesion_Clase(id_sesion)
);

-- ======================================================
-- 5. TABLAS DE RELACIÓN Y GESTIÓN
-- ======================================================

-- 5.1 Grupo_Camper_Asignacion
CREATE TABLE IF NOT EXISTS Grupo_Camper_Asignacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_grupo INT NOT NULL,
    id_camper INT NOT NULL,
    fecha_asignacion DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_asignacion_grupo FOREIGN KEY (id_grupo) REFERENCES Grupo_Campers(id_grupo),
    CONSTRAINT fk_asignacion_camper FOREIGN KEY (id_camper) REFERENCES Camper(id_camper),
    UNIQUE (id_grupo, id_camper)
);

-- 5.2 Asignacion_Entrenador_Grupo
CREATE TABLE IF NOT EXISTS Asignacion_Entrenador_Grupo (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_entrenador INT NOT NULL,
    id_grupo INT NOT NULL,
    id_area INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    CONSTRAINT fk_asignacion_entrenador_grupo FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id_entrenador),
    CONSTRAINT fk_asignacion_grupo_grupo FOREIGN KEY (id_grupo) REFERENCES Grupo_Campers(id_grupo),
    CONSTRAINT fk_asignacion_grupo_area FOREIGN KEY (id_area) REFERENCES AreaEntrenamiento(id_area)
);

-- 5.3 Disponibilidad_Entrenador
CREATE TABLE IF NOT EXISTS Disponibilidad_Entrenador (
    id_disponibilidad INT AUTO_INCREMENT PRIMARY KEY,
    id_entrenador INT NOT NULL,
    dia_semana ENUM('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo'),
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    CONSTRAINT fk_disponibilidad_entrenador FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id_entrenador),
    CONSTRAINT chk_hora_disponibilidad CHECK (hora_fin > hora_inicio)
);

-- 5.4 Ruta_Skill
CREATE TABLE IF NOT EXISTS Ruta_Skill (
    id_ruta INT,
    id_skill INT,
    PRIMARY KEY (id_ruta, id_skill),
    CONSTRAINT fk_ruta_skill_ruta FOREIGN KEY (id_ruta) REFERENCES RutaEntrenamiento(id_ruta),
    CONSTRAINT fk_ruta_skill_skill FOREIGN KEY (id_skill) REFERENCES Skill(id_skill)
);

-- 5.5 Egresado
CREATE TABLE IF NOT EXISTS Egresado (
    id_egresado INT AUTO_INCREMENT PRIMARY KEY,
    id_camper INT,
    fecha_graduacion DATE,
    comentarios TEXT,
    CONSTRAINT fk_egresado_camper FOREIGN KEY (id_camper) REFERENCES Camper(id_camper)
);

-- 5.6 Entrenador_Competencia
CREATE TABLE IF NOT EXISTS Entrenador_Competencia (
    id_entrenador INT,
    id_competencia INT,
    PRIMARY KEY (id_entrenador, id_competencia),
    CONSTRAINT fk_entrenador_competencia_entrenador FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id_entrenador),
    CONSTRAINT fk_entrenador_competencia_competencia FOREIGN KEY (id_competencia) REFERENCES Competencia(id_competencia)
);

-- 5.7 Notificacion
CREATE TABLE IF NOT EXISTS Notificacion (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    mensaje TEXT,
    fecha_notificacion DATETIME,
    leido BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_notificacion_usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

-- 5.8 Notificacion_Trainer
CREATE TABLE IF NOT EXISTS Notificacion_Trainer (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_entrenador INT,
    id_ruta INT,
    mensaje TEXT,
    fecha_notificacion DATETIME,
    leido BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_notificacion_trainer_entrenador FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id_entrenador),
    CONSTRAINT fk_notificacion_trainer_ruta FOREIGN KEY (id_ruta) REFERENCES RutaEntrenamiento(id_ruta)
);

-- 5.9 Conocimiento_Trainer
CREATE TABLE IF NOT EXISTS Conocimiento_Trainer (
    id_entrenador INT,
    id_modulo INT,
    nivel_experiencia ENUM('Básico', 'Intermedio', 'Avanzado'),
    fecha_certificacion DATE,
    PRIMARY KEY (id_entrenador, id_modulo),
    CONSTRAINT fk_conocimiento_trainer_entrenador FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id_entrenador),
    CONSTRAINT fk_conocimiento_trainer_modulo FOREIGN KEY (id_modulo) REFERENCES Modulo(id_modulo)
);

-- 5.10 Plantilla_Modulo
CREATE TABLE IF NOT EXISTS Plantilla_Modulo (
    id_plantilla INT,
    id_modulo INT,
    orden INT,
    PRIMARY KEY (id_plantilla, id_modulo),
    CONSTRAINT fk_plantilla_modulo_plantilla FOREIGN KEY (id_plantilla) REFERENCES Plantilla_Ruta(id_plantilla),
    CONSTRAINT fk_plantilla_modulo_modulo FOREIGN KEY (id_modulo) REFERENCES Modulo(id_modulo)
);

-- 5.11 Modulo_SGDB
CREATE TABLE IF NOT EXISTS Modulo_SGDB (
    id_modulo INT,
    id_sgdb INT,
    es_principal BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (id_modulo, id_sgdb),
    CONSTRAINT fk_modulo_sgdb_modulo FOREIGN KEY (id_modulo) REFERENCES Modulo(id_modulo),
    CONSTRAINT fk_modulo_sgdb_sgdb FOREIGN KEY (id_sgdb) REFERENCES SistemaGestorBaseDatos(id_sgdb)
);

-- 5.12 Notificacion_Cambio_Ruta
CREATE TABLE IF NOT EXISTS Notificacion_Cambio_Ruta (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_ruta INT,
    id_entrenador INT,
    tipo_cambio VARCHAR(50),
    descripcion TEXT,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    leido BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_notificacion_cambio_ruta FOREIGN KEY (id_ruta) REFERENCES RutaEntrenamiento(id_ruta),
    CONSTRAINT fk_notificacion_cambio_entrenador FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id_entrenador)
);
