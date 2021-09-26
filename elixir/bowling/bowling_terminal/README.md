# Bowling Terminal

A TUI client that connects to the Bowling Hall game server.

At start-up the terminal will negotiate/find the next free terminal ID with which
it will register itself in the game server.

## Installation

```bash
mix deps.get
```

## Running

First make sure the Bowling Hall web service has been started in an other console.
The Bowling Hall HTTP is served from [localhost:3001](http://localhost:3001).

```bash
cd ../bowling_hall
mix run --no-halt
```

or

```bash
cd ../bowling_hall
iex -S mix
```

After the game server service is up and running its possible to start one or
serveral Bowling Terminal clients.

```bash
cd ../bowling_terminal
mix run --no-halt
```
