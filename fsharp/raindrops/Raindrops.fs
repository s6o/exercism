module Raindrops

let convert (number: int) : string =
    let modx m x = x % m

    let samples =
        [ (modx 3, "Pling")
          (modx 5, "Plang")
          (modx 7, "Plong") ]

    let sound =
        samples
        |> List.map (fun (f, s) -> if f number = 0 then s else "")
        |> String.concat ""

    match sound.Length with
    | 0 -> number.ToString()
    | _ -> sound
