module Html.Shorthand.Event exposing (..)
{-| Shorthands for common Html events

# Events
@docs onInput', onEnter, onChange, onKeyboardLost, onMouseLost

# Special decoders
@docs messageDecoder

-}

import Html exposing (Attribute)
import Html.Events exposing (..)
import Html.Shorthand.Type as T
import Json.Decode as Json
import Maybe
import Result

{-| Similar to onInput, but uses a decoder to return the internal state of an input field.
-}
onInput' : Json.Decoder a -> (a -> msg) -> Attribute msg
onInput' dec f = on "input" (Json.map f dec)

{-| Fires when a "change" event is triggered.
-}
onChange : Json.Decoder a -> (a -> msg) -> Attribute msg
onChange dec f = on "change" (Json.map f dec)

{-| Fires off the message when the `Enter` key is pressed (on keydown).
-}
onEnter : Json.Decoder a -> (a -> msg) -> Attribute msg
onEnter dec f =
  on "keydown" <| Json.map
    f
    (Json.customDecoder (Json.object2 (,) keyCode dec) <| \(c, val) -> if c == 13 then Ok val else Err "expected key code 13")

-- TODO: see https://github.com/evancz/virtual-dom/pull/5
-- TODO: use key/code/keyEvent once it is well supported in browsers.
-- {-| An alternate version of `onKeyPress` that allows you to filter key strokes.
-- -}
-- filterOnKeyPress : (String -> Maybe Signal.Message) -> Attribute
-- filterOnKeyPress f =
--   on "keypress"
--     (messageDecoder key <| \r ->
--       case r of
--         Err _ -> Nothing
--         Ok c  -> f c
--     )
--     identity

-- TODO: see https://github.com/evancz/virtual-dom/pull/5
-- {-| An alternate version of `onKeyPress` that listens for printable key strokes and allows you to filter them.
-- -}
-- filterOnKeyPressChar : (Char -> Maybe Signal.Message) -> Attribute
-- filterOnKeyPressChar f =
--   -- TODO: change implementation to key/code once it is well supported in browsers.
--   on "keypress"
--     (messageDecoder (Json.customDecoder charCode <| Result.fromMaybe "empty character code") <| \r ->
--       case r of
--         Err _ -> Nothing
--         Ok c  -> f c
--     )
--     identity

{-| Similar to onBlur, but uses a decoder to return the internal state of an input field.
-}
onKeyboardLost : Json.Decoder a -> (a -> msg) -> Attribute msg
onKeyboardLost dec f = on "blur" (Json.map f dec)

{-| Similar to onMouseLeave, but uses a decoder to return the internal state of an input field.
-}
onMouseLost : Json.Decoder a -> (a -> msg) -> Attribute msg
onMouseLost dec f = on "mouseleave" (Json.map f dec)

{-| A special decoder that allows you to mix event decoding logic with message generation.
This function takes an existing event decoder and passes the result of the parser along in order to produce an optional message directly.
This provides a mechanism for altering messages if parse errors occur in the decoder.

    messageDecoder targetValueFloat <| \r ->
      case r of
        Ok temp -> Just <| SetTemperature temp
        Err _   -> Just <| SetError "Please enter a valid temperature"
-}
messageDecoder : Json.Decoder a -> (Result T.EventDecodeError a -> Maybe msg) -> Json.Decoder msg
messageDecoder dec f =
  Json.customDecoder Json.value <| \event ->
    let r  = Json.decodeValue dec event
        r' = Result.formatError (T.EventDecodeError event) r
    in case (f r', r) of
      (Nothing , Err e) -> Err e
      (Nothing , Ok _ ) -> Err "no message in response to event"
      (Just msg, _    ) -> Ok msg
