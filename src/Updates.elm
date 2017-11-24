module Updates exposing (..)


import Messages exposing (Msg(..))
import Models exposing (Model, Slide, ShowSlide)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    InputTitle title ->
      ({ model | title = title }, Cmd.none)

    InputContents content ->
      (
        { model
        | contents = content 
        }
        , Cmd.none
      )

    Cancel ->
     ( { model
        | title = ""
        , contents = ""
        , slideId = Nothing
      }
      , Cmd.none)
    
    Save ->
      if (String.isEmpty model.title || String.isEmpty model.contents) then
        (model, Cmd.none)
      else
        save model

    AddSlide slide ->
      addSlide model slide


    EditSlide slide ->
      (
        { model 
        | title = slide.title
        , contents = slide.contents
        , slideId = Just slide.id
        }
        , Cmd.none
      )

    SwitchView page ->
      ({ model 
        | currentPage = page
      }, Cmd.none)


    ShowAnotherSlide direction ->
      showAnotherSlide direction model

    _ ->
      (model, Cmd.none)


showAnotherSlide : String -> Model -> (Model, Cmd Msg)
showAnotherSlide direction model =
  case direction of
    "+" ->
      if model.currentSlideId == ( List.length model.showSlides - 1)  then
        (model, Cmd.none)
      else
        ({ model
            | currentSlideId = model.currentSlideId + 1 
        }
        , Cmd.none)
    
    "-" ->
      if model.currentSlideId == 0 then 
        (model, Cmd.none)
      else
        ({ model
            | currentSlideId = model.currentSlideId - 1
        }, Cmd.none)

    "restart" ->
          ({ model
            | currentSlideId = 0 
          }, Cmd.none)

    _ ->
      (model, Cmd.none)
     

addSlide : Model -> Slide -> (Model, Cmd Msg)
addSlide model slide =
  
  let
    newShowSlide =
      ShowSlide (List.length model.showSlides) slide.id slide.title slide.contents
  
    isUnique x xs =
      List.filter(\s -> s.slideId == x.slideId) xs

  in
    if ( List.isEmpty (isUnique newShowSlide model.showSlides) ) then
      (
        { model
        | showSlides = newShowSlide :: model.showSlides 
        }
        , Cmd.none
      )
    
    else
      (model, Cmd.none)
      

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
      (
        { model
        | slides = newSlides
        , showSlides = newSlideShow
        , title = ""
        , contents = ""
        , slideId = Nothing
        }
        , Cmd.none
      )

add : Model -> (Model, Cmd Msg)
add model =
  let
    slide =
    -- Slide <id> <title> <contents>
    Slide (List.length model.slides) model.title model.contents

    newSlides =
      slide :: model.slides
  in
    (
      { model
      | slides = newSlides
      , title = ""
      , contents = ""
      }
      , Cmd.none
    )
