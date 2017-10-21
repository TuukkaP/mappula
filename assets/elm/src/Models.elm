module Models exposing (..)

import RemoteData exposing (WebData)


initialModel : Flags -> Model
initialModel flags =
    { response = RemoteData.Loading
    , questions = []
    , currentQuestion = Nothing
    , answers = []
    , origin = flags.origin
    , path = flags.path
    }


type alias Flags =
    { origin : String
    , path : String
    }


type alias Question =
    { id : QuestionId
    , formId : FormId
    , content : String
    , correctAnswer : String
    , questionType : String
    , audio : Maybe String
    , choices : List Choice
    }


type alias Choice =
    { id : ChoiceId
    , questionId : QuestionId
    , content : String
    , url : Maybe String
    , image : Maybe String
    }


type alias QuestionId =
    Int


type alias ChoiceId =
    Int


type alias FormId =
    Int


type alias QuestionList =
    { questions : List Question }


type alias Answer =
    { questionId : QuestionId
    , answer : ChoiceId
    }



{--TODO Change answers to WebData (List Answer) to support errors from backend
--}


type alias Model =
    { response : WebData (List Question)
    , questions : List Question
    , currentQuestion : Maybe Question
    , answers : List Answer
    , origin : String
    , path : String
    }
