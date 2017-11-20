module Main exposing (..)

import Ports
import View.Compass as Compass
import Html exposing (Html, text, div, h1, img, button, text)
import Html.Events exposing (onClick)
import EveryDict exposing (EveryDict)


---- MODEL ----


type alias LatLng =
    ( Float, Float )


type TargetId
    = TargetId String


type alias Model =
    { pickedTarget : Maybe TargetId
    , targetPositions : EveryDict TargetId LatLng
    , aim : Float
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )


initModel : Model
initModel =
    { pickedTarget = Nothing
    , targetPositions = initTargets
    , aim = 0
    }


initTargets : EveryDict TargetId LatLng
initTargets =
    EveryDict.fromList
        ([ ( (TargetId "Helsinki"), ( 60.192, 24.9458 ) )
         , ( (TargetId "Porto"), ( 41.1496, -8.6109 ) )
         ]
        )



---- UPDATE ----


type Msg
    = PickTargetPosition TargetId
    | NewAim Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PickTargetPosition newTargetId ->
            let
                getTarget targetId =
                    EveryDict.get targetId model.targetPositions
                        |> Maybe.withDefault ( 0, 0 )
            in
                { model | pickedTarget = Just newTargetId } ! [ Ports.targetPositionOut (getTarget newTargetId) ]

        NewAim newAim ->
            { model | aim = newAim } ! []



---- VIEW ----


view : Model -> Html Msg
view model =
    div [] <|
        [ Compass.view { direction = model.aim } ]
            ++ (List.map
                    (\( targetId, position ) -> viewPositionButton targetId)
                    (EveryDict.toList model.targetPositions)
               )


viewPositionButton : TargetId -> Html Msg
viewPositionButton targetId =
    let
        targetIdToString (TargetId idString) =
            idString
    in
        div
            []
            [ button [ onClick (PickTargetPosition targetId) ]
                [ text <| targetIdToString targetId
                ]
            ]



---- SUBS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Ports.customAimIn NewAim
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
