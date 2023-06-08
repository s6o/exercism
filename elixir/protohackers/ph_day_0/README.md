# Protohackers, Day 0

Deep inside Initrode Global's enterprise management framework lies a component
that writes data to a server and expects to read the same data back. (Think of
it as a kind of distributed system delay-line memory). We need you to write the
server to echo the data back.

Accept TCP connections.

Whenever you receive data from a client, send it back unmodified.

Make sure you don't mangle binary data, and that you can handle at least 5
simultaneous clients.

Once the client has finished sending data to you it shuts down its sending side.
Once you've reached end-of-file on your receiving side, and sent back all the
data you've received, close the socket so that the client knows you've finished.
(This point trips up a lot of proxy software, such as ngrok; if you're using a
proxy and you can't work out why you're failing the check, try hosting your server
in the cloud instead).

Your program will implement the TCP Echo Service from RFC 862.

## Youtube

[Stream](https://www.youtube.com/watch?v=owz50_NYIZ8)

## Notes

Failed to notice that in the initial implementation of `PhDay0.EchoServer.init/1`
that it had a return `{:ok, %__MODULE__{}}`, despite already having the
`case :gen_tcp.listen(port, listen_options) do` in place, from which the return
value for `PhDay0.EchoServer.init/1` should arise.

There were no error messages, everything just hanged :-) - thanks, compiler!
Now I know that it cannot detect accidental multiple retruns or warn about discarded
expressions.

## Deployment

Prepare project:

```zsh
mix release.init
```

Configure [env.sh.eex](./rel/env.sh.eex) and [Dockerfile](./Dockerfile).

A [Fly.io](https://fly.io) account is required. After which install the command line
`flyctl` utility.

```zsh
brew install flyctl

flyctl auth login
flyctl launch
```

After modifications to `fly.toml`.

```zsh
flyctl deploy
```

Mark down the assigned IP.

```zsh
echo foobar | nc <fly-assigned-ip> 5001
```

## Verifying

Goto [Problem 0](https://protohackers.com/problem/0) and enter the IP address and
port assigned by Fly.io.
