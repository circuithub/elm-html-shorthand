module Html.Shorthand.Internal exposing (..)

{-| Internals for Html.Shorthand See [Html.Shorthand](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand)

@docs encodeId, encodeClass, class_, id_
-}

import Maybe
import List
import Char
import String
import Html exposing (..)
import Html.Attributes as A
import Html.Shorthand.Type exposing (..)
import Html.Shorthand.Event exposing (..)


{-| -}
encodeId : IdString -> IdString
encodeId =
    let
        hu =
            [ '-', '_' ]

        isAlpha c =
            let
                cc =
                    Char.toCode <| Char.toLower c
            in
                cc >= Char.toCode 'a' && cc <= Char.toCode 'z'

        -- Note that : and . are also allowed in HTML 4, but since these need to be escaped in selectors we exclude them
        -- HTML 5 includes many more characters, but we'll exclude these for now
        isIdChar c =
            Char.isDigit c
                || isAlpha c
                || (List.member c hu)

        startWithAlpha s =
            case String.uncons s of
                Just ( c, s_ ) ->
                    if not (isAlpha c) then
                        String.cons 'x' s
                    else
                        s

                Nothing ->
                    s

        smartTrimLeft s =
            case String.uncons s of
                Just ( c, s_ ) ->
                    if List.member c hu then
                        s_
                    else
                        s

                Nothing ->
                    s

        smartTrimRight s =
            case String.uncons (String.reverse s) of
                Just ( c, s_ ) ->
                    if List.member c hu then
                        String.reverse s_
                    else
                        s

                Nothing ->
                    s

        smartTrim =
            smartTrimLeft >> smartTrimRight
    in
        String.words
            >> List.map
                (String.toLower
                    >> String.filter isIdChar
                    >> smartTrim
                )
            >> String.join "-"
            >> startWithAlpha


{-| -}
encodeClass : ClassString -> ClassString
encodeClass =
    let
        hu =
            [ '-', '_' ]

        isAlpha c =
            let
                cc =
                    Char.toCode <| Char.toLower c
            in
                cc >= Char.toCode 'a' && cc <= Char.toCode 'z'

        -- Note that : and . are also allowed in HTML 4, but since these need to be escaped in selectors we exclude them
        -- HTML 5 includes many more characters, but we'll exclude these for now
        isClassChar c =
            Char.isDigit c
                || isAlpha c
                || (List.member c hu)

        startWithAlpha s =
            case String.uncons s of
                Just ( c, s_ ) ->
                    if not (isAlpha c) then
                        String.cons 'x' s
                    else
                        s

                Nothing ->
                    s

        smartTrimLeft s =
            case String.uncons s of
                Just ( c, s_ ) ->
                    if List.member c hu then
                        s_
                    else
                        s

                Nothing ->
                    s

        smartTrimRight s =
            case String.uncons (String.reverse s) of
                Just ( c, s_ ) ->
                    if List.member c hu then
                        String.reverse s_
                    else
                        s

                Nothing ->
                    s

        smartTrim =
            smartTrimLeft >> smartTrimRight
    in
        String.words
            >> List.map
                (String.toLower
                    >> String.filter isClassChar
                    >> smartTrim
                    >> startWithAlpha
                )
            >> String.join " "


{-| -}
id_ : IdString -> Attribute msg
id_ =
    A.id << encodeId


{-| -}
class_ : ClassString -> Attribute msg
class_ =
    A.class << encodeClass
