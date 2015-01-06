module Html.Shorthand.Event where
{-| Shorthands for common Html events

# Events
@docs onEnter

-}

import Html.Events (..)
import Json.Decode as Json

{-| Fires off the message when the `Enter` key is pressed (on keydown).
-}
onEnter : Signal.Message -> Attribute
onEnter message =
  on "keydown"
    (Json.customDecoder keyCode (\c -> if c == 13 then Ok () else Err "expected key code 13"))
    (always message)
