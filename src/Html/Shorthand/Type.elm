module Html.Shorthand.Type where
{-| Types used by the shorthand. All of these types are re-exported by `Html.Shorthand` so this module is only useful if
you aren't already importing Html.Shorthand.

# Common types
@docs IdString, ClassString, UrlString, TextString

# Event / handler types
@docs EventDecodeError, FormUpdate, FieldUpdate, SelectUpdate

# Element parameters
@docs ClassParam, ClassIdParam, ClassTextParam, ClassIdTextParam, ClassCiteParam, ClassCiteTextParam, AnchorParam, ModParam, ImgParam, IframeParam, EmbedParam, ObjectParam, InputFieldParam, InputTextParam, InputMaybeTextParam, InputFloatParam, InputMaybeFloatParam, InputIntParam, InputMaybeIntParam, SelectParam, OptionParam, OutputParam, ProgressParam, MeterParam

-}

import Signal
import Json.Decode as Json

-- COMMON TYPES

type alias IdString    = String
type alias ClassString = String
type alias UrlString   = String
type alias TextString  = String

-- EVENT / HANDLER TYPES

type alias EventDecodeError a =
  { event           : Json.Value
  , reason          : String
  }

type alias FormUpdate =
  { onSubmit        : Maybe Signal.Message
  }

type alias FieldUpdate a =
  { onInput         : Maybe (Result (EventDecodeError a) a -> Maybe Signal.Message)
  , onEnter         : Maybe (Result (EventDecodeError a) a -> Maybe Signal.Message)
  , onKeyboardLost  : Maybe (Result (EventDecodeError a) a -> Maybe Signal.Message)
  }

type alias SelectUpdate a =
  { onSelect        : a -> Signal.Message
  }

-- ELEMENT PARAMETERS

type alias ClassParam =
  { class           : ClassString
  }

type alias ClassIdParam =
  { class           : ClassString
  , id              : IdString
  }

type alias ClassTextParam =
  { class           : ClassString
  , text            : TextString
  }

type alias ClassIdTextParam =
  { class           : ClassString
  , id              : IdString
  , text            : TextString
  }

type alias ClassCiteParam =
  { class           : ClassString
  , cite            : UrlString
  }

type alias ClassCiteTextParam =
  { class           : ClassString
  , cite            : UrlString
  , text            : TextString
  }

type alias AnchorParam =
  { class           : ClassString
  , href            : UrlString
  }

type alias ModParam =
  { class           : ClassString
  , cite            : String
  , datetime        : String
  }

type alias ImgParam =
  { class           : ClassString
  , src             : UrlString
  , width           : Int
  , height          : Int
  , alt             : String
  }

type alias IframeParam =
  { class           : ClassString
  , name            : IdString
  , src             : UrlString
  , width           : Int
  , height          : Int
  -- , allowfullscreen : Bool
  , sandbox         : Maybe String
  , seamless        : Bool
  -- , srcdoc          : String
  }

type alias EmbedParam =
  { class           : ClassString
  , id              : IdString
  , src             : UrlString
  , type'           : String
  , useMapName      : Maybe IdString
  , height          : Int
  , width           : Int
  }

type alias ObjectParam =
  { class           : ClassString
  , name            : IdString
  , data            : UrlString
  , type'           : String
  , useMapName      : Maybe IdString
  , height          : Int
  , width           : Int
  }

type alias FormParam =
  { class           : ClassString
  , novalidate      : Bool
  , update          : FormUpdate
  }

type alias FieldsetParam =
  { class           : ClassString
  , disabled        : Bool
  }

type alias InputFieldParam a =
  { class           : ClassString
  , name            : IdString
  , placeholder     : Maybe String
  , update          : FieldUpdate a
  , type'           : String
  , pattern         : Maybe String
  , required        : Bool
  , decoder         : Json.Decoder a
  }

type alias InputTextParam =
  { class           : ClassString
  , name            : IdString
  , placeholder     : Maybe String
  , value           : String
  , required        : Bool
  , autocomplete    : Bool
  , update          : FieldUpdate String
  }

type alias InputMaybeTextParam =
  { class           : ClassString
  , name            : IdString
  , placeholder     : Maybe String
  , value           : Maybe String
  , autocomplete    : Bool
  , update          : FieldUpdate (Maybe String)
  }

type alias InputFloatParam =
  { class           : ClassString
  , name            : IdString
  , placeholder     : Maybe String
  , value           : Float
  , min             : Maybe Float
  , max             : Maybe Float
  , step            : Maybe Float
  , update          : FieldUpdate Float
  }

type alias InputMaybeFloatParam =
  { class           : ClassString
  , name            : IdString
  , placeholder     : Maybe String
  , value           : Maybe Float
  , min             : Maybe Float
  , max             : Maybe Float
  , step            : Maybe Float
  , update          : FieldUpdate (Maybe Float)
  }

type alias InputIntParam =
  { class           : ClassString
  , name            : IdString
  , placeholder     : Maybe String
  , value           : Int
  , min             : Maybe Int
  , max             : Maybe Int
  , step            : Maybe Int
  , update          : FieldUpdate Int
  }

type alias InputMaybeIntParam =
  { class           : ClassString
  , name            : IdString
  , placeholder     : Maybe String
  , value           : Maybe Int
  , min             : Maybe Int
  , max             : Maybe Int
  , step            : Maybe Int
  , update          : FieldUpdate (Maybe Int)
  }

type alias SelectParam =
  { class           : ClassString
  , name            : IdString
  , update          : SelectUpdate String
  }

type alias OptionParam =
  { label           : String
  , value           : String
  , selected        : Bool
  }

type alias OutputParam =
  { class           : ClassString
  , name            : IdString
  , for             : List IdString
  }

type alias ProgressParam =
  { class           : ClassString
  , value           : Float
  , max             : Float
  }

type alias MeterParam =
  { class           : ClassString
  , value           : Float
  , min             : Float
  , max             : Float
  , low             : Maybe Float
  , high            : Maybe Float
  , optimum         : Maybe Float
  }
