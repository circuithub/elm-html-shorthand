module Html.Shorthand exposing (..)

{-| Shorthands for common Html elements

# Interactive elements (Unsupported)
The following elements are not currently well supported and do not have shorthands:

* [&lt;details&gt;, &lt;summary&gt;](http://caniuse.com/#feat=details)
* [&lt;menu&gt;, &lt;menuitem&gt;](http://caniuse.com/#feat=menu)

# Conventions
The following two conventions are used for shorthands. One example is provided for each.

## Elision form
Most attributes of the node are elided, only one or two arguments needs to be supplied.

@docs div_

## Idiomatic form

This form attempts to take a common sense record of parameters. This is a more expansive shorthand which
will not satisfy every need, but takes care of the usual cases while still encouraging uniformity.

@docs img_

# Basic types
The following types are all aliases for `String` and as such, only serve documentation purposes.

@docs IdString, ClassString, UrlString, TextString, TextDirection

# Event / handler types
@docs EventDecodeError, FormUpdate, FieldUpdate, SelectUpdate, fieldUpdate, fieldUpdateContinuous, fieldUpdateFocusLost, fieldUpdateFallbackFocusLost, fieldUpdateFallbackContinuous

# Element types
@docs ClassParam, ClassIdParam, ClassCiteParam, AnchorParam, ModParam, ImgParam, IframeParam, EmbedParam, ObjectParam, MediaParam, VideoParam, AudioParam, FormParam, FieldsetParam, LabelParam, InputFieldParam, InputTextParam, InputMaybeTextParam, InputFloatParam, InputMaybeFloatParam, InputIntParam, InputMaybeIntParam, InputUrlParam, InputMaybeUrlParam, ButtonParam, SelectParam, OptionParam, OutputParam, ProgressParam, MeterParam

# Encoders
@docs encodeId, encodeClass

# Idiomatic attributes
@docs id_, class_

# Sections
@docs body_, section_, nav_, article_, aside_
@docs h1_, h2_, h3_, h4_, h5_, h6_, header_, footer_
@docs address_

# Grouping content
@docs p_, pre_, blockquote_, ol_, ul_, li_, dl_, dt_, dd_, hr_
@docs figure_, figcaption_
@docs div_, a_, em_, strong_, small_, s_
@docs cite_, q_, dfn_, abbr_
* time_ (TODO)
@docs code_, var_, samp_, kbd_
@docs sub_, sup_, i_, b_, u_, mark_
@docs ruby_, rt_, rp_, bdi_, bdo_
@docs span_
@docs br_, wbr_

# Edits
@docs ins_, del_

# Embedded content
@docs img_, iframe_, embed_, object_
@docs param_, video_, audio_
* source_ (TODO)
* track_ (TODO)
* svg_ (TODO)
* math_ (TODO)

# Tabular data
@docs table_, caption_
* colgroup_ (TODO)
* col_ (TODO)
@docs tbody_, thead_, tfoot_, tr_, td_, th_

# Forms
@docs form_, fieldset_, legend_, label_
@docs inputField_, inputText_, inputMaybeText_, inputFloat_, inputMaybeFloat_, inputInt_, inputMaybeInt_, inputUrl_, inputMaybeUrl_
* radio_ (TODO)
* checkbox_ (TODO)
@docs button_, buttonLink_, buttonSubmit_, buttonReset_
@docs select_
* datalist_ (TODO)
* optgroup_ (TODO)
@docs option_
* (TODO)
* textarea_ (TODO)
* (TODO)
* keygen_ (TODO)
@docs output_, progress_, meter_

-}

import Html exposing (..)
import Html.Attributes as A
import Html.Attributes.Extra as A
import Html.Events exposing (..)
import Html.Events.Extra exposing (charCode, targetValueFloat, targetValueInt, targetValueMaybe, targetValueMaybeInt, targetValueMaybeFloat)
import String
import List
import Maybe
import Json.Decode as Json


--import Graphics.Input.Field

import Html.Shorthand.Type as T
import Html.Shorthand.Internal as Internal
import Html.Shorthand.Event exposing (..)


{-| Id parameters will automatically be encoded via `encodeId`
-}
type alias IdString =
    T.IdString


{-| Class parameters will automatically be encoded via `encodeClass`
-}
type alias ClassString =
    T.ClassString


{-| Only valid urls should be passed to functions taking this parameter
-}
type alias UrlString =
    T.UrlString



-- re-export


{-| The string passed to a function taking this parameter will be rendered as textual content via `text`.
-}
type alias TextString =
    T.TextString



-- re-export


{-| Direction to output text
-}
type TextDirection
    = LeftToRight
    | RightToLeft
    | AutoDirection



--type alias Selection = Graphics.Input.Field.Selection  -- re-export


{-| Update configuration for a `form` element.

* *onSubmit* - a submit action was triggered
* *onEnter* - action to perform on enter key... see also [virtual-dom/pull/5#issuecomment-88444513](https://github.com/evancz/virtual-dom/pull/5#issuecomment-88444513)

See also [FormUpdate](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#FormUpdate)

-}
type alias FormUpdate msg =
    T.FormUpdate msg


{-| A field error is generated when an input fails to parse its input string during an attempt to produce the output value.
This gives the user an opportunity to specify a fallback behaviour or simply ignore the error, leaving the input in an intermediate state.

* *event* - json event that generated this error
* *reason* - error string describing the parse error

See also [EventDecodeError](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#EventDecodeError)

-}
type alias EventDecodeError =
    T.EventDecodeError


{-| Update configuration for `input` fields.

* *onInput* - continuously send messages on any input event (`onInput`)
* *onEnter* - a message to send whenever the enter key is hit
* *onKeyboardLost* - a message to send whenever the input field loses the keyboard cursor

In the future, if this can be made efficient, this may also support:

* *onMouseMove* - a message to send whenever the mouse moves while the input field has keyboard focus

See also [FieldUpdate](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#FieldUpdate)

-}
type alias FieldUpdate a msg =
    T.FieldUpdate a msg


{-| Update configuration for a `select` element.

* *onSelect* - the selected option has changed.

See also [SelectUpdate](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#SelectUpdate)

-}
type alias SelectUpdate a msg =
    T.SelectUpdate a msg


{-| Default field update handlers. Use this to select only one or two handlers.

    { fieldUpdate
    | onInput <- Just (\r -> case r of
                                Ok x -> Just (SetValue x)
                                Err _ -> Just (SetError "Input error"))
    }

-}
fieldUpdate : FieldUpdate a msg
fieldUpdate =
    { onInput = Nothing
    , onEnter = Nothing
    , onKeyboardLost = Nothing
    }


{-| Good configuration for continuously updating fields that don_t have any invalid states, or are restricted by a pattern.
-}
fieldUpdateContinuous :
    { onInput : a -> msg
    }
    -> FieldUpdate a msg
fieldUpdateContinuous handler =
    let
        doOk r =
            case r of
                Ok x ->
                    Just (handler.onInput x)

                Err _ ->
                    Nothing
    in
        { fieldUpdate
            | onInput = Just doOk
        }


{-| Use with fields that should consolidate their value when the focus moved.
-}
fieldUpdateFocusLost :
    { onInput : a -> msg
    }
    -> FieldUpdate a msg
fieldUpdateFocusLost handler =
    let
        doOk r =
            case r of
                Ok x ->
                    Just (handler.onInput x)

                Err _ ->
                    Nothing
    in
        { fieldUpdate
            | onEnter = Just doOk
            , onKeyboardLost = Just doOk
        }


{-| Continuously update the field, handling invalid states only when the focus is lost.
The input element will try to consolidate the field with its value in all of these scenarios:

* During input event, if and only if the input parses correctly
* When the return key (ENTER) is hit; resets to the last known value if it couldn't parse
* When the keyboard cursor is moved to a different element; resets to the last known value if it couldn't parse

In the future, if this can be made efficient, it will also support:
* When the element has keyboard focus and the mouse cursor is moved ; resets to the last known value if it couldn't parse

This function takes an explicit fallback function that can usually be set to the previous value in order to have the field simply reset.

    inputField_
      { update = fieldUpdateFallbackFocusLost
                  { -- Reset the input to the current temperature
                    onFallback _ = SetTemperature currentTemperature
                  , -- Update the temperature if it parsed correctly
                    onInput v = SetTemperature v
                  }
      , ...
      }

Note that this configuration does not work well with `inputFloat_`/`inputMaybeFloat_` and `inputInt_`/`inputMaybeInt_` fields due to
the strange way that browsers treat numeric inputs. This update method can be used to implement custom field types however.

-}
fieldUpdateFallbackFocusLost :
    { onFallback : String -> msg
    , onInput : a -> msg
    }
    -> FieldUpdate a msg
fieldUpdateFallbackFocusLost handler =
    let
        doOk r =
            case r of
                Ok x ->
                    Just (handler.onInput x)

                Err _ ->
                    Nothing

        doErr r =
            case r of
                Ok _ ->
                    Nothing

                Err { event } ->
                    case Json.decodeValue targetValue event of
                        Ok s ->
                            Just (handler.onFallback s)

                        Err s ->
                            Nothing
    in
        { onInput = Just doOk
        , onEnter = Just doErr
        , onKeyboardLost = Just doErr
        }


{-| Continuously update the field, handling invalid states on any input event.
Use this configuration to generate error notifications rapidly.

    inputField_
      { update = fieldUpdateFallbackContinuous
                  { -- Show an error notification (e.g. highlight the input field)
                    onFallback _ = InvalidTemperature
                  , -- Update the temperature if it parsed correctly
                    onInput v = SetTemperature v
                  }
      , ...
      }

Note that this configuration does not work well with `inputFloat_`/`inputMaybeFloat_` and `inputInt_`/`inputMaybeInt_` fields due to
the strange way that browsers treat numeric inputs. This update method can be used to implement custom field types however.

-}
fieldUpdateFallbackContinuous :
    { onFallback : String -> msg
    , onInput : a -> msg
    }
    -> FieldUpdate a msg
fieldUpdateFallbackContinuous handler =
    let
        doOkErr r =
            case r of
                Ok x ->
                    Just (handler.onInput x)

                Err { event } ->
                    case Json.decodeValue targetValue event of
                        Ok s ->
                            Just (handler.onFallback s)

                        Err s ->
                            Nothing
    in
        { fieldUpdate
            | onInput = Just doOkErr
        }


{-| See [ClassParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#ClassParam)
-}
type alias ClassParam =
    T.ClassParam


{-| See [ClassIdParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#ClassIdParam)
-}
type alias ClassIdParam =
    T.ClassIdParam


{-| See [ClassCiteParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#ClassCiteParam)
-}
type alias ClassCiteParam =
    T.ClassCiteParam


{-| See [AnchorParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#AnchorParam)
-}
type alias AnchorParam =
    T.AnchorParam


{-| See [ModParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#ModParam)
-}
type alias ModParam =
    T.ModParam


{-| See [ImgParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#ImgParam)
-}
type alias ImgParam =
    T.ImgParam


{-| See [IframeParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#IframeParam)
-}
type alias IframeParam =
    T.IframeParam


{-| See [EmbedParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#EmbedParam)
-}
type alias EmbedParam =
    T.EmbedParam


{-| See [ObjectParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#ObjectParam)
-}
type alias ObjectParam =
    T.ObjectParam


{-| See [MediaParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#MediaParam)
-}
type alias MediaParam =
    T.MediaParam


{-| See [VideoParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#VideoParam)
-}
type alias VideoParam =
    T.VideoParam


{-| See [AudioParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#AudioParam)
-}
type alias AudioParam =
    T.AudioParam


{-| See [FormParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#FormParam)
-}
type alias FormParam msg =
    T.FormParam msg


{-| See [FieldsetParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#FieldsetParam)
-}
type alias FieldsetParam =
    T.FieldsetParam


{-| See [LabelParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#LabelParam)
-}
type alias LabelParam =
    T.LabelParam


{-| See [InputFieldParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputFieldParam)
-}
type alias InputFieldParam a msg =
    T.InputFieldParam a msg


{-| See [InputTextParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputTextParam)
-}
type alias InputTextParam msg =
    T.InputTextParam msg


{-| See [InputMaybeTextParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputMaybeTextParam)
-}
type alias InputMaybeTextParam msg =
    T.InputMaybeTextParam msg


{-| See [InputFloatParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputFloatParam)
-}
type alias InputFloatParam msg =
    T.InputFloatParam msg


{-| See [InputMaybeFloatParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputMaybeFloatParam)
-}
type alias InputMaybeFloatParam msg =
    T.InputMaybeFloatParam msg


{-| See [InputIntParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputIntParam)
-}
type alias InputIntParam msg =
    T.InputIntParam msg


{-| See [InputMaybeIntParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputMaybeIntParam)
-}
type alias InputMaybeIntParam msg =
    T.InputMaybeIntParam msg


{-| See [InputUrlParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputUrlParam)
-}
type alias InputUrlParam msg =
    T.InputUrlParam msg


{-| See [InputMaybeUrlParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputMaybeUrlParam)
-}
type alias InputMaybeUrlParam msg =
    T.InputMaybeUrlParam msg


{-| See [ButtonParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#ButtonParam)
-}
type alias ButtonParam msg =
    T.ButtonParam msg


{-| See [SelectParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#SelectParam)
-}
type alias SelectParam msg =
    T.SelectParam msg


{-| See [OptionParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#OptionParam)
-}
type alias OptionParam =
    T.OptionParam


{-| See [OutputParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#OutputParam)
-}
type alias OutputParam =
    T.OutputParam


{-| See [ProgressParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#ProgressParam)
-}
type alias ProgressParam =
    T.ProgressParam


{-| See [MeterParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#MeterParam)
-}
type alias MeterParam =
    T.MeterParam



-- ENCODERS


{-| A simplistic way of encoding `id` attributes into a [sane format](http://stackoverflow.com/a/72577).
This is used internally by all of the shorthands that take an `IdString`.

* Everything is turned into lowercase
* Only alpha-numeric characters (a-z,A-Z,0-9), hyphens (-) and underscores (_) are passed through the filter.
* Trim hyphens (-) and underscores (_) off the sides.
* If the first character is a number, 'x' will be prepended.
* Empty strings are allowed

E.g.

    encodeId "Elmo teaches Elm!" == "elmo-teaches-elm"
    encodeId "99 bottles of beer, 98 bottles..." == "x99-bottles-of-beer-98-bottles"
    encodeId "_internal- -<-identifier->-" == "internal-identifier"
    encodeId " \t \n" == ""

-}
encodeId : IdString -> IdString
encodeId =
    Internal.encodeId


{-| A simplistic way of encoding of `class` attributes into a [sane format](http://stackoverflow.com/a/72577).
This is used internally by all of the shorthands that take a `ClassString`.

* Everything is turned into lowercase
* Only alpha-numeric characters (a-z,A-Z,0-9), hyphens (-) and underscores (_) are passed through the filter.
* Trim hyphens (-) and underscores (_) on the sides of each class.
* If the first character is a number, 'x' will be prepended.
* Empty strings are allowed

E.g.

    encodeClass "Color.encoding: BLUE-GREEN" == "colorencoding blue-green"
    encodeClass "99-bottles... 98-bottles" == "x99-bottles x98-bottles"
    encodeClass "_internal-class-" == "internal-class"
    encodeClass " \t \n" == ""

-}
encodeClass : ClassString -> ClassString
encodeClass =
    Internal.encodeClass



-- IDIOMATIC ATTRIBUTES


{-| Encoded id attribute. Uses `encodeId` to ensure that the id is nicely normalized.
-}
id_ : IdString -> Attribute msg
id_ =
    Internal.id_


{-| Encoded class attribute. Uses `encodeClass` to ensure that the classes are nicely normalized.
-}
class_ : ClassString -> Attribute msg
class_ =
    Internal.class_



-- SECTIONS


{-| [&lt;body&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/body) represents the content of an HTML document. There is only one `body`
element in a document.
-}
body_ : ClassParam -> List (Html msg) -> Html msg
body_ p =
    body [ class_ p.class ]


{-| [&lt;section&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/section) defines a section in a document. Use sections to construct a document outline.

**Do:**
* [use &lt;section&gt;s to define document outlines](http://html5doctor.com/outlines/)
* [...but use &lt;h*n*&gt;s carefully](http://www.paciellogroup.com/blog/2013/10/html5-document-outline/)

**Don't:**
* [use &lt;section&gt; as a wrapper for styling](http://html5doctor.com/avoiding-common-html5-mistakes/#section-wrapper)

-}
section_ : ClassIdParam -> List (Html msg) -> Html msg
section_ p =
    section [ class_ p.class, id_ p.id ]


{-| [&lt;nav&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/nav) defines a section that contains only navigation links.

**Do:**
* [use &lt;nav&gt; for major navigation](http://html5doctor.com/avoiding-common-html5-mistakes/#nav-external)

**Don't:**
* [wrap all lists of links in &lt;nav&gt;](http://html5doctor.com/avoiding-common-html5-mistakes/#nav-external)

-}
nav_ : ClassParam -> List (Html msg) -> Html msg
nav_ p =
    nav [ class_ p.class ]


{-| [&lt;article&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/article) defines self-contained content that could exist independently of the rest
of the content.

**Do:**
* [use &lt;article&gt; for self-contained components with informational content](http://html5doctor.com/the-article-element/)
* [use &lt;article&gt; for blog entries, user-submitted comments, interactive educational gadgets](http://html5doctor.com/the-article-element/)

**Don't:**
* [confuse &lt;article&gt; with &lt;section&gt; which need not be self-contained](http://www.brucelawson.co.uk/2010/html5-articles-and-sections-whats-the-difference/)

-}
article_ : ClassIdParam -> List (Html msg) -> Html msg
article_ p =
    article [ class_ p.class, id_ p.id ]


{-| [&lt;aside&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/aside) defines some content loosely related to the page content. If it is removed,
the remaining content still makes sense.
-}
aside_ : ClassIdParam -> List (Html msg) -> Html msg
aside_ p =
    aside [ class_ p.class, id_ p.id ]


{-| [&lt;h*n*&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Heading_Elements) provide titles for sections and subsections, describing the topic it introduces.

**Do:**
* [use &lt;h*n*&gt; to define a document outline](http://www.paciellogroup.com/blog/2013/10/html5-document-outline/)
* [try to have only one first level &lt;h*n*&gt; on a page](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Heading_Elements)
* [introduce &lt;section&gt;s with headings](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Heading_Elements)

**Don't:**
* [skip &lt;h*n*&gt; levels if you can help it](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Heading_Elements)
* [style &lt;h*n*&gt;s using html5 &lt;section&gt;s](http://www.stubbornella.org/content/2011/09/06/style-headings-using-html5-sections/)
* [use &lt;h*n*&gt; for subtitles, subheadings](http://html5doctor.com/howto-subheadings/)

-}
h1_ : ClassParam -> List (Html msg) -> Html msg
h1_ p =
    h1 [ class_ p.class ]


{-| -}
h2_ : ClassParam -> List (Html msg) -> Html msg
h2_ p =
    h2 [ class_ p.class ]


{-| -}
h3_ : ClassParam -> List (Html msg) -> Html msg
h3_ p =
    h3 [ class_ p.class ]


{-| -}
h4_ : ClassParam -> List (Html msg) -> Html msg
h4_ p =
    h4 [ class_ p.class ]


{-| -}
h5_ : ClassParam -> List (Html msg) -> Html msg
h5_ p =
    h5 [ class_ p.class ]


{-| -}
h6_ : ClassParam -> List (Html msg) -> Html msg
h6_ p =
    h6 [ class_ p.class ]


{-| [&lt;header&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/header) defines the header of a page or section. It often contains a logo, the
title of the web site, and a navigational table of content.

**Don't:**
* [overuse &lt;header&gt;](http://html5doctor.com/avoiding-common-html5-mistakes/#header-hgroup)

-}
header_ : ClassParam -> List (Html msg) -> Html msg
header_ p =
    header [ class_ p.class ]


{-| [&lt;footer&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/footer) defines the footer for a page or section. It often contains a copyright
notice, some links to legal information, or addresses to give feedback.
-}
footer_ : ClassParam -> List (Html msg) -> Html msg
footer_ p =
    footer [ class_ p.class ]


{-| [&lt;address&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/address) defines a section containing contact information.

**Do:**
* [place inside the &lt;footer&gt; where appropriate](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/address#Summary)

**Don't:**
* [represent an arbitrary, unrelated address](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/address#Summary)

-}
address_ : ClassParam -> List (Html msg) -> Html msg
address_ p =
    address [ class_ p.class ]



-- GROUPING CONTENT


{-| [&lt;p&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/p) defines a portion that should be displayed as a paragraph of text.
-}
p_ : ClassParam -> List (Html msg) -> Html msg
p_ param =
    p [ class_ param.class ]


{-| [&lt;hr&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/hr) represents a thematic break between paragraphs of a section or article or
any longer content.

No other form is provided since hr should probably not have any classes or contents.

-}
hr_ : Html msg
hr_ =
    hr [] []


{-| [&lt;pre&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/pre) indicates that its content is preformatted and that this format must be
preserved.

**Do:**
* [use &lt;pre&gt; for blocks of whitespace sensitive text that must not wrap](http://stackoverflow.com/a/4611735)
* use &lt;pre&gt; as a wrapper for blocks &lt;`code_`&gt;
* use &lt;pre&gt; as a wrapper for blocks of &lt;`samp_`&gt; output from a computer program

-}
pre_ : ClassParam -> List (Html msg) -> Html msg
pre_ p =
    pre [ class_ p.class ]


{-| [&lt;blockquote&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/blockquote) represents a content that is quoted from another source.

The idiomatic form uses a cite url, but an elision form is also provided.

**Don't:**
* use blockquote for short, inline quotations, we have &lt;`q_`&gt; for that

-}
blockquote_ : ClassCiteParam -> List (Html msg) -> Html msg
blockquote_ p =
    blockquote [ class_ p.class, A.cite p.cite ]


{-| [&lt;ol&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ol) defines an ordered list of items.
-}



-- TODO: A template version of ol_' that simply takes a list of TextString?


ol_ : ClassParam -> List (Html msg) -> Html msg
ol_ p =
    ol [ class_ p.class ]


{-| [&lt;ul&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ul) defines an unordered list of items.
-}



-- TODO: A template version of ul_ that simply takes a list of TextString?


ul_ : ClassParam -> List (Html msg) -> Html msg
ul_ p =
    ul [ class_ p.class ]


{-| [&lt;li&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/li) defines a item of an enumeration list.
-}
li_ : ClassParam -> List (Html msg) -> Html msg
li_ p =
    li [ class_ p.class ]


{-| [&lt;dl&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dl) defines a definition list, that is, a list of terms and their associated
definitions.
-}



-- TODO: A template version of dl_' that take <dt> and <dd> TextString directly?


dl_ : ClassParam -> List (Html msg) -> Html msg
dl_ p =
    dl [ class_ p.class ]


{-| [&lt;dt&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dt) represents a term defined by the next `dd`.
-}
dt_ : ClassIdParam -> List (Html msg) -> Html msg
dt_ p =
    dt [ class_ p.class, id_ p.id ]


{-| [&lt;dd&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dd) represents the definition of the terms immediately listed before it.
-}
dd_ : ClassParam -> List (Html msg) -> Html msg
dd_ p =
    dd [ class_ p.class ]


{-| [&lt;figure&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/figure) represents a figure illustrated as part of the document.

**Do:**
* [use figure for captioned content](http://html5doctor.com/the-figure-figcaption-elements/)
* [use figure for things other than images: video, audio, a chart, a table etc](http://html5doctor.com/the-figure-figcaption-elements/)

**Don't:**
* [turn every image into a figure](http://html5doctor.com/avoiding-common-html5-mistakes/#figure)

-}
figure_ : ClassIdParam -> List (Html msg) -> Html msg
figure_ p =
    figure [ class_ p.class, id_ p.id ]


{-| [&lt;figcaption&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/figcaption) represents the legend of a figure.
-}
figcaption_ : ClassParam -> List (Html msg) -> Html msg
figcaption_ p =
    figcaption [ class_ p.class ]


{-| [&lt;div&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/div) represents a generic container with no special meaning.
-}
div_ : ClassParam -> List (Html msg) -> Html msg
div_ p =
    div [ class_ p.class ]



-- TEXT LEVEL SEMANTIC


{-| [&lt;a&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a) represents a hyperlink , linking to another resource.
-}



-- TODO: Possibly a download version https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a#attr-download
--       e.g. aDownload : FilenameString -> UrlString -> Html msg
-- TODO: A 'blank' version may also be very helpful. E.g.
--       <a href="http://elm-lang.org/" target="_blank">
--         <img src="http://elm-lang.org/logo.png" alt="Elm logo" />
--       </a>
-- TODO: Also see https://developer.mozilla.org/en-US/docs/Web/HTML/Link_types
-- TODO: etc...


a_ : AnchorParam -> List (Html msg) -> Html msg
a_ p =
    a [ class_ p.class, A.href p.href ]


{-| [&lt;em&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/em) represents emphasized text, like a stress accent.
-}
em_ : ClassParam -> List (Html msg) -> Html msg
em_ p =
    em [ class_ p.class ]


{-| [&lt;strong&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/strong) represents especially important text.
-}
strong_ : ClassParam -> List (Html msg) -> Html msg
strong_ p =
    strong [ class_ p.class ]


{-| [&lt;small&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/small) represents a side comment , that is, text like a disclaimer or a
copyright, which is not essential to the comprehension of the document.

**Don't:**
  * [use small for pure styling](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/small#Summary)

**Do:**
  * [use small for side-comments and small print, including copyright and legal text](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/small#Summary)

-}
small_ : ClassParam -> List (Html msg) -> Html msg
small_ p =
    small [ class_ p.class ]


{-| [&lt;s&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/s) represents content that is no longer accurate or relevant.

**Don't:**
* [use &lt;s&gt; for indicating document edits, use &lt;del&gt; or &lt;ins&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/s#Summary)

-}
s_ : ClassParam -> List (Html msg) -> Html msg
s_ p =
    s [ class_ p.class ]


{-| [&lt;cite&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/cite) represents the title of a work.

**Do:**
* [consider using an anchor inside of the cite to link to the origin](http://html5doctor.com/cite-and-blockquote-reloaded/)

-}
cite_ : ClassParam -> List (Html msg) -> Html msg
cite_ p =
    cite [ class_ p.class ]


{-| [&lt;q&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/q) represents an inline quotation.

The idiomatic form uses a cite url, but the elision is also provided.
-}
q_ : ClassCiteParam -> List (Html msg) -> Html msg
q_ p =
    q [ class_ p.class, A.cite p.cite ]


{-| [&lt;dfn&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dfn) represents a term whose definition is contained in its nearest ancestor
content.
-}
dfn_ : ClassIdParam -> List (Html msg) -> Html msg
dfn_ p =
    dfn [ class_ p.class, id_ p.id ]


{-| [&lt;abbr&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/abbr) represents an abbreviation or an acronym ; the expansion of the
abbreviation can be represented in the title attribute.
-}
abbr_ : ClassParam -> List (Html msg) -> Html msg
abbr_ p =
    abbr [ class_ p.class ]



{- [&lt;time&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/time) represents a date and time value; the machine-readable equivalent can be
   represented in the datetime attribute.
-}
-- TODO: String presentation doesn't appear to exist for Dates yet
--time_ : TimeParam -> Html msg
--time_ p = time [class_ c, datetime d] [text t]


{-| [&lt;code&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/code) represents computer code.
-}
code_ : ClassParam -> List (Html msg) -> Html msg
code_ p =
    code [ class_ p.class ]


{-| [&lt;var&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/var) represents a variable. Specific cases where it should be used include an
actual mathematical expression or programming context, an identifier
representing a constant, a symbol identifying a physical quantity, a function
parameter, or a mere placeholder in prose.
-}
var_ : ClassParam -> List (Html msg) -> Html msg
var_ p =
    var [ class_ p.class ]


{-| [&lt;samp&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/samp) represents the output of a program or a computer.
-}
samp_ : ClassParam -> List (Html msg) -> Html msg
samp_ p =
    samp [ class_ p.class ]


{-| [&lt;kbd&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/kbd) represents user input, often from the keyboard, but not necessarily; it
may represent other input, like transcribed voice commands.

    instructions : Html msg
    instructions =
      p_ { class = "" }
        [ text "Press "
        , kbd_ { class = "key" }
          [ kbd_ { class = "key" } [ text "Ctrl" ]
          , text "+"
          , kbd_ { class = "key" } [ text "S"]
          ]
        , text " to save this document."
        ]

-}
kbd_ : ClassParam -> List (Html msg) -> Html msg
kbd_ p =
    kbd [ class_ p.class ]


{-| [&lt;sub&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/sub) represent a subscript.
-}
sub_ : ClassParam -> List (Html msg) -> Html msg
sub_ p =
    sub [ class_ p.class ]


{-| [&lt;sup&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/sup) represent a superscript.
-}
sup_ : ClassParam -> List (Html msg) -> Html msg
sup_ p =
    sup [ class_ p.class ]


{-| [&lt;i&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/i) represents some text in an alternate voice or mood, or at least of
different quality, such as a taxonomic designation, a technical term, an
idiomatic phrase, a thought, or a ship name.
-}
i_ : ClassParam -> List (Html msg) -> Html msg
i_ p =
    i [ class_ p.class ]


{-| [&lt;b&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/b) represents a text which to which attention is drawn for utilitarian
purposes. It doesn't convey extra importance and doesn't imply an alternate voice.
-}
b_ : ClassParam -> List (Html msg) -> Html msg
b_ p =
    b [ class_ p.class ]


{-| [&lt;u&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/u) represents a non-textual annoatation for which the conventional
presentation is underlining, such labeling the text as being misspelt or
labeling a proper name in Chinese text.
-}
u_ : ClassParam -> List (Html msg) -> Html msg
u_ p =
    u [ class_ p.class ]


{-| [&lt;mark&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/mark) represents text highlighted for reference purposes, that is for its
relevance in another context.
-}
mark_ : ClassParam -> List (Html msg) -> Html msg
mark_ p =
    mark [ class_ p.class ]


{-| [&lt;ruby&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ruby) represents content to be marked with ruby annotations, short runs of text
presented alongside the text. This is often used in conjunction with East Asian
language where the annotations act as a guide for pronunciation, like the
Japanese furigana.
-}
ruby_ : ClassParam -> List (Html msg) -> Html msg
ruby_ p =
    ruby [ class_ p.class ]


{-| [&lt;rt&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/rt) represents the text of a ruby annotation .
-}
rt_ : ClassParam -> List (Html msg) -> Html msg
rt_ p =
    rt [ class_ p.class ]


{-| [&lt;rp&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/rp) represents parenthesis around a ruby annotation, used to display the
annotation in an alternate way by browsers not supporting the standard display
for annotations.
-}
rp_ : ClassParam -> List (Html msg) -> Html msg
rp_ p =
    rp [ class_ p.class ]


{-| [&lt;bdi&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/bdi) represents text that must be isolated from its surrounding for
bidirectional text formatting. It allows embedding a span of text with a
different, or unknown, directionality.
-}
bdi_ : ClassParam -> List (Html msg) -> Html msg
bdi_ p =
    bdi [ class_ p.class ]


{-| [&lt;bdo&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/bdo) represents the directionality of its children, in order to explicitly
override the Unicode bidirectional algorithm.
-}
bdo_ : TextDirection -> List (Html msg) -> Html msg
bdo_ dir =
    bdo
        [ A.dir <|
            case dir of
                LeftToRight ->
                    "ltr"

                RightToLeft ->
                    "rtl"

                AutoDirection ->
                    "auto"
        ]


{-| [&lt;span&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/span) represents text with no specific meaning. This has to be used when no other
text-semantic element conveys an adequate meaning, which, in this case, is
often brought by global attributes like class_, lang, or dir.
-}
span_ : ClassParam -> List (Html msg) -> Html msg
span_ p =
    span [ class_ p.class ]


{-| [&lt;br&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/br) represents a line break.
-}
br_ : Html msg
br_ =
    br [] []


{-| [&lt;wbr&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/wbr) represents a line break opportunity , that is a suggested point for
wrapping text in order to improve readability of text split on several lines.
-}
wbr_ : Html msg
wbr_ =
    wbr [] []



-- EDITS


{-| [&lt;ins&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ins) defines an addition to the document.
-}
ins_ : ModParam -> List (Html msg) -> Html msg
ins_ p =
    ins [ class_ p.class, A.cite p.cite, A.datetime p.datetime ]


{-| [&lt;del&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/del) defines a removal from the document.
-}
del_ : ModParam -> List (Html msg) -> Html msg
del_ p =
    del [ class_ p.class, A.cite p.cite, A.datetime p.datetime ]



-- EMBEDDED CONTENT


{-| [&lt;img&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/img) represents an image.
-}
img_ : ImgParam -> Html msg
img_ p =
    img [ class_ p.class, A.src p.src, A.width p.width, A.height p.height, A.alt p.alt ] []


{-| [&lt;iframe&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe) embedded an HTML document.
-}
iframe_ : IframeParam -> Html msg
iframe_ p =
    let
        i_ =
            encodeId p.name

        filterJust =
            List.filterMap identity
    in
        iframe
            ([ class_ p.class
             , A.id i_
             , A.name i_
             , A.src p.src
             , A.width p.width
             , A.height p.height
             , A.seamless p.seamless
             ]
                ++ filterJust
                    [ Maybe.map A.sandbox p.sandbox
                    ]
            )
            []


{-| [&lt;embed&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/embed) represents a integration point for an external, often non-HTML,
application or interactive content.
-}
embed_ : EmbedParam -> Html msg
embed_ p =
    embed [ class_ p.class, id_ p.id, A.src p.src, A.type_ p.type_, A.width p.width, A.height p.height ] []


{-| [&lt;object&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/object) represents an external resource , which is treated as an image, an HTML
sub-document, or an external resource to be processed by a plug-in.
-}
object_ : ObjectParam -> List (Html msg) -> Html msg
object_ p =
    let
        i_ =
            encodeId p.name

        filterJust =
            List.filterMap identity

        attrs =
            filterJust
                [ Maybe.map (A.usemap << String.cons '#' << encodeId) p.useMapName
                ]
    in
        object <|
            [ class_ p.class, A.id i_, A.name i_, A.attribute "data" p.data, A.type_ p.type_ ]
                ++ attrs
                ++ [ A.height p.height, A.width p.width ]


{-| [&lt;param&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/param) defines parameters for use by plug-ins invoked by `object` elements.
-}
param_ : String -> String -> Html msg
param_ n v =
    param [ A.name n, A.value v ] []


{-| [&lt;video&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/video) represents a video, the associated audio and captions, and controls.

Doesn_t allow for &lt;track&gt;s &lt;source&gt;s, please use `video` for that.
-}
video_ : VideoParam -> List (Html msg) -> Html msg
video_ p =
    let
        filterJust =
            List.filterMap identity
    in
        video <|
            [ class_ p.class
            , A.width p.width
            , A.height p.height
            , A.autoplay p.autoplay
            , A.controls p.controls
            , A.loop p.loop
              -- , A.boolProperty "muted" p.muted
            ]
                ++ filterJust
                    [ Maybe.map A.src p.src
                      -- , Maybe.map (A.property "crossorigin") p.crossorigin
                    , Maybe.map (A.stringProperty "preload") p.preload
                    , Maybe.map A.poster p.poster
                    , Maybe.map A.volume p.volume
                    ]


{-| [&lt;audio&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/audio) represents a sound or audio stream.

Doesn't allow for &lt;track&gt;s &lt;source&gt;s, please use `audio` for that.
-}
audio_ : AudioParam -> List (Html msg) -> Html msg
audio_ p =
    let
        filterJust =
            List.filterMap identity
    in
        audio <|
            [ class_ p.class
            , A.autoplay p.autoplay
            , A.controls p.controls
            , A.loop p.loop
              -- , A.boolProperty "muted" p.muted
            ]
                ++ filterJust
                    [ Maybe.map A.src p.src
                      -- , Maybe.map (A.property "crossorigin") p.crossorigin
                    , Maybe.map (A.stringProperty "preload") p.preload
                    , Maybe.map A.poster p.poster
                    , Maybe.map A.volume p.volume
                    ]



--{-| [&lt;source&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/source) allows authors to specify alternative media resources for media elements
--like `video` or `audio`.
---}
-- TODO
--source_ :  -> List (Html msg) -> Html msg
--source_ = source []
--source_ : ClassParam -> List (Html msg) -> Html msg
--source_ p = source [class_ p.class]
--{-| [&lt;track&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/track) allows authors to specify timed text track for media elements like `video`
--or `audio`.
---}
-- TODO
--track_ :  -> List (Html msg) -> Html msg
--track_ = track []
--track_ : ClassParam -> List (Html msg) -> Html msg
--track_ p = track [class_ p.class]
{- [&lt;canvas&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/canvas) represents a bitmap area for graphics rendering.

   No defaults provided since you're probably best off using Elm's `Graphics`!
-}
{--TODO: elm-html hasn't exposed these functions
--{-| In conjunction with `area`, defines an image map.
---}
map_ : List (Html msg) -> Html msg
map_ = map []

--{-| In conjunction with `map`, defines an image map.
---}
area_ : List (Html msg) -> Html msg
area_ = area []
--}
--{-| [&lt;svg&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/svg) defines an embedded vectorial image.
---}
--svg_ : ClassParam -> List (Html msg) -> Html msg
--svg_ p = svg [class_ p.class]
--{-| [&lt;math&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/math) defines a mathematical formula.
---}
--math_ :  -> List (Html msg) -> Html msg
--math_ = math []
--math_ : ClassParam -> List (Html msg) -> Html msg
--math_ p = math [class_ p.class]
-- TABULAR DATA


{-| [&lt;table&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/table) represents data with more than one dimension.
-}
table_ : ClassParam -> List (Html msg) -> Html msg
table_ p =
    table [ class_ p.class ]


{-| [&lt;caption&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/caption) represents the title of a table.
-}
caption_ : ClassParam -> List (Html msg) -> Html msg
caption_ p =
    caption [ class_ p.class ]



--{-| [&lt;colgroup&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/colgroup) represents a set of one or more columns of a table.
---}
--colgroup_ : ClassParam -> List (Html msg) -> Html msg
--colgroup_ p = colgroup [class_ p.class]
--{-| [&lt;col&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/col) represents a column of a table.
---}
--col_ :  -> List (Html msg) -> Html msg
--col_ = col []
--col_ : ClassParam -> List (Html msg) -> Html msg
--col_ p = col [class_ p.class]


{-| [&lt;tbody&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/tbody) represents the block of rows that describes the concrete data of a table.
-}
tbody_ : ClassParam -> List (Html msg) -> Html msg
tbody_ p =
    tbody [ class_ p.class ]


{-| [&lt;thead&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/thead) represents the block of rows that describes the column labels of a table.
-}
thead_ : ClassParam -> List (Html msg) -> Html msg
thead_ p =
    thead [ class_ p.class ]


{-| [&lt;tfoot&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/tfoot) represents the block of rows that describes the column summaries of a table.
-}
tfoot_ : ClassParam -> List (Html msg) -> Html msg
tfoot_ p =
    tfoot [ class_ p.class ]


{-| [&lt;tr&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/tr) represents a row of cells in a table.
-}
tr_ : ClassParam -> List (Html msg) -> Html msg
tr_ p =
    tr [ class_ p.class ]


{-| [&lt;td&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/td) represents a data cell in a table.
-}
td_ : ClassParam -> List (Html msg) -> Html msg
td_ p =
    td [ class_ p.class ]


{-| [&lt;th&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/th) represents a header cell in a table.
-}
th_ : ClassParam -> List (Html msg) -> Html msg
th_ p =
    th [ class_ p.class ]



-- FORMS


{-| [&lt;form&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/form) represents a form , consisting of controls, that can be submitted to a
server for processing.

In future `Nothing` may mask out the default submit on Enter key behaviour.
See [virtual-dom/pull/5#issuecomment-88444513](https://github.com/evancz/virtual-dom/pull/5#issuecomment-88444513) and [stackoverflow](http://stackoverflow.com/a/587575/167485).
-}
form_ : FormParam msg -> List (Html msg) -> Html msg
form_ p =
    let
        filterJust =
            List.filterMap identity

        onEnter_ msg =
            on "keypress"
                (customDecoder keyCode <|
                    \c ->
                        if c == 13 then
                            Ok msg
                        else
                            Err "expected key code 13"
                )
    in
        form <|
            class_ p.class
                :: A.novalidate p.novalidate
                -- TODO: mask enter key when no handler is given
                -- See https://github.com/evancz/virtual-dom/pull/5#issuecomment-88444513
                -- and http://stackoverflow.com/a/587575/167485
                -- :: Maybe.withDefault maskEnter (Maybe.map onEnter_ p.update.onEnter)
                ::
                    filterJust
                        [ Maybe.map onSubmit p.update.onSubmit
                        , Maybe.map onEnter_ p.update.onSubmit
                        ]


{-| [&lt;fieldset&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/fieldset) represents a set of controls.
-}
fieldset_ : FieldsetParam -> List (Html msg) -> Html msg
fieldset_ p =
    fieldset [ class_ p.class, A.disabled p.disabled ]


{-| [&lt;legend&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/legend) represents the caption for a `fieldset`.
-}
legend_ : ClassParam -> List (Html msg) -> Html msg
legend_ p =
    legend [ class_ p.class ]


{-| [&lt;label&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/label) represents the caption of a form control.
-}
label_ : LabelParam -> List (Html msg) -> Html msg
label_ p =
    label
        [ class_ p.class
        , A.for p.for
        ]


{-| [&lt;input&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input) represents a typed data field allowing the user to edit the data.

In order to disable an input field, use `fieldset_ False`.
-}
inputField_ : InputFieldParam a msg -> List (Attribute msg) -> Html msg
inputField_ p attrs =
    let
        filterJust =
            List.filterMap identity

        i_ =
            encodeId p.name

        pattrs =
            [ A.type_ p.type_
            , A.id i_
            , A.name i_
            , A.required p.required
            ]
                ++ filterJust
                    [ Maybe.map class_
                        (if p.class == "" then
                            Nothing
                         else
                            Just p.class
                        )
                    , Maybe.map (\onEvent -> onInput_ (messageDecoder p.decoder onEvent) identity) p.update.onInput
                    , Maybe.map (\onEvent -> onEnter (messageDecoder p.decoder onEvent) identity) p.update.onEnter
                    , Maybe.map (\onEvent -> onKeyboardLost (messageDecoder p.decoder onEvent) identity) p.update.onKeyboardLost
                    , Maybe.map A.placeholder p.placeholder
                    , Maybe.map A.pattern p.pattern
                    ]
    in
        input (pattrs ++ attrs) []


{-| -}
inputText_ : InputTextParam msg -> Html msg
inputText_ p =
    inputField_
        { class = p.class
        , name = p.name
        , placeholder = p.placeholder
        , update = p.update
        , type_ = "text"
        , pattern = Nothing
        , required = p.required
        , decoder = targetValue
        }
        [ A.value p.value
        , A.autocomplete p.autocomplete
        ]


{-| -}
inputMaybeText_ : InputMaybeTextParam msg -> Html msg
inputMaybeText_ p =
    inputField_
        { class = p.class
        , name = p.name
        , placeholder = p.placeholder
        , update = p.update
        , type_ = "text"
        , pattern = Nothing
        , required = False
        , decoder = targetValueMaybe
        }
        [ A.value (Maybe.withDefault "" p.value)
        , A.autocomplete p.autocomplete
        ]


{-| -}
inputFloat_ : InputFloatParam msg -> Html msg
inputFloat_ p =
    let
        filterJust =
            List.filterMap identity

        --allowedChars =  '.'
        --                :: case p.min of
        --                      Nothing -> ['-']
        --                      Just x  -> if x >= 0 then [] else ['-']
    in
        inputField_
            { class = p.class
            , name = p.name
            , placeholder = p.placeholder
            , update = p.update
            , type_ = "number"
            , pattern = Nothing
            , required = True
            , decoder =
                case ( p.min, p.max ) of
                    ( Nothing, Nothing ) ->
                        targetValueFloat

                    _ ->
                        customDecoder targetValueFloat <|
                            \v ->
                                if v < Maybe.withDefault (-1 / 0) p.min || v > Maybe.withDefault (1 / 0) p.max then
                                    Err "out of bounds"
                                else
                                    Ok v
            }
        <|
            A.valueAsFloat p.value
                --:: filterOnKeyPressChar (\c -> if (c >= '0' && c <= '9') || c `List.member` allowedChars then Just tmpMsg else Nothing)
                ::
                    A.stringProperty "step" (Maybe.withDefault "any" <| Maybe.map toString p.step)
                :: filterJust
                    [ Maybe.map (A.min << toString) p.min
                    , Maybe.map (A.max << toString) p.max
                    ]


{-| -}
inputMaybeFloat_ : InputMaybeFloatParam msg -> Html msg
inputMaybeFloat_ p =
    let
        filterJust =
            List.filterMap identity
    in
        inputField_
            { class = p.class
            , name = p.name
            , placeholder = p.placeholder
            , update = p.update
            , type_ = "number"
            , pattern = Nothing
            , required = False
            , decoder =
                case ( p.min, p.max ) of
                    ( Nothing, Nothing ) ->
                        targetValueMaybeFloat

                    _ ->
                        customDecoder targetValueMaybeFloat <|
                            \mv ->
                                case mv of
                                    Nothing ->
                                        Ok Nothing

                                    Just v ->
                                        if v < Maybe.withDefault (-1 / 0) p.min || v > Maybe.withDefault (1 / 0) p.max then
                                            Err "out of bounds"
                                        else
                                            Ok mv
            }
        <|
            (case p.value of
                Nothing ->
                    A.value ""

                Just v ->
                    A.valueAsFloat v
            )
                :: A.stringProperty "step" (Maybe.withDefault "any" <| Maybe.map toString p.step)
                :: filterJust
                    [ Maybe.map (A.min << toString) p.min
                    , Maybe.map (A.max << toString) p.max
                    ]


{-| -}
inputInt_ : InputIntParam msg -> Html msg
inputInt_ p =
    let
        filterJust =
            List.filterMap identity
    in
        inputField_
            { class = p.class
            , name = p.name
            , placeholder = p.placeholder
            , update = p.update
            , type_ = "number"
            , pattern = Nothing
            , required = True
            , decoder =
                case ( p.min, p.max ) of
                    ( Nothing, Nothing ) ->
                        targetValueInt

                    _ ->
                        customDecoder targetValueInt <|
                            \v ->
                                if v < Maybe.withDefault (floor <| -1 / 0) p.min || v > Maybe.withDefault (ceiling <| 1 / 0) p.max then
                                    Err "out of bounds"
                                else
                                    Ok v
            }
        <|
            A.valueAsInt p.value
                :: filterJust
                    [ Maybe.map (A.min << toString) p.min
                    , Maybe.map (A.max << toString) p.max
                    , Maybe.map (A.stringProperty "step" << toString) p.step
                    ]


{-| -}
inputMaybeInt_ : InputMaybeIntParam msg -> Html msg
inputMaybeInt_ p =
    let
        filterJust =
            List.filterMap identity
    in
        inputField_
            { class = p.class
            , name = p.name
            , placeholder = p.placeholder
            , update = p.update
            , type_ = "number"
            , pattern = Nothing
            , required = False
            , decoder =
                case ( p.min, p.max ) of
                    ( Nothing, Nothing ) ->
                        targetValueMaybeInt

                    _ ->
                        customDecoder targetValueMaybeInt <|
                            \mv ->
                                case mv of
                                    Nothing ->
                                        Ok Nothing

                                    Just v ->
                                        if v < Maybe.withDefault (floor <| -1 / 0) p.min || v > Maybe.withDefault (ceiling <| 1 / 0) p.max then
                                            Err "out of bounds"
                                        else
                                            Ok mv
            }
        <|
            (case p.value of
                Nothing ->
                    A.value ""

                Just v ->
                    A.valueAsInt v
            )
                :: filterJust
                    [ Maybe.map (A.min << toString) p.min
                    , Maybe.map (A.max << toString) p.max
                    , Maybe.map (A.stringProperty "step" << toString) p.step
                    ]


{-| -}
inputUrl_ : InputUrlParam msg -> Html msg
inputUrl_ p =
    inputField_
        { class = p.class
        , name = p.name
        , placeholder = p.placeholder
        , update = p.update
        , type_ = "url"
        , pattern = Nothing
        , required = p.required
        , decoder = targetValue
        }
        [ A.value p.value
        , A.autocomplete p.autocomplete
        ]


{-| -}
inputMaybeUrl_ : InputMaybeUrlParam msg -> Html msg
inputMaybeUrl_ p =
    inputField_
        { class = p.class
        , name = p.name
        , placeholder = p.placeholder
        , update = p.update
        , type_ = "url"
        , pattern = Nothing
        , required = False
        , decoder = targetValueMaybe
        }
        [ A.value (Maybe.withDefault "" p.value)
        , A.autocomplete p.autocomplete
        ]


{-| [&lt;button&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button) represents a button.
-}
button_ : ButtonParam msg -> List (Html msg) -> Html msg
button_ p =
    button
        [ class_ p.class
        , A.type_ "button"
        , onClick p.update.onClick
        ]



-- This is technically an anchor, but behaves more like a button


{-| -}
buttonLink_ : ButtonParam msg -> List (Html msg) -> Html msg
buttonLink_ p =
    a
        [ class_ p.class
        , A.href "#"
        , onClick p.update.onClick
        ]


{-| -}
buttonSubmit_ : ClassParam -> List (Html msg) -> Html msg
buttonSubmit_ p =
    button
        [ class_ p.class
        , A.type_ "submit"
        ]


{-| -}
buttonReset_ : ClassParam -> List (Html msg) -> Html msg
buttonReset_ p =
    button
        [ class_ p.class
        , A.type_ "reset"
        ]


{-| [&lt;select&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/select) represents a control allowing selection among a set of options.
-}
select_ : SelectParam msg -> List (Html msg) -> Html msg
select_ p =
    let
        i_ =
            encodeId p.name
    in
        select
            [ class_ p.class
            , A.id i_
            , A.name i_
            , onChange targetValue p.update.onSelect
              -- , on "click" targetValue p.update.onSelect
              -- , on "keypress" targetValue p.update.onSelect
            ]



--{-| [&lt;datalist&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/datalist) represents a set of predefined options for other controls.
---}
--datalist_ :  -> List (Html msg) -> Html msg
--datalist_ = datalist []
--datalist_ : ClassParam -> List (Html msg) -> Html msg
--datalist_ p = datalist [class_ p.class]
--{-| [&lt;optgroup&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/optgroup) represents a set of options , logically grouped.
---}
--optgroup_ :  -> List (Html msg) -> Html msg
--optgroup_ = optgroup []
--optgroup_ : ClassParam -> List (Html msg) -> Html msg
--optgroup_ p = optgroup [class_ p.class]


{-| [&lt;option&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/option) represents an option in a `select` element or a suggestion of a `datalist` element.
-}
option_ : OptionParam -> Html msg
option_ p =
    option [ A.stringProperty "label" p.label, A.value p.value, A.selected p.selected ] []



--{-| [&lt;textarea&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea) represents a multiline text edit control.
---}
--textarea_ : ClassParam -> List (Html msg) -> Html msg
--textarea_ p = textarea [class_ p.class]
--{-| [&lt;keygen&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/keygen) represents a key-pair generator control.
---}
--keygen_ : ClassParam -> List (Html msg) -> Html msg
--keygen_ p = keygen [class_ p.class]


{-| [&lt;output&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/output) represents the result of a calculation.
-}
output_ : OutputParam -> List (Html msg) -> Html msg
output_ p =
    let
        i_ =
            encodeId p.name
    in
        output [ class_ p.class, A.id i_, A.name i_, A.for (String.join " " <| List.map encodeId p.for) ]


{-| [&lt;progress&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/progress) represents the completion progress of a task.
-}
progress_ : ProgressParam -> String -> Html msg
progress_ p t =
    progress [ A.value (toString p.value), A.max (toString p.max) ] [ text t ]


{-| [&lt;meter&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/meter) represents a scalar measurement (or a fractional value), within a known range.
-}
meter_ : MeterParam -> String -> Html msg
meter_ p t =
    let
        filterJust =
            List.filterMap identity
    in
        meter
            ([ A.value (toString p.value)
             , A.min (toString min)
             , A.max (toString p.max)
             ]
                ++ filterJust
                    [ Maybe.map (A.low << toString) p.low
                    , Maybe.map (A.high << toString) p.high
                    , Maybe.map (A.optimum << toString) p.optimum
                    ]
            )
            [ text t ]



-- INTERACTIVE ELEMENTS
--{-| [&lt;details&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/details) represents a widget from which the user can obtain additional information or controls.
--
-- Warning: Details & summary is not widely supported at this time. http://caniuse.com/#feat=details
--
---}
--details_ :  -> List (Html msg) -> Html msg
--details_ = details []
--{-| [&lt;summary&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/summary) represents a summary , caption , or legend for a given `details`.
--
-- Warning: Details & summary is not widely supported at this time. http://caniuse.com/#feat=details
--
---}
--summary_ :  -> List (Html msg) -> Html msg
--summary_ = summary []
--{-| [&lt;menuitem&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/menuitem) represents a command that the user can invoke.
--
-- Warning: Menu is not widely supported at this time. http://caniuse.com/#feat=menu
--
---}
--menuitem_ :  -> List (Html msg) -> Html msg
--menuitem_ = menuitem []
--{-| [&lt;menu&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/menu) represents a list of commands.
--
-- Warning: Menu is not widely supported at this time. http://caniuse.com/#feat=menu
--
---}
--menu_ :  -> List (Html msg) -> Html msg
--menu_ = menu []
--menu_ : ClassParam -> List (Html msg) -> Html msg
--menu_ p = menu [class_ p.class]
