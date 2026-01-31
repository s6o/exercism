static class Badge
{
    private static string IdPrint(int? id) => id != null ? $"[{id.ToString()}] - " : "";
    private static string DepPrint(string? dep) => $" - {dep?.ToUpper() ?? "OWNER"}";
    public static string Print(int? id, string name, string? department)
    {
        return $"{IdPrint(id)}{name}{DepPrint(department)}";
    }
}
