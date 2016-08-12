module Main exposing (..)

import Html.App as App
import Views exposing (..)
import State exposing (..)


main : Program Never
main =
    App.beginnerProgram
        { model = newStandardGame "typesafefrontend"
        , view = view
        , update = update
        }
