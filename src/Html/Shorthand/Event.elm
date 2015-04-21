module Html.Shorthand.Event where
{-| Shorthands for common Html events

# Events
@docs onInput, onEnter, onKeyboardLost, onMouseLost

# Special decoders
@docs messageDecoder

-}

import Html exposing (Attribute)
import Html.Events exposing (..)
import Html.Events.Extra exposing (..)
import Html.Shorthand.Type as T
import Json.Decode as Json
import Signal
import Maybe
import Result

{-| Fires off the message when an "input" event is triggered.
Use this with &lt;`input`&gt; and &lt;`textarea`&gt; elements.
-}
onInput : Json.Decoder a -> (a -> Signal.Message) -> Attribute
onInput = on "input"

{-| Fires when a "change" event is triggered.
-}
onChange : Json.Decoder a -> (a -> Signal.Message) -> Attribute
onChange = on "change"

{-| Fires off the message when the `Enter` key is pressed (on keydown).
-}
onEnter : Json.Decoder a -> (a -> Signal.Message) -> Attribute
onEnter dec f =
  on "keydown"
    (Json.customDecoder (Json.object2 (,) keyCode dec) <| \(c, val) -> if c == 13 then Ok val else Err "expected key code 13")
    f

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
onKeyboardLost : Json.Decoder a -> (a -> Signal.Message) -> Attribute
onKeyboardLost = on "blur"

{-| Similar to onMouseLeave, but uses a decoder to return the internal state of an input field.
-}
onMouseLost : Json.Decoder a -> (a -> Signal.Message) -> Attribute
onMouseLost = on "mouseleave"

{-| A special decoder that allows you to mix event decoding logic with message generation.
This function takes an existing event decoder and passes the result of the parser along in order to produce an optional message directly.
This provides a mechanism for altering messages if parse errors occur in the decoder.

    messageDecoder targetValueFloat <| \r ->
      case r of
        Ok temp -> Just <| Channel.send action (SetTemperature temp)
        Err _   -> Just <| Channel.send action (SetError "Please enter a valid temperature")

Alternatively one could also send to a different channel entirely, although this splitting should be done only after some delibiration.
It may not be desirable to split channels if the signals derived from these channels need to be remerged in future.

    messageDecoder targetValueFloat <| \r ->
      case r of
        Ok temp -> Just <| Channel.send action SetTemperature temp
        Err e   -> Just <| Channel.send errorLog <|
                    "Invalid temperature: "
                    ++ toString (targetValue e.event)
                    ++ "(" ++ e.reason ++ ")."

-}
messageDecoder : Json.Decoder a -> (Result (T.EventDecodeError a) a -> Maybe Signal.Message) -> Json.Decoder Signal.Message
messageDecoder dec f =
  Json.customDecoder Json.value <| \event ->
    let r  = Json.decodeValue dec event
        r' = Result.formatError (T.EventDecodeError event) r
    in case (f r', r) of
      (Nothing , Err e) -> Err e
      (Nothing , Ok _ ) -> Err "no message in response to event"
      (Just msg, _    ) -> Ok msg
