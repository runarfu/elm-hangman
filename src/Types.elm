module Types exposing (..)

import Set exposing (Set)


type alias Letters =
    Set Char


type alias Words =
    List String


type alias Game =
    { staticData : StaticData
    , guessedCharacters : Letters
    , attemptsLeft : Int
    , state : GameState
    }


type alias StaticData =
    { secretWords : Words
    , alphabet : Letters
    , maxGuesses : Int
    }


type Msg
    = Guess Char


type GameState
    = Playing
    | Lost
    | Won
