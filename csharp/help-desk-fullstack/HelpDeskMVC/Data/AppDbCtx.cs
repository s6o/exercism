using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using HelpDeskMVC.Models;

    public class AppDbCtx : DbContext
    {
        public AppDbCtx (DbContextOptions<AppDbCtx> options)
            : base(options)
        {
        }

        public DbSet<HelpDeskMVC.Models.Ticket> Ticket { get; set; } = default!;
    }
