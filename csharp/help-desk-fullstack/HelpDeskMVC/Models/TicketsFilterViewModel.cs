using Microsoft.EntityFrameworkCore;

namespace HelpDeskMVC.Models;

public class TicketsFilterViewModel
{
  public string? SearchString { get; init; }

  public required List<TicketViewModel> Tickets { get; init; }

  public static async Task<TicketsFilterViewModel> Create(AppDbCtx context, string? search)
  {
    var formatted = context.Ticket.Where(t => t.IsDone == false).OrderByDescending(t => t.Deadline);

    var filtered = string.IsNullOrWhiteSpace(search) switch
    {
      false => formatted.Where(t => t.Description != null ? t.Description.ToLower().Contains(search.ToLower()) : false),
      true => formatted
    };

    var viewTickets = await filtered.Select(t => new TicketViewModel(t)).ToListAsync();

    return new TicketsFilterViewModel { Tickets = viewTickets, SearchString = search };
  }
}
