module Types exposing (..)

import Set exposing (Set)


type alias Letters =
    Set Char


type alias Game =
    { staticData : StaticData
    , guessedCharacters : Letters
    , attemptsLeft : Int
    , state : GameState
    }


type alias StaticData =
    { secretWord : String
    , alphabet : Letters
    , maxGuesses : Int
    }


type Msg
    = Guess Char


type GameState
    = Playing
    | Lost
    | Won
