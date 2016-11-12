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
        words =
            hideCharacters game.staticData.secretWords game.state game.guessedCharacters
    in
        h2 [ style [ ( "font-family", "courier" ) ] ] [ text (String.join " - " words) ]


hideCharacters : Words -> GameState -> Letters -> Words
hideCharacters secretWords gameState guessedCharacters =
    case gameState of
        Playing ->
            secretWords
                |> List.map (hideSingleCharacterInWord guessedCharacters)

        -- |> List.map
        -- |> List.map (\w -> (List.map (hideSingleCharacter guessedCharacters) w))
        -- |> List.map (\w -> toString (List.map (hideSingleCharacter guessedCharacters) (String.toList w)))
        -- |> List.map (\w -> List.map (List.map hideSingleCharacter guessedCharacters))
        Won ->
            List.map spaceLetters secretWords

        Lost ->
            List.map spaceLetters secretWords


spaceLetters : String -> String
spaceLetters string =
    string
        |> String.toList
        |> List.intersperse ' '
        |> String.fromList


hideSingleCharacterInWord : Letters -> String -> String
hideSingleCharacterInWord guessedCharacters word =
    word
        |> String.toList
        |> List.map (hideSingleCharacter guessedCharacters)
        |> List.intersperse ' '
        |> String.fromList


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
