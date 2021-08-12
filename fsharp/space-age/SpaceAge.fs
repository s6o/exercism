module SpaceAge
(*
https://stackoverflow.com/questions/12156022/defining-modules-vs-net-vs-f-interactive
#if INTERACTIVE
#else
module SpaceAge
#endif
*)

type Planet =
    | Venus
    | Mercury
    | Earth
    | Mars
    | Jupiter
    | Saturn
    | Uranus
    | Neptune

let age (planet: Planet) (seconds: int64) : float =
    let earthYear = 31557600L |> float

    let planetYear =
        match planet with
        | Mercury -> 0.2408467
        | Venus -> 0.61519726
        | Earth -> 1.
        | Mars -> 1.8808158
        | Jupiter -> 11.862615
        | Saturn -> 29.447498
        | Uranus -> 84.016846
        | Neptune -> 164.79132

    (seconds |> float) / (planetYear * earthYear)
