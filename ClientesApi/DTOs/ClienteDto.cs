namespace ClientesApi.DTOs
{
    /// <summary>
    /// Objeto de transferencia de datos para exponer la información del cliente en la API.
    /// </summary>
    public class ClienteDto
    {
        public int Id { get; set; }
        public string TipoIdentificacion { get; set; } = string.Empty;
        public string NumeroIdentificacion { get; set; } = string.Empty;
        public string Nombres { get; set; } = string.Empty;
        public string Apellidos { get; set; } = string.Empty;
        public DateTime? FechaNacimiento { get; set; }
        public string? Direccion { get; set; }
        public string? Telefono { get; set; }
        public string? Email { get; set; }
    }

    /// <summary>
    /// Estructura estándar de respuesta usada por la API.
    /// </summary>
    /// <typeparam name="T">Tipo de dato contenido en la respuesta.</typeparam>
    public class ApiResponse<T>
    {
        public bool Exito { get; set; }
        public string Mensaje { get; set; } = string.Empty;
        public T? Datos { get; set; }
    }
}
