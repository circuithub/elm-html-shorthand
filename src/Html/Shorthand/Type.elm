module Html.Shorthand.Type where
{-| Types used by the shorthand. All of these types are re-exported by `Html.Shorthand` so this module is only useful if
you aren't already importing Html.Shorthand.

@docs IdString, ClassString, UrlString, TextString
@docs EventDecodeError, FieldUpdate
-}

import Signal
import Json.Decode as Json

type alias IdString = String
type alias ClassString = String
type alias UrlString = String
type alias TextString = String

type alias EventDecodeError a =
  { event  : Json.Value
  , reason : String
  }

type alias FieldUpdate a =
  { continuous : Maybe (a -> Signal.Message)
  , onEnter : Maybe (a -> Signal.Message)
  }
