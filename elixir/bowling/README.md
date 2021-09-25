# Bowling

## Bowling Score

The bowling_score library encapsulates core concepts of ten pin bowling vocabulary
and game logic.

* Each `game` consits of 1..N `players`
* every `player` has score `board`
* every `board` is made up of 1..12 `frames`
* each `frame` captures ball role results, score `carries` and a frame classification
  of `regular`, `spare`, `strike`

## Bowling Hall

A minimal HTTP JSON API to allow bowling hall's terminals to display and drive
games for players.

## Bowling Terminal

A TUI client with [ratatouille](https://github.com/ndreynolds/ratatouille) that
at startup would use the Bowling Hall API to register itself and then allow input
for:

* registering players
* driving the game by sending pin score for currenlty active `player` in the
  respective `game` visualized by the terminal.

TODO
