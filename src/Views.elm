module Views exposing (..)

import Bulma.CDN exposing (stylesheet)



import Html exposing (Html, a, nav, article, button, div, form, header, h1, i, input, p, pre, text, textarea)
import Html.Attributes exposing (class, placeholder, type_, value, width, max, style)
import Html.Events exposing (onClick, onInput, onSubmit )
import Markdown
import Models exposing (Model, Slide, ShowSlide)
import Messages exposing (Msg(..))



-- VIEW
view : Model -> Html Msg
view model =
  div [ ]
  [stylesheet, page model]

page: Model -> Html Msg
page model =
  div [class "section is-light is-bold"]
    [ title model
    , navbar model
    , case model.currentPage of
        "slidePicker" ->
          renderSlidePickerPage model
        "slideViewer" ->
          renderSlideShow model
        _->
          renderSlidePickerPage model
    ]

navbar : Model -> Html Msg
navbar model =
  nav [ class "navbar"  ]
      [ nav [ class "navbar-menu"]
        [ nav [class "navbar-start"]
            [  a [class "navbar-item",  onClick (SwitchView "slidePicker")]
                [ text "PICK SLIDES" ]
            , a [class "navbar-item",  onClick (SwitchView "slideViewer")]
                [ text "VIEW SLIDES" ]
            ]
        ]
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
        [ h1 [class "title is-1 is-spaced", style[("text-align", "center")]] [text "PREZENTER"]
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
    |> div [ class "columns is-variable is-3 is-multiline"]
        -- (List.map slide model.slides)

slide : Slide -> Html Msg
slide slide =
  article [ class "column is-2 box notification"]
    [ div [class "section" ]
      [ text slide.title]
    , div []
      [ button [ type_ "button", class "button", onClick (EditSlide slide)]
          [ i  [ class "fa fa-edit" ]
            []]
    , button [ type_ "button", class "button", onClick (AddSlideToShow slide)]
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
      [ div [class ""]
        [ toMarkDown model.contents ]
      ]
    else
      div [class "section box"]
        [ pre [] [text "MARKDOWN HERE"] ]

renderSlideShow : Model -> Html Msg
renderSlideShow model =
        div [class "section hero is-light is-bold"]
        [ div []
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
            -- |> Debug.log "text"
            |> toValue
            |> toHtml
            |> toMarkDown


      in
        div [class "column is-four-fifths"]
          [
          --   text (toString slideShow)
          -- , div[] [text "----------------------"]
          -- , text (toString model)
               div [ class "hero box is-bold" ]
                  [
                  article [ class "media" ]
                    [ div [class "content"]
                      [ currentSlide ] ]
                  ]
                , div [ ]
                    [ restartButton model]

                ]


toCurrentSlide : ( List ShowSlide, Int) -> (List ShowSlide, Int)
toCurrentSlide ( slides, chosenId) =
  (List.filter
    (\s ->
      s.id == chosenId
    )
    slides, chosenId)

toValue : (List ShowSlide, Int) -> Maybe ShowSlide
toValue (slides, id) =
  if List.length slides == 0 then
    Nothing
  else
    List.head slides


toHtml : Maybe ShowSlide -> String
toHtml maybeSlide =
  case maybeSlide of
    Just maybeSlide ->
      maybeSlide.contents
    Nothing ->
      "You need to pick a slide first"

toMarkDown : String -> Html Msg
toMarkDown content =
    Markdown.toHtml [class "content"] content


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

restartButton : Model -> Html Msg
restartButton model =
  div [class "column"]
    [ button [ class "button", type_ "button", onClick (ShowAnotherSlide "restart")] [ text "RESTART" ]
    ]
