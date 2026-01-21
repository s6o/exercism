// Single file programs since .NET 10 and C# 14
// Shebang is broken, the line below does not work with zsh on MacOS
// #!/usr/local/share/dotnet/dotnet run
// 
// And this version:
// #!/usr/bin/env dotnet
// is also broken with zsh on MacOS
//
// Running via: dotnet run hello-world-cli.cs
Console.WriteLine("Hello, World!");
