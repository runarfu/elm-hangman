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
    h1 [] [ text "Hangman in Elm" ]


viewGame : Game -> Html Msg
viewGame game =
    div []
        [ viewSecretWords game
        , viewButtons game
        , viewProgress game
        ]


viewSecretWords : Game -> Html Msg
viewSecretWords game =
    h2 [ style [ ( "font-family", "courier" ) ] ]
        [ hideUnguessedCharacters game
            |> List.map spaceLetters
            |> String.join " - "
            |> text
        ]


hideUnguessedCharacters : Game -> Words
hideUnguessedCharacters game =
    case game.state of
        Playing ->
            game.staticData.secretWords
                |> List.map (hideSingleCharacterInWord game.guessedCharacters)

        Won ->
            game.staticData.secretWords

        Lost ->
            game.staticData.secretWords


hideSingleCharacterInWord : Letters -> String -> String
hideSingleCharacterInWord guessedCharacters word =
    word
        |> String.toList
        |> List.map (hideSingleCharacter guessedCharacters)
        |> String.fromList


hideSingleCharacter : Letters -> Char -> Char
hideSingleCharacter guessedCharacters guessedCharacter =
    if Set.member guessedCharacter guessedCharacters then
        guessedCharacter
    else
        '_'


spaceLetters : String -> String
spaceLetters string =
    string
        |> String.toList
        |> List.intersperse ' '
        |> String.fromList


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
            let
                pluralOrSingularAttempt =
                    if game.attemptsLeft == 1 then
                        "attempt"
                    else
                        "attempts"
            in
                "You have "
                    ++ (toString game.attemptsLeft)
                    ++ " "
                    ++ pluralOrSingularAttempt
                    ++ " left"

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
