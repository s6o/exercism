module Accumulate

let accumulate (func: 'a -> 'b) (input: 'a list) : 'b list =
    let rec loop accum remaining =
        match remaining with
        | [] -> accum
        | a :: rest -> loop (accum @ [ func a ]) rest

    loop [] input
