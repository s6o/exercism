module rec Allergies

open System

type Allergen =
    | Eggs
    | Peanuts
    | Shellfish
    | Strawberries
    | Tomatoes
    | Chocolate
    | Pollen
    | Cats


let allergicTo codedAllergies allergen =
    list codedAllergies |> List.contains allergen


let list codedAllergies =
    let allergens =
        FSharp.Reflection.FSharpType.GetUnionCases typeof<Allergen>

    allergens
    |> Array.fold
        (fun (num, accum) allergen ->
            if num &&& 1 = 1 then
                (num >>> 1,
                 accum
                 @ [ FSharp.Reflection.FSharpValue.MakeUnion(allergen, [||]) :?> Allergen ])
            else
                (num >>> 1, accum))
        (codedAllergies, [])
    |> (fun (_, a) -> a)
