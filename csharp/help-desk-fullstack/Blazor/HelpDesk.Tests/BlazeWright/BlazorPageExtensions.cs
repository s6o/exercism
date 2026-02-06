using System.Diagnostics;
using System.Threading.Tasks;
using Microsoft.Playwright;

namespace BlazeWright;

public static class BlazorPageExtensions
{
    [DebuggerHidden]
    [DebuggerStepThrough]
    public static Task<IResponse?> GotoBlazorServerPageAsync(this IPage page, string url)
        => page.GotoAsync(
            url,
            new PageGotoOptions()
            {
                WaitUntil = WaitUntilState.NetworkIdle
            });
}
