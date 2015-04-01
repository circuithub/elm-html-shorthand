module Html.Shorthand.Type where
{-| Types used by the shorthand. All of these types are re-exported by `Html.Shorthand` so this module is only useful if
you aren't already importing Html.Shorthand.

# Common types
@docs IdString, ClassString, UrlString, TextString

# Event / handler types
@docs EventDecodeError, FormUpdate, FieldUpdate, SelectUpdate

# Element parameters
@docs ClassParam, ClassIdParam, ClassCiteParam, AnchorParam, ModParam, ImgParam, IframeParam, EmbedParam, ObjectParam, MediaParam, VideoParam, AudioParam, InputFieldParam, InputTextParam, InputMaybeTextParam, InputFloatParam, InputMaybeFloatParam, InputIntParam, InputMaybeIntParam, InputUrlParam, InputMaybeUrlParam, ButtonParam, SelectParam, OptionParam, OutputParam, ProgressParam, MeterParam

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
  { event                  : Json.Value
  , reason                 : String
  }

type alias FormUpdate =
  { onSubmit               : Maybe Signal.Message
  , onEnter                : Maybe Signal.Message -- TODO: In future Nothing may mask out the default submit Enter key behaviour. See, https://github.com/evancz/virtual-dom/pull/5#issuecomment-88444513
  }

type alias FieldUpdate a =
  { onInput                : Maybe (Result (EventDecodeError a) a -> Maybe Signal.Message)
  , onEnter                : Maybe (Result (EventDecodeError a) a -> Maybe Signal.Message)
  , onKeyboardLost         : Maybe (Result (EventDecodeError a) a -> Maybe Signal.Message)
  }

type alias ButtonUpdate =
  { onClick                : Signal.Message
  }

type alias SelectUpdate a =
  { onSelect               : a -> Signal.Message
  }

-- ELEMENT PARAMETERS

type alias ClassParam =
  { class                  : ClassString
  }

type alias ClassIdParam =
  { class                  : ClassString
  , id                     : IdString
  }

type alias ClassCiteParam =
  { class                  : ClassString
  , cite                   : UrlString
  }

type alias AnchorParam =
  { class                  : ClassString
  , href                   : UrlString
  }

type alias ModParam =
  { class                  : ClassString
  , cite                   : String
  , datetime               : String
  }

type alias ImgParam =
  { class                  : ClassString
  , src                    : UrlString
  , width                  : Int
  , height                 : Int
  , alt                    : String
  }

type alias IframeParam =
  { class                  : ClassString
  , name                   : IdString
  , src                    : UrlString
  , width                  : Int
  , height                 : Int
  -- , allowfullscreen     : Bool
  , sandbox                : Maybe String
  , seamless               : Bool
  -- , srcdoc              : String
  }

type alias EmbedParam =
  { class                  : ClassString
  , id                     : IdString
  , src                    : UrlString
  , type'                  : String
  , useMapName             : Maybe IdString
  , height                 : Int
  , width                  : Int
  }

type alias ObjectParam =
  { class                  : ClassString
  , name                   : IdString
  , data                   : UrlString
  , type'                  : String
  , useMapName             : Maybe IdString
  , height                 : Int
  , width                  : Int
  }

type alias MediaParam =
  { class                  : ClassString
  , src                    : Maybe UrlString
  -- , audioTracks         : AudioTrackList
  , autoplay               : Bool
  -- , buffered            : TimeRanges     -- Read only
  -- , controller          : MediaController
  , controls               : Bool
  -- , crossorigin         : Maybe String
  -- , currentSrc          : String         -- Read only
  -- , currentTime         : Float
  -- , defaultMuted        : Bool
  -- , defaultPlaybackRate : Float
  -- , duration            : Float          -- Read only
  -- , ended               : Bool           -- Read only
  -- , error               : MediaError     -- Read only
  -- , initialTime         : Float          -- Read only
  , loop                   : Bool
  -- , mediaGroup          : String
  -- , mediaKeys           : MediaKeys
  -- , muted               : Bool
  -- , networkState        : unsigned short
  -- , paused              : Boolean        -- Read only
  -- , playbackRate        : double
  -- , played              : TimeRanges
  , preload                : Maybe String
  -- , readyState          : unsigned short -- Read only
  , poster                 : Maybe UrlString
  -- , seekable            : TimeRanges     -- Read only
  -- , seeking             : Boolean        -- Read only
  -- , textTracks          : TextTrackList
  -- , videoTracks         : VideoTrackList
  , volume                 : Maybe Float
  }

type alias VideoParam =
  -- TODO                  : extend MediaParam
  { class                  : ClassString
  , src                    : Maybe UrlString
  , width                  : Int
  , height                 : Int
  , videoHeight            : Int            -- Read only
  , videoWidth             : Int            -- Read only
  -- , audioTracks         : AudioTrackList
  , autoplay               : Bool
  -- , buffered            : TimeRanges     -- Read only
  -- , controller          : MediaController
  , controls               : Bool
  -- , crossorigin         : Maybe String
  -- , currentSrc          : String         -- Read only
  -- , currentTime         : Float
  -- , defaultMuted        : Bool
  -- , defaultPlaybackRate : Float
  -- , duration            : Float          -- Read only
  -- , ended               : Bool           -- Read only
  -- , error               : MediaError     -- Read only
  -- , initialTime         : Float          -- Read only
  , loop                   : Bool
  -- , mediaGroup          : String
  -- , mediaKeys           : MediaKeys
  -- , muted               : Bool
  -- , networkState        : unsigned short
  -- , paused              : Boolean        -- Read only
  -- , playbackRate        : double
  -- , played              : TimeRanges
  , preload                : Maybe String
  -- , readyState          : unsigned short -- Read only
  , poster                 : Maybe UrlString
  -- , seekable            : TimeRanges     -- Read only
  -- , seeking             : Boolean        -- Read only
  -- , textTracks          : TextTrackList
  -- , videoTracks         : VideoTrackList
  , volume                 : Maybe Float
  }

type alias AudioParam = MediaParam

type alias FormParam =
  { class                  : ClassString
  , novalidate             : Bool
  , update                 : FormUpdate
  }

type alias FieldsetParam =
  { class                  : ClassString
  , disabled               : Bool
  }

type alias LabelParam =
  { class                  : ClassString
  , for                    : IdString
  }

type alias InputFieldParam a =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , update                 : FieldUpdate a
  , type'                  : String
  , pattern                : Maybe String
  , required               : Bool
  , decoder                : Json.Decoder a
  }

type alias InputTextParam =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , value                  : String
  , required               : Bool
  , autocomplete           : Bool
  , update                 : FieldUpdate String
  }

type alias InputMaybeTextParam =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , value                  : Maybe String
  , autocomplete           : Bool
  , update                 : FieldUpdate (Maybe String)
  }

type alias InputUrlParam =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , value                  : UrlString
  , required               : Bool
  , autocomplete           : Bool
  , update                 : FieldUpdate UrlString
  }

type alias InputMaybeUrlParam =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , value                  : Maybe UrlString
  , autocomplete           : Bool
  , update                 : FieldUpdate (Maybe UrlString)
  }

type alias InputFloatParam =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , value                  : Float
  , min                    : Maybe Float
  , max                    : Maybe Float
  , step                   : Maybe Float
  , update                 : FieldUpdate Float
  }

type alias InputMaybeFloatParam =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , value                  : Maybe Float
  , min                    : Maybe Float
  , max                    : Maybe Float
  , step                   : Maybe Float
  , update                 : FieldUpdate (Maybe Float)
  }

type alias InputIntParam =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , value                  : Int
  , min                    : Maybe Int
  , max                    : Maybe Int
  , step                   : Maybe Int
  , update                 : FieldUpdate Int
  }

type alias InputMaybeIntParam =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , value                  : Maybe Int
  , min                    : Maybe Int
  , max                    : Maybe Int
  , step                   : Maybe Int
  , update                 : FieldUpdate (Maybe Int)
  }

type alias ButtonParam =
  { class                  : ClassString
  , update                 : ButtonUpdate
  }

type alias SelectParam =
  { class                  : ClassString
  , name                   : IdString
  , update                 : SelectUpdate String
  }

type alias OptionParam =
  { label                  : String
  , value                  : String
  , selected               : Bool
  }

type alias OutputParam =
  { class                  : ClassString
  , name                   : IdString
  , for                    : List IdString
  }

type alias ProgressParam =
  { class                  : ClassString
  , value                  : Float
  , max                    : Float
  }

type alias MeterParam =
  { class                  : ClassString
  , value                  : Float
  , min                    : Float
  , max                    : Float
  , low                    : Maybe Float
  , high                   : Maybe Float
  , optimum                : Maybe Float
  }
