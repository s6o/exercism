module RobotSimulator

type Direction =
    | North
    | East
    | South
    | West

type Position = int * int

type Robot =
    { Direction: Direction
      Position: Position }

let create direction position =
    { Direction = direction
      Position = position }

let move instructions robot =
    let execute (s: Robot) (i: char) =
        match i with
        | 'A' ->
            match s.Direction with
            | East ->
                { s with
                      Position = ((fst s.Position) + 1, snd s.Position) }
            | North ->
                { s with
                      Position = (fst s.Position, (snd s.Position) + 1) }
            | South ->
                { s with
                      Position = (fst s.Position, (snd s.Position) - 1) }
            | West ->
                { s with
                      Position = ((fst s.Position) - 1, snd s.Position) }
        | 'L' ->
            match s.Direction with
            | East -> { s with Direction = North }
            | North -> { s with Direction = West }
            | South -> { s with Direction = East }
            | West -> { s with Direction = South }
        | 'R' ->
            match s.Direction with
            | East -> { s with Direction = South }
            | North -> { s with Direction = East }
            | South -> { s with Direction = West }
            | West -> { s with Direction = North }
        | _ -> s

    instructions
    |> Seq.toList
    |> Seq.fold execute robot
