using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace HelpDeskMVC.Models;

public class TicketViewModel
{
  public int Id { get; init; }
  [DisplayName("Created at")]
  public string CreatedAt { get; init; }
  [Required(ErrorMessage = "Ticket description is required.")]
  public string? Description { get; init; }
  [Required(ErrorMessage = "Ticket Deadline is required.")]
  public string Deadline { get; init; }
  [DisplayName("Done")]
  public bool IsDone { get; init; }

  public bool PastDue { get; init; }

  public TicketViewModel(Ticket t)
  {
    Id = t.Id;
    CreatedAt = t.Timestamp.ToString("yyyy-MM-dd HH:mm:ss");
    Description = t.Description;
    Deadline = t.Deadline.ToString("yyyy-MM-dd HH:mm:ss");
    IsDone = t.IsDone;
    PastDue = (t.Deadline - DateTime.Now).TotalHours < 1.0;
  }
}
