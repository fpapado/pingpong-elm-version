port module Ports exposing (targetPositionOut, customAimIn)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline


port targetPositionOut : ( Float, Float ) -> Cmd msg


port customAimIn : (Float -> msg) -> Sub msg


port customAimError : (String -> msg) -> Sub msg
