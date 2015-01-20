module Html.Shorthand.Type where
{-|
-}

import Signal

type alias IdString = String
type alias ClassString = String
type alias UrlString = String
type alias TextString = String

--type alias FieldUpdate =
--  { continuous : Maybe (FieldEvent -> Signal.Message)
--  , onEnter : Maybe (FieldEvent -> Signal.Message)
--  }

type alias FieldUpdate =
  { continuous : Maybe (String -> Signal.Message)
  , onEnter : Maybe (String -> Signal.Message)
  }
