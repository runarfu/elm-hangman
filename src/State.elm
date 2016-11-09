module State exposing (newStandardGame, update)

import Set exposing (Set)
import Char
import String
import Types exposing (..)


newStandardGame : Words -> Game
newStandardGame secretWords =
    let
        staticData =
            { secretWords = uppercaseWords secretWords
            , alphabet = englishAlphabetUppercased
            , maxGuesses = 10
            }
    in
        { staticData = staticData
        , guessedCharacters = Set.empty
        , attemptsLeft = staticData.maxGuesses
        , state = Playing
        }


uppercaseWords : Words -> Words
uppercaseWords words =
    List.map (String.map Char.toUpper) words


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
            List.any (\w -> (String.contains (String.fromChar character) w)) game.staticData.secretWords

        -- List.any (List.member character) String.join "" game.staticData.secretWords
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
                |> String.join ""
                |> String.toList
                |> List.all (\c -> Set.member c game.guessedCharacters)

        -- List.all (\w -> Set.member c game.guessedCharacters) game.staticData.secretWords
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
