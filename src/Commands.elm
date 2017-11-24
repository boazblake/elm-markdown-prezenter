module Commands exposing (..)


import Http
import RemoteData
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Messages exposing (Msg)
import Models exposing (Slide)

fetchSlides : Cmd Msg
fetchSlides = 
  Http.get fetchSlidesUrl slidesDecoder
   |> RemoteData.sendRequest
   |> Cmd.map Messages.OnInitialLoad


fetchSlidesUrl : String
fetchSlidesUrl =
  "http://localhost:4000/slides"


slidesDecoder : Decode.Decoder (List Slide)
slidesDecoder =
  Decode.list slideDecoder


slideDecoder : Decode.Decoder Slide
slideDecoder =
  decode Slide
    |> required "id" Decode.int
    |> required "title" Decode.string
    |> required "contents" Decode.string