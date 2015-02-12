module Html.Shorthand.Event where
{-| Shorthands for common Html events

# Events
@docs targetValueFloat, targetValueInt, targetValueMaybe, targetValueMaybeFloat, targetValueMaybeInt
@docs onEnter, onInput, onKeyboardLost, onMouseLost

# Special decoders
@docs messageDecoder

-}

import Html (Attribute)
import Html.Events (..)
import Html.Shorthand.Type as T
import Json.Decode as Json
import String
import Signal
import Maybe
import Result

{-| Floating-point target value
-}
targetValueFloat : Json.Decoder Float
targetValueFloat =
  Json.customDecoder (Json.at ["target", "valueAsNumber"] Json.float) <| \v ->
    if isNaN v
    then Err "Not a number"
    else Ok v

{-| Integer target value
-}
targetValueInt : Json.Decoder Int
targetValueInt =
  Json.at ["target", "valueAsNumber"] Json.int

{-| String or empty target value
-}
targetValueMaybe : Json.Decoder (Maybe String)
targetValueMaybe = Json.customDecoder targetValue (\s -> Ok <| if s == "" then Nothing else Just s)

{-| Floating-point or empty target value
-}
targetValueMaybeFloat : Json.Decoder (Maybe Float)
targetValueMaybeFloat =
  targetValueMaybe `Json.andThen` \mval ->
    case mval of
      Nothing -> Json.succeed Nothing
      Just _ -> Json.map Just targetValueFloat

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
