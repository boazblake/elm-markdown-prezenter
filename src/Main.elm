module Main exposing (..)

import Html exposing (Html)

import Models exposing (..)
import Updates exposing (..)
import Messages exposing (..)
import Views exposing (..)
import Subscriptions exposing (..)


-- MAIN
main : Program Never Model Msg
main =
  Html.program
    { init = (initModel, Cmd.none)
    , update = update
    , subscriptions = subscriptions
    , view = view
    }
