using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace HelpDeskMVC.Models;

public class Ticket
{
  public int Id { get; set; }
  [DisplayName("Created at")]
  public DateTime Timestamp { get; set; }
  [Required(ErrorMessage = "Ticket description is required.")]
  public string? Description { get; set; }
  [Required(ErrorMessage = "Ticket Deadline is required.")]
  public DateTime Deadline { get; set; }
  [DisplayName("Done")]
  public bool IsDone { get; set; }
}
