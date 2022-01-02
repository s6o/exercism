module LetterAParser =

    open System

    let parseA str =
        if String.IsNullOrEmpty(str) then
            (false, "")
        else if str.[0] = 'A' then
            let remaining = str.[1..]
            (true, remaining)
        else
            (false, str)

    let inputABC = "ABC"
    let test1 = parseA inputABC

    let inputZBC = "ZBC"
    let test2 = parseA inputZBC


module SingleLetterParser =

    open System

    let pchar (charToMatch, str) =
        if String.IsNullOrEmpty(str) then
            let msg = "No more input"
            (msg, "")
        else
            let first = str.[0]

            if first = charToMatch then
                let remaining = str.[1..]
                let msg = sprintf "Found %c" charToMatch
                (msg, remaining)
            else
                let msg = sprintf "Expecting '%c'. Got '%c'" charToMatch first
                (msg, str)


    let inputABC = "ABC"
    let test1 = pchar ('A', inputABC)

    let inputZBC = "ZBC"
    let test2 = pchar ('A', inputZBC)


module LetterParser =

    open System

    type ParserResult<'a> =
        | Success of 'a
        | Failure of string

    // let pchar (charToMatch, str) = initial, not curried version
    let pchar charToMatch str =
        if String.IsNullOrEmpty(str) then
            Failure "No more input"
        else
            let first = str.[0]

            if first = charToMatch then
                let remaining = str.[1..]
                Success(charToMatch, remaining)
            else
                let msg = sprintf "Expecting, '%c'. Got '%c'" charToMatch first
                Failure msg

    let inputABC = "ABC"
    //let test1 = pchar ('A', inputABC)
    let test1 = pchar 'A', inputABC

    let inputZBC = "ZBC"
    //let test2 = pchar ('A', inputZBC)
    let test2 = pchar 'A' inputZBC

    // partial application
    let parseA = pchar 'A'
    let test3 = parseA inputABC


module Parser =

    open System

    type ParseResult<'T> =
        | Success of 'T
        | Failure of string

    type Parser<'T> = Parser of (string -> ParseResult<'T * string>)

    let pchar (charToMatch: char) : Parser<char> =
        let innerFn str =
            if String.IsNullOrEmpty(str) then
                Failure "End of input"
            else
                let first = str.[0]

                if first = charToMatch then
                    let remaining = str.[1..]
                    Success(charToMatch, remaining)
                else
                    let msg = sprintf "Expecting '%c'. Got '%c'" charToMatch first
                    Failure msg

        Parser innerFn


    let run (parser: Parser<'T>) (input: string) =
        let (Parser innerFn) = parser
        innerFn input

    let parseA = pchar 'A'
    let inputABC = "ABC"
    let inputZBC = "ZBC"

    let test1 = run parseA inputABC
    let test2 = run parseA inputZBC


module ParserCombinators =

    open Parser

    let andThen (leftP: Parser<'A>) (rightP: Parser<'B>) =
        let innerFn (input: string) =
            let left = run leftP input

            match left with
            | Failure err -> Failure err
            | Success (leftChar, leftRemaining) ->
                let right = run rightP leftRemaining

                match right with
                | Failure err -> Failure err
                | Success (rightChar, rightRemaining) ->
                    let result = (leftChar, rightChar)
                    Success(result, rightRemaining)

        Parser innerFn

    let orElse (leftP: Parser<'A>) (rightP: Parser<'A>) =
        let innerFn (input: string) =
            let left = run leftP input

            match left with
            | Success _ -> left
            | Failure _ -> run rightP input

        Parser innerFn

    let (.>>.) = andThen
    let (<|>) = orElse

    let choise listOfParsers = List.reduce (<|>) listOfParsers

    let anyOf listOfChars = listOfChars |> List.map pchar |> choise


    // Tests
    let inputABC = "ABC"
    let inputZBC = "ZBC"

    let parseA = pchar 'A'
    let parseB = pchar 'B'
    let parseC = pchar 'C'
    let parseAThenB = parseA .>>. parseB
    let parseAOrElseB = parseA <|> parseB
    let bOrElseC = parseB <|> parseC
    let aAndThenBOrC = parseA .>>. bOrElseC
    let parseLowercase = anyOf [ 'a' .. 'z' ]
    let parseDigit = anyOf [ '0' .. '9' ]

    let test1 = run parseAThenB inputABC
    let test2 = run parseAThenB inputZBC

    let test3 = run parseAOrElseB "AZZ"
    let test4 = run parseAOrElseB "BZZ"
    let test5 = run parseAOrElseB "CZZ"

    let test6 = run aAndThenBOrC "ABZ"
    let test7 = run aAndThenBOrC "ACZ"
    let test8 = run aAndThenBOrC "QBZ"
    let test9 = run aAndThenBOrC "AQZ"

    let test10 = run parseLowercase "aBC"
    let test11 = run parseLowercase "ABC"

    let test12 = run parseDigit "1ABC"
    let test13 = run parseDigit "9ABC"
    let test14 = run parseDigit "|ABC"
