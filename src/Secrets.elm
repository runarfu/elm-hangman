module Secrets exposing (secretWords)

import String
import Types exposing (Words)


secretWords : Words
secretWords =
    "the wonderful world of elm"
        |> String.words
