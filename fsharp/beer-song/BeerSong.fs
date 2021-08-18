module BeerSong

let recite (startBottles: int) (takeDown: int) =
    let verse (count: int) =
        match count with
        | 0 ->
            [ "No more bottles of beer on the wall, no more bottles of beer."
              "Go to the store and buy some more, 99 bottles of beer on the wall." ]
        | 1 ->
            [ "1 bottle of beer on the wall, 1 bottle of beer."
              "Take it down and pass it around, no more bottles of beer on the wall." ]
        | 2 ->
            [ "2 bottles of beer on the wall, 2 bottles of beer."
              "Take one down and pass it around, 1 bottle of beer on the wall." ]
        | _ ->
            [ $"{count} bottles of beer on the wall, {count} bottles of beer."
              $"Take one down and pass it around, {count - 1} bottles of beer on the wall." ]

    seq {
        for i in 0 .. takeDown - 1 ->
            if takeDown > 1 && i < takeDown - 1 then
                verse (startBottles - i) @ [ "" ]
            else
                verse (startBottles - i)
    }
    |> Seq.concat
    |> Seq.toList
