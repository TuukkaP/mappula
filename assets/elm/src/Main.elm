module Main exposing (..)

import Html exposing (program)
import Models exposing (Model, initialModel)
import Commands exposing (fetchQuestions)
import Messages exposing (..)
import Update exposing (update)
import View exposing (view)


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchQuestions )


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
