enum AccountType : byte
{
    Guest = Permission.Read,
    User = Permission.Read | Permission.Write,
    Moderator = Permission.All,
}

[Flags]
enum Permission : byte
{
    None = 0b00000000,
    Read = 0b00000001,
    Write = 0b00000010,
    Delete = 0b00000100,
    All = 0b00000111,
}

static class Permissions
{
    public static Permission Default(AccountType accountType) =>
        accountType > AccountType.Moderator ? Permission.None : Enum.GetValues<Permission>().Aggregate(Permission.None, (acc, p) => ((Permission)accountType & p) == p ? acc | p : acc);

    public static Permission Grant(Permission current, Permission grant) => current | grant;

    public static Permission Revoke(Permission current, Permission revoke) =>
        Enum.GetValues<Permission>().Aggregate(current, (acc, p) => (revoke & p) == p && (current & p) == p ? acc ^ p : acc);

    public static bool Check(Permission current, Permission check) => (current & check) == check;
}
