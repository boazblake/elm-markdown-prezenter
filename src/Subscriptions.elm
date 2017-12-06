module Subscriptions exposing (..)

import Models exposing (..)
import Messages exposing (..)

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none