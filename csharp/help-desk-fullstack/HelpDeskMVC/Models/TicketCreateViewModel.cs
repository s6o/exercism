using System.ComponentModel.DataAnnotations;

namespace HelpDeskMVC.Models;

public class TicketCreateViewModel : IValidatableObject
{
  [Required(ErrorMessage = "Ticket description is required.")]
  public string? Description { get; set; }

  [Required(ErrorMessage = "Ticket Deadline is required.")]
  public DateTime Deadline { get; set; } = DateTime.Now;
  public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
  {
    var today = DateTime.UtcNow.AddMinutes(-5.0);
    if (today > Deadline.ToUniversalTime())
    {
      yield return new ValidationResult($"Ticket deadline cannot be in the past.", new[] { nameof(Deadline) });
    }
  }
}
