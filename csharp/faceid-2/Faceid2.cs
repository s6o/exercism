public class FacialFeatures(string eyeColor, decimal philtrumWidth)
{
    public string EyeColor { get; } = eyeColor;
    public decimal PhiltrumWidth { get; } = philtrumWidth;
    public override bool Equals(object? other) => GetHashCode() == other?.GetHashCode();
    public override int GetHashCode() => HashCode.Combine(EyeColor.GetHashCode(), PhiltrumWidth.GetHashCode());
}

public class Identity(string email, FacialFeatures facialFeatures)
{
    public string Email { get; } = email;
    public FacialFeatures FacialFeatures { get; } = facialFeatures;
    public override bool Equals(object? other) => GetHashCode() == other?.GetHashCode();
    public override int GetHashCode() => HashCode.Combine(Email.GetHashCode(), FacialFeatures.GetHashCode());
}

public class Authenticator
{
    private HashSet<Identity> identities = [];

    public static bool AreSameFace(FacialFeatures faceA, FacialFeatures faceB) => faceA.Equals(faceB);

    public bool IsAdmin(Identity identity) => identity.Equals(new Identity("admin@exerc.ism", new FacialFeatures("green", 0.9m)));

    public bool Register(Identity identity) => identities.Add(identity);

    public bool IsRegistered(Identity identity) => identities.Contains(identity);

    public static bool AreSameObject(Identity identityA, Identity identityB) => identityA == identityB;
}
