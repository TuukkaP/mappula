module Update exposing (..)

import RemoteData exposing (WebData)
import Models exposing (Model, Choice, Question, Answer)
import Messages exposing (Msg)
import Commands exposing (saveAnswerCmd)
import Debug exposing (log)
import Navigation exposing (load)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Messages.OnFetchQuestions response ->
            ( bootstrapQuestions { model | response = response } response, Cmd.none )

        -- Currently answer is created in the next question which is not a good place, TODO refactor
        Messages.Choose choice ->
            let
                next =
                    nextQuestion model choice
            in
                case next.currentQuestion of
                    Just question ->
                        ( next, Cmd.none )

                    Nothing ->
                        log "All answered"
                            ( next, saveAnswerCmd next )

        Messages.OnAnswersPost (Ok answers) ->
            ( model, load "completed" )

        Messages.OnAnswersPost (Err error) ->
            log (toString error)
                ( model, Cmd.none )


bootstrapQuestions : Model -> WebData (List Question) -> Model
bootstrapQuestions model wquestions =
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
                    List.drop 1 questions
            in
                case currentQuestion of
                    Just question ->
                        { model | questions = questionsTail, currentQuestion = currentQuestion }

                    Nothing ->
                        { model | questions = [], currentQuestion = Nothing }

        RemoteData.Failure error ->
            Debug.log (toString error)
                model


nextQuestion : Model -> Choice -> Model
nextQuestion model choice =
    let
        questions =
            model.questions

        nextQuestion =
            List.head questions

        questionsTail =
            List.tail questions

        newModel =
            { model | answers = model.answers ++ [ Answer choice.questionId choice.id ] }
    in
        case questionsTail of
            Just questions ->
                { newModel | questions = questions, currentQuestion = nextQuestion }

            Nothing ->
                { newModel | questions = [], currentQuestion = Nothing }
