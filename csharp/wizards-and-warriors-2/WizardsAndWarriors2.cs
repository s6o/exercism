static class GameMaster
{
    public static string Describe(Character character)
    {
        var template = "You're a level {0} {1} with {2} hit points.";
        return string.Format(template, character.Level, character.Class, character.HitPoints);
    }

    public static string Describe(Destination destination)
    {
        var template = "You've arrived at {0}, which has {1} inhabitants.";
        return string.Format(template, destination.Name, destination.Inhabitants);
    }

    public static string Describe(TravelMethod travelMethod) => travelMethod switch
    {
        TravelMethod.Walking => "You're traveling to your destination by walking.",
        TravelMethod.Horseback => "You're traveling to your destination on horseback.",
        _ => ""
    };

    public static string Describe(Character character, Destination destination, TravelMethod travelMethod)
        => $"{Describe(character)} {Describe(travelMethod)} {Describe(destination)}";

    public static string Describe(Character character, Destination destination)
        => $"{Describe(character)} {Describe(TravelMethod.Walking)} {Describe(destination)}";
}

class Character
{
    public string? Class { get; set; }
    public int Level { get; set; }
    public int HitPoints { get; set; }
}

class Destination
{
    public string? Name { get; set; }
    public int Inhabitants { get; set; }
}

enum TravelMethod
{
    Walking,
    Horseback
}
