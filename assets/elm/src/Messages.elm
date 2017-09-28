module Messages exposing (..)

import Http exposing (Error)
import RemoteData exposing (WebData)
import Models exposing (Choice, Question, Answer)


type Msg
    = OnFetchQuestions (WebData (List Question))
    | Choose Choice
    | OnAnswersPost (Result Http.Error (List Answer))
