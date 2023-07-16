# Clusters

```zsh
iex --sname left --cookie cook
iex --sname right --cookie cook
```

## IEX commands

```iex
# On either side
Node.self()
Node.list()
```

### Connecting nodes

```iex
Node.connect(:left@mm)
Node.list()
```

### Defining a module on the left

```iex
defmodule M do
  def run, do: IO.puts("Hi on the left!")
end
M.run()
```

### Calling the module from the right

```iex
left = :left@mm
Node.spawn(left, fn -> M.run() end)
```

Notice output on the right, but the `:ok` atom has been "swallowed".

### A new module with a better result on the left

```iex
defmodule M do
  def add(n), do: n + 4
end
```

### On the right

```iex
this = self() # store iex console pid, correct clouser context
Node.spawn(left, fn -> send(this, M.add(3)) end)
```

```iex
flush # mailbox
```

```iex
Node.spawn(left, fn -> send(this, M.add(3)) end)
receive do any -> any end # or pattern match on the mailbox for the addition result only
```

### Node PID aliasing and prefixes

```iex
Node.spawn(left, fn -> send(this, IO.inspect(self(), label:"pid left")) end)
receive do any -> any end # or pattern match on the mailbox for the addition result only
```

### Group leaders

On the left

```iex
Application.put_env(:elixir, :gl, :erlang.group_leader())
```

On the right

```iex
Node.spawn(left, fn -> send(this, Application.get_env(:elixir, :gl)) end)
receive do any -> any end 
```

Notice the second number of the retruned PID.


