using static System.Math;

internal class TeleprompterConfig
{
  public int DelayInMilliseconds { get; private set; } = 100;

  public void UpdateDelay(int increment)
  {
    var newDelay = Min(DelayInMilliseconds + increment, 1000);
    newDelay = Max(newDelay, 20);
    DelayInMilliseconds = newDelay;
  }

  public bool Done { get; private set; }

  public void setDone()
  {
    Done = true;
  }
}
