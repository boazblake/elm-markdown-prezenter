module Updates exposing (..)

import Commands exposing (saveSlidesCmd)

import RemoteData exposing (WebData)

import Messages exposing (Msg(..))
import Models exposing (Model, Slide, ShowSlide)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    OnInitialLoad response ->
      parseSlides model response

    InputTitle title ->
      ({ model | title = title }, Cmd.none)

    InputContents content ->
      ( { model
        | contents = content
        }
        , Cmd.none )

    Cancel ->
     ( { model
        | title = ""
        , contents = ""
        , slideId = Nothing
      }
      , Cmd.none)

    Save ->
      let
          emptyTitle =
            String.isEmpty model.title
          
          emptyContents =
            String.isEmpty model.contents
      in
          
      if emptyTitle || emptyContents then
        (model, Cmd.none)
      else
        save model

    AddSlideToShow slide ->
      addSlideToShow model slide

    EditSlide slide ->
      editSlide model slide

    SwitchView page ->
      ( { model
        | currentPage = page
      }, Cmd.none )

    ShowAnotherSlide direction ->
      showAnotherSlide direction model

    OnSlideSave (Ok slides) ->
     ( Debug.log"slide saved"
      <| updateSlides model slides )

    OnSlideSave (Err err) ->
      ( Debug.log"slide ERROR"
      <| model, Cmd.none )

    _ ->
      ( model, Cmd.none )


editSlide : Model -> Slide -> (Model, Cmd Msg)
editSlide model slide =
  ( { model
  | title = slide.title
  , contents = slide.contents
  , slideId = Just slide.id
  } , Cmd.none )

toggleisEditing: Slide -> Slide
toggleisEditing slide =
  { slide | isEditing = (not slide.isEditing)}

updateSlides : Model -> List Slide -> (Model, Cmd Msg)
updateSlides model fromDbSlides =
  Debug.log "dbslides?"
  ( { model
        | slides = fromDbSlides
    } , Cmd.none )

parseSlides :  Model -> WebData (List Slide) -> (Model, Cmd Msg)
parseSlides model maybeModel =
  case maybeModel of
    RemoteData.NotAsked ->
      ( model, Cmd.none )

    RemoteData.Loading ->
      ( model, Cmd.none )

    RemoteData.Success dbSlides ->
      ( { model
          | slides = dbSlides
        } , Cmd.none )

    RemoteData.Failure error ->
      ( model, Cmd.none )


showAnotherSlide : String -> Model -> (Model, Cmd Msg)
showAnotherSlide direction model =
  case direction of
    "+" ->
      if model.currentSlideId == ( List.length model.showSlides - 1)  then
        ( model, Cmd.none )
      else
        ( { model
            | currentSlideId = model.currentSlideId + 1
        }
        , Cmd.none )

    "-" ->
      if model.currentSlideId == 0 then
        ( model, Cmd.none )
      else
        ( { model
            | currentSlideId = model.currentSlideId - 1
        }, Cmd.none )

    "restart" ->
        ( { model
            | currentSlideId = 0
        } , Cmd.none )

    _ ->
        ( model, Cmd.none )


addSlideToShow : Model -> Slide -> (Model, Cmd Msg)
addSlideToShow model slide =

  let
    showSlideId =
      model.showSlides
        |> List.length 

    newShowSlide =
      ShowSlide showSlideId slide.id slide.title slide.contents

    isUnique x xs =
      List.filter(\s -> s.slideId == x.slideId) xs

  in
    if 
      List.isEmpty (model.showSlides |> isUnique newShowSlide )
    then
      (
        { model
        | showSlides = newShowSlide :: model.showSlides
        } , Cmd.none )

    else
      ( model, Cmd.none )


save : Model -> (Model, Cmd Msg)
save model =
  case model.slideId of
    Just id ->
      edit model id
    Nothing ->
      add model

edit : Model -> Int -> (Model, Cmd Msg)
edit model id =
  let
    compareSlideById slide id =
      slide.id == id 

    newSlides =
      List.map
        (\slide ->
          if compareSlideById slide id then
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
    ( { model
      | slides = newSlides
      , showSlides = newSlideShow
      , title = ""
      , contents = ""
      , slideId = Nothing
      } , saveSlidesCmd newSlides )

add : Model -> (Model, Cmd Msg)
add model =
  let
    slideId =
      model.slides
        |>  List.length

    -- Slide <id> <title> <contents>
    slide =
    Slide slideId model.title model.contents False

    newSlides =
      Debug.log "adding slides?"
        slide :: model.slides
  in
    ( { model
      | slides = newSlides
      , title = ""
      , contents = ""
      } , saveSlidesCmd newSlides )
