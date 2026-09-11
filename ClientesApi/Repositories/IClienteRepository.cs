using ClientesApi.Models;

namespace ClientesApi.Repositories
{
    /// <summary>
    /// Contrato para el acceso a datos de clientes.
    /// </summary>
    public interface IClienteRepository
    {
        /// <summary>
        /// Obtiene un cliente por su número de identificación invocando el
        /// stored procedure sp_ObtenerCliente.
        /// </summary>
        Task<Cliente?> ObtenerPorIdentificacionAsync(string numeroIdentificacion);
    }
}
