module Main exposing (..)

import Html.App as App
import Views exposing (..)
import State exposing (..)
import Secrets


main : Program Never
main =
    App.beginnerProgram
        { model = newStandardGame Secrets.secretWords
        , view = view
        , update = update
        }
