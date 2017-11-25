module Commands exposing (..)


import Http
import RemoteData
import Json.Decode as Decode
import Json.Encode as Encode exposing (..)
import Json.Decode.Pipeline exposing (decode, required)
import Messages exposing (Msg)
import Models exposing (Slide, Model)

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

saveSlidesUrl : String
saveSlidesUrl =
  "http://localhost:4000/slides"

saveSlidesRequest : List Slide -> Http.Request (List Slide)
saveSlidesRequest slides =
  Http.request
    { body = slidesEncoder slides |> toHttpBody
    , expect = Http.expectJson slidesDecoder
    , headers = []
    , method = "PUT"
    , timeout = Nothing
    , url = saveSlidesUrl
    , withCredentials = False
    }

toHttpBody : String -> Http.Body
toHttpBody someString =
  Http.jsonBody someString

saveSlidesCmd : List Slide -> Cmd Msg
saveSlidesCmd slides =
  saveSlidesRequest slides |>
    Http.send Messages.OnSlideSave

slidesEncoder : List Slide -> String
slidesEncoder slides =
  encode object (slidesReducer slides)

slidesReducer : List Slide -> Encode.Value
slidesReducer slides =
  Encode.list ( List.map(slideEncoder)slides)



slideEncoder : Slide -> Encode.Value
slideEncoder slide =
  let
    attributes =
      [ ("id", Encode.int slide.id)
      , ("title", Encode.string slide.title)
      , ("contents", Encode.string slide.contents)
      ]
  in
    Encode.object (attributes)
  