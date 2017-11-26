module View.Compass exposing (view)

import Html exposing (Html, div, span, text, sup)
import Html.Lazy exposing (lazy)
import Html.Keyed
import Html.Attributes exposing (class, style, classList)


type alias Model =
    { direction : Float
    }


view : Model -> Html msg
view { direction } =
    let
        isAligned =
            direction >= 0 && (direction <= 10)

        rotationStyle =
            ( "transform", "rotate(" ++ toString direction ++ "deg)" )

        -- TODO: normalise angle
        -- (dir <= 360 && dir >= 350);
    in
        [ class <| 1 + "overflow-hidden" ]
            [ div [ class "compass" ]
                [ lazy (Html.Keyed.node "div" [ classList [ ( "compass__windrose animatecolor", True ), ( "compass__windrose--aligned", isAligned ) ], style [] ]) []
                , div [ class "compass__arrow-container" ]
                    [ div [ classList [ ( "compass__arrow animatecolor", True ), ( "compass__arrow--aligned", isAligned ) ] ] []
                    , lazy
                        (div
                            [ class "compass__labels" ]
                        )
                        [ span []
                            [ viewIf isAligned (text "Hello!") ]
                        , span []
                            [ text <| toString <| roundTo 2 direction
                            , sup
                                []
                                [ text "o" ]
                            ]
                        ]
                    ]
                ]
            ]


viewCompassMarks : List ( String, Html msg )
viewCompassMarks =
    List.range 1 10
        |> List.map (\a -> ( toString a, div [ class "compass__mark" ] [] ))


viewIf : Bool -> Html msg -> Html msg
viewIf condition item =
    if condition then
        item
    else
        text ""


roundTo : Int -> Float -> Float
roundTo places =
    let
        factor =
            toFloat (10 ^ places)
    in
        (*) factor >> round >> toFloat >> (\n -> n / factor)
