module State exposing (update)

import Set exposing (Set)
import Char
import String
import Types exposing (..)


update : Msg -> Game -> Game
update msg game =
    case msg of
        Guess character ->
            game
                |> guessedCharacter character
                |> determineNewState


guessedCharacter : Char -> Game -> Game
guessedCharacter character game =
    let
        newGuessedCharacters =
            Set.insert character game.guessedCharacters

        guessedRight =
            game.staticData.secretWords
                |> List.map (String.contains (String.fromChar character))
                |> List.any ((==) True)

        newAttemptsLeft =
            if guessedRight then
                game.attemptsLeft
            else
                game.attemptsLeft - 1
    in
        { game
            | guessedCharacters = newGuessedCharacters
            , attemptsLeft = newAttemptsLeft
        }


determineNewState : Game -> Game
determineNewState game =
    let
        everyLetterIsGuessedCorrectly =
            game.staticData.secretWords
                |> String.concat
                |> String.toList
                |> List.all (\c -> Set.member c game.guessedCharacters)

        newState =
            if game.attemptsLeft == 0 then
                Lost
            else if everyLetterIsGuessedCorrectly then
                Won
            else
                Playing
    in
        { game | state = newState }
