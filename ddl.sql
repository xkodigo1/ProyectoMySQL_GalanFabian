CampusLands

CREATE DATABASE campusmanagement;

USE campusmanagement;

-- 1. Campus: Registra las sedes o ubicaciones de Campuslands.
CREATE TABLE Campus (
    id_campus INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    region VARCHAR(50),
    direccion VARCHAR(150)
);

-- 2. Estado_camper: Define los estados posibles de un camper.
CREATE TABLE Estado_camper (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL,
    estado_camper ENUM('En proceso de ingreso', 'Inscrito', 'Aprobado', 'Cursando', 'Graduado', 'Expulsado', 'Retirado')
);

-- 3. Camper: Información básica del estudiante.
CREATE TABLE Camper (
    id_camper INT AUTO_INCREMENT PRIMARY KEY,
    numero_identificacion VARCHAR(20) NOT NULL,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    id_campus INT,
    id_estado INT,
    nivel_riesgo ENUM('Bajo', 'Medio', 'Alto') DEFAULT 'Bajo',
    CONSTRAINT fk_camper_campus FOREIGN KEY (id_campus) REFERENCES Campus(id_campus),
    CONSTRAINT fk_camper_estado FOREIGN KEY (id_estado) REFERENCES Estado_camper(id_estado)
);

-- 4. Acudiente: Registra información del acudiente de cada camper.
CREATE TABLE Acudiente (
    id_acudiente INT AUTO_INCREMENT PRIMARY KEY,
    id_camper INT,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(80),
    parentesco VARCHAR(30),
    CONSTRAINT fk_acudiente_camper FOREIGN KEY (id_camper) REFERENCES Camper(id_camper) ON DELETE CASCADE
);

-- 5. Direccion: Normaliza la dirección en una tabla separada.
CREATE TABLE Direccion (
    id_direccion INT AUTO_INCREMENT PRIMARY KEY,
    id_camper INT,
    calle VARCHAR(100),
    ciudad VARCHAR(50),
    departamento VARCHAR(50),
    codigo_postal VARCHAR(10),
    pais VARCHAR(30),
    CONSTRAINT fk_direccion_camper FOREIGN KEY (id_camper) REFERENCES Camper(id_camper) ON DELETE CASCADE
);

-- 6. SistemaGestorBaseDatos: Define los SGDB disponibles para las rutas.
CREATE TABLE SistemaGestorBaseDatos (
    id_sgdb INT AUTO_INCREMENT PRIMARY KEY,
    nombre_sgdb VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150)
);

-- 7. RutaEntrenamiento: Define las rutas o itinerarios.
CREATE TABLE RutaEntrenamiento (
    id_ruta INT AUTO_INCREMENT PRIMARY KEY,
    nombre_ruta VARCHAR(80) NOT NULL,
    descripcion VARCHAR(200),
    id_sgdb_principal INT,   -- Clave foránea a SistemaGestorBaseDatos
    id_sgdb_alternativo INT,  -- Clave foránea a SistemaGestorBaseDatos
    CONSTRAINT fk_ruta_sgdb_principal FOREIGN KEY (id_sgdb_principal) REFERENCES SistemaGestorBaseDatos(id_sgdb),
    CONSTRAINT fk_ruta_sgdb_alternativo FOREIGN KEY (id_sgdb_alternativo) REFERENCES SistemaGestorBaseDatos(id_sgdb)
);

-- 8. Estado_Inscripcion: Estados para la inscripción de un camper a una ruta.
CREATE TABLE Estado_Inscripcion (
    id_estado_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL,
    estado_inscripcion ENUM('Activa', 'Completada', 'Cancelada') DEFAULT 'Activa'
);

-- 9. Inscripcion: Registra la matrícula de un camper en una ruta.
CREATE TABLE Inscripcion (
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_camper INT,
    id_ruta INT,
    fecha_inscripcion DATE,
    id_estado_inscripcion INT,
    CONSTRAINT fk_inscripcion_camper FOREIGN KEY (id_camper) REFERENCES Camper(id_camper),
    CONSTRAINT fk_inscripcion_ruta FOREIGN KEY (id_ruta) REFERENCES RutaEntrenamiento(id_ruta),
    CONSTRAINT fk_inscripcion_estado FOREIGN KEY (id_estado_inscripcion) REFERENCES Estado_Inscripcion(id_estado_inscripcion)
);

-- 10. Modulo: Cada ruta se compone de varios módulos o cursos.
CREATE TABLE Modulo (
    id_modulo INT AUTO_INCREMENT PRIMARY KEY,
    id_ruta INT,
    nombre_modulo VARCHAR(80) NOT NULL,
    descripcion VARCHAR(200),
    duracion INT,         -- Ej.: duración en horas o semanas
    secuencia INT,        -- Orden del módulo en la ruta
    peso_teorico DECIMAL(5,2) DEFAULT 30.00,
    peso_practico DECIMAL(5,2) DEFAULT 60.00,
    peso_quizzes DECIMAL(5,2) DEFAULT 10.00,
    CONSTRAINT fk_modulo_ruta FOREIGN KEY (id_ruta) REFERENCES RutaEntrenamiento(id_ruta),
    CONSTRAINT chk_pesos_modulo CHECK (peso_teorico + peso_practico + peso_quizzes = 100.00)
);

-- 11. Evaluacion: Registra las evaluaciones de cada módulo.
CREATE TABLE Evaluacion (
    id_evaluacion INT AUTO_INCREMENT PRIMARY KEY,
    id_inscripcion INT,
    id_modulo INT,
    fecha_evaluacion DATE,
    nota_teorica DECIMAL(5,2),         -- 30%
    nota_practica DECIMAL(5,2),        -- 60%
    nota_trabajos_quizzes DECIMAL(5,2),  -- 10%
    calificacion_final DECIMAL(5,2),     -- Calculada: (nota_teorica*0.3 + nota_practica*0.6 + nota_trabajos_quizzes*0.1)
    CONSTRAINT fk_evaluacion_inscripcion FOREIGN KEY (id_inscripcion) REFERENCES Inscripcion(id_inscripcion),
    CONSTRAINT fk_evaluacion_modulo FOREIGN KEY (id_modulo) REFERENCES Modulo(id_modulo),
    CONSTRAINT chk_nota_teorica CHECK (nota_teorica >= 0 AND nota_teorica <= 100),
    CONSTRAINT chk_nota_practica CHECK (nota_practica >= 0 AND nota_practica <= 100),
    CONSTRAINT chk_nota_quizzes CHECK (nota_trabajos_quizzes >= 0 AND nota_trabajos_quizzes <= 100)
);

-- 12. AreaEntrenamiento: Define las áreas de especialización.
CREATE TABLE AreaEntrenamiento (
    id_area INT AUTO_INCREMENT PRIMARY KEY,
    nombre_area VARCHAR(80) NOT NULL,
    descripcion VARCHAR(200),
    capacidad_maxima INT DEFAULT 33,  -- Capacidad máxima por área
    estado ENUM('Activo', 'Inactivo', 'Mantenimiento') DEFAULT 'Activo',
    ocupacion_actual INT DEFAULT 0,
    CONSTRAINT chk_ocupacion CHECK (ocupacion_actual <= capacidad_maxima)
);

-- 13. Salon: Registra la información de salones o aulas.
CREATE TABLE Salon (
    id_salon INT AUTO_INCREMENT PRIMARY KEY,
    nombre_salon VARCHAR(50) NOT NULL,
    ubicacion VARCHAR(150)
);

-- 14. Horario_Clase: Define franjas horarias para las clases.
CREATE TABLE Horario_Clase (
    id_horario INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(100),  -- Ejemplo: "08:00-12:00"
    hora_inicio TIME,
    hora_fin TIME,
    dia_semana ENUM('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo')
);

-- 15. Asignacion_Salon_Horario: Relaciona salones con horarios para áreas de entrenamiento.
CREATE TABLE Asignacion_Salon_Horario (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_salon INT,
    id_horario INT,
    id_area INT,  -- Área de entrenamiento a la que se asigna este salón y horario
    CONSTRAINT fk_asig_salon FOREIGN KEY (id_salon) REFERENCES Salon(id_salon),
    CONSTRAINT fk_asig_horario FOREIGN KEY (id_horario) REFERENCES Horario_Clase(id_horario),
    CONSTRAINT fk_asig_area FOREIGN KEY (id_area) REFERENCES AreaEntrenamiento(id_area)
);

-- 16. Entrenador: Información de los entrenadores.
CREATE TABLE Entrenador (
    id_entrenador INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    email VARCHAR(80),
    id_campus INT,
    CONSTRAINT fk_entrenador_campus FOREIGN KEY (id_campus) REFERENCES Campus(id_campus)
);

-- 17. Entrenador_Area: Relación muchos a muchos entre entrenadores y áreas de entrenamiento.
CREATE TABLE Entrenador_Area (
    id_entrenador INT,
    id_area INT,
    PRIMARY KEY (id_entrenador, id_area),
    CONSTRAINT fk_entrenador_area_entrenador FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id_entrenador),
    CONSTRAINT fk_entrenador_area_area FOREIGN KEY (id_area) REFERENCES AreaEntrenamiento(id_area)
);

-- 18. Asignacion_Entrenador_Ruta: Asigna entrenadores a rutas con un horario específico.
CREATE TABLE Asignacion_Entrenador_Ruta (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_entrenador INT,
    id_ruta INT,
    id_horario INT,  -- Referencia a un horario definido en Horario_Clase
    CONSTRAINT fk_asignacion_entrenador FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id_entrenador),
    CONSTRAINT fk_asignacion_ruta FOREIGN KEY (id_ruta) REFERENCES RutaEntrenamiento(id_ruta),
    CONSTRAINT fk_asignacion_horario FOREIGN KEY (id_horario) REFERENCES Horario_Clase(id_horario)
);

-- 19. Telefono_Camper: Múltiples números de contacto para un Camper.
CREATE TABLE Telefono_Camper (
    id_telefono INT AUTO_INCREMENT PRIMARY KEY,
    id_camper INT,
    numero VARCHAR(20) NOT NULL,
    tipo ENUM('movil', 'fijo', 'trabajo', 'otro') DEFAULT 'movil',
    es_principal BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_telefono_camper FOREIGN KEY (id_camper) REFERENCES Camper(id_camper) ON DELETE CASCADE
);

-- 20. Telefono_Entrenador: Múltiples números de contacto para un Entrenador.
CREATE TABLE Telefono_Entrenador (
    id_telefono INT AUTO_INCREMENT PRIMARY KEY,
    id_entrenador INT,
    numero VARCHAR(20) NOT NULL,
    tipo ENUM('movil', 'fijo', 'trabajo', 'otro') DEFAULT 'movil',
    es_principal BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_telefono_entrenador FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id_entrenador) ON DELETE CASCADE
);

-- 21. Historial_Estado_Camper: Registra los cambios históricos en el estado de cada camper.
CREATE TABLE Historial_Estado_Camper (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_camper INT,
    id_estado INT,
    fecha_cambio DATETIME,
    observaciones VARCHAR(255),
    CONSTRAINT fk_historial_camper FOREIGN KEY (id_camper) REFERENCES Camper(id_camper),
    CONSTRAINT fk_historial_estado FOREIGN KEY (id_estado) REFERENCES Estado_camper(id_estado)
);

-- 22. Sesion_Clase: Registra las sesiones de clase asociadas a un módulo y un horario.
CREATE TABLE Sesion_Clase (
    id_sesion INT AUTO_INCREMENT PRIMARY KEY,
    id_modulo INT,
    id_horario INT,
    fecha_sesion DATE,
    tema VARCHAR(150),
    CONSTRAINT fk_sesion_modulo FOREIGN KEY (id_modulo) REFERENCES Modulo(id_modulo),
    CONSTRAINT fk_sesion_horario FOREIGN KEY (id_horario) REFERENCES Horario_Clase(id_horario)
);

-- 23. Material_Educativo: Contiene los materiales educativos asociados a cada módulo.
CREATE TABLE Material_Educativo (
    id_material INT AUTO_INCREMENT PRIMARY KEY,
    id_modulo INT,
    titulo VARCHAR(150),
    descripcion TEXT,
    url_material VARCHAR(255),
    CONSTRAINT fk_material_modulo FOREIGN KEY (id_modulo) REFERENCES Modulo(id_modulo)
);

-- 24. Usuario: Registra los usuarios del sistema (administradores, entrenadores, campers, acudientes).
CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(30) NOT NULL,
    contrasena VARCHAR(128) NOT NULL,
    rol ENUM('admin','entrenador','camper','acudiente') NOT NULL,
    email VARCHAR(80)
);

-- 25. Notificacion: Notificaciones enviadas a los usuarios.
CREATE TABLE Notificacion (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    mensaje TEXT,
    fecha_notificacion DATETIME,
    leido BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_notificacion_usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

-- Tabla para registro de asistencia
CREATE TABLE Asistencia (
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

-- Tabla para egresados (graduados)
CREATE TABLE Egresado (
    id_egresado INT AUTO_INCREMENT PRIMARY KEY,
    id_camper INT,
    fecha_graduacion DATE,
    comentarios TEXT,
    CONSTRAINT fk_egresado_camper FOREIGN KEY (id_camper) REFERENCES Camper(id_camper)
);

-- Tabla para notificaciones específicas a trainers
CREATE TABLE Notificacion_Trainer (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_entrenador INT,
    id_ruta INT,
    mensaje TEXT,
    fecha_notificacion DATETIME,
    leido BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_notificacion_entrenador FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id_entrenador),
    CONSTRAINT fk_notificacion_ruta FOREIGN KEY (id_ruta) REFERENCES RutaEntrenamiento(id_ruta)
);

-- Tabla para grupos de campers (nueva)
CREATE TABLE Grupo_Campers (
    id_grupo INT AUTO_INCREMENT PRIMARY KEY,
    nombre_grupo VARCHAR(50) NOT NULL,
    id_ruta INT NOT NULL,
    fecha_creacion DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_grupo_ruta FOREIGN KEY (id_ruta) REFERENCES RutaEntrenamiento(id_ruta)
);

-- Tabla de asignación de campers a grupos (nueva)
CREATE TABLE Grupo_Camper_Asignacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_grupo INT NOT NULL,
    id_camper INT NOT NULL,
    fecha_asignacion DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_asignacion_grupo FOREIGN KEY (id_grupo) REFERENCES Grupo_Campers(id_grupo),
    CONSTRAINT fk_asignacion_camper FOREIGN KEY (id_camper) REFERENCES Camper(id_camper),
    UNIQUE (id_grupo, id_camper)
);

-- Agregar tabla de competencias para entrenadores
CREATE TABLE Competencia (
    id_competencia INT AUTO_INCREMENT PRIMARY KEY,
    nombre_competencia VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(200)
);

-- Tabla de relación entre entrenadores y competencias
CREATE TABLE Entrenador_Competencia (
    id_entrenador INT,
    id_competencia INT,
    PRIMARY KEY (id_entrenador, id_competencia),
    CONSTRAINT fk_entrenador_competencia_entrenador FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id_entrenador),
    CONSTRAINT fk_entrenador_competencia_competencia FOREIGN KEY (id_competencia) REFERENCES Competencia(id_competencia)
);

-- Agregar asignación de entrenador a grupo
CREATE TABLE Asignacion_Entrenador_Grupo (
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

-- Agregar tabla de disponibilidad de entrenadores
CREATE TABLE Disponibilidad_Entrenador (
    id_disponibilidad INT AUTO_INCREMENT PRIMARY KEY,
    id_entrenador INT NOT NULL,
    dia_semana ENUM('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo'),
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    CONSTRAINT fk_disponibilidad_entrenador FOREIGN KEY (id_entrenador) REFERENCES Entrenador(id_entrenador),
    CONSTRAINT chk_hora_disponibilidad CHECK (hora_fin > hora_inicio)
);
