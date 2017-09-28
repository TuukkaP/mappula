module Commands exposing (..)

import Http
import RemoteData exposing (WebData)
import Json.Decode as Decode
import Json.Decode.Pipeline as JsonPipeline exposing (decode, required)
import Json.Encode as Encode
import Models exposing (Choice, Question, Answer, Model)
import Messages exposing (Msg)
import Debug exposing (crash)


fetchQuestions : String -> String -> Cmd Msg
fetchQuestions origin path =
    Http.get (fetchQuestionsUrl origin path) questionsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Messages.OnFetchQuestions


fetchQuestionsUrl : String -> String -> String
fetchQuestionsUrl origin path =
    let
        formId =
            path
                |> String.split "/"
                |> List.drop 2
                |> List.head
    in
        case formId of
            Just id ->
                origin ++ "/api/forms/" ++ id ++ "/questions"

            Nothing ->
                crash "Faulty form id"


questionsDecoder : Decode.Decoder (List Question)
questionsDecoder =
    Decode.list questionDecoder


questionDecoder : Decode.Decoder Question
questionDecoder =
    JsonPipeline.decode Question
        |> JsonPipeline.required "id" Decode.int
        |> JsonPipeline.required "form_id" Decode.int
        |> JsonPipeline.required "content" Decode.string
        |> JsonPipeline.required "correct_answer" Decode.string
        |> JsonPipeline.required "question_type" Decode.string
        |> JsonPipeline.required "choices" (Decode.list choiceDecoder)


choiceDecoder : Decode.Decoder Choice
choiceDecoder =
    JsonPipeline.decode Choice
        |> JsonPipeline.required "id" Decode.int
        |> JsonPipeline.required "question_id" Decode.int
        |> JsonPipeline.required "content" Decode.string
        |> JsonPipeline.required "url" (Decode.nullable Decode.string)
        |> JsonPipeline.required "image" (Decode.nullable Decode.string)


answersDecoder : Decode.Decoder (List Answer)
answersDecoder =
    Decode.list answerDecoder


answerDecoder : Decode.Decoder Answer
answerDecoder =
    JsonPipeline.decode Answer
        |> JsonPipeline.required "question_id" Decode.int
        |> JsonPipeline.required "answer" Decode.string


saveAnswersUrl : String -> String
saveAnswersUrl origin =
    origin ++ "/api/answers"


saveAnswersRequest : Model -> Http.Request (List Answer)
saveAnswersRequest model =
    Http.request
        { body = answersEncoder model.answers |> Http.jsonBody
        , expect = Http.expectJson answersDecoder
        , headers = []
        , method = "POST"
        , timeout = Nothing
        , url = saveAnswersUrl model.origin
        , withCredentials = False
        }


saveAnswerCmd : Model -> Cmd Msg
saveAnswerCmd model =
    saveAnswersRequest model
        |> Http.send Messages.OnAnswersPost


answersEncoder : List Answer -> Encode.Value
answersEncoder answers =
    let
        attributes =
            answers
                |> List.map (\answer -> Encode.object [ ( "question_id", Encode.int answer.questionId ), ( "answer", Encode.string answer.answer ) ])
    in
        Encode.list attributes
