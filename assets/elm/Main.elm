module Main exposing (..)

import Http
import RemoteData exposing (WebData)
import Json.Decode as Decode
import Json.Decode.Pipeline as JsonPipeline exposing (decode, required)
import Html exposing (..)
import Html.Attributes exposing (name, style, type_, class, src, classList)
import Html.Events exposing (onClick)
import Debug exposing (log)
import Navigation exposing (Location)


--- Models


type alias Question =
    { id : QuestionId
    , formId : Int
    , content : String
    , correctAnswer : String
    , questionType : String
    , choices : List Choice
    }


type alias Choice =
    { id : Int
    , questionId : QuestionId
    , content : String
    , url : Maybe String
    , image : Maybe String
    }


type alias QuestionId =
    Int


type alias QuestionList =
    { questions : List Question }


type alias Answer =
    { question_id : Int
    , answer : String
    }


type alias Model =
    { response : WebData (List Question)
    , questions : List Question
    , currentQuestion : Maybe Question
    , answers : List Answer
    }



--- Commands


fetchQuestions : Cmd Msg
fetchQuestions =
    Http.get fetchQuestionsUrl questionsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OnFetchQuestions


fetchQuestionsUrl : String
fetchQuestionsUrl =
    "http://localhost:4000/api/forms/1/questions"


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



-- Add form to your model and msgs


type Msg
    = OnFetchQuestions (WebData (List Question))
    | Choose Choice



-- Setup form validation
---    ( { form = Form.initial [] validation }, Cmd.none )


initialModel : Model
initialModel =
    { response = RemoteData.Loading
    , questions = []
    , currentQuestion = Nothing
    , answers = []
    }



---( { form = RemoteData.Loading }, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchQuestions )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchQuestions questions ->
            ( setQuestions model questions, Cmd.none )

        Choose choice ->
            let
                next =
                    nextQuestion model
            in
                case next.currentQuestion of
                    Just question ->
                        log (toString question)
                            ( next, Cmd.none )

                    Nothing ->
                        log "All answered"
                            ( next, Cmd.none )


setQuestions : Model -> WebData (List Question) -> Model
setQuestions model wquestions =
    case wquestions of
        RemoteData.NotAsked ->
            Debug.log ("NotAsked")
                model

        RemoteData.Loading ->
            Debug.log ("Loading")
                model

        RemoteData.Success questions ->
            let
                currentQuestion =
                    List.head questions

                questionsTail =
                    List.tail questions
            in
                case questionsTail of
                    Just questions ->
                        { model | questions = questions, currentQuestion = currentQuestion }

                    Nothing ->
                        { model | questions = [], currentQuestion = Nothing }

        RemoteData.Failure error ->
            Debug.log (toString error)
                model


nextQuestion : Model -> Model
nextQuestion model =
    case model.questions of
        questions ->
            let
                nextQuestion =
                    List.head questions

                questionsTail =
                    List.tail questions
            in
                case questionsTail of
                    Just questions ->
                        { model | questions = questions, currentQuestion = nextQuestion }

                    Nothing ->
                        { model | questions = [], currentQuestion = Nothing }



-- Render form with Input helpers


view : Model -> Html Msg
view response =
    div []
        [ maybeQuestion response ]


maybeQuestion : Model -> Html Msg
maybeQuestion model =
    case model.currentQuestion of
        Just question ->
            renderQuestion question

        Nothing ->
            img [ src ("http://localhost:4000/images/loading.gif") ] []


renderQuestion : Question -> Html Msg
renderQuestion question =
    div [ class "form-group" ]
        [ text question.content
        , renderChoices (question.choices)
        ]


renderChoices : List Choice -> Html Msg
renderChoices choices =
    div [ class "form-group" ] (List.map radio choices)


radio : Choice -> Html Msg
radio choice =
    let
        choiceContent =
            case choice.image of
                Just url ->
                    img [ src url, style [ ( "height", "200px" ) ] ] []

                Nothing ->
                    text choice.content
    in
        label
            [ classList [ ( "form-check-label", True ) ] ]
            [ input [ type_ "radio", name ("multiple_choice_" ++ toString choice.id), onClick (Choose choice) ] []
            , choiceContent
            ]


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
