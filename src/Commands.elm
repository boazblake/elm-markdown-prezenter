module Commands exposing (..)


import Http
import RemoteData
import Json.Decode as Decode
import Json.Encode as Encode exposing (..)
import Json.Decode.Pipeline exposing (decode, required)
import Messages exposing (Msg)
import Models exposing (Slide, Model, Slides)

fetchSlides : Cmd Msg
fetchSlides = 
  Http.get slidesUrl slidesDecoder
   |> RemoteData.sendRequest
   |> Cmd.map Messages.OnInitialLoad


slidesUrl : String
slidesUrl =
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


saveSlidesRequest : Slide -> Http.Request (List Slide)
saveSlidesRequest slide =
  Http.request
    { body = slideEncoder slide |> Http.jsonBody
    , expect = Http.expectJson slidesDecoder
    , headers = []
    , method = "POST"
    , timeout = Nothing
    , url = slidesUrl
    , withCredentials = False
    }

toHttpBody : Encode.Value -> Http.Body
toHttpBody slide =
  Http.jsonBody (Debug.log "slides being saved?"slide)

saveSlidesCmd : Slide -> Cmd Msg
saveSlidesCmd model =
  saveSlidesRequest model |>
    Http.send Messages.OnSlideSave 

slidesEncoder : List Slide -> Encode.Value
slidesEncoder slides =
  Encode.list (List.map(slideEncoder)slides)

slideEncoder : Slide -> Encode.Value
slideEncoder slide =
  let
    attributes =
      [ ("id", Encode.int slide.id)
      , ("title", Encode.string slide.title)
      , ("contents", Encode.string slide.contents)
      ]
  in
    Encode.object attributes
  