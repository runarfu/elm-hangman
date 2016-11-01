module Views exposing (view)

import Html exposing (..)
import String
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Set exposing (Set)
import Types exposing (..)


view : Game -> Html Msg
view game =
    div [ centerStyle ]
        [ header
        , viewGame game
        ]


header =
    h1 [] [ text "Hangman" ]


viewGame : Game -> Html Msg
viewGame game =
    div []
        [ viewSecretWord game
        , viewButtons game
        , viewProgress game
        ]


viewSecretWord : Game -> Html Msg
viewSecretWord game =
    let
        word =
            hideCharacters game.staticData.secretWord game.state game.guessedCharacters

        wordWithSpaces =
            word
                |> String.toList
                |> List.intersperse ' '
                |> String.fromList
    in
        h2 [] [ text wordWithSpaces ]


hideCharacters : String -> GameState -> Letters -> String
hideCharacters secretWord gameState guessedCharacters =
    case gameState of
        Playing ->
            String.toList secretWord
                |> List.map (hideSingleCharacter guessedCharacters)
                |> String.fromList

        Won ->
            secretWord

        Lost ->
            secretWord


hideSingleCharacter : Letters -> Char -> Char
hideSingleCharacter guessedCharacters guessedCharacter =
    if Set.member guessedCharacter guessedCharacters then
        guessedCharacter
    else
        '_'


viewButtons : Game -> Html Msg
viewButtons game =
    let
        unusedCharacters =
            Set.diff game.staticData.alphabet game.guessedCharacters
                |> Set.toList
                |> List.sort

        gameIsOver =
            List.member game.state [ Won, Lost ]
    in
        div []
            (List.map
                (\c ->
                    button
                        [ onClick (Guess c)
                        , disabled gameIsOver
                        , title <| "Guess '" ++ String.fromChar c ++ "'"
                        ]
                        [ text <| String.fromChar c ]
                )
                unusedCharacters
            )


viewProgress : Game -> Html Msg
viewProgress game =
    div []
        [ h2 [] [ text <| progressStatusMessage game ]
        , viewImage game
        ]


progressStatusMessage : Game -> String
progressStatusMessage game =
    case game.state of
        Playing ->
            "You have " ++ (toString game.attemptsLeft) ++ " attempts left"

        Won ->
            "You won!"

        Lost ->
            "You lost!"


viewImage : Game -> Html Msg
viewImage game =
    img [ src (filename game.attemptsLeft) ] []


filename : Int -> String
filename attemptsLeft =
    let
        zeroPadded =
            String.padLeft 2 '0' (toString attemptsLeft)
    in
        "../img/hangman_" ++ (zeroPadded) ++ ".png"


centerStyle =
    style [ ( "text-align", "center" ) ]
