using ClientesApi.DTOs;
using ClientesApi.Repositories;

namespace ClientesApi.Services
{
    /// <summary>
    /// Implementación de la lógica de negocio para la consulta de clientes.
    /// </summary>
    public class ClienteService : IClienteService
    {
        private readonly IClienteRepository _clienteRepository;
        private readonly ILogger<ClienteService> _logger;

        public ClienteService(IClienteRepository clienteRepository, ILogger<ClienteService> logger)
        {
            _clienteRepository = clienteRepository;
            _logger = logger;
        }

        public async Task<ClienteDto?> ObtenerClientePorIdentificacionAsync(string numeroIdentificacion)
        {
            if (string.IsNullOrWhiteSpace(numeroIdentificacion))
            {
                throw new ArgumentException("El número de identificación es requerido.", nameof(numeroIdentificacion));
            }

            _logger.LogInformation("Consultando cliente con identificación {Identificacion}", numeroIdentificacion);

            var cliente = await _clienteRepository.ObtenerPorIdentificacionAsync(numeroIdentificacion);

            if (cliente is null)
            {
                return null;
            }

            return new ClienteDto
            {
                Id = cliente.Id,
                TipoIdentificacion = cliente.TipoIdentificacion,
                NumeroIdentificacion = cliente.NumeroIdentificacion,
                Nombres = cliente.Nombres,
                Apellidos = cliente.Apellidos,
                FechaNacimiento = cliente.FechaNacimiento,
                Direccion = cliente.Direccion,
                Telefono = cliente.Telefono,
                Email = cliente.Email
            };
        }
    }
}
