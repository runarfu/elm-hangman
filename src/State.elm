module State exposing (newStandardGame, update)

import Set exposing (Set)
import Char
import String
import Types exposing (..)


newStandardGame : String -> Game
newStandardGame secretWord =
    let
        staticData =
            { secretWord = String.map Char.toUpper secretWord
            , alphabet = englishAlphabetUppercased
            , maxGuesses = 10
            }
    in
        { staticData = staticData
        , guessedCharacters = Set.empty
        , attemptsLeft = staticData.maxGuesses
        , state = Playing
        }


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
            List.member character (String.toList game.staticData.secretWord)

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
            String.all (\c -> Set.member c game.guessedCharacters) game.staticData.secretWord

        newGameState =
            if game.attemptsLeft == 0 then
                Lost
            else if everyLetterIsGuessedCorrectly then
                Won
            else
                Playing
    in
        { game | state = newGameState }


englishAlphabetUppercased : Letters
englishAlphabetUppercased =
    [Char.toCode 'A'..Char.toCode 'Z']
        |> List.map Char.fromCode
        |> Set.fromList
