/*
Prueba Técnica SQL Server
Base de datos: EmpresaDB
Incluye:
  1. Modelo y datos de prueba
  2. Consultas solicitadas
  3. Stored procedure y función
  4. Índice y backup/restore
*/

IF DB_ID(N'EmpresaDB') IS NULL
BEGIN
    CREATE DATABASE EmpresaDB;
END
GO

USE EmpresaDB;
GO

-- Limpieza para ejecución repetible
IF OBJECT_ID(N'dbo.EmpleadoProyecto', N'U') IS NOT NULL DROP TABLE dbo.EmpleadoProyecto;
IF OBJECT_ID(N'dbo.Empleados', N'U') IS NOT NULL DROP TABLE dbo.Empleados;
IF OBJECT_ID(N'dbo.Proyectos', N'U') IS NOT NULL DROP TABLE dbo.Proyectos;
IF OBJECT_ID(N'dbo.Departamentos', N'U') IS NOT NULL DROP TABLE dbo.Departamentos;
GO

CREATE TABLE dbo.Departamentos
(
    IdDepartamento INT IDENTITY(1,1) NOT NULL,
    Nombre         VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Departamentos PRIMARY KEY CLUSTERED (IdDepartamento),
    CONSTRAINT UQ_Departamentos_Nombre UNIQUE (Nombre)
);
GO

CREATE TABLE dbo.Empleados
(
    IdEmpleado     INT IDENTITY(1,1) NOT NULL,
    Nombre         VARCHAR(100) NOT NULL,
    Apellido       VARCHAR(100) NOT NULL,
    Email          VARCHAR(150) NOT NULL,
    FechaIngreso   DATE NOT NULL,
    IdDepartamento INT NOT NULL,
    CONSTRAINT PK_Empleados PRIMARY KEY CLUSTERED (IdEmpleado),
    CONSTRAINT UQ_Empleados_Email UNIQUE (Email),
    CONSTRAINT FK_Empleados_Departamentos
        FOREIGN KEY (IdDepartamento) REFERENCES dbo.Departamentos(IdDepartamento)
);
GO

CREATE TABLE dbo.Proyectos
(
    IdProyecto INT IDENTITY(1,1) NOT NULL,
    Nombre     VARCHAR(150) NOT NULL,
    Presupuesto DECIMAL(18,2) NOT NULL,
    FechaInicio DATE NOT NULL,
    CONSTRAINT PK_Proyectos PRIMARY KEY CLUSTERED (IdProyecto),
    CONSTRAINT UQ_Proyectos_Nombre UNIQUE (Nombre),
    CONSTRAINT CK_Proyectos_Presupuesto CHECK (Presupuesto >= 0)
);
GO

CREATE TABLE dbo.EmpleadoProyecto
(
    IdEmpleado INT NOT NULL,
    IdProyecto INT NOT NULL,
    FechaAsignacion DATE NOT NULL,
    CONSTRAINT PK_EmpleadoProyecto PRIMARY KEY CLUSTERED (IdEmpleado, IdProyecto),
    CONSTRAINT FK_EmpleadoProyecto_Empleado
        FOREIGN KEY (IdEmpleado) REFERENCES dbo.Empleados(IdEmpleado),
    CONSTRAINT FK_EmpleadoProyecto_Proyecto
        FOREIGN KEY (IdProyecto) REFERENCES dbo.Proyectos(IdProyecto)
);
GO

-- 5 registros por tabla
INSERT INTO dbo.Departamentos (Nombre)
VALUES
('Tecnología'),
('Recursos Humanos'),
('Finanzas'),
('Operaciones'),
('Marketing'),
('Legal'); -- departamento sin empleados para demostrar la consulta requerida
GO

INSERT INTO dbo.Empleados (Nombre, Apellido, Email, FechaIngreso, IdDepartamento)
VALUES
('Ana',    'Gómez',      'ana.gomez@empresa.com',      '2022-01-10', 1),
('Carlos', 'Rodríguez', 'carlos.rodriguez@empresa.com','2021-06-15', 1),
('Laura',  'Martínez',  'laura.martinez@empresa.com',  '2023-03-20', 2),
('Diego',  'Pérez',      'diego.perez@empresa.com',     '2020-11-02', 3),
('Sofía',  'García',     'sofia.garcia@empresa.com',    '2024-01-08', 4),
('Andrés', 'López',      'andres.lopez@empresa.com',    '2022-09-12', 5);
GO

INSERT INTO dbo.Proyectos (Nombre, Presupuesto, FechaInicio)
VALUES
('Migración Cloud',       150000.00, '2025-01-15'),
('Portal Corporativo',     80000.00, '2025-02-01'),
('Analítica de Datos',    120000.00, '2025-03-10'),
('Optimización Operativa', 95000.00, '2025-04-05'),
('Campaña Digital',        60000.00, '2025-05-20');
GO

INSERT INTO dbo.EmpleadoProyecto (IdEmpleado, IdProyecto, FechaAsignacion)
VALUES
(1, 1, '2025-01-15'),
(1, 2, '2025-02-01'),
(1, 3, '2025-03-10'),
(2, 1, '2025-01-15'),
(2, 2, '2025-02-01'),
(2, 3, '2025-03-10'),
(2, 4, '2025-04-05'),
(3, 2, '2025-02-01'),
(3, 5, '2025-05-20'),
(4, 3, '2025-03-10'),
(4, 4, '2025-04-05'),
(5, 4, '2025-04-05'),
(5, 5, '2025-05-20'),
(6, 5, '2025-05-20');
GO

-- =========================================================
-- 2. CONSULTAS SQL
-- =========================================================

-- 2.1 Todos los empleados con su departamento
SELECT
    e.IdEmpleado,
    e.Nombre,
    e.Apellido,
    e.Email,
    e.FechaIngreso,
    d.Nombre AS Departamento
FROM dbo.Empleados AS e
INNER JOIN dbo.Departamentos AS d
    ON d.IdDepartamento = e.IdDepartamento
ORDER BY e.Apellido, e.Nombre;
GO

-- 2.2 Proyectos con presupuesto y cantidad de empleados asignados
SELECT
    p.IdProyecto,
    p.Nombre AS Proyecto,
    p.Presupuesto,
    COUNT(ep.IdEmpleado) AS CantidadEmpleados
FROM dbo.Proyectos AS p
LEFT JOIN dbo.EmpleadoProyecto AS ep
    ON ep.IdProyecto = p.IdProyecto
GROUP BY p.IdProyecto, p.Nombre, p.Presupuesto
ORDER BY p.IdProyecto;
GO

-- 2.3empleados con más proyectos
SELECT TOP (3)
    e.IdEmpleado,
    CONCAT(e.Nombre, ' ', e.Apellido) AS Empleado,
    COUNT(ep.IdProyecto) AS TotalProyectos
FROM dbo.Empleados AS e
LEFT JOIN dbo.EmpleadoProyecto AS ep
    ON ep.IdEmpleado = e.IdEmpleado
GROUP BY e.IdEmpleado, e.Nombre, e.Apellido
ORDER BY TotalProyectos DESC, Empleado ASC;
GO

-- 2.4 Departamentos que no tienen empleados
SELECT
    d.IdDepartamento,
    d.Nombre AS Departamento
FROM dbo.Departamentos AS d
LEFT JOIN dbo.Empleados AS e
    ON e.IdDepartamento = d.IdDepartamento
WHERE e.IdEmpleado IS NULL
ORDER BY d.Nombre;
GO

-- 2.5 Empleados que participan en más de un proyecto
SELECT
    e.IdEmpleado,
    CONCAT(e.Nombre, ' ', e.Apellido) AS Empleado,
    COUNT(ep.IdProyecto) AS TotalProyectos
FROM dbo.Empleados AS e
INNER JOIN dbo.EmpleadoProyecto AS ep
    ON ep.IdEmpleado = e.IdEmpleado
GROUP BY e.IdEmpleado, e.Nombre, e.Apellido
HAVING COUNT(ep.IdProyecto) > 1
ORDER BY TotalProyectos DESC, Empleado ASC;
GO

-- =========================================================
-- 3. PROCEDIMIENTO Y FUNCIÓN
-- =========================================================

CREATE OR ALTER PROCEDURE dbo.sp_buscar_empleado
    @Nombre VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        e.IdEmpleado,
        e.Nombre,
        e.Apellido,
        e.Email,
        e.FechaIngreso,
        d.IdDepartamento,
        d.Nombre AS Departamento
    FROM dbo.Empleados AS e
    INNER JOIN dbo.Departamentos AS d
        ON d.IdDepartamento = e.IdDepartamento
    WHERE e.Nombre LIKE '%' + @Nombre + '%'
       OR e.Apellido LIKE '%' + @Nombre + '%'
    ORDER BY e.Apellido, e.Nombre;
END;
GO

CREATE OR ALTER FUNCTION dbo.fn_total_proyectos
(
    @IdEmpleado INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Total INT;

    SELECT @Total = COUNT(*)
    FROM dbo.EmpleadoProyecto
    WHERE IdEmpleado = @IdEmpleado;

    RETURN ISNULL(@Total, 0);
END;
GO

-- Ejemplos
EXEC dbo.sp_buscar_empleado @Nombre = 'Ana';
SELECT dbo.fn_total_proyectos(2) AS TotalProyectosEmpleado;
GO

-- =========================================================
-- 4. OPTIMIZACIÓN Y ADMINISTRACIÓN
-- =========================================================

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_Empleados_Apellido'
      AND object_id = OBJECT_ID(N'dbo.Empleados')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_Empleados_Apellido
        ON dbo.Empleados (Apellido);
END
GO

/*
BACKUP:
BACKUP DATABASE EmpresaDB
TO DISK = 'C:\Backups\EmpresaDB_FULL.bak'
WITH INIT, COMPRESSION, STATS = 10;

RESTORE:
RESTORE DATABASE EmpresaDB
FROM DISK = 'C:\Backups\EmpresaDB_FULL.bak'
WITH REPLACE, RECOVERY, STATS = 10;

*/

En producción se recomienda programar backups FULL y, según el modelo de recuperación,
backups diferenciales y de log, almacenándolos en una ubicación segura y verificando
periódicamente su restauración.
