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
            guessedCharacter game character


guessedCharacter : Game -> Char -> Game
guessedCharacter game character =
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

        newGame =
            { game
                | guessedCharacters = newGuessedCharacters
                , attemptsLeft = newAttemptsLeft
            }
    in
        { newGame | state = determineNewState newGame }


determineNewState : Game -> GameState
determineNewState game =
    let
        everyLetterIsGuessedCorrectly =
            String.all (\c -> Set.member c game.guessedCharacters) game.staticData.secretWord
    in
        if game.attemptsLeft == 0 then
            Lost
        else if everyLetterIsGuessedCorrectly then
            Won
        else
            Playing


englishAlphabetUppercased : Letters
englishAlphabetUppercased =
    [Char.toCode 'A'..Char.toCode 'Z']
        |> List.map Char.fromCode
        |> Set.fromList
