module Main exposing (..)

import Html exposing (Html)

import Commands exposing (fetchSlides)
import Models exposing (..)
import Updates exposing (..)
import Messages exposing (..)
import Views exposing (..)
import Subscriptions exposing (..)


-- MAIN
main : Program Never Model Msg
main =
  Html.program
    { init = (initModel, fetchSlides)
    , update = update
    , subscriptions = subscriptions
    , view = view
    }
