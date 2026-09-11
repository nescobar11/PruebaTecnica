# API de Clientes — Prueba Técnica Backend

Web API en **.NET 6** que consulta los datos de un cliente por su número de
identificación en **SQL Server 2019**, estructurada en capas y documentada
con **Swagger**.

## Arquitectura (modelo en capas)

```
ClientesApi/
├── Controllers/        → API: controladores y endpoints
│   └── ClientesController.cs
├── Services/            → Lógica de negocio
│   ├── IClienteService.cs
│   └── ClienteService.cs
├── Repositories/        → Acceso a datos con Entity Framework Core
│   ├── IClienteRepository.cs
│   └── ClienteRepository.cs
├── DTOs/                 → Objetos de transferencia de datos
│   └── ClienteDto.cs
├── Models/               → Entidades EF Core
│   └── Cliente.cs
├── Data/                 → DbContext
│   └── ClientesDbContext.cs
├── Database/             → Scripts SQL
│   ├── 01_CrearBaseDeDatosYTabla.sql
│   ├── 02_StoredProcedure.sql
│   └── 03_DatosDePrueba.sql
├── Program.cs
├── appsettings.json
└── ClientesApi.csproj
```

## 1. Base de datos

Ejecutar en SQL Server 2019 Management Studio, en orden:

1. `Database/01_CrearBaseDeDatosYTabla.sql` — crea la base de datos `DBClientes`
   y la tabla `Clientes`.
2. `Database/02_StoredProcedure.sql` — crea `sp_ObtenerCliente`, que recibe
   `@NumeroIdentificacion` y devuelve los datos del cliente.
3. `Database/03_DatosDePrueba.sql` (opcional) — inserta 3 clientes de ejemplo
   para probar el endpoint.

## 2. Configurar la cadena de conexión

Editar `appsettings.json` (o `appsettings.Development.json`) y ajustar
`ConnectionStrings:DBClientes` según tu instancia de SQL Server:

```json
"ConnectionStrings": {
  "DBClientes": "Server=TU_SERVIDOR;Database=DBClientes;Trusted_Connection=True;TrustServerCertificate=True;"
}
```

Si usas autenticación SQL en vez de Windows:

```
Server=TU_SERVIDOR;Database=DBClientes;User Id=usuario;Password=clave;TrustServerCertificate=True;
```

## 3. Ejecutar el proyecto

### Desde Visual Studio 2022
1. Abrir `ClientesApi.csproj` (o crear una solución `.sln` que lo contenga).
2. Restaurar paquetes NuGet (se restauran automáticamente al abrir).
3. Presionar `F5` / `Iniciar` (perfil IIS Express o Kestrel).
4. El navegador abrirá Swagger automáticamente en la raíz `/`.

### Desde línea de comandos
```bash
cd ClientesApi
dotnet restore
dotnet run

## 4. Endpoint

```
GET /api/clientes/{identificacion}
```

**Ejemplo:**
```
GET /api/clientes/1234567890
```

**Respuesta 200 (cliente encontrado):**
```json
{
  "exito": true,
  "mensaje": "Cliente encontrado.",
  "datos": {
    "id": 1,
    "tipoIdentificacion": "CC",
    "numeroIdentificacion": "1234567890",
    "nombres": "Juan Carlos",
    "apellidos": "Pérez Gómez",
    "fechaNacimiento": "1990-05-14T00:00:00",
    "direccion": "Calle 10 # 20-30",
    "telefono": "3001234567",
    "email": "juan.perez@example.com"
  }
}
```

**Respuesta 404 (cliente no existe):**
```json
{
  "exito": false,
  "mensaje": "No se encontró un cliente con la identificación '000'."
}
```

## Notas técnicas

- El acceso a datos usa **Entity Framework Core** (`FromSqlRaw`) para invocar
  el stored procedure `sp_ObtenerCliente`, evitando SQL dinámico y protegiendo
  contra inyección SQL mediante parámetros tipados (`SqlParameter`).
- La capa **Services** contiene la lógica de negocio y el mapeo de la entidad
  `Cliente` al `ClienteDto` expuesto por la API.
- El controlador maneja los códigos de estado HTTP: `200 OK`, `400 BadRequest`,
  `404 NotFound` y `500 InternalServerError`.
- Swagger está habilitado en todos los entornos y configurado en la ruta raíz
  (`/`) para facilitar la prueba de la API.
