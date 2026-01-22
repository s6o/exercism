namespace TeleprompterConsole;

internal class Program
{
  static async Task Main(string[] args)
  {
    Console.WriteLine("Teleprompter Console");
    Console.WriteLine();
    await RunTelepromter();
  }

  private static async Task RunTelepromter()
  {
    var config = new TeleprompterConfig();

    var speedTask = GetInput(config);
    var displayTask = ShowTeleprompter(config);

    await Task.WhenAny(displayTask, speedTask);
  }

  private static async Task ShowTeleprompter(TeleprompterConfig config)
  {
    var words = ReadByWord("sample-quotes.txt");
    foreach (var w in words)
    {
      Console.Write(w);
      if (!string.IsNullOrWhiteSpace(w))
      {
        await Task.Delay(config.DelayInMilliseconds);
      }
    }
    config.setDone();
  }

  private static async Task GetInput(TeleprompterConfig config)
  {
    Action work = () =>
    {
      do
      {
        var key = Console.ReadKey(true);
        if (key.KeyChar == '>')
          config.UpdateDelay(-10);
        else if (key.KeyChar == '<')
          config.UpdateDelay(10);
        else if (key.KeyChar == 'X' || key.KeyChar == 'x')
          config.setDone();
      } while (true);
    };
    await Task.Run(work);
  }

  static IEnumerable<string> ReadByWord(string file)
  {
    string? line;
    using (var reader = File.OpenText(file))
    {
      while ((line = reader.ReadLine()) != null)
      {
        var lineLength = 0;
        var words = line.Split(" ");
        foreach (var word in words)
        {
          yield return word + " ";
          lineLength += word.Length + 1;
          if (lineLength > 75)
          {
            yield return Environment.NewLine;
            lineLength = 0;
          }
        }
        yield return Environment.NewLine;
      }
    }
  }
}