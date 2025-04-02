# Sistema de Gestión Campus - Base de Datos

## 📋 Descripción
Sistema de gestión de base de datos MySQL para administrar las operaciones de un campus de entrenamiento. Incluye gestión de campers, rutas de aprendizaje, evaluaciones, trainers y espacios físicos.

## 🗂 Estructura del Proyecto

```
📁 sql/
├── 📄 ddl.sql            # Definición de tablas
├── 📄 dml.sql            # Datos iniciales
├── 📄 dql_select.sql     # Consultas básicas
├── 📄 dql_joins.sql      # Consultas con JOIN
├── 📄 dql_subconsultas.sql   # Subconsultas
├── 📄 dql_procedimientos.sql # Procedimientos almacenados
├── 📄 dql_funciones.sql  # Funciones
└── 📄 dql_triggers.sql   # Triggers
```

## 🚀 Configuración Inicial

### Prerrequisitos
- MySQL Server 8.0 o superior
- Cliente MySQL o herramienta de administración (MySQL Workbench recomendado)

## 📚 Funcionalidades Principales

### Gestión de Campers
- Registro de nuevos campers
- Actualización de estados
- Control de asistencia
- Seguimiento académico

```sql
-- Registrar nuevo camper
CALL sp_registrar_camper('12345', 'Juan', 'Pérez', 1, '3001234567', 
    'juan@email.com', 'Calle 123', 'María Pérez', '3009876543');

-- Actualizar estado
CALL sp_actualizar_estado_camper(1, 'Inscrito', 'Completó registro');
```

### Evaluaciones y Notas
- Registro de evaluaciones
- Cálculo automático de notas finales
- Actualización de niveles de riesgo

```sql
-- Registrar evaluación
CALL sp_registrar_evaluacion(1, 1, 85.5, 90.0, 88.5);

-- Generar reporte mensual
CALL sp_reporte_mensual_notas(1, 3, 2024);
```

### Gestión de Rutas y Grupos
- Asignación de campers a rutas
- Gestión de cupos
- Control de capacidad en salones

```sql
-- Inscribir camper en ruta
CALL sp_inscribir_camper(1, 1);

-- Asignar salón
CALL sp_asignar_salon(1, 1);
```

### Administración de Trainers
- Asignación de horarios
- Control de disponibilidad
- Gestión de áreas de especialización

```sql
-- Asignar trainer a ruta
CALL sp_asignar_trainer_ruta(1, 1, 1, '08:00:00', '12:00:00');

-- Cambiar horario
CALL sp_cambiar_horario_trainer(1, 1, 2);
```

## 📊 Consultas Frecuentes

### Consultas Básicas
```sql
-- Ver campers activos
SELECT * FROM Camper WHERE id_estado = 4;

-- Ver rutas disponibles
SELECT * FROM RutaEntrenamiento;
```

### Reportes
```sql
-- Rendimiento por ruta
SELECT r.nombre_ruta, AVG(e.nota_final) as promedio
FROM RutaEntrenamiento r
JOIN Inscripcion i ON r.id_ruta = i.id_ruta
JOIN Evaluacion e ON i.id_inscripcion = e.id_inscripcion
GROUP BY r.nombre_ruta;
```

## ⚠️ Consideraciones Importantes

1. **Transacciones**: Los procedimientos incluyen control transaccional para mantener la integridad de los datos.

2. **Validaciones**: Se implementan validaciones para:
   - Cupos disponibles
   - Choques de horarios
   - Capacidad de salones
   - Requisitos de notas

3. **Niveles de Riesgo**: Se actualizan automáticamente basados en el rendimiento académico:
   - Alto: < 60
   - Medio: 60-74
   - Bajo: ≥ 75

4. **Respaldos**: Se recomienda realizar respaldos diarios de la base de datos.

## 🔒 Seguridad

- Implementar roles y permisos según necesidades
- Restringir acceso directo a tablas
- Usar procedimientos almacenados para operaciones críticas

## 📝 Mantenimiento

### Limpieza de Datos
```sql
-- Actualizar estados de campers
CALL sp_recalcular_estados_campers();

-- Verificar inscripciones activas
SELECT * FROM Inscripcion WHERE fecha_fin IS NULL;
```

### Optimización
- Índices creados en campos de búsqueda frecuente
- Procedimientos optimizados para mejor rendimiento
- Consultas diseñadas para uso eficiente de recursos

## 👥 Contribución
Para contribuir al proyecto:
1. Fork del repositorio
2. Crear rama para nueva característica
3. Commit con mensaje descriptivo
4. Push a la rama
5. Crear Pull Request

## 📄 Licencia
Este proyecto está bajo la Licencia MIT.
