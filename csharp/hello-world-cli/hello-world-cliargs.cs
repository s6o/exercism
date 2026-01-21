class CliArgs
{
  public static void Main()
  {
    Console.WriteLine();
    string[] arguments = Environment.GetCommandLineArgs();
    // skip the script name and print the rest of argumetns
    var args = arguments.Index().Where((t, s) => t.Index > 0).Select(t => t.Item);
    if (arguments.Length < 2)
    {
      Console.WriteLine("No arguments were passed!");
    }
    else
    {
      foreach (string arg in args)
      {
        Console.WriteLine(arg);
      }
    }
  }
}
