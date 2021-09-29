# Bowling Hall

A simple HTTP JSON API to which Bowling Screens can hook up to, to manage their
respective games.

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

For development the webserver is started at [localhost:3001](http://localhost:3001)

## Routes

### POST /terminals

Register a new Bowling Hall screen. On successful registration the assigned
terminal id is returned.

`HTTP 201 Created`

```json
{
  "terminal_id": 1
}
```

### GET /terminals

List registered Bowling Screen id-s (terminals) with game state: vacant | occupied.

`HTTP 200 OK`

```json
[
  {
    "terminal_id": 1,
    "state": "vacant"
  },
  {
    "terminal_id": 2,
    "state": "occupied"
  }
```

### GET /games/:terminal_id

Get game state for sepcified terminal. If a terminal is free - a game has not
been started and

`HTTP 200 OK`

```json
{
}
```

is returned.

Otherwise, the current game state for specified terminal is returned. As an
example the first initial game state for Alice and Bob where Alice the first
active player to have roll/throw.

Both of the state fields: game_state and board_state can have 2 of possible values:
"in_progress" and "completed".

`HTTP 200 OK`

```json
{
  "active_player": 0,
  "game_state": "in_progress",
  "board": [
    {
      "player": "Alice",
      "board_state": "in_progress",
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
      "board_state": "in_progress",
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

### POST /games/:terminal_id

Request a new game for specified terminal with a list of player names.

```json
["Alice","Bob"]
```

`HTTP 201 Created`

```json
{
  "active_player": 0,
  "game_state": "in_progress",
  "board": [
        {
          "player": "Alice",
          "board_state": "in_progress",
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
          "board_state": "in_progress",
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

### PUT /games/:terminal_id

```json
{
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
  "game_state": "in_progress",
  "board": [
    {
      "player": "Alice",
      "board_state": "in_progress",
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
      "board_state": "in_progress",
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
