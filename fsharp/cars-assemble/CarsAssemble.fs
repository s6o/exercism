module CarsAssemble

let defaultCarsPerHour = 221

let successRate (speed: int) : float =
    if speed <= 0 then
        0.00
    else if speed >= 1 && speed <= 4 then
        1.00
    else if speed >= 5 && speed <= 8 then
        0.90
    else if speed = 9 then
        0.80
    else
        0.77

let productionRatePerHour (speed: int) : float =
    let prediction = speed * defaultCarsPerHour |> float
    let defectAdjustment = successRate speed
    prediction * defectAdjustment

let workingItemsPerMinute (speed: int) : int =
    productionRatePerHour speed / 60.0 |> int
