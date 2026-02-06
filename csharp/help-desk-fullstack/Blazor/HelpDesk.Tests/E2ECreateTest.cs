using System.Threading.Tasks;
using Microsoft.Playwright;
using BlazeWright;

public class E2ECreateTest : BlazorPageTest<Program>
{
    [Fact]
    public async Task EmptyFormSubmitValidations()
    {
        // Arrange
        // Tip: create reusable Goto methods that incapsulate cross cutting concerns,
        // e.g. GotoPageAsUser(url, userName)
        await Page.GotoBlazorServerPageAsync("new-ticket");

        // Act
        // Finding the element by role makes our tests more resilient
        // to refactoring since we can change the HTML element used
        // without breaking the test, as long as the element has the same
        // role, implicitly or explicitly.
        // Learn more about this frontend testing strategy
        // at https://testing-library.com/docs/
        await Page
            .GetByRole(AriaRole.Button, new PageGetByRoleOptions() { Name = "Create" })
            .ClickAsync();

        // Assert
        ILocator status = Page.GetByRole(AriaRole.Alert);
        await Expect(status).ToHaveTextAsync("Ticket description is required.");
    }
}
