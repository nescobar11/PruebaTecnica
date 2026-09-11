/* =========================================================
   PRUEBA TECNICA BACKEND
   Script 1: Creación de la base de datos DBClientes y tabla Clientes
   SQL Server 2019
   ========================================================= */

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'DBClientes')
BEGIN
    CREATE DATABASE DBClientes;
END
GO

USE DBClientes;
GO

IF OBJECT_ID(N'dbo.Clientes', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Clientes
    (
        Id                   INT IDENTITY(1,1)  NOT NULL,
        TipoIdentificacion   VARCHAR(20)         NOT NULL,
        NumeroIdentificacion VARCHAR(20)         NOT NULL,
        Nombres              VARCHAR(100)        NOT NULL,
        Apellidos            VARCHAR(100)        NOT NULL,
        FechaNacimiento      DATE                NULL,
        Direccion            VARCHAR(200)        NULL,
        Telefono             VARCHAR(20)         NULL,
        Email                VARCHAR(100)        NULL,
        FechaCreacion        DATETIME            NOT NULL CONSTRAINT DF_Clientes_FechaCreacion DEFAULT (GETDATE()),
        Activo               BIT                 NOT NULL CONSTRAINT DF_Clientes_Activo DEFAULT (1),

        CONSTRAINT PK_Clientes PRIMARY KEY CLUSTERED (Id ASC),
        CONSTRAINT UQ_Clientes_NumeroIdentificacion UNIQUE (NumeroIdentificacion)
    );
END
GO
