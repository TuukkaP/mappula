module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (name, style, type_, class, src, classList, class, autoplay)
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
            div [ class "mx-auto", style [ ( "width", "200px" ) ] ]
                [ i [ class "fa fa-cog fa-spin fa-5x fa-fw" ] []
                ]


renderQuestion : Question -> Html Msg
renderQuestion question =
    let
        audioElement =
            case question.audio of
                Just url ->
                    audio [ (autoplay True), src url ] []

                Nothing ->
                    i [ class "fa fa-ban fa-stack-2x text-danger" ] []
    in
        div [ class "container" ]
            [ div [ class "row align-items-center" ]
                [ div [ class "col" ] [ text question.content ]
                , div [ class "col" ]
                    [ a [ class "btn btn-link float-right" ]
                        [ span [ class "fa-stack fa-lg" ]
                            [ i [ class "fa fa-music fa-stack-1x text-primary" ] []
                            , audioElement
                            ]
                        ]
                    ]
                ]
            , renderChoices (question.choices)
            ]


renderChoices : List Choice -> Html Msg
renderChoices choices =
    div [ class "row align-items-center" ] (choices |> List.sortBy .id |> List.map choiceButton)


choiceButton : Choice -> Html Msg
choiceButton choice =
    let
        choiceContent =
            case choice.image of
                Just url ->
                    img [ src url, style [ ( "max-width", "100%" ), ( "max-height", "300px" ) ] ] []

                Nothing ->
                    text choice.content
    in
        div
            [ class "col-md col-sm-12" ]
            [ button
                [ class "btn btn-outline-info mt-4 btn-block"
                , name ("multiple_choice_" ++ toString choice.id)
                , onClick (Messages.Choose choice)
                ]
                [ choiceContent ]
            ]
