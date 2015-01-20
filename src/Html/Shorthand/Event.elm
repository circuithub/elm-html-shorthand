module Html.Shorthand.Event where
{-| Shorthands for common Html events

# Events
@docs onEnter

-}

import Html (Attribute)
import Html.Events (..)
import Json.Decode as Json
import Signal
--import Graphics.Input.Field (Selection, Direction)

-- {-| `FieldEvent` is similar to `Graphics.Input.Field.Content`.
-- However, `FieldEvent` renames `string` to `targetValue` for consistency with regular `on` events using Json.Decoder.
-- It also adds keyCode in order to record the last key press, as well as active key modifiers.
-- -}
-- --type KeyEvent = Modifier KeyModifier
-- --              | Code KeyCode
-- type alias FieldEvent =
--   { value     : String
--   , selection : Selection
--   -- , keyCombination : List KeyEvent
--   }

{-| Fires off the message when the `Enter` key is pressed (on keydown).
-}
keyCodeValue : Json.Decoder (Int, String)
keyCodeValue =
  Json.object2 (,)
    keyCode
    targetValue

onEnter : Json.Decoder a -> (a -> Signal.Message) -> Attribute
onEnter decoder f =
  on "keydown"
    (Json.customDecoder (Json.object2 (,) keyCode decoder) (\(c, val) -> if c == 13 then Ok val else Err "expected key code 13"))
    f
