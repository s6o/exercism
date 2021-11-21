module LuciansLusciousLasagna

let expectedMinutesInOven = 40

let remainingMinutesInOven elapsed = expectedMinutesInOven - elapsed

let preparationTimeInMinutes layer = layer * 2

let elapsedTimeInMinutes layer elapsed =
    preparationTimeInMinutes layer + elapsed
