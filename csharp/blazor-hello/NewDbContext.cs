using Microsoft.EntityFrameworkCore;

public class NewDbContext(DbContextOptions<NewDbContext> options) : DbContext(options)
{
    public DbSet<BlazorHello.Models.Movie> Movie { get; set; } = default!;
}
