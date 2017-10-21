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
    case parseFormIdFromPath path of
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
        |> JsonPipeline.required "audio" (Decode.nullable Decode.string)
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
        |> JsonPipeline.required "answer" Decode.int


saveAnswersUrl : String -> String -> String
saveAnswersUrl origin path =
    case parseFormIdFromPath path of
        Just id ->
            origin ++ "/api/forms/" ++ id ++ "/answers"

        Nothing ->
            crash "Faulty form id"


saveAnswersRequest : Model -> Http.Request (List Answer)
saveAnswersRequest model =
    Http.request
        { body = answersEncoder model.answers |> Http.jsonBody
        , expect = Http.expectJson answersDecoder
        , headers = []
        , method = "POST"
        , timeout = Nothing
        , url = saveAnswersUrl model.origin model.path
        , withCredentials = False
        }


saveAnswerCmd : Model -> Cmd Msg
saveAnswerCmd model =
    saveAnswersRequest model
        |> Http.send Messages.OnAnswersPost


answersEncoder : List Answer -> Encode.Value
answersEncoder answers =
    let
        questionAttribute answer =
            Encode.object
                [ ( "question_id", Encode.int answer.questionId )
                , ( "answer", Encode.int answer.answer )
                ]

        attributes =
            answers
                |> List.map questionAttribute
    in
        Encode.object [ ( "answers", Encode.list attributes ) ]


parseFormIdFromPath : String -> Maybe String
parseFormIdFromPath path =
    path
        |> String.split "/"
        |> List.drop 2
        |> List.head
