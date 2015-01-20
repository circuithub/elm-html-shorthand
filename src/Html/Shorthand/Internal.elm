module Html.Shorthand.Internal where

import Maybe
import List
import Html (..)
import Html.Attributes as A
import Html.Events (..)
import Html.Shorthand.Type (..)
import Html.Shorthand.Event (..)

inputField : String -> IdString -> String -> String -> FieldUpdate -> Html
inputField type' i p v fu =
  let filter = List.filterMap identity
      events =
        filter
        <| Maybe.map (on "input" targetValue) fu.continuous
        :: [ Maybe.map (onEnter targetValue) fu.onEnter ]
  in input ([A.type' type', A.id i, A.name i, A.placeholder p, A.value v] ++ events) []
