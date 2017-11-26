module Messages exposing (..)

import Http
import RemoteData exposing (WebData)


import Models exposing (Slide, Slides, ShowSlide)



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
  | OnInitialLoad (WebData(List(Slide)))
  | OnSlideSave (Result Http.Error (List Slide))