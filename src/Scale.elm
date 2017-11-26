module Scale exposing (CustomScale, makeCustomScale, getScaled)

import Dict exposing (Dict)


type CustomScale
    = CustomScale (Dict Int Float)


makeCustomScale : List Float -> CustomScale
makeCustomScale ratios =
    ratios
        |> List.indexedMap (\i v -> ( i, v ))
        |> Dict.fromList
        |> CustomScale


getScaled : Float -> CustomScale -> Int -> Float
getScaled base scale index =
    getScaledInt base scale index


getScaledInt : Float -> CustomScale -> Int -> Float
getScaledInt base (CustomScale ratios) index =
    Dict.get index ratios
        |> Maybe.withDefault 1
        |> (*) base
