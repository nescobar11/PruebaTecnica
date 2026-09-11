using ClientesApi.Models;
using Microsoft.EntityFrameworkCore;

namespace ClientesApi.Data
{
    /// <summary>
    /// Contexto de base de datos de Entity Framework Core para DBClientes.
    /// </summary>
    public class ClientesDbContext : DbContext
    {
        public ClientesDbContext(DbContextOptions<ClientesDbContext> options) : base(options)
        {
        }

        public DbSet<Cliente> Clientes { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Cliente>(entity =>
            {
                entity.ToTable("Clientes");
                entity.HasKey(c => c.Id);
                entity.HasIndex(c => c.NumeroIdentificacion).IsUnique();
            });

            base.OnModelCreating(modelBuilder);
        }
    }
}
