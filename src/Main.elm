module Main exposing (..)

import Html exposing (Html, button, div, form, header, h1, input, p, text, textarea)
import Html.Attributes exposing (class, placeholder, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit )


-- MODEL

type alias Model =
  { slides : List Slide
  , title : String
  , contents : String
  , slideId : Maybe Int
  , showSlides : List ShowSlide
  }

type alias Slide =
  { id : Int
  , title : String
  , contents : String
  }

type alias ShowSlide =
  { id : Int
  , slideId : Int
  , title : String
  , contents : String
  }

initModel : Model
initModel =
  { slides = []
  , title = ""
  , contents = ""
  , slideId = Nothing
  , showSlides = []
  }



-- UPDATE


type Msg
  = Edit Slide
  | Score Slide Int
  | InputTitle String
  | InputContents String
  | Save
  | Cancel
  | DeleteShow ShowSlide

update : Msg -> Model -> Model
update msg model =
  case msg of
    InputTitle title ->
      { model | title = title }

    InputContents content ->
      { model
        | contents = content 
      }

    Cancel ->
      { model
        | title = ""
        , contents = ""
        , slideId = Nothing
      }
    
    Save ->
      if (String.isEmpty model.title || String.isEmpty model.contents) then
        model
      else
        save model

    _ ->
      model



save : Model -> Model
save model =
  case model.slideId of
    Just id ->
      edit model id 
    Nothing ->
      add model

edit : Model -> Int -> Model
edit model id =
  let
    newSlides =
      List.map
        (\slide ->
          if slide.id == id then
            { slide
              | title = model.title
              , contents = model.contents
            }
          else slide
        )
          model.slides

    newSlideShow =
      List.map
        (\slideShow ->
          if slideShow.slideId == id then
            { slideShow 
              | title = model.title
              , contents = model.contents
            }
          else
            slideShow
        )
        model.showSlides
  in
      { model
        | slides = newSlides
        , showSlides = newSlideShow
        , title = ""
        , contents = ""
        , slideId = Nothing
      }

add : Model -> Model
add model =
  let
    slide =
    -- Slide <id> <title> <contents>
    Slide (List.length model.slides) model.title model.contents

    newSlides =
      slide :: model.slides
  in
    { model
      | slides = newSlides
      , title = ""
      , contents = ""
    }


-- VIEW
view : Model -> Html Msg
view model =
  div [class "container is-fluid"]
    [ title model
    , playerForm model
    , p [] [text (toString model)]
    ]


title : Model -> Html Msg
title model =
  div [ class "hero is-primary is-bold"  ]
    [ div [ class "hero-body"  ]
      [ header [class "container"]
        [ h1 [class "title is-1 is-spaced"] [text "PREZENTER"]
        ]
      ]
    ]

playerForm : Model -> Html Msg
playerForm model =
  div [class "section"] 
    [ div [ class "container"]
      [ form [  onSubmit Save ]
          [ inputsSection model
          ]
      ]
    ]

inputsSection : Model -> Html Msg
inputsSection model =
  div [ class "section"]
    [ titleInput model
    , textAreaInput model
    , actionsSection model
    ]

actionsSection : Model -> Html Msg
actionsSection model =
  div [ class "container"]
    [  button [ class "button is-success", type_ "submit" ] [ text "Save" ]
    , button [ class "button is-danger", type_ "button", onClick Cancel] [ text "cancel" ]
    ]

titleInput : Model -> Html Msg
titleInput model =
  div [ class "field is-normal"]
    [
      div [ class "field is-horizontal"]
        [ text "Slide Title"]
    , div [ class "field"]
      [ div [ class "field-body"]
        [ div [ class "control"]
          [ input
              [ class "input"
              , type_ "text"
              , placeholder "Add/Edit Slide Title ..."
              , onInput InputTitle
              , value model.title
              ]
                []
          ]
        ]
      ]
    ]

textAreaInput : Model -> Html Msg
textAreaInput model =
  div [ class "field"]
    [ div [ class "label"] [ text "SLIDE CONTENTS"]
    , div [ class "control" ]
        [ textarea
            [ class "textarea"
            , placeholder "Add/Edit Slide Content ..."
            , onInput InputContents
            , value model.contents
            ]
              []
        ]
    ]
-- MAIN
main : Program Never Model Msg
main =
  Html.beginnerProgram
    { model = initModel
    , view = view
    , update = update
    }