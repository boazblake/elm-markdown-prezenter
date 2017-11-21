module Main exposing (..)

import Html exposing (Html, article, button, div, form, header, h1, i, input, p, text, textarea)
import Html.Attributes exposing (class, placeholder, type_, value, width, max)
import Html.Events exposing (onClick, onInput, onSubmit )


-- MODEL

type alias Model =
  { slides : List Slide
  , title : String
  , contents : String
  , slideId : Maybe Int
  , showSlides : List ShowSlide
  , currentPage : String
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
  , currentPage = "slidePicker"
  }

-- UPDATE
type Msg
  = EditSlide Slide
  | AddSlide Slide
  | InputTitle String
  | InputContents String
  | Save
  | Cancel
  | DeleteShow ShowSlide
  | SwitchView String
  | ToPickSlides

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

    AddSlide slide ->
      addSlide model slide


    EditSlide slide ->
        { model 
          | title = slide.title
          , contents = slide.contents
          , slideId = Just slide.id
        }

    SwitchView page ->
      { model 
        | currentPage = page
      }

    _ ->
      model

addSlide : Model -> Slide -> Model
addSlide model slide =
  let
    newShowSlide =
      ShowSlide (List.length model.showSlides) slide.id slide.title slide.contents
  in
      { model
        | showSlides = newShowSlide :: model.showSlides}

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
    , navbar model
    , if model.currentPage == "slidePicker" then
      renderSlidePickerPage model
    else if model.currentPage == "slideViewer" then
      div [] [text "show Slides here"]
    else
      renderSlidePickerPage model
    ]

navbar : Model -> Html Msg
navbar model =
  div [ class "section"]
    [ button [ class "button", type_ "button", onClick (SwitchView "slidePicker")] [ text "PICK SLIDES" ]
    , button [ class "button", type_ "button", onClick (SwitchView "slideViewer")] [ text "VIEW SLIDES" ]
    ]


renderSlidePickerPage : Model -> Html Msg
renderSlidePickerPage model =
  div [class "container is-fluid"]
    [ body model
    , contentViewer model
    -- , p [] [text (toString model)]
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


body : Model -> Html Msg
body model =
  div [ class "columns"]
    [ slideForm model
    , slideShowSection model
    ]

slideShowSection : Model -> Html Msg
slideShowSection model =
  div [ class "column"]
        [ div [class "section"]
          [ slidesCollection model  ]
      -- , slideShowActions model
        ]

slidesCollection : Model -> Html Msg
slidesCollection model =
  model.slides
    |> List.sortBy .title
    |> List.map slide
    |> div [ class "columns is-multiline"]
        -- (List.map slide model.slides)
  
slide : Slide -> Html Msg
slide slide =
  article [ class "column is-2 box"]
    [ div []
        [ i
          [ class "fa fa-edit"
          , onClick (EditSlide slide)
          ]
          []
        , div []
          [ text slide.title]
        , button [ type_ "button", class "button", onClick (AddSlide slide)]
            [ text "ADD NEXT"]
        ]
    ]


slideForm : Model -> Html Msg
slideForm model =
  div [class "column is-4"] 
    [ div [ ]
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
  div [ class "section"]
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


contentViewer : Model -> Html Msg
contentViewer model =
  if (not (String.isEmpty model.contents)) then
    div [class "section box"]
      [ text (toString model.contents)]
    else 
      div [class "section box"]
        [ ] 










-- MAIN
main : Program Never Model Msg
main =
  Html.beginnerProgram
    { model = initModel
    , view = view
    , update = update
    }