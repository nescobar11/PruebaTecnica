/* =========================================================
   PRUEBA TECNICA BACKEND
   Script 3: Datos de prueba para la tabla Clientes
   SQL Server 2019
   ========================================================= */

USE DBClientes;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Clientes WHERE NumeroIdentificacion = '1234567890')
BEGIN
    INSERT INTO dbo.Clientes (TipoIdentificacion, NumeroIdentificacion, Nombres, Apellidos, FechaNacimiento, Direccion, Telefono, Email)
    VALUES ('CC', '1234567890', 'Juan Carlos', 'Pérez Gómez', '1990-05-14', 'Calle 10 # 20-30', '3001234567', 'juan.perez@example.com');
END

IF NOT EXISTS (SELECT 1 FROM dbo.Clientes WHERE NumeroIdentificacion = '9876543210')
BEGIN
    INSERT INTO dbo.Clientes (TipoIdentificacion, NumeroIdentificacion, Nombres, Apellidos, FechaNacimiento, Direccion, Telefono, Email)
    VALUES ('CC', '9876543210', 'María Fernanda', 'López Rodríguez', '1985-11-02', 'Carrera 45 # 12-08', '3109876543', 'maria.lopez@example.com');
END

IF NOT EXISTS (SELECT 1 FROM dbo.Clientes WHERE NumeroIdentificacion = '800123456')
BEGIN
    INSERT INTO dbo.Clientes (TipoIdentificacion, NumeroIdentificacion, Nombres, Apellidos, FechaNacimiento, Direccion, Telefono, Email)
    VALUES ('NIT', '800123456', 'Empresa', 'Ejemplo S.A.S.', NULL, 'Avenida 68 # 90-15', '6017654321', 'contacto@empresaejemplo.com');
END
GO

-- Prueba rápida del stored procedure
-- EXEC dbo.sp_ObtenerCliente @NumeroIdentificacion = '1234567890';
