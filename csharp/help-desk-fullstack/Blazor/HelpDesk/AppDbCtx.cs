using Microsoft.EntityFrameworkCore;

public class AppDbCtx(DbContextOptions<AppDbCtx> options) : DbContext(options)
{
    public DbSet<HelpDesk.Ticket> Ticket { get; set; } = default!;
}
