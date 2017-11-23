module Main exposing (..)

import Html exposing (Html, article, button, div, form, header, h1, i, input, p, text, textarea)
import Html.Attributes exposing (class, placeholder, type_, value, width, max)
import Html.Events exposing (onClick, onInput, onSubmit )
import Markdown


-- MODEL

type alias Model =
  { slides : List Slide
  , title : String
  , contents : String
  , slideId : Maybe Int
  , currentSlide: Maybe ShowSlide
  , currentSlideId: Int
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
  , currentSlide = Nothing
  , currentSlideId = 0
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
  | ShowAnotherSlide String

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


    ShowAnotherSlide direction ->
      showAnotherSlide direction model

    _ ->
      model


showAnotherSlide : String -> Model -> Model
showAnotherSlide direction model =
  case direction of
    "+" ->
        {model
          | currentSlideId = model.currentSlideId + 1 }
    
    "-" ->
        {model
          | currentSlideId = model.currentSlideId - 1 }

    _ ->
      model
     

addSlide : Model -> Slide -> Model
addSlide model slide =
  
  let
    newShowSlide =
      ShowSlide (List.length model.showSlides) slide.id slide.title slide.contents
  
    isUnique x xs =
      List.filter(\s -> s.slideId == x.slideId) xs

  in
    if ( List.isEmpty (isUnique newShowSlide model.showSlides) ) then
      { model
        | showSlides = newShowSlide :: model.showSlides }
    
    else
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
    , navbar model
    , if model.currentPage == "slidePicker" then
      renderSlidePickerPage model
    else if model.currentPage == "slideViewer" then
      renderSlideShow model
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
    [ div [class "section"]
      [ text slide.title]
    , div [] 
      [ button [ type_ "button", class "button", onClick (EditSlide slide)]
          [ i  [ class "fa fa-edit" ]
            []]
    , button [ type_ "button", class "button", onClick (AddSlide slide)]
          [ i  [ class "fa fa-share-square-o" ]
            []
            ]
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
              ] []
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
            ] []
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

renderSlideShow : Model -> Html Msg
renderSlideShow model =
        div [] 
        [ div [class "container"]
          [ div [ class "columns"] 
            [ previousButton model
            , slideContentViewer model
            , nextButton model
            ]
          ]
        ]

slideContentViewer : Model -> Html Msg
slideContentViewer model =
      let
        slideShow =
          model.showSlides
            |> List.sortBy .id

        currentSlide =
          (List.sortBy .id model.showSlides, model.currentSlideId)
            |> toCurrentSlide
            |> Debug.log "text"
            |> toHtml
            -- |> toValue
            -- |> toMarkDown


      in
        div []
          [ text (toString slideShow)
          , div[] [text "----------------------"]
          , text (toString model)
                ,  div [ class "section box" ]
                  [
                  article [ class "media" ]
                    [ currentSlide ]
                  ]
                ]


toCurrentSlide : ( List ShowSlide, Int) -> (List ShowSlide, Int)
toCurrentSlide ( slides, chosenId) =
  (List.filter
    (\s ->
      s.id == chosenId
    )
    slides, chosenId)





toHtml : (List ShowSlide, Int) -> Html Msg
toHtml (slides, id) =
  Html.text (toString (slides, id))

toValue : Maybe ShowSlide -> String
toValue maybeShowSlide =
  case maybeShowSlide of
    Just maybeShowSlide -> toString maybeShowSlide.contents
    Nothing -> "You need to first select a slide"


toMarkDown : message -> Html Msg
toMarkDown message =
  div [] 
    <| Markdown.toHtml Nothing (toString message)

previousButton : Model -> Html Msg
previousButton model =
  div [class "column"]
    [ button [ class "button", type_ "button", onClick (ShowAnotherSlide "-")] [ text "PREVIOUS" ]
    ]

nextButton : Model -> Html Msg
nextButton model =
  div [class "column"]
    [ button [ class "button", type_ "button", onClick (ShowAnotherSlide "+")] [ text "NEXT" ]
    ]



-- MAIN
main : Program Never Model Msg
main =
  Html.beginnerProgram
    { model = initModel
    , view = view
    , update = update
    }