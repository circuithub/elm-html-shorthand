module Html.Shorthand.Type exposing (..)
{-| Types used by the shorthand. All of these types are re-exported by `Html.Shorthand` so this module is only useful if
you aren't already importing Html.Shorthand.

# Common types
@docs IdString, ClassString, UrlString, TextString

# Event / handler types
@docs EventDecodeError, FormUpdate, FieldUpdate, ButtonUpdate, SelectUpdate

# Element parameters
@docs ClassParam, ClassIdParam, ClassCiteParam, AnchorParam, ModParam, ImgParam, IframeParam, EmbedParam, ObjectParam, MediaParam, VideoParam, AudioParam, FormParam, FieldsetParam, LabelParam, InputFieldParam, InputTextParam, InputMaybeTextParam, InputFloatParam, InputMaybeFloatParam, InputIntParam, InputMaybeIntParam, InputUrlParam, InputMaybeUrlParam, ButtonParam, SelectParam, OptionParam, OutputParam, ProgressParam, MeterParam

-}

import Json.Decode as Json

-- COMMON TYPES

{-| -}
type alias IdString    = String
{-| -}
type alias ClassString = String
{-| -}
type alias UrlString   = String
{-| -}
type alias TextString  = String

-- EVENT / HANDLER TYPES

{-| -}
type alias EventDecodeError =
  { event                  : Json.Value
  , reason                 : String
  }

{-| -}
type alias FormUpdate msg =
  { onSubmit               : Maybe msg
  , onEnter                : Maybe msg -- TODO: In future Nothing may mask out the default submit Enter key behaviour. See, https://github.com/evancz/virtual-dom/pull/5#issuecomment-88444513
  }

{-| -}
type alias FieldUpdate a msg =
  { onInput                : Maybe (Result EventDecodeError a -> Maybe msg)
  , onEnter                : Maybe (Result EventDecodeError a -> Maybe msg)
  , onKeyboardLost         : Maybe (Result EventDecodeError a -> Maybe msg)
  }

{-| -}
type alias ButtonUpdate msg =
  { onClick                : msg
  }

{-| -}
type alias SelectUpdate a msg =
  { onSelect               : a -> msg
  }

-- ELEMENT PARAMETERS

{-| -}
type alias ClassParam =
  { class                  : ClassString
  }

{-| -}
type alias ClassIdParam =
  { class                  : ClassString
  , id                     : IdString
  }

{-| -}
type alias ClassCiteParam =
  { class                  : ClassString
  , cite                   : UrlString
  }

{-| -}
type alias AnchorParam =
  { class                  : ClassString
  , href                   : UrlString
  }

{-| -}
type alias ModParam =
  { class                  : ClassString
  , cite                   : String
  , datetime               : String
  }

{-| -}
type alias ImgParam =
  { class                  : ClassString
  , src                    : UrlString
  , width                  : Int
  , height                 : Int
  , alt                    : String
  }

{-| -}
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

{-| -}
type alias EmbedParam =
  { class                  : ClassString
  , id                     : IdString
  , src                    : UrlString
  , type'                  : String
  , useMapName             : Maybe IdString
  , height                 : Int
  , width                  : Int
  }

{-| -}
type alias ObjectParam =
  { class                  : ClassString
  , name                   : IdString
  , data                   : UrlString
  , type'                  : String
  , useMapName             : Maybe IdString
  , height                 : Int
  , width                  : Int
  }

{-| -}
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

{-| -}
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

{-| -}
type alias AudioParam = MediaParam

{-| -}
type alias FormParam msg =
  { class                  : ClassString
  , novalidate             : Bool
  , update                 : FormUpdate msg
  }

{-| -}
type alias FieldsetParam =
  { class                  : ClassString
  , disabled               : Bool
  }

{-| -}
type alias LabelParam =
  { class                  : ClassString
  , for                    : IdString
  }

{-| -}
type alias InputFieldParam a msg =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , update                 : FieldUpdate a msg
  , type'                  : String
  , pattern                : Maybe String
  , required               : Bool
  , decoder                : Json.Decoder a
  }

{-| -}
type alias InputTextParam msg =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , value                  : String
  , required               : Bool
  , autocomplete           : Bool
  , update                 : FieldUpdate String msg
  }

{-| -}
type alias InputMaybeTextParam msg =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , value                  : Maybe String
  , autocomplete           : Bool
  , update                 : FieldUpdate (Maybe String) msg
  }

{-| -}
type alias InputUrlParam msg =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , value                  : UrlString
  , required               : Bool
  , autocomplete           : Bool
  , update                 : FieldUpdate UrlString msg
  }

{-| -}
type alias InputMaybeUrlParam msg =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , value                  : Maybe UrlString
  , autocomplete           : Bool
  , update                 : FieldUpdate (Maybe UrlString) msg
  }

{-| -}
type alias InputFloatParam msg =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , value                  : Float
  , min                    : Maybe Float
  , max                    : Maybe Float
  , step                   : Maybe Float
  , update                 : FieldUpdate Float msg
  }

{-| -}
type alias InputMaybeFloatParam msg =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , value                  : Maybe Float
  , min                    : Maybe Float
  , max                    : Maybe Float
  , step                   : Maybe Float
  , update                 : FieldUpdate (Maybe Float) msg
  }

{-| -}
type alias InputIntParam msg =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , value                  : Int
  , min                    : Maybe Int
  , max                    : Maybe Int
  , step                   : Maybe Int
  , update                 : FieldUpdate Int msg
  }

{-| -}
type alias InputMaybeIntParam msg =
  { class                  : ClassString
  , name                   : IdString
  , placeholder            : Maybe String
  , value                  : Maybe Int
  , min                    : Maybe Int
  , max                    : Maybe Int
  , step                   : Maybe Int
  , update                 : FieldUpdate (Maybe Int) msg
  }

{-| -}
type alias ButtonParam msg =
  { class                  : ClassString
  , update                 : ButtonUpdate msg
  }

{-| -}
type alias SelectParam msg =
  { class                  : ClassString
  , name                   : IdString
  , update                 : SelectUpdate String msg
  }

{-| -}
type alias OptionParam =
  { label                  : String
  , value                  : String
  , selected               : Bool
  }

{-| -}
type alias OutputParam =
  { class                  : ClassString
  , name                   : IdString
  , for                    : List IdString
  }

{-| -}
type alias ProgressParam =
  { class                  : ClassString
  , value                  : Float
  , max                    : Float
  }

{-| -}
type alias MeterParam =
  { class                  : ClassString
  , value                  : Float
  , min                    : Float
  , max                    : Float
  , low                    : Maybe Float
  , high                   : Maybe Float
  , optimum                : Maybe Float
  }
