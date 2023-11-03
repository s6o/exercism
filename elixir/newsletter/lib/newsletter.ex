defmodule Newsletter do
  def read_emails(path) do
    File.read!(path)
    |> String.split()
  end

  def open_log(path) do
    File.open!(path, [:write])
  end

  def log_sent_email(pid, email) do
    IO.puts(pid, String.to_charlist(String.trim(email, "\n")))
  end

  def close_log(pid) do
    File.close(pid)
  end

  def send_newsletter(emails_path, log_path, send_fun) do
    pid = open_log(log_path)

    read_emails(emails_path)
    |> Enum.each(fn e -> if(send_fun.(e) == :ok, do: log_sent_email(pid, e)) end)

    close_log(pid)
  end
end
