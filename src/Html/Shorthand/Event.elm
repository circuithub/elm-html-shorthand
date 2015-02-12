module Html.Shorthand.Event where
{-| Shorthands for common Html events

# Events
@docs targetValueFloat, targetValueInt, targetValueMaybe, targetValueMaybeFloat, targetValueMaybeInt
@docs onEnter, onInput, onKeyboardLost, onMouseLost

-}

import Html (Attribute)
import Html.Events (..)
import Json.Decode as Json
import String
import Signal
import Maybe
import Result
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
targetValueInt =
  Json.customDecoder targetValue String.toInt

{-| String or empty target value
-}
targetValueMaybe : Json.Decoder (Maybe String)
targetValueMaybe = Json.customDecoder targetValue (\s -> Ok <| if s == "" then Nothing else Just s)

{-| Floating-point or empty target value
-}
targetValueMaybeFloat : Json.Decoder (Maybe Float)
targetValueMaybeFloat =
  let toFloat s = if String.endsWith "." s
                  then Err "number cannot end in period"
                  else if String.startsWith "." s
                  then Err "number cannot start with period"
                  else String.toFloat s
      traverse f mx = case mx of
                        Nothing -> Ok Nothing
                        Just x  -> Result.map Just (f x)
  in Json.customDecoder targetValueMaybe (traverse toFloat)

{-| Integer or empty target value
-}
targetValueMaybeInt : Json.Decoder (Maybe Int)
targetValueMaybeInt =
  let traverse f mx = case mx of
                        Nothing -> Ok Nothing
                        Just x  -> Result.map Just (f x)
  in Json.customDecoder targetValueMaybe (traverse String.toInt)

{-| Fires off the message when an "input" event is triggered
-}
onInput : Json.Decoder a -> (a -> Signal.Message) -> Attribute
onInput = on "input"

{-| Fires off the message when the `Enter` key is pressed (on keydown).
-}
onEnter : Json.Decoder a -> (a -> Signal.Message) -> Attribute
onEnter dec f =
  on "keydown"
    (Json.customDecoder (Json.object2 (,) keyCode dec) (\(c, val) -> if c == 13 then Ok val else Err "expected key code 13"))
    f

{-| Similar to onBlur, but uses a decoder to return the internal state of an input field.
-}
onKeyboardLost : Json.Decoder a -> (a -> Signal.Message) -> Attribute
onKeyboardLost = on "blur"

{-| Similar to onMouseLeave, but uses a decoder to return the internal state of an input field.
-}
onMouseLost : Json.Decoder a -> (a -> Signal.Message) -> Attribute
onMouseLost = on "mouseleave"

