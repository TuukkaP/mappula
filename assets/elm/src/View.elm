module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (name, style, type_, class, src, classList)
import Html.Events exposing (onClick)
import Models exposing (Model, Choice, Question)
import Messages exposing (Msg)


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
        [ label [] [ text question.content ]
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
            [ input [ type_ "radio", name ("multiple_choice_" ++ toString choice.id), onClick (Messages.Choose choice) ] []
            , choiceContent
            ]
