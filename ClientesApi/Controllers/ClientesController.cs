using ClientesApi.DTOs;
using ClientesApi.Services;
using Microsoft.AspNetCore.Mvc;

namespace ClientesApi.Controllers
{
    /// <summary>
    /// Controlador que expone los endpoints relacionados con clientes.
    /// </summary>
    [ApiController]
    [Route("api/clientes")]
    [Produces("application/json")]
    public class ClientesController : ControllerBase
    {
        private readonly IClienteService _clienteService;
        private readonly ILogger<ClientesController> _logger;

        public ClientesController(IClienteService clienteService, ILogger<ClientesController> logger)
        {
            _clienteService = clienteService;
            _logger = logger;
        }

        /// <summary>
        /// Obtiene los datos de un cliente a partir de su número de identificación.
        /// </summary>
        /// <param name="identificacion">Número de identificación del cliente.</param>
        /// <returns>Los datos del cliente si existe.</returns>
        /// <response code="200">Cliente encontrado.</response>
        /// <response code="404">No existe un cliente con la identificación indicada.</response>
        /// <response code="400">La identificación enviada no es válida.</response>
        [HttpGet("{identificacion}")]
        [ProducesResponseType(typeof(ApiResponse<ClienteDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status404NotFound)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> ObtenerPorIdentificacion(string identificacion)
        {
            if (string.IsNullOrWhiteSpace(identificacion))
            {
                return BadRequest(new ApiResponse<object>
                {
                    Exito = false,
                    Mensaje = "Debe indicar el número de identificación del cliente."
                });
            }

            try
            {
                var cliente = await _clienteService.ObtenerClientePorIdentificacionAsync(identificacion);

                if (cliente is null)
                {
                    return NotFound(new ApiResponse<object>
                    {
                        Exito = false,
                        Mensaje = $"No se encontró un cliente con la identificación '{identificacion}'."
                    });
                }

                return Ok(new ApiResponse<ClienteDto>
                {
                    Exito = true,
                    Mensaje = "Cliente encontrado.",
                    Datos = cliente
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al consultar el cliente {Identificacion}", identificacion);
                return StatusCode(StatusCodes.Status500InternalServerError, new ApiResponse<object>
                {
                    Exito = false,
                    Mensaje = "Ocurrió un error al procesar la solicitud."
                });
            }
        }
    }
}
