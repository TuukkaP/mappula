module Main exposing (..)

import Html exposing (programWithFlags)
import Models exposing (Model, Flags, initialModel)
import Commands exposing (fetchQuestions)
import Messages exposing (..)
import Update exposing (update)
import View exposing (view)


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initialModel flags, fetchQuestions flags.origin flags.path )


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
