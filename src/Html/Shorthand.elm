module Html.Shorthand where
{-| Shorthands for common Html elements

# Conventions
The following two conventions are used for shorthands. One example is provided for each.

## Elision form
Most attributes of the node are elided, only one or two arguments needs to be supplied.

@docs div_

## Idiomatic form

This form attempts to take a common sense record of parameters. This is a more expansive shorthand which
will not satisfy every need, but takes care of the usual cases while still encouraging uniformity.

@docs img'

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
@docs id', class'

# Sections
@docs body_, body', section_, section', nav_, nav', article_, article', aside'
@docs h1_, h1', h2_, h2', h3_, h3', h4_, h4', h5_, h5', h6_, h6', header_, header', footer_, footer'
@docs address_, address', main_

# Grouping content
@docs p_, p', pre_, pre', blockquote_, blockquote', ol_, ol', ul_, ul', li_, li', dl_, dl', dt', dd_, dd'
@docs figure', figcaption_, figcaption'
@docs div_, div', a_, a', em_, em', strong_, strong', small_, small', s_, s'
@docs cite_, cite', q_, q', dfn', abbr_, abbr'
* time_ (TODO)
* time' (TODO)
@docs code_, code', var_, var', samp_, samp', kbd_, kbd'
@docs sub_, sub', sup_, sup', i_, i', b_, b', u_, u', mark_, mark'
@docs ruby_, ruby', rt_, rt', rp_, rp', bdi_, bdi', bdo'
@docs span_, span'

# Edits
@docs ins_, ins', del_, del'

# Embedded content
@docs img', img_, iframe', embed', object'
@docs param', video_, video', audio_, audio'
* source' (TODO)
* track' (TODO)
@docs map_, area_
* svg' (TODO)
* math' (TODO)

# Tabular data
@docs table_, table', caption_, caption'
* colgroup' (TODO)
* col' (TODO)
@docs tbody_, tbody', thead_, thead', tfoot_, tfoot', tr_, tr', td_, td', th_, th'

# Forms
@docs form', fieldset_, fieldset, legend_, legend', label_, label'
@docs inputField', inputText', inputMaybeText', inputFloat', inputMaybeFloat', inputInt', inputMaybeInt', inputUrl', inputMaybeUrl'
* radio' (TODO)
* checkbox' (TODO)
@docs button_, button', buttonLink_, buttonLink', buttonSubmit_, buttonSubmit', buttonReset_, buttonReset'
@docs select'
* datalist' (TODO)
* optgroup' (TODO)
@docs option_, option'
* textarea_ (TODO)
* textarea' (TODO)
* keygen_ (TODO)
* keygen' (TODO)
@docs output', progress', meter'

# Interactive elements (Unsupported)
The following elements are not currently well supported and do not have shorthands:

* [&lt;details&gt;, &lt;summary&gt;](http://caniuse.com/#feat=details)
* [&lt;menu&gt;, &lt;menuitem&gt;](http://caniuse.com/#feat=menu)

-}

import Html exposing (..)
import Html.Attributes as A
import Html.Attributes.Extra as A
import Html.Events exposing (..)
import Html.Events.Extra exposing (..)
import Signal
import String
import List
import Maybe
import Json.Decode as Json
--import Graphics.Input.Field
import Html.Shorthand.Type as T
import Html.Shorthand.Internal as Internal
import Html.Shorthand.Event exposing (..)
import Debug

{-| Id parameters will automatically be encoded via `encodeId`
-}
type alias IdString = T.IdString

{-| Class parameters will automatically be encoded via `encodeClass`
-}
type alias ClassString = T.ClassString

{-| Only valid urls should be passed to functions taking this parameter
-}
type alias UrlString = T.UrlString -- re-export

{-| The string passed to a function taking this parameter will be rendered as textual content via `text`.
-}
type alias TextString = T.TextString -- re-export

{-| Direction to output text
-}
type TextDirection = LeftToRight | RightToLeft | AutoDirection

--type alias Selection = Graphics.Input.Field.Selection  -- re-export

{-| Update configuration for a `form` element.

* *onSubmit* - a submit action was triggered
* *onEnter* - action to perform on enter key... see also [virtual-dom/pull/5#issuecomment-88444513](https://github.com/evancz/virtual-dom/pull/5#issuecomment-88444513)

See also [FormUpdate](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#FormUpdate)

-}
type alias FormUpdate = T.FormUpdate

{-| A field error is generated when an input fails to parse its input string during an attempt to produce the output value.
This gives the user an opportunity to specify a fallback behaviour or simply ignore the error, leaving the input in an intermediate state.

* *event* - json event that generated this error
* *reason* - error string describing the parse error

See also [EventDecodeError](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#EventDecodeError)

-}
type alias EventDecodeError a = T.EventDecodeError a

{-| Update configuration for `input` fields.

* *onInput* - continuously send messages on any input event (`onInput`)
* *onEnter* - a message to send whenever the enter key is hit
* *onKeyboardLost* - a message to send whenever the input field loses the keyboard cursor

In the future, if this can be made efficient, this may also support:

* *onMouseMove* - a message to send whenever the mouse moves while the input field has keyboard focus

See also [FieldUpdate](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#FieldUpdate)

-}
type alias FieldUpdate a = T.FieldUpdate a

{-| Update configuration for a `select` element.

* *onSelect* - the selected option has changed.

See also [SelectUpdate](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#SelectUpdate)

-}
type alias SelectUpdate a = T.SelectUpdate a

{-| Default field update handlers. Use this to select only one or two handlers.

    { fieldUpdate
    | onInput <- Just (\val -> Signal.send updates (MyEvent val))
    }

-}
fieldUpdate : FieldUpdate a
fieldUpdate =
  { onInput        = Nothing
  , onEnter        = Nothing
  , onKeyboardLost = Nothing
  }

{-| Good configuration for continuously updating fields that don't have any invalid states, or are restricted by a pattern.
-}
fieldUpdateContinuous : { onInput : a -> Signal.Message
                        }
                      -> FieldUpdate a
fieldUpdateContinuous handler =
  let doOk r =  case r of
                  Ok x  -> Just (handler.onInput x)
                  Err _ -> Nothing
  in  { fieldUpdate
      | onInput <- Just doOk
      }

{-| Use with fields that should consolidate their value when the focus moved.
-}
fieldUpdateFocusLost : { onInput : a -> Signal.Message
                       }
                      -> FieldUpdate a
fieldUpdateFocusLost handler =
  let doOk r =  case r of
                  Ok x  -> Just (handler.onInput x)
                  Err _ -> Nothing
  in  { fieldUpdate
      | onEnter <- Just doOk
      , onKeyboardLost <- Just doOk
      }

{-| Continuously update the field, handling invalid states only when the focus is lost.
The input element will try to consolidate the field with its value in all of these scenarios:

* During input event, if and only if the input parses correctly
* When the return key (ENTER) is hit; resets to the last known value if it couldn't parse
* When the keyboard cursor is moved to a different element; resets to the last known value if it couldn't parse

In the future, if this can be made efficient, it will also support:
* When the element has keyboard focus and the mouse cursor is moved ; resets to the last known value if it couldn't parse

This function takes an explicit fallback function that can usually be set to the previous value in order to have the field simply reset.

    inputField'
      { update = fieldUpdateFallbackFocusLost
                  { -- Reset the input to the current temperature
                    onFallback _ = Channel.send action <| SetTemperature currentTemperature
                  , -- Update the temperature if it parsed correctly
                    onInput v = Channel.send action <| SetTemperature v
                  }
      , ...
      }

Note that this configuration does not work well with `inputFloat'`/`inputMaybeFloat'` and `inputInt'`/`inputMaybeInt'` fields due to
the strange way that browsers treat numeric inputs. This update method can be used to implement custom field types however.

-}
fieldUpdateFallbackFocusLost  : { onFallback : String -> Signal.Message
                                , onInput    : a -> Signal.Message
                                }
                          -> FieldUpdate a
fieldUpdateFallbackFocusLost handler =
  let doOk r =  case r of
                  Ok x  -> Just (handler.onInput x)
                  Err _ -> Nothing
      doErr r = case r of
                  Ok _        -> Nothing
                  Err {event} ->
                    case Json.decodeValue targetValue event of
                      Ok s -> Just (handler.onFallback s)
                      Err s -> Nothing
  in  { onInput = Just doOk
      , onEnter = Just doErr
      , onKeyboardLost = Just doErr
      }

{-| Continuously update the field, handling invalid states on any input event.
Use this configuration to generate error notifications rapidly.

    inputField'
      { update = fieldUpdateFallbackContinuous
                  { -- Show an error notification (e.g. highlight the input field)
                    onFallback _ = Channel.send action InvalidTemperature
                  , -- Update the temperature if it parsed correctly
                    onInput v = Channel.send action <| SetTemperature v
                  }
      , ...
      }

Note that this configuration does not work well with `inputFloat'`/`inputMaybeFloat'` and `inputInt'`/`inputMaybeInt'` fields due to
the strange way that browsers treat numeric inputs. This update method can be used to implement custom field types however.

-}
fieldUpdateFallbackContinuous : { onFallback : String -> Signal.Message
                                , onInput    : a -> Signal.Message
                                }
                              -> FieldUpdate a
fieldUpdateFallbackContinuous handler =
  let doOkErr r = case r of
                    Ok x  -> Just (handler.onInput x)
                    Err {event} ->
                      case Json.decodeValue targetValue event of
                        Ok s -> Just (handler.onFallback s)
                        Err s -> Nothing
  in  { fieldUpdate
      | onInput <- Just doOkErr
      }

{-| See [ClassParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#ClassParam)
-}
type alias ClassParam = T.ClassParam

{-| See [ClassIdParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#ClassIdParam)
-}
type alias ClassIdParam = T.ClassIdParam

{-| See [ClassCiteParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#ClassCiteParam)
-}
type alias ClassCiteParam = T.ClassCiteParam

{-| See [AnchorParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#AnchorParam)
-}
type alias AnchorParam = T.AnchorParam

{-| See [ModParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#ModParam)
-}
type alias ModParam = T.ModParam

{-| See [ImgParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#ImgParam)
-}
type alias ImgParam = T.ImgParam

{-| See [IframeParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#IframeParam)
-}
type alias IframeParam = T.IframeParam

{-| See [EmbedParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#EmbedParam)
-}
type alias EmbedParam = T.EmbedParam

{-| See [ObjectParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#ObjectParam)
-}
type alias ObjectParam = T.ObjectParam

{-| See [MediaParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#MediaParam)
-}
type alias MediaParam = T.MediaParam

{-| See [VideoParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#VideoParam)
-}
type alias VideoParam = T.VideoParam

{-| See [AudioParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#AudioParam)
-}
type alias AudioParam = T.AudioParam

{-| See [FormParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#FormParam)
-}
type alias FormParam = T.FormParam

{-| See [FieldsetParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#FieldsetParam)
-}
type alias FieldsetParam = T.FieldsetParam

{-| See [LabelParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#LabelParam)
-}
type alias LabelParam = T.LabelParam

{-| See [InputFieldParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputFieldParam)
-}
type alias InputFieldParam a = T.InputFieldParam a

{-| See [InputTextParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputTextParam)
-}
type alias InputTextParam = T.InputTextParam

{-| See [InputMaybeTextParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputMaybeTextParam)
-}
type alias InputMaybeTextParam = T.InputMaybeTextParam

{-| See [InputFloatParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputFloatParam)
-}
type alias InputFloatParam = T.InputFloatParam

{-| See [InputMaybeFloatParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputMaybeFloatParam)
-}
type alias InputMaybeFloatParam = T.InputMaybeFloatParam

{-| See [InputIntParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputIntParam)
-}
type alias InputIntParam = T.InputIntParam

{-| See [InputMaybeIntParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputMaybeIntParam)
-}
type alias InputMaybeIntParam = T.InputMaybeIntParam

{-| See [InputUrlParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputUrlParam)
-}
type alias InputUrlParam = T.InputUrlParam

{-| See [InputMaybeUrlParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#InputMaybeUrlParam)
-}
type alias InputMaybeUrlParam = T.InputMaybeUrlParam

{-| See [ButtonParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#ButtonParam)
-}
type alias ButtonParam = T.ButtonParam

{-| See [SelectParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#SelectParam)
-}
type alias SelectParam = T.SelectParam

{-| See [OptionParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#OptionParam)
-}
type alias OptionParam = T.OptionParam

{-| See [OutputParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#OutputParam)
-}
type alias OutputParam = T.OutputParam

{-| See [ProgressParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#ProgressParam)
-}
type alias ProgressParam = T.ProgressParam

{-| See [MeterParam](http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest/Html-Shorthand-Type#MeterParam)
-}
type alias MeterParam = T.MeterParam

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
encodeId = Internal.encodeId

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
encodeClass = Internal.encodeClass

-- IDIOMATIC ATTRIBUTES

{-| Encoded id attribute. Uses `encodeId` to ensure that the id is nicely normalized.
-}
id' : IdString -> Attribute
id' = Internal.id'

{-| Encoded class attribute. Uses `encodeClass` to ensure that the classes are nicely normalized.
-}
class' : ClassString -> Attribute
class' = Internal.class'

-- SECTIONS

{-| [&lt;body&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/body) represents the content of an HTML document. There is only one `body`
element in a document.
-}
body_ : List Html -> Html
body_ = body []

body' : ClassParam -> List Html -> Html
body' p = body [class' p.class]

{-| [&lt;section&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/section) defines a section in a document. Use sections to construct a document outline.

**Do:**
* [use &lt;section&gt;s to define document outlines](http://html5doctor.com/outlines/)
* [...but use &lt;h*n*&gt;s carefully](http://www.paciellogroup.com/blog/2013/10/html5-document-outline/)

**Don't:**
* [use &lt;section&gt; as a wrapper for styling](http://html5doctor.com/avoiding-common-html5-mistakes/#section-wrapper)

-}
section_ : IdString -> List Html -> Html
section_ i = section [id' i]

section' : ClassIdParam -> List Html -> Html
section' p = section [class' p.class, id' p.id]

{-| [&lt;nav&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/nav) defines a section that contains only navigation links.

**Do:**
* [use &lt;nav&gt; for major navigation](http://html5doctor.com/avoiding-common-html5-mistakes/#nav-external)

**Don't:**
* [wrap all lists of links in &lt;nav&gt;](http://html5doctor.com/avoiding-common-html5-mistakes/#nav-external)

-}
nav_ : List Html -> Html
nav_ = nav []

nav' : ClassParam -> List Html -> Html
nav' p = nav [class' p.class]

{-| [&lt;article&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/article) defines self-contained content that could exist independently of the rest
of the content.

**Do:**
* [use &lt;article&gt; for self-contained components with informational content](http://html5doctor.com/the-article-element/)
* [use &lt;article&gt; for blog entries, user-submitted comments, interactive educational gadgets](http://html5doctor.com/the-article-element/)

**Don't:**
* [confuse &lt;article&gt; with &lt;section&gt; which need not be self-contained](http://www.brucelawson.co.uk/2010/html5-articles-and-sections-whats-the-difference/)

-}
article_ : IdString -> List Html -> Html
article_ i = article [id' i]

article' : ClassIdParam -> List Html -> Html
article' p = article [class' p.class, id' p.id]

{-| [&lt;aside&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/aside) defines some content loosely related to the page content. If it is removed,
the remaining content still makes sense.
-}
aside' : ClassIdParam -> List Html -> Html
aside' p = aside [class' p.class, id' p.id]

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
h1_ : TextString -> Html
h1_ t = h1 [] [text t]

h1' : ClassParam -> List Html -> Html
h1' p = h1 [class' p.class]

h2_ : TextString -> Html
h2_ t = h2 [] [text t]

h2' : ClassParam -> List Html -> Html
h2' p = h2 [class' p.class]

h3_ : TextString -> Html
h3_ t = h3 [] [text t]

h3' : ClassParam -> List Html -> Html
h3' p = h3 [class' p.class]

h4_ : TextString -> Html
h4_ t = h4 [] [text t]

h4' : ClassParam -> List Html -> Html
h4' p = h4 [class' p.class]

h5_ : TextString -> Html
h5_ t = h5 [] [text t]

h5' : ClassParam -> List Html -> Html
h5' p = h5 [class' p.class]

h6_ : TextString -> Html
h6_ t = h6 [] [text t]

h6' : ClassParam -> List Html -> Html
h6' p = h6 [class' p.class]

{-| [&lt;header&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/header) defines the header of a page or section. It often contains a logo, the
title of the web site, and a navigational table of content.

**Don't:**
* [overuse &lt;header&gt;](http://html5doctor.com/avoiding-common-html5-mistakes/#header-hgroup)

-}
header_ : List Html -> Html
header_ = header []

header' : ClassParam -> List Html -> Html
header' p = header [class' p.class]

{-| [&lt;footer&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/footer) defines the footer for a page or section. It often contains a copyright
notice, some links to legal information, or addresses to give feedback.
-}
footer_ : List Html -> Html
footer_ = footer []

footer' : ClassParam -> List Html -> Html
footer' p = footer [class' p.class]

{-| [&lt;address&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/address) defines a section containing contact information.

**Do:**
* [place inside the &lt;footer&gt; where appropriate](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/address#Summary)

**Don't:**
* [represent an arbitrary, unrelated address](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/address#Summary)

-}
address_ : List Html -> Html
address_ = address []

address' : ClassParam -> List Html -> Html
address' p = address [class' p.class]

{-| [&lt;main&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/main) defines the main or important content in the document. There is only one
`main` element in the document.

Note that main' is provided by [elm-html](http://package.elm-lang.org/packages/evancz/elm-html/latest/Html#main'), not by this package which only provides `main_`.

-}
main_ : List Html -> Html
main_ = main' []

-- GROUPING CONTENT

{-| [&lt;p&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/p) defines a portion that should be displayed as a paragraph of text.
-}
p_ : List Html -> Html
p_ = p []

p' : ClassParam -> List Html -> Html
p' param = p [class' param.class]

{-| [&lt;hr&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/hr) represents a thematic break between paragraphs of a section or article or
any longer content.

No other form is provided since hr should probably not have any classes or contents.

-}
hr_ : Html
hr_ = hr [] []

{-| [&lt;pre&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/pre) indicates that its content is preformatted and that this format must be
preserved.

**Do:**
* [use &lt;pre&gt; for blocks of whitespace sensitive text that must not wrap](http://stackoverflow.com/a/4611735)
* use &lt;pre&gt; as a wrapper for blocks &lt;`code_`&gt;
* use &lt;pre&gt; as a wrapper for blocks of &lt;`samp_`&gt; output from a computer program

-}
pre_ : List Html -> Html
pre_ = pre []

pre' : ClassParam -> List Html -> Html
pre' p = pre [class' p.class]

{-| [&lt;blockquote&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/blockquote) represents a content that is quoted from another source.

The idiomatic form uses a cite url, but an elision form is also provided.

**Don't:**
* use blockquote for short, inline quotations, we have &lt;`q'`&gt; for that

-}
blockquote_ : List Html -> Html
blockquote_ = blockquote []

blockquote' : ClassCiteParam -> List Html -> Html
blockquote' p = blockquote [class' p.class, A.cite p.cite]

{-| [&lt;ol&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ol) defines an ordered list of items.
-}
-- TODO: A template version of ol'' that simply takes a list of TextString?
ol_ : List Html -> Html
ol_ = ol []

ol' : ClassParam -> List Html -> Html
ol' p = ol [class' p.class]

{-| [&lt;ul&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ul) defines an unordered list of items.
-}
-- TODO: A template version of ul' that simply takes a list of TextString?
ul_ : List Html -> Html
ul_ = ul []

ul' : ClassParam -> List Html -> Html
ul' p = ul [class' p.class]

{-| [&lt;li&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/li) defines a item of an enumeration list.
-}
li_ : List Html -> Html
li_ = li []

li' : ClassParam -> List Html -> Html
li' p = li [class' p.class]

{-| [&lt;dl&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dl) defines a definition list, that is, a list of terms and their associated
definitions.
-}
-- TODO: A template version of dl'' that take <dt> and <dd> TextString directly?
dl_ : List Html -> Html
dl_ = dl []

dl' : ClassParam -> List Html -> Html
dl' p = dl [class' p.class]

{-| [&lt;dt&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dt) represents a term defined by the next `dd`.
-}
dt' : ClassIdParam -> List Html -> Html
dt' p = dt [class' p.class, id' p.id]

{-| [&lt;dd&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dd) represents the definition of the terms immediately listed before it.
-}
dd_ : List Html -> Html
dd_ = dd []

dd' : ClassParam -> List Html -> Html
dd' p = dd [class' p.class]

{-| [&lt;figure&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/figure) represents a figure illustrated as part of the document.

**Do:**
* [use figure for captioned content](http://html5doctor.com/the-figure-figcaption-elements/)
* [use figure for things other than images: video, audio, a chart, a table etc](http://html5doctor.com/the-figure-figcaption-elements/)

**Don't:**
* [turn every image into a figure](http://html5doctor.com/avoiding-common-html5-mistakes/#figure)

-}
figure' : ClassIdParam -> List Html -> Html
figure' p = figure [class' p.class, id' p.id]

{-| [&lt;figcaption&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/figcaption) represents the legend of a figure.
-}
figcaption_ : List Html -> Html
figcaption_ = figcaption []

figcaption' : ClassParam -> List Html -> Html
figcaption' p = figcaption [class' p.class]

{-| [&lt;div&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/div) represents a generic container with no special meaning.
-}
div_ : List Html -> Html
div_ = div []

div' : ClassParam -> List Html -> Html
div' p = div [class' p.class]


-- TEXT LEVEL SEMANTIC

{-| [&lt;a&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a) represents a hyperlink , linking to another resource.
-}

-- TODO: Possibly a download version https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a#attr-download
--       e.g. aDownload : FilenameString -> UrlString -> Html
-- TODO: A 'blank' version may also be very helpful. E.g.
--       <a href="http://elm-lang.org/" target="_blank">
--         <img src="http://elm-lang.org/logo.png" alt="Elm logo" />
--       </a>
-- TODO: Also see https://developer.mozilla.org/en-US/docs/Web/HTML/Link_types
-- TODO: etc...

a_ : UrlString -> TextString -> Html
a_ href t = a [A.href href] [text t]

a' : AnchorParam -> List Html -> Html
a' p = a [class' p.class, A.href p.href]

{-| [&lt;em&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/em) represents emphasized text, like a stress accent.
-}
em_ : TextString -> Html
em_ t = em [] [text t]

em' : ClassParam -> List Html -> Html
em' p = em [class' p.class]

{-| [&lt;strong&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/strong) represents especially important text.
-}
strong_ : TextString -> Html
strong_ t = em [] [text t]

strong' : ClassParam -> List Html -> Html
strong' p = strong [class' p.class]

{-| [&lt;small&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/small) represents a side comment , that is, text like a disclaimer or a
copyright, which is not essential to the comprehension of the document.

**Don't:**
  * [use small for pure styling](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/small#Summary)

**Do:**
  * [use small for side-comments and small print, including copyright and legal text](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/small#Summary)

-}
small_ : TextString -> Html
small_ t = small [] [text t]

small' : ClassParam -> List Html -> Html
small' p = small [class' p.class]

{-| [&lt;s&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/s) represents content that is no longer accurate or relevant.

**Don't:**
* [use &lt;s&gt; for indicating document edits, use &lt;del&gt; or &lt;ins&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/s#Summary)

-}
s_ : TextString -> Html
s_ t = s [] [text t]

s' : ClassParam -> List Html -> Html
s' p = s [class' p.class]

{-| [&lt;cite&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/cite) represents the title of a work.

**Do:**
* [consider using an anchor inside of the cite to link to the origin](http://html5doctor.com/cite-and-blockquote-reloaded/)

-}
cite_ : List Html -> Html
cite_ = cite []

cite' : ClassParam -> List Html -> Html
cite' p = cite [class' p.class]

{-| [&lt;q&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/q) represents an inline quotation.

The idiomatic form uses a cite url, but the elision is also provided.
-}
q_ : TextString -> Html
q_ t = q [] [text t]

q' : ClassCiteParam -> List Html -> Html
q' p = q [class' p.class, A.cite p.cite]

{-| [&lt;dfn&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dfn) represents a term whose definition is contained in its nearest ancestor
content.
-}
dfn' : ClassIdParam -> List Html -> Html
dfn' p = dfn [class' p.class, id' p.id]

{-| [&lt;abbr&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/abbr) represents an abbreviation or an acronym ; the expansion of the
abbreviation can be represented in the title attribute.
-}
abbr_ : TextString -> Html
abbr_ t = abbr [] [text t]

abbr' : ClassParam -> List Html -> Html
abbr' p = abbr [class' p.class]

{-| [&lt;time&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/time) represents a date and time value; the machine-readable equivalent can be
represented in the datetime attribute.
-}
-- TODO: String presentation doesn't appear to exist for Dates yet
--time_ : Date -> Html
--time_ d t = time [datetime d] [text t]

--time' : TimeParam -> Html
--time' p = time [class' c, datetime d] [text t]

{-| [&lt;code&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/code) represents computer code.
-}
code_ : List Html -> Html
code_ = code []

code' : ClassParam -> List Html -> Html
code' p = code [class' p.class]

{-| [&lt;var&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/var) represents a variable. Specific cases where it should be used include an
actual mathematical expression or programming context, an identifier
representing a constant, a symbol identifying a physical quantity, a function
parameter, or a mere placeholder in prose.
-}
var_ : TextString -> Html
var_ t = var [] [text t]

var' : ClassParam -> List Html -> Html
var' p = var [class' p.class]

{-| [&lt;samp&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/samp) represents the output of a program or a computer.
-}
samp_ : List Html -> Html
samp_ = samp []

samp' : ClassParam -> List Html -> Html
samp' p = samp [class' p.class]

{-| [&lt;kbd&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/kbd) represents user input, often from the keyboard, but not necessarily; it
may represent other input, like transcribed voice commands.

    instructions : Html
    instructions =
      p_
        [ text "Press "
        , kbd_
          [ kbd_ [ text "Ctrl" ]
          , text "+"
          , kbd_ [ text "S"]
          ]
        , text " to save this document."
        ]

-}
kbd_ : List Html -> Html
kbd_ = kbd []

kbd' : ClassParam -> List Html -> Html
kbd' p = kbd [class' p.class]

{-| [&lt;sub&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/sub) represent a subscript.
-}
sub_ : TextString -> Html
sub_ t = sub [] [text t]

sub' : ClassParam -> List Html -> Html
sub' p = sub [class' p.class]

{-| [&lt;sup&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/sup) represent a superscript.
-}
sup_ : TextString -> Html
sup_ t = sup [] [text t]

sup' : ClassParam -> List Html -> Html
sup' p = sup [class' p.class]

{-| [&lt;i&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/i) represents some text in an alternate voice or mood, or at least of
different quality, such as a taxonomic designation, a technical term, an
idiomatic phrase, a thought, or a ship name.
-}
i_ : TextString -> Html
i_ t = i [] [text t]

i' : ClassParam -> List Html -> Html
i' p = i [class' p.class]

{-| [&lt;b&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/b) represents a text which to which attention is drawn for utilitarian
purposes. It doesn't convey extra importance and doesn't imply an alternate voice.
-}
b_ : TextString -> Html
b_ t = b [] [text t]

b' : ClassParam -> List Html -> Html
b' p = b [class' p.class]

{-| [&lt;u&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/u) represents a non-textual annoatation for which the conventional
presentation is underlining, such labeling the text as being misspelt or
labeling a proper name in Chinese text.
-}
u_ : TextString -> Html
u_ t = u [] [text t]

u' : ClassParam -> List Html -> Html
u' p = u [class' p.class]

{-| [&lt;mark&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/mark) represents text highlighted for reference purposes, that is for its
relevance in another context.
-}
mark_ : List Html -> Html
mark_ = mark []

mark' : ClassParam -> List Html -> Html
mark' p = mark [class' p.class]

{-| [&lt;ruby&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ruby) represents content to be marked with ruby annotations, short runs of text
presented alongside the text. This is often used in conjunction with East Asian
language where the annotations act as a guide for pronunciation, like the
Japanese furigana.
-}
ruby_ : List Html -> Html
ruby_ = ruby []

ruby' : ClassParam -> List Html -> Html
ruby' p = ruby [class' p.class]

{-| [&lt;rt&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/rt) represents the text of a ruby annotation .
-}
rt_ : TextString -> Html
rt_ t = rt [] [text t]

rt' : ClassParam -> List Html -> Html
rt' p = rt [class' p.class]

{-| [&lt;rp&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/rp) represents parenthesis around a ruby annotation, used to display the
annotation in an alternate way by browsers not supporting the standard display
for annotations.
-}
rp_ : TextString -> Html
rp_ t = rp [] [text t]

rp' : ClassParam -> List Html -> Html
rp' p = rp [class' p.class]

{-| [&lt;bdi&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/bdi) represents text that must be isolated from its surrounding for
bidirectional text formatting. It allows embedding a span of text with a
different, or unknown, directionality.
-}
bdi_ : TextString -> Html
bdi_ t = bdi [] [text t]

bdi' : ClassParam -> List Html -> Html
bdi' p = bdi [class' p.class]

{-| [&lt;bdo&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/bdo) represents the directionality of its children, in order to explicitly
override the Unicode bidirectional algorithm.
-}
bdo' : TextDirection -> List Html -> Html
bdo' dir =
  bdo
    [ A.dir <| case dir of
        LeftToRight -> "ltr"
        RightToLeft -> "rtl"
        AutoDirection -> "auto"
    ]

{-| [&lt;span&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/span) represents text with no specific meaning. This has to be used when no other
text-semantic element conveys an adequate meaning, which, in this case, is
often brought by global attributes like class', lang, or dir.
-}
span_ : List Html -> Html
span_ = span []

span' : ClassParam -> List Html -> Html
span' p = span [class' p.class]

{-| [&lt;br&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/br) represents a line break.
-}
br' : Html
br' = br [] []

{-| [&lt;wbr&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/wbr) represents a line break opportunity , that is a suggested point for
wrapping text in order to improve readability of text split on several lines.
-}
wbr' : Html
wbr' = wbr [] []


-- EDITS

{-| [&lt;ins&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ins) defines an addition to the document.
-}
ins_ : List Html -> Html
ins_ = ins []

ins' : ModParam -> List Html -> Html
ins' p = ins [class' p.class, A.cite p.cite, A.datetime p.datetime]

{-| [&lt;del&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/del) defines a removal from the document.
-}
del_ : List Html -> Html
del_ = del []

del' : ModParam -> List Html -> Html
del' p = del [class' p.class, A.cite p.cite, A.datetime p.datetime]


-- EMBEDDED CONTENT

{-| [&lt;img&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/img) represents an image.
-}
img' : ImgParam -> Html
img' p = img [class' p.class, A.src p.src, A.width p.width, A.height p.height, A.alt p.alt] []

img_ : Int -> Int -> UrlString -> String -> Html
img_ w h s a = img [A.width w, A.height h, A.src s, A.alt a] []

{-| [&lt;iframe&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe) embedded an HTML document.
-}
iframe' : IframeParam -> Html
iframe' p =
  let i'     = encodeId p.name
      filter = List.filterMap identity
  in iframe
      (  [ class' p.class
          , A.id i'
          , A.name i'
          , A.src p.src
          , A.width p.width
          , A.height p.height
          , A.seamless p.seamless
          ]
      ++  filter
          [ Maybe.map A.sandbox p.sandbox
          ]
      )
      []

{-| [&lt;embed&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/embed) represents a integration point for an external, often non-HTML,
application or interactive content.
-}
embed' : EmbedParam -> Html
embed' p = embed [class' p.class, id' p.id, A.src p.src, A.type' p.type', A.width p.width, A.height p.height] []

{-| [&lt;object&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/object) represents an external resource , which is treated as an image, an HTML
sub-document, or an external resource to be processed by a plug-in.
-}
object' : ObjectParam -> List Html -> Html
object' p =
  let i' = encodeId p.name
      filter = List.filterMap identity
      attrs = filter
                [ Maybe.map (A.usemap << String.cons '#' << encodeId) p.useMapName
                ]
  in object
      <| [class' p.class, A.id i', A.name i', A.attribute "data" p.data, A.type' p.type']
      ++ attrs
      ++ [A.height p.height, A.width p.width]

{-| [&lt;param&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/param) defines parameters for use by plug-ins invoked by `object` elements.
-}
param' : String -> String -> Html
param' n v = param [A.name n, A.value v] []

{-| [&lt;video&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/video) represents a video, the associated audio and captions, and controls.

Doesn't allow for &lt;track&gt;s &lt;source&gt;s, please use `video` for that.
-}
video_ : UrlString -> Html
video_ url = video [A.src url] []

video' : VideoParam -> List Html -> Html
video' p =
  let filter = List.filterMap identity
  in video
      <|  [ class' p.class
          , A.width p.width
          , A.height p.height
          , A.autoplay p.autoplay
          , A.controls p.controls
          , A.loop p.loop
          -- , A.boolProperty "muted" p.muted
          ]
      ++ filter
          [ Maybe.map A.src p.src
          -- , Maybe.map (A.property "crossorigin") p.crossorigin
          , Maybe.map (A.stringProperty "preload") p.preload
          , Maybe.map A.poster p.poster
          , Maybe.map A.volume p.volume
          ]


{-| [&lt;audio&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/audio) represents a sound or audio stream.

Doesn't allow for &lt;track&gt;s &lt;source&gt;s, please use `audio` for that.
-}
audio_ : UrlString -> Html
audio_ url = audio [A.src url] []

audio' : AudioParam -> List Html -> Html
audio' p =
  let filter = List.filterMap identity
  in audio
      <|  [ class' p.class
          , A.autoplay p.autoplay
          , A.controls p.controls
          , A.loop p.loop
          -- , A.boolProperty "muted" p.muted
          ]
      ++ filter
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
--source' :  -> List Html -> Html
--source' = source []

--source' : ClassParam -> List Html -> Html
--source' p = source [class' p.class]

--{-| [&lt;track&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/track) allows authors to specify timed text track for media elements like `video`
--or `audio`.
---}
-- TODO
--track' :  -> List Html -> Html
--track' = track []

--track' : ClassParam -> List Html -> Html
--track' p = track [class' p.class]

{-| [&lt;canvas&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/canvas) represents a bitmap area for graphics rendering.

No defaults provided since you're probably best off using Elm's `Graphics`!
-}

{-- TODO: elm-html hasn't exposed these functions
--{-| In conjunction with `area`, defines an image map.
---}
map_ : List Html -> Html
map_ = map []

--{-| In conjunction with `map`, defines an image map.
---}
area_ : List Html -> Html
area_ = area []
--}

--{-| [&lt;svg&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/svg) defines an embedded vectorial image.
---}
-- TODO
--svg_ : List Html -> Html
--svg_ = svg []

--svg' : ClassParam -> List Html -> Html
--svg' p = svg [class' p.class]

--{-| [&lt;math&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/math) defines a mathematical formula.
---}
-- TODO
--math_ : List Html -> Html
--math_ = math []

--math' :  -> List Html -> Html
--math' = math []

--math' : ClassParam -> List Html -> Html
--math' p = math [class' p.class]


-- TABULAR DATA

{-| [&lt;table&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/table) represents data with more than one dimension.
-}
table_ : List Html -> Html
table_ = table []

table' : ClassParam -> List Html -> Html
table' p = table [class' p.class]

{-| [&lt;caption&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/caption) represents the title of a table.
-}
caption_ : List Html -> Html
caption_ = caption []

caption' : ClassParam -> List Html -> Html
caption' p = caption [class' p.class]

--{-| [&lt;colgroup&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/colgroup) represents a set of one or more columns of a table.
---}
-- TODO
--colgroup_ : List Html -> Html
--colgroup_ = colgroup []

--colgroup' : ClassParam -> List Html -> Html
--colgroup' p = colgroup [class' p.class]

--{-| [&lt;col&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/col) represents a column of a table.
---}
-- TODO
--col_ : List Html -> Html
--col_ = col []

--col' :  -> List Html -> Html
--col' = col []

--col' : ClassParam -> List Html -> Html
--col' p = col [class' p.class]

{-| [&lt;tbody&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/tbody) represents the block of rows that describes the concrete data of a table.
-}
tbody_ : List Html -> Html
tbody_ = tbody []

tbody' : ClassParam -> List Html -> Html
tbody' p = tbody [class' p.class]

{-| [&lt;thead&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/thead) represents the block of rows that describes the column labels of a table.
-}
thead_ : List Html -> Html
thead_ = thead []

thead' : ClassParam -> List Html -> Html
thead' p = thead [class' p.class]

{-| [&lt;tfoot&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/tfoot) represents the block of rows that describes the column summaries of a table.
-}
tfoot_ : List Html -> Html
tfoot_ = tfoot []

tfoot' : ClassParam -> List Html -> Html
tfoot' p = tfoot [class' p.class]

{-| [&lt;tr&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/tr) represents a row of cells in a table.
-}
tr_ : List Html -> Html
tr_ = tr []

tr' : ClassParam -> List Html -> Html
tr' p = tr [class' p.class]

{-| [&lt;td&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/td) represents a data cell in a table.
-}
td_ : List Html -> Html
td_ = td []

td' : ClassParam -> List Html -> Html
td' p = td [class' p.class]

{-| [&lt;th&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/th) represents a header cell in a table.
-}
th_ : List Html -> Html
th_ = th []

th' : ClassParam -> List Html -> Html
th' p = th [class' p.class]


-- FORMS

{-| [&lt;form&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/form) represents a form , consisting of controls, that can be submitted to a
server for processing.

In future `Nothing` may mask out the default submit on Enter key behaviour.
See [virtual-dom/pull/5#issuecomment-88444513](https://github.com/evancz/virtual-dom/pull/5#issuecomment-88444513) and [stackoverflow](http://stackoverflow.com/a/587575/167485).
-}
form' : FormParam -> List Html -> Html
form' p =
  let filter = List.filterMap identity
      onEnter' msg = on "keypress"
                      ( Json.customDecoder keyCode
                        <| \c ->
                            if c == 13
                              then Ok ()
                              else Err "expected key code 13"
                      )
                      (always msg)
  in  form
      <| class' p.class
      :: A.novalidate p.novalidate
      -- TODO: mask enter key when no handler is given
      -- See https://github.com/evancz/virtual-dom/pull/5#issuecomment-88444513
      -- and http://stackoverflow.com/a/587575/167485
      -- :: Maybe.withDefault maskEnter (Maybe.map onEnter' p.update.onEnter)
      :: filter
          [ Maybe.map (on "submit" Json.value << always) p.update.onSubmit
          , Maybe.map onEnter' p.update.onSubmit
          ]

{-| [&lt;fieldset&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/fieldset) represents a set of controls.
-}
fieldset_ : Bool -> List Html -> Html
fieldset_ disabled = fieldset [A.disabled disabled]

fieldset' : FieldsetParam -> List Html -> Html
fieldset' p = fieldset [class' p.class, A.disabled p.disabled]

{-| [&lt;legend&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/legend) represents the caption for a `fieldset`.
-}
legend_ : TextString -> Html
legend_ t = legend [] [text t]

legend' : ClassParam -> List Html -> Html
legend' p = legend [class' p.class]

{-| [&lt;label&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/label) represents the caption of a form control.
-}
label_ : IdString -> TextString -> Html
label_ for t = label [A.for for] [text t]

label' : LabelParam -> List Html -> Html
label' p = label
  [ class' p.class
  , A.for p.for
  ]

{-| [&lt;input&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input) represents a typed data field allowing the user to edit the data.

In order to disable an input field, use `fieldset_ False`.
-}
inputField' : InputFieldParam a -> List Attribute -> Html
inputField' p attrs =
  let filter = List.filterMap identity
      i' = encodeId p.name
      pattrs =
        [ A.type' p.type'
        , A.id i'
        , A.name i'
        , A.required p.required
        ]
        ++ filter
            [ Maybe.map class' (if p.class == "" then Nothing else Just p.class)
            , Maybe.map (\onEvent -> onInput        (messageDecoder p.decoder onEvent) identity) p.update.onInput
            , Maybe.map (\onEvent -> onEnter        (messageDecoder p.decoder onEvent) identity) p.update.onEnter
            , Maybe.map (\onEvent -> onKeyboardLost (messageDecoder p.decoder onEvent) identity) p.update.onKeyboardLost
            , Maybe.map A.placeholder p.placeholder
            , Maybe.map A.pattern p.pattern
            ]
  in input (pattrs ++ attrs) []

inputText' : InputTextParam -> Html
inputText' p =
  inputField'
    { class       = p.class
    , name        = p.name
    , placeholder = p.placeholder
    , update      = p.update
    , type'       = "text"
    , pattern     = Nothing
    , required    = p.required
    , decoder     = targetValue
    }
    [ A.value p.value
    , A.autocomplete p.autocomplete
    ]

inputMaybeText' : InputMaybeTextParam -> Html
inputMaybeText' p =
  inputField'
    { class       = p.class
    , name        = p.name
    , placeholder = p.placeholder
    , update      = p.update
    , type'       = "text"
    , pattern     = Nothing
    , required    = False
    , decoder     = targetValueMaybe
    }
    [ A.value (Maybe.withDefault "" p.value)
    , A.autocomplete p.autocomplete
    ]

inputFloat' : InputFloatParam -> Html
inputFloat' p =
  let filter       = List.filterMap identity
      --allowedChars =  '.'
      --                :: case p.min of
      --                      Nothing -> ['-']
      --                      Just x  -> if x >= 0 then [] else ['-']
  in inputField'
      { class       = p.class
      , name        = p.name
      , placeholder = p.placeholder
      , update      = p.update
      , type'       = "number"
      , pattern     = Nothing
      , required    = True
      , decoder     =
          case (p.min, p.max) of
            (Nothing, Nothing) -> targetValueFloat
            _                  ->
              Json.customDecoder targetValueFloat <| \v ->
                if v < Maybe.withDefault (-1/0) p.min || v > Maybe.withDefault (1/0) p.max
                then Err "out of bounds"
                else Ok v
      }
      <| A.valueAsFloat p.value
      --:: filterOnKeyPressChar (\c -> if (c >= '0' && c <= '9') || c `List.member` allowedChars then Just tmpMsg else Nothing)
      :: A.stringProperty "step" (Maybe.withDefault "any" <| Maybe.map toString p.step)
      :: filter
          [ Maybe.map (A.min << toString) p.min
          , Maybe.map (A.max << toString) p.max
          ]

inputMaybeFloat' : InputMaybeFloatParam -> Html
inputMaybeFloat' p =
  let filter = List.filterMap identity
  in inputField'
      { class       = p.class
      , name        = p.name
      , placeholder = p.placeholder
      , update      = p.update
      , type'       = "number"
      , pattern     = Nothing
      , required    = False
      , decoder     =
          case (p.min, p.max) of
            (Nothing, Nothing) -> targetValueMaybeFloat
            _                  ->
              Json.customDecoder targetValueMaybeFloat <| \mv ->
                case mv of
                  Nothing -> Ok Nothing
                  Just v -> if v < Maybe.withDefault (-1/0) p.min || v > Maybe.withDefault (1/0) p.max
                            then Err "out of bounds"
                            else Ok mv
      }
      <|  ( case p.value of
              Nothing -> A.value ""
              Just v  -> A.valueAsFloat v
          )
      :: A.stringProperty "step" (Maybe.withDefault "any" <| Maybe.map toString p.step)
      :: filter
          [ Maybe.map (A.min << toString) p.min
          , Maybe.map (A.max << toString) p.max
          ]

inputInt' : InputIntParam -> Html
inputInt' p =
  let filter = List.filterMap identity
  in inputField'
      { class       = p.class
      , name        = p.name
      , placeholder = p.placeholder
      , update      = p.update
      , type'       = "number"
      , pattern     = Nothing
      , required    = True
      , decoder     =
          case (p.min, p.max) of
            (Nothing, Nothing) -> targetValueInt
            _                  ->
              Json.customDecoder targetValueInt <| \v ->
                if v < Maybe.withDefault (floor <| -1/0) p.min || v > Maybe.withDefault (ceiling <| 1/0) p.max
                then Err "out of bounds"
                else Ok v
      }
      <| A.valueAsInt p.value
      :: filter
          [ Maybe.map (A.min << toString) p.min
          , Maybe.map (A.max << toString) p.max
          , Maybe.map (A.stringProperty "step" << toString) p.step
          ]

inputMaybeInt' : InputMaybeIntParam -> Html
inputMaybeInt' p =
  let filter = List.filterMap identity
  in inputField'
      { class       = p.class
      , name        = p.name
      , placeholder = p.placeholder
      , update      = p.update
      , type'       = "number"
      , pattern     = Nothing
      , required    = False
      , decoder     =
          case (p.min, p.max) of
            (Nothing, Nothing) -> targetValueMaybeInt
            _                  ->
              Json.customDecoder targetValueMaybeInt <| \mv ->
                case mv of
                  Nothing -> Ok Nothing
                  Just v -> if v < Maybe.withDefault (floor <| -1/0) p.min || v > Maybe.withDefault (ceiling <| 1/0) p.max
                            then Err "out of bounds"
                            else Ok mv
      }
      <|  ( case p.value of
              Nothing -> A.value ""
              Just v  -> A.valueAsInt v
          )
      :: filter
          [ Maybe.map (A.min << toString) p.min
          , Maybe.map (A.max << toString) p.max
          , Maybe.map (A.stringProperty "step" << toString) p.step
          ]

inputUrl' : InputUrlParam -> Html
inputUrl' p =
  inputField'
    { class       = p.class
    , name        = p.name
    , placeholder = p.placeholder
    , update      = p.update
    , type'       = "url"
    , pattern     = Nothing
    , required    = p.required
    , decoder     = targetValue
    }
    [ A.value p.value
    , A.autocomplete p.autocomplete
    ]

inputMaybeUrl' : InputMaybeUrlParam -> Html
inputMaybeUrl' p =
  inputField'
    { class       = p.class
    , name        = p.name
    , placeholder = p.placeholder
    , update      = p.update
    , type'       = "url"
    , pattern     = Nothing
    , required    = False
    , decoder     = targetValueMaybe
    }
    [ A.value (Maybe.withDefault "" p.value)
    , A.autocomplete p.autocomplete
    ]

{-| [&lt;button&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button) represents a button.
-}
button_ : TextString -> Signal.Address a -> a -> Html
button_ t clickAddr click = button [A.type' "button", onClick clickAddr click] [text t]

button' : ButtonParam -> List Html -> Html
button' p =
  button
  [ class' p.class
  , A.type' "button"
  , on "click" Json.value (always p.update.onClick)
  ]

-- This is technically an anchor, but behaves more like a button
buttonLink_ : TextString -> Signal.Address a -> a -> Html
buttonLink_ t clickAddr click = button [A.type' "button", onClick clickAddr click] [text t]

buttonLink' : ButtonParam -> List Html -> Html
buttonLink' p =
  a
  [ class' p.class
  , A.href "#"
  , on "click" Json.value (always p.update.onClick)
  ]

buttonSubmit_ : TextString -> Html
buttonSubmit_ t = button [A.type' "submit"] [text t]

buttonSubmit' : ClassParam -> List Html -> Html
buttonSubmit' p =
  button
  [ class' p.class
  , A.type' "submit"
  ]

buttonReset_ : TextString -> Html
buttonReset_ t = button [A.type' "reset"] [text t]

buttonReset' : ClassParam -> List Html -> Html
buttonReset' p = button
  [ class' p.class
  , A.type' "reset"
  ]

{-| [&lt;select&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/select) represents a control allowing selection among a set of options.
-}
select' : SelectParam -> List Html -> Html
select' p =
  let i' = encodeId p.name
  in select
      [ class' p.class
      , A.id i'
      , A.name i'
      , onChange targetValue p.update.onSelect
      -- , on "click" targetValue p.update.onSelect
      -- , on "keypress" targetValue p.update.onSelect
      ]

--{-| [&lt;datalist&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/datalist) represents a set of predefined options for other controls.
---}
-- TODO
--datalist_ : List Html -> Html
--datalist_ = datalist []

--datalist' :  -> List Html -> Html
--datalist' = datalist []

--datalist' : ClassParam -> List Html -> Html
--datalist' p = datalist [class' p.class]

--{-| [&lt;optgroup&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/optgroup) represents a set of options , logically grouped.
---}
-- TODO
--optgroup_ : List Html -> Html
--optgroup_ = optgroup []

--optgroup' :  -> List Html -> Html
--optgroup' = optgroup []

--optgroup' : ClassParam -> List Html -> Html
--optgroup' p = optgroup [class' p.class]

{-| [&lt;option&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/option) represents an option in a `select` element or a suggestion of a `datalist` element.
-}
option_ : TextString -> Bool -> Html
option_ val sel = option [ A.selected sel ] [ text val ]

option' : OptionParam -> Html
option' p = option [ A.stringProperty "label" p.label, A.value (toString p.value), A.selected p.selected ] []

--{-| [&lt;textarea&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea) represents a multiline text edit control.
---}
-- TODO
--textarea_ : List Html -> Html
--textarea_ = textarea []

--textarea' : ClassParam -> List Html -> Html
--textarea' p = textarea [class' p.class]

--{-| [&lt;keygen&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/keygen) represents a key-pair generator control.
---}
-- TODO
--keygen_ : List Html -> Htm
--keygen_ = keygen []

--keygen' : ClassParam -> List Html -> Html
--keygen' p = keygen [class' p.class]

{-| [&lt;output&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/output) represents the result of a calculation.
-}
output' : OutputParam -> List Html -> Html
output' p =
  let i' = encodeId p.name
  in output [class' p.class, A.id i', A.name i', A.for (String.join " " <| List.map encodeId p.for)]

{-| [&lt;progress&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/progress) represents the completion progress of a task.
-}
progress' : ProgressParam -> String -> Html
progress' p t = progress [A.value (toString p.value), A.max (toString p.max)] [text t]

{-| [&lt;meter&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/meter) represents a scalar measurement (or a fractional value), within a known range.
-}
meter' : MeterParam -> String -> Html
meter' p t =
  let filter = List.filterMap identity
  in meter
      (   [ A.value (toString p.value)
          , A.min (toString min)
          , A.max (toString p.max)
          ]
      ++ filter
          [ Maybe.map (A.low << toString) p.low
          , Maybe.map (A.high << toString) p.high
          , Maybe.map (A.optimum << toString) p.optimum
          ]
      )
      [text t]

-- INTERACTIVE ELEMENTS

--{-| [&lt;details&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/details) represents a widget from which the user can obtain additional information or controls.
--
-- Warning: Details & summary is not widely supported at this time. http://caniuse.com/#feat=details
--
---}
-- TODO
--details_ : List Html -> Html
--details_ = details []

--details' :  -> List Html -> Html
--details' = details []

--{-| [&lt;summary&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/summary) represents a summary , caption , or legend for a given `details`.
--
-- Warning: Details & summary is not widely supported at this time. http://caniuse.com/#feat=details
--
---}
-- TODO
--summary_ : List Html -> Html
--summary_ = summary []

--summary' :  -> List Html -> Html
--summary' = summary []

--{-| [&lt;menuitem&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/menuitem) represents a command that the user can invoke.
--
-- Warning: Menu is not widely supported at this time. http://caniuse.com/#feat=menu
--
---}
-- TODO
--menuitem_ : List Html -> Html
--menuitem_ = menuitem []

--menuitem' :  -> List Html -> Html
--menuitem' = menuitem []

--{-| [&lt;menu&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/menu) represents a list of commands.
--
-- Warning: Menu is not widely supported at this time. http://caniuse.com/#feat=menu
--
---}
-- TODO
--menu_ : List Html -> Html
--menu_ = menu []

--menu' :  -> List Html -> Html
--menu' = menu []

--menu' : ClassParam -> List Html -> Html
--menu' p = menu [class' p.class]
