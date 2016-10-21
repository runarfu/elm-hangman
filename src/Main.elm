module Main exposing (..)

import Html.App as App
import Views exposing (..)
import State exposing (..)
import SecretWord


main : Program Never
main =
    App.beginnerProgram
        { model = newStandardGame SecretWord.secretWord
        , view = view
        , update = update
        }
