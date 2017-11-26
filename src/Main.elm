module Main exposing (..)

import Ports
import Element exposing (..)
import Element.Events exposing (onClick)
import Element.Attributes exposing (center, padding, paddingXY, spacing)
import Stylesheet exposing (stylesheet, Styles(..))
import View.Compass as Compass
import Html exposing (Html)
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
    Element.viewport stylesheet <|
        column MainContainer
            [ Element.Attributes.height <| Element.Attributes.percent 100 ]
            [ el None [ padding 32 ] (el Title [ center ] (text "PingPong"))
            , row None [ center ] [ html (Compass.view { direction = model.aim }) ]
            , viewButtonsRow (EveryDict.toList model.targetPositions)
            ]


viewButtonsRow : List ( TargetId, v ) -> Element Styles variation Msg
viewButtonsRow targetPositions =
    List.map (\( id, pos ) -> viewPositionButton id) targetPositions
        |> row None [ center, padding 32, spacing 16 ]


viewPositionButton : TargetId -> Element Styles variation Msg
viewPositionButton targetId =
    let
        targetIdToString (TargetId idString) =
            idString
    in
        el
            None
            []
            (button Button
                [ paddingXY 32 8, onClick (PickTargetPosition targetId) ]
                (text <| targetIdToString targetId)
            )



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
