module Main exposing (..)

import Html exposing (beginnerProgram)
import Types exposing (Game, Msg)
import GameUtils
import Secrets
import Views
import State


main : Program Never Game Msg
main =
    Html.beginnerProgram
        { model = GameUtils.newStandardGame Secrets.secretWords
        , view = Views.view
        , update = State.update
        }
