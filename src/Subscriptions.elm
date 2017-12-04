module Subscriptions exposing (..)

import AnimationFrame exposing (..)
import Time exposing (second)

import Models exposing (..)
import Messages exposing (..)

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    \_ -> AnimationFrame.times ShowAnotherSlide