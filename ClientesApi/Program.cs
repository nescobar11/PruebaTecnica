using ClientesApi.Data;
using ClientesApi.Repositories;
using ClientesApi.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Controladores
builder.Services.AddControllers();

// Entity Framework Core - SQL Server
builder.Services.AddDbContext<ClientesDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DBClientes")));

// Inyección de dependencias - capas Repository y Service
builder.Services.AddScoped<IClienteRepository, ClienteRepository>();
builder.Services.AddScoped<IClienteService, ClienteService>();

// Swagger / OpenAPI
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "API de Clientes",
        Version = "v1",
        Description = "Prueba técnica backend - Consulta de clientes por número de identificación (.NET 6 Web API + SQL Server)."
    });
});

// CORS (permite pruebas desde cualquier origen; ajustar en producción)
builder.Services.AddCors(options =>
{
    options.AddPolicy("PermitirTodo", policy =>
    {
        policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
    });
});

var app = builder.Build();

// Swagger habilitado siempre para efectos de la prueba técnica
app.UseSwagger();
app.UseSwaggerUI(options =>
{
    options.SwaggerEndpoint("/swagger/v1/swagger.json", "API de Clientes v1");
    options.RoutePrefix = string.Empty; // Swagger disponible en la raíz "/"
});

app.UseHttpsRedirection();

app.UseCors("PermitirTodo");

app.UseAuthorization();

app.MapControllers();

app.Run();
