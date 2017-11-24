module Messages exposing (..)


import Models exposing (Slide, ShowSlide)



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

