module Main exposing (..)

import Html.App as App
import GameUtils
import Secrets
import Views
import State


main : Program Never
main =
    App.beginnerProgram
        { model = GameUtils.newStandardGame Secrets.secretWords
        , view = Views.view
        , update = State.update
        }
