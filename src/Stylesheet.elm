module Stylesheet exposing (stylesheet, Styles(..))

import Color as Color exposing (rgba)
import Style exposing (StyleSheet, styleSheet, style)
import Style.Font as Font exposing (font)
import Scale exposing (CustomScale, makeCustomScale, getScaled)
import Style.Color as Color


-- We need a type that represents out style identifiers.
-- These act like css classes


type Styles
    = Button
    | Title
    | None
    | MainContainer



-- We define our stylesheet


scale : CustomScale
scale =
    makeCustomScale
        [ 3, 2.25, 1.5, 1.25, 1, 0.875, 0.75 ]


scaled : Int -> Float
scaled =
    getScaled 16 scale


colors =
    { siteblue = rgba 43 133 157 1
    , darkgray = rgba 51 51 51 1
    , lightblue = rgba 150 204 255 1
    }


type FontStack
    = SansSerif
    | Serif


stack : FontStack -> List Style.Font
stack fontstack =
    case fontstack of
        SansSerif ->
            [ font "-apple-system"
            , font "BlinkMacSystemFont"
            , font "avenir next"
            , font "avenir"
            , font "helvetica neue"
            , font "helvetica"
            , font "ubuntu"
            , font "robotol"
            , font "noto"
            , font "segoe ui"
            , font "arial"
            , font "sans-serif"
            ]

        Serif ->
            [ Font.font "georgia"
            ]


stylesheet : StyleSheet Styles variation
stylesheet =
    styleSheet
        [ style MainContainer
            [ Color.background colors.siteblue
            ]
        , style Button
            [ Font.size (scaled 4)
            , Font.typeface (stack SansSerif)
            , Font.bold
            , Color.background Color.white
            , Color.text colors.darkgray
            ]
        , style None []
        , style Title
            [ Font.size (scaled 2)
            ]
        ]
