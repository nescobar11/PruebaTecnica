using ClientesApi.DTOs;

namespace ClientesApi.Services
{
    /// <summary>
    /// Contrato de la lógica de negocio relacionada con clientes.
    /// </summary>
    public interface IClienteService
    {
        /// <summary>
        /// Obtiene los datos de un cliente a partir de su número de identificación.
        /// Devuelve null si el cliente no existe.
        /// </summary>
        Task<ClienteDto?> ObtenerClientePorIdentificacionAsync(string numeroIdentificacion);
    }
}
