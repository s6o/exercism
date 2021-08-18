module rec Bob

open System.Text.RegularExpressions

let response (input: string) : string =
    match input with
    | Question -> "Sure."
    | Silence -> "Fine. Be that way!"
    | Yell -> "Whoa, chill out!"
    | YelledQuestion -> "Calm down, I know what I'm doing!"
    | Whatever -> "Whatever."


let (|Question|Silence|Yell|YelledQuestion|Whatever|) (input: string) =
    let trimmed = input.Trim()

    let noise =
        Regex.Replace(input, "[^a-zA-Z0-9 -?]", "").Trim()

    if noise.Length = 0 then
        Silence
    else if isAllUpper trimmed && trimmed.EndsWith("?") then
        YelledQuestion
    else if trimmed.EndsWith("?") then
        Question
    else if isAllUpper trimmed then
        Yell
    else
        Whatever

let isAllUpper input =
    let textOnly =
        Regex.Replace(input, "[^a-zA-Z -]", "").Trim()

    let upped = textOnly.ToUpper()
    textOnly.Length > 0 && textOnly = upped
