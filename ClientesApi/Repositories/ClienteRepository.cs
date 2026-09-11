using ClientesApi.Data;
using ClientesApi.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace ClientesApi.Repositories
{
    /// <summary>
    /// Implementación del repositorio de clientes usando Entity Framework Core.
    /// La consulta se realiza a través del stored procedure sp_ObtenerCliente.
    /// </summary>
    public class ClienteRepository : IClienteRepository
    {
        private readonly ClientesDbContext _context;

        public ClienteRepository(ClientesDbContext context)
        {
            _context = context;
        }

        public async Task<Cliente?> ObtenerPorIdentificacionAsync(string numeroIdentificacion)
        {
            var parametro = new SqlParameter("@NumeroIdentificacion", numeroIdentificacion);

            // Se invoca el stored procedure a través de EF Core (FromSqlRaw)
            // y se materializa el resultado como una entidad sin tracking.
            var cliente = await _context.Clientes
                .FromSqlRaw("EXEC sp_ObtenerCliente @NumeroIdentificacion", parametro)
                .AsNoTracking()
                .FirstOrDefaultAsync();

            return cliente;
        }
    }
}
