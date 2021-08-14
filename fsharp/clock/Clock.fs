module Clock

type CM = { Minutes: int }

let create (hours: int) (minutes: int) : CM =
    let cm = hours * 60 + minutes

    match cm with
    | t when t >= 0 ->
        { Minutes =
              if t = 1440 then
                  0
              else
                  (((t / 60) % 24) * 60) + (t % 60) }
    | _ ->
        let (hmin, rmin) =
            if (abs cm % 60) = 0 then
                (0, 0)
            else
                (1, 60 - (abs cm % 60))

        { Minutes = ((24 - hmin - ((abs cm / 60) % 24)) * 60) + rmin }

let add minutes clock = create 0 (clock.Minutes + minutes)

let subtract minutes clock = create 0 (clock.Minutes - minutes)

let display (clock: CM) : string =
    sprintf "%02d:%02d" ((clock.Minutes / 60) % 24) (clock.Minutes % 60)
