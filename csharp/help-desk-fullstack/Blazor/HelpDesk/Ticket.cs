using System.ComponentModel.DataAnnotations;

namespace HelpDesk;

public class Ticket
{
  public int Id { get; set; }
  public DateTime Timestamp { get; set; }
  [Required(ErrorMessage = "Ticket description is required.")]
  public string? Description { get; set; }
  [Required(ErrorMessage = "Ticket Deadline is required.")]
  public DateTime Deadline { get; set; }
  public bool IsDone { get; set; }
}
