module GameUtils exposing (newStandardGame)

import String
import Char
import Set
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


englishAlphabetUppercased : Letters
englishAlphabetUppercased =
    [Char.toCode 'A'..Char.toCode 'Z']
        |> List.map Char.fromCode
        |> Set.fromList
