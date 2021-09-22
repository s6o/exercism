# Bowling Hall

A simple HTTP JSON API to which Bowling Screens can hook up to, to manage their
respective games.

## Routes

### POST /terminals

Register a new Bowling Hall screen.

```json
{
  "terminal_id": 1
}
```

On successful registration returns `HTTP 204 No Content`. If a terminal tries to
join with an already reserved id `HTTP 409 Conflict` is returned.

### GET /games

List registered Bowling Screen id-s (terminals) with game state: free | game.

`HTTP 200 OK`

```json
[
  {
    "terminal_id": 1,
    "state": "free"
  },
  {
    "terminal_id": 2,
    "state": "game"
  }
]
```

### POST /games/:terminal_id

Request a new game for specified terminal with a list of player names.

```json
["Alice","Bob"]
```

`HTTP 201 Created`

```json
{
  "active_player": 0,
  "board": [
        {
          "player": "Alice",
          "frames": [
            {
              "slot1": null,
              "slot2": null,
              "slot_result": "regular",
              "score": null,
            }
          ]
        },
        {
          "player": "Bob",
          "frames": [
            {
              "slot1": null,
              "slot2": null,
              "slot_result": "regular",
              "score": null,
            }
          ]
        }
      ]
}

```

### PUT /games/:terminal

```json
{
  "terminal_id": 1,
  "pins_down": 4
}
```

Update terminal's game score for currently active player. And return new game
state. An example below show a games state where Alice has completed 2 frames and
Bob is about to complete his 2nd frame (being the active player).

Notice that frames receive their final score after they have been completed.

`HTTP 200 OK`

```json
{
  "active_player": 1,
  "board": [
    {
      "player": "Alice",
      "frames": [
        {
          "slot1": 10,
          "slot2": 0,
          "slot_result": "strike",
          "score": 19,
        },
        {
          "slot1": 3,
          "slot2": 6,
          "slot_result": "regular",
          "score": 28,
        },
        {
          "slot1": null,
          "slot2": null,
          "slot_result": "regular",
          "score": null,
        }
      ]
    },
    {
      "player": "Bob",
      "frames": [
        {
          "slot1": 7,
          "slot2": 3,
          "slot_result": "spare",
          "score": null,
        },
        {
          "slot1": 4,
          "slot2": null,
          "slot_result": "regular",
          "score": null,
        }
      ]
    }
  ]
}
```

## Installation

```bash
mix deps.get
```

## Running

with iex

```bash
iex -S mix
```

without

```bash
mix run --no-halt
```
