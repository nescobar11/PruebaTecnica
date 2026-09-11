/* =========================================================
   PRUEBA TECNICA BACKEND
   Script 2: Stored Procedure para obtener los datos del cliente
             por su número de identificación
   SQL Server 2019
   ========================================================= */

USE DBClientes;
GO

IF OBJECT_ID(N'dbo.sp_ObtenerCliente', N'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ObtenerCliente;
GO

CREATE PROCEDURE dbo.sp_ObtenerCliente
    @NumeroIdentificacion VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        Id,
        TipoIdentificacion,
        NumeroIdentificacion,
        Nombres,
        Apellidos,
        FechaNacimiento,
        Direccion,
        Telefono,
        Email,
        FechaCreacion,
        Activo
    FROM dbo.Clientes
    WHERE NumeroIdentificacion = @NumeroIdentificacion
      AND Activo = 1;
END
GO
