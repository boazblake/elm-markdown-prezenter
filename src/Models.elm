module Models exposing (..)



import RemoteData exposing (WebData)
-- MODEL

type alias Model =
  { slides : List Slide
  , title : String
  , contents : String
  , slideId : Maybe Int
  , currentSlide: Maybe ShowSlide
  , currentSlideId: Int
  , showSlides : List ShowSlide
  , dbSlides : WebData (Slides)
  , currentPage : String
  }

type alias Slide =
  { id : Int
  , title : String
  , contents : String
  , isEditing : Bool
  }

type alias Slides =
  List Slide

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
  , dbSlides = RemoteData.Loading
  , currentPage = "slidePicker"
  }