#load "Allergies.fs"

open Allergies
open System

let a = list 509

let b = Enum.GetValues(typeof<Allergen>)

//let b = allergicTo 509 Allergen.Peanuts
