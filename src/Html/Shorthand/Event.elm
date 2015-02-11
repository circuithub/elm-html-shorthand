module Html.Shorthand.Event where
{-| Shorthands for common Html events

# Events
@docs targetValueFloat, targetValueInt
@docs onEnter

-}

import Html (Attribute)
import Html.Events (..)
import Json.Decode as Json
import String
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

{-| Floating-point target value
-}
targetValueFloat : Json.Decoder Float
targetValueFloat =
  let toFloat s = if String.endsWith "." s
                  then Err "number cannot end in period"
                  else if String.startsWith "." s
                  then Err "number cannot start with period"
                  else String.toFloat s
  in Json.customDecoder targetValue toFloat

{-| Integer target value
-}
targetValueInt : Json.Decoder Int
targetValueInt = Json.customDecoder targetValue String.toInt

{-| Fires off the message when the `Enter` key is pressed (on keydown).
-}
onEnter : Json.Decoder a -> (a -> Signal.Message) -> Attribute
onEnter dec f =
  on "keydown"
    (Json.customDecoder (Json.object2 (,) keyCode dec) (\(c, val) -> if c == 13 then Ok val else Err "expected key code 13"))
    f
