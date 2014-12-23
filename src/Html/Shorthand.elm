module Html.Shorthand where
{-| Shorthands for common Html elements

# Conventions
The following conventions are used for shorthands. One example is provided for each.

## Single argument form
The attributes argument of the node is elided, with only the list of children remaining.
For certain elements where a canonical form is highly desirable, these functions have been left
off in order to encourage more uniform use. For example, an `img` tag will almost certainly benefit
from `src` and `alt` attributes. Some structural elements such as `section`, `aside`, `article`
and `figure` should quite likely list an `id` in order to help users target interesting portions of
your website via a URL. Other elements, such as `hr` are not included in this list simply because it
does not make sense to provide them with *any* child elements. In this case the canonical form is
also appropriate.

@docs div_

## Canonical form

This form attempts to take a common sense list of arguments. This is a limited form which
will not satisfy every need, but takes care of the extremely common cases. Many of the elements
excluded from single argument form is included here in a special form.

@docs img'

Note that `main'` is provided by elm-html, not by this package which only provides `main_`.

## Classy form

Another very common case is creating elements for mostly aesthetic reasons.
For this it is frequently convenient to specify only a `class` attribute and not much else.
These 'c'-postfixed shorthands are similar to the canonical form, but also take a class string
(a space separated list of CSS classes).

@docs divc

-}

import Html (..)
import Html.Attributes as A
import String
import Char
import List

type alias IdString = String
type alias ClassString = String
type alias UrlString = String
type alias TextString = String

-- ENCODERS

{-| A simplistic way of encoding `id` attributes into a [sane format](http://stackoverflow.com/a/72577).
This is used internally by all of the shorthands that take an `IdString`.

* Everything is turned into lowercase
* Only alpha-numeric characters (a-z,A-Z,0-9), hyphens (-) and underscores (_) are passed through the filter.
* If the first characters not a letter, 'x' will be prepended.
* Empty strings are allowed

-}
encodeId : IdString -> IdString
encodeId =
  let isAlpha c = let cc = Char.toCode <| Char.toLower c 
                  in cc >= Char.toCode 'a' && cc <= Char.toCode 'z'
      -- Note that : and . are also allowed in HTML 4, but since these need to be escaped in selectors we exclude them
      -- HTML 5 includes many more characters, but we'll exclude these for now
      isIdChar c = Char.isDigit c 
                    || isAlpha c
                    || (c `List.member` String.toList "-_")
      startWithAlpha s = case String.uncons s of
                          Just (c, s') -> if not (isAlpha c) then 'x' `String.cons` s else s
                          Nothing      -> s
  in  String.words
      >> String.join "-"
      -- TODO: trim '-' around the id?
      >> String.toLower
      >> String.filter isIdChar
      >> startWithAlpha
          

{-| A simplistic way of encoding of `class` attributes into a [sane format](http://stackoverflow.com/a/72577).
This is used internally by all of the shorthands that take a `ClassString`.

* Everything is turned into lowercase
* Only alpha-numeric characters (a-z,A-Z,0-9), hyphens (-) and underscores (_) are passed through the filter.
* If the first characters not a letter, 'x' will be prepended.
* Empty strings are allowed

-}
encodeClass : ClassString -> ClassString
encodeClass =
  let isAlpha c = let cc = Char.toCode <| Char.toLower c
                  in cc >= Char.toCode 'a' && cc <= Char.toCode 'z'
      -- Note that : and . are also allowed in HTML 4, but since these need to be escaped in selectors we exclude them
      -- HTML 5 includes many more characters, but we'll exclude these for now
      isClassChar c = Char.isDigit c 
                      || isAlpha c
                      || (c `List.member` String.toList "-_")
      startWithAlpha s = case String.uncons s of
                          Just (c, s') -> if not (isAlpha c) then 'x' `String.cons` s else s
                          Nothing      -> s
  in  String.words
      >> String.join " "
      >> String.toLower
      >> String.filter isClassChar
      >> startWithAlpha

-- CANONICAL ATTRIBUTES

id' : IdString -> Attribute
id' = A.id << encodeId

class' : ClassString -> Attribute
class' = A.class << encodeClass

-- SECTIONS

{-| [&lt;body&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/body) represents the content of an HTML document. There is only one `body`
element in a document.
-}
body_ : List Html -> Html
body_ = body []

bodyc : ClassString -> List Html -> Html
bodyc c = body [class' c]

{-| [&lt;section&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/section) defines a section in a document. Use sections to construct a document outline.

Do:
* [use &lt;section&gt;s to define document outlines](http://html5doctor.com/outlines/)
* [...but use headings carefully](http://www.paciellogroup.com/blog/2013/10/html5-document-outline/)

Don't:
* [use section as a wrapper for styling](http://html5doctor.com/avoiding-common-html5-mistakes/#section-wrapper)

-}
section' : IdString -> List Html -> Html
section' i = section [id' i]

sectionc : ClassString -> IdString -> List Html -> Html
sectionc c i = section [class' c, id' i]

{-| [&lt;nav&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/nav) defines a section that contains only navigation links.

Do:
* [use nav for major navigation](http://html5doctor.com/avoiding-common-html5-mistakes/#nav-external)

Don't:
* [wrap all lists of links in &lt;nav&gt;](http://html5doctor.com/avoiding-common-html5-mistakes/#nav-external)

-}
nav_ : List Html -> Html
nav_ = nav []

navc : ClassString -> List Html -> Html
navc c = nav [class' c]

{-| [&lt;article&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/article) defines self-contained content that could exist independently of the rest
of the content.

Do:
* [use &lt;article&gt; for self-contained components with informational content](http://html5doctor.com/the-article-element/)
* [use &lt;article&gt; for blog entries, user-submitted comments, interactive educational gadgets](http://html5doctor.com/the-article-element/)

Don't:
* [confuse &lt;article&gt; with &lt;section&gt; which need not be self-contained](http://www.brucelawson.co.uk/2010/html5-articles-and-sections-whats-the-difference/)

-}
article' : IdString -> List Html -> Html
article' i = article [id' i]

articlec : ClassString -> IdString -> List Html -> Html
articlec c i = article [class' c, id' i]

{-| [&lt;aside&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/aside) defines some content loosely related to the page content. If it is removed,
the remaining content still makes sense.
-}
aside' : IdString -> List Html -> Html
aside' i = aside [id' i]

asidec : ClassString -> IdString -> List Html -> Html
asidec c i = aside [class' c, id' i]

{-| [&lt;h*&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Heading_Elements) provide titles for sections and subsections, describing the topic it introduces.

Do:
* [use headings to define a document outline](http://www.paciellogroup.com/blog/2013/10/html5-document-outline/)
* [try to have only one first level heading on a page](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Heading_Elements)
* [introduce &lt;section&gt;s with headings](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Heading_Elements)

Don't:
* [skip heading levels if you can help it](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Heading_Elements)
* [style headings using html5 &lt;section&gt;s](http://www.stubbornella.org/content/2011/09/06/style-headings-using-html5-sections/)

-}
h1' : TextString -> Html
h1' t = h1 [] [text t]

h1c : ClassString -> TextString -> Html
h1c c t = h1 [class' c] [text t]

h2' : TextString -> Html
h2' t = h2 [] [text t]

h2c : ClassString -> TextString -> Html
h2c c t = h2 [class' c] [text t]

h3' : TextString -> Html
h3' t = h3 [] [text t]

h3c : ClassString -> TextString -> Html
h3c c t = h3 [class' c] [text t]

h4' : TextString -> Html
h4' t = h4 [] [text t]

h4c : ClassString -> TextString -> Html
h4c c t = h4 [class' c] [text t]

h5' : TextString -> Html
h5' t = h5 [] [text t]

h5c : ClassString -> TextString -> Html
h5c c t = h5 [class' c] [text t]

h6' : TextString -> Html
h6' t = h6 [] [text t]

h6c : ClassString -> TextString -> Html
h6c c t = h6 [class' c] [text t]

{-| [&lt;header&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/header) defines the header of a page or section. It often contains a logo, the
title of the web site, and a navigational table of content.

Don't:
* [overuse &lt;header&gt;](http://html5doctor.com/avoiding-common-html5-mistakes/#header-hgroup)

-}
header_ : List Html -> Html
header_ = header []

headerc : ClassString -> List Html -> Html
headerc c = header [class' c]

{-| [&lt;footer&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/footer) defines the footer for a page or section. It often contains a copyright
notice, some links to legal information, or addresses to give feedback.
-}
footer_ : List Html -> Html
footer_ = footer []

footerc : ClassString -> List Html -> Html
footerc c = footer [class' c]

{-| [&lt;address&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/address) defines a section containing contact information.

Do:
* [place inside the &lt;footer&gt; where appropriate](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/address#Summary)

Don't:
* [represent an arbitrary, unrelated address](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/address#Summary)

-}
address_ : List Html -> Html
address_ = address []

addressc : ClassString -> List Html -> Html
addressc c = address [class' c]

{-| [&lt;main&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/main) defines the main or important content in the document. There is only one
`main` element in the document.
-}
main_ : List Html -> Html
main_ = main' []

mainc : ClassString -> List Html -> Html
mainc c = main' [class' c]

-- GROUPING CONTENT

{-| [&lt;p&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/p) defines a portion that should be displayed as a paragraph of text.
-}
p_ : List Html -> Html
p_ = p []

p' : TextString -> Html
p' t = p [] [text t]

pc : ClassString -> TextString -> Html
pc c t = p [class' c] [text t]

{-| [&lt;hr&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/hr) represents a thematic break between paragraphs of a section or article or
any longer content.

No class'y form is provided to prevent abuse.
-}
hr' : Html
hr' = hr [] []

{-| [&lt;pre&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/pre) indicates that its content is preformatted and that this format must be
preserved.

Do:
* [use &lt;pre&gt; for blocks of whitespace sensitive text that must not wrap](http://stackoverflow.com/a/4611735)
* use &lt;pre&gt; as a wrapper for blocks &lt;`code_`&gt;
* use &lt;pre&gt; as a wrapper for blocks of &lt;`samp_`&gt; output from a computer program

-}
pre_ : List Html -> Html
pre_ = pre []

prec : ClassString -> List Html -> Html
prec c = pre [class' c]

{-| [&lt;blockquote&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/blockquote) represents a content that is quoted from another source.

The canonical form uses a cite url, but a single argument form is also provided

Don't:
* use blockquote for short, inline quotations, we have &lt;`q'`&gt; for that

-}
blockquote_ : List Html -> Html
blockquote_ = blockquote []

blockquote' : UrlString -> List Html -> Html
blockquote' url = blockquote [A.cite url]

blockquotec : ClassString -> UrlString -> List Html -> Html
blockquotec c url = blockquote [class' c, A.cite url]

{-| [&lt;ol&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ol) defines an ordered list of items.
-}
-- TODO: A template version of ol'' that simply takes a list of TextString?
ol_ : List Html -> Html
ol_ = ol []

olc : ClassString -> List Html -> Html
olc c = ol [class' c]

{-| [&lt;ul&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ul) defines an unordered list of items.
-}
-- TODO: A template version of ul'' that simply takes a list of TextString?
ul_ : List Html -> Html
ul_ = ul []

ulc : ClassString -> List Html -> Html
ulc c = ul [class' c]

{-| [&lt;li&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/li) defines a item of an enumeration list.
-}
li_ : List Html -> Html
li_ = li []

li' : TextString -> Html
li' t = li [] [text t]

lic : ClassString -> TextString -> Html
lic c t = li [class' c] [text t]

{-| [&lt;dl&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dl) defines a definition list, that is, a list of terms and their associated
definitions.
-}
-- TODO: A template version of dl'' that take <dt> and <dd> TextString directly?
dl_ : List Html -> Html
dl_ = dl []

dlc : ClassString -> List Html -> Html
dlc c = dl [class' c]

{-| [&lt;dt&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dt) represents a term defined by the next `dd`.
-}
dt' : IdString -> TextString -> Html
dt' i t = dt [id' i] [text t]

dtc : ClassString -> IdString -> TextString -> Html
dtc c i t = dt [class' c, id' i] [text t]

{-| [&lt;dd&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dd) represents the definition of the terms immediately listed before it.
-}
dd' : TextString -> Html
dd' t = dd [] [text t]

ddc : ClassString -> TextString -> Html
ddc c t = dd [class' c] [text t]

{-| [&lt;figure&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/figure) represents a figure illustrated as part of the document.

Do:
* [use figure for captioned content](http://html5doctor.com/the-figure-figcaption-elements/)
* [use figure for things other than images: video, audio, a chart, a table etc](http://html5doctor.com/the-figure-figcaption-elements/)

Don't:
* [turn every image into a figure](http://html5doctor.com/avoiding-common-html5-mistakes/#figure)

-}
figure' : IdString -> List Html -> Html
figure' i = figure [id' i]

figurec : ClassString -> IdString -> List Html -> Html
figurec c i = figure [class' c, id' i]

{-| [&lt;figcaption&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/figcaption) represents the legend of a figure.
-}
figcaption_ : List Html -> Html
figcaption_ = figcaption []

figcaption' : TextString -> Html
figcaption' t = figcaption [] [text t]

figcaptionc : ClassString -> TextString -> Html
figcaptionc c t = figcaption [class' c] [text t]

{-| [&lt;div&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/div) represents a generic container with no special meaning.
-}
div_ : List Html -> Html
div_ = div []

divc : ClassString -> List Html -> Html
divc c = div [class' c]


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

a' : UrlString -> String -> TextString -> Html
a' url alt t = a [A.href url, A.alt alt] [text t]

ac : ClassString -> UrlString -> String -> TextString -> Html
ac c url alt t = a [class' c, A.href url, A.alt alt] [text t]

{-| [&lt;em&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/em) represents emphasized text, like a stress accent.
-}
em_ : List Html -> Html
em_ = em []

em' : TextString -> Html
em' t = em [] [text t]

emc : ClassString -> TextString -> Html
emc c t = em [class' c] [text t]

{-| [&lt;strong&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/strong) represents especially important text.
-}
strong_ : List Html -> Html
strong_ = strong []

strong' : TextString -> Html
strong' t = em [] [text t]

strongc : ClassString -> TextString -> Html
strongc c t = strong [class' c] [text t]

{-| [&lt;small&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/small) represents a side comment , that is, text like a disclaimer or a
copyright, which is not essential to the comprehension of the document.

Don't:
  * [use small for pure styling](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/small#Summary)

Do:
  * [use small for side-comments and small print, including copyright and legal text](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/small#Summary)

-}
small_ : List Html -> Html
small_ = small []

small' : TextString -> Html
small' t = small [] [text t]

smallc : ClassString -> TextString -> Html
smallc c t = small [class' c] [text t]

{-| [&lt;s&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/s) represents content that is no longer accurate or relevant.

Don't:
* [use &lt;s&gt; for indicating document edits, use &lt;del&gt; or &lt;ins&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/s#Summary)

-}
s_ : List Html -> Html
s_ = s []

s' : TextString -> Html
s' t = s [] [text t]

sc : ClassString -> TextString -> Html
sc c t = s [class' c] [text t]

{-| [&lt;cite&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/cite) represents the title of a work.

Do:
* [consider using an anchor inside of the cite to link to the origin](http://html5doctor.com/cite-and-blockquote-reloaded/)

-}
cite_ : List Html -> Html
cite_ = cite []

citec : ClassString -> List Html -> Html
citec c = cite [class' c]

{-| [&lt;q&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/q) represents an inline quotation.

The canonical form uses a cite url, but the single argument is also provided.
-}
q_ : List Html -> Html
q_ = q []

q' : UrlString -> TextString -> Html
q' url t = q [A.cite url] [text t]

qc : ClassString -> UrlString -> TextString -> Html
qc c url t = q [class' c, A.cite url] [text t]

{-| [&lt;dfn&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dfn) represents a term whose definition is contained in its nearest ancestor
content.
-}
dfn' : IdString -> List Html -> Html
dfn' i = dfn [id' i]

dfnc : ClassString -> IdString -> List Html -> Html
dfnc c i = dfn [class' c, id' i]

{-| [&lt;abbr&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/abbr) represents an abbreviation or an acronym ; the expansion of the
abbreviation can be represented in the title attribute.
-}
abbr' : TextString -> Html
abbr' t = abbr [] [text t]

abbrc : ClassString -> TextString -> Html
abbrc c t = abbr [class' c] [text t]

{-| [&lt;time&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/time) represents a date and time value; the machine-readable equivalent can be
represented in the datetime attribute.
-}
-- TODO: String presentation doesn't appear to exist for Dates yet
time_ : List Html -> Html
time_ = time []

--time' : Date -> TextString -> Html
--time' d t = time [datetime d] [text t]

--timec : ClassString -> Date -> TextString -> Html
--timec c t = time [class' c, datetime d] [text t]

{-| [&lt;code&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/code) represents computer code.

`code` or `code_` can be used for code that includes color highlighting.
`code'` and `codec` can be used for simple unhighlighted code fragments.
-}
code_ : List Html -> Html
code_ = code []

code' : TextString -> Html
code' t = code [] [text t]

codec : ClassString -> TextString -> Html
codec c t = code [class' c] [text t]

{-| [&lt;var&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/var) represents a variable. Specific cases where it should be used include an
actual mathematical expression or programming context, an identifier
representing a constant, a symbol identifying a physical quantity, a function
parameter, or a mere placeholder in prose.
-}
var' : TextString -> Html
var' t = var [] [text t]

varc : ClassString -> TextString -> Html
varc c t = var [class' c] [text t]

{-| [&lt;samp&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/samp) represents the output of a program or a computer.
-}
samp_ : List Html -> Html
samp_ = samp []

samp' : TextString -> Html
samp' t = samp [] [text t]

sampc : ClassString -> TextString -> Html
sampc c t = samp [class' c] [text t]

{-| [&lt;kbd&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/kbd) represents user input, often from the keyboard, but not necessarily; it
may represent other input, like transcribed voice commands.

    instructions : Html
    instructions =
        p_ 
        [ text "Press "
        , kbd_ [ kbd' "Ctrl", text "+", kbd' "S" ]
        , text " to save this document."
        ] 

-}
kbd_ : List Html -> Html
kbd_ = kbd []

kbd' : TextString -> Html
kbd' t = kbd [] [text t]

kbdc : ClassString -> TextString -> Html
kbdc c t = kbd [class' c] [text t]

{-| [&lt;sub&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/sub) represent a subscript.
-}
sub_ : List Html -> Html
sub_ = sub []

sub' : TextString -> Html
sub' t = sub [] [text t]

subc : ClassString -> TextString -> Html
subc c t = sub [class' c] [text t]

{-| [&lt;sup&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/sup) represent a superscript.
-}
sup_ : List Html -> Html
sup_ = sup []

sup' : TextString -> Html
sup' t = sup [] [text t]

supc : ClassString -> TextString -> Html
supc c t = sup [class' c] [text t]

{-| [&lt;i&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/i) represents some text in an alternate voice or mood, or at least of
different quality, such as a taxonomic designation, a technical term, an
idiomatic phrase, a thought, or a ship name.
-}
i_ : List Html -> Html
i_ = i []

i' : TextString -> Html
i' t = i [] [text t]

ic : ClassString -> TextString -> Html
ic c t = i [class' c] [text t]

{-| [&lt;b&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/b) represents a text which to which attention is drawn for utilitarian
purposes. It doesn't convey extra importance and doesn't imply an alternate
voice.
-}
b_ : List Html -> Html
b_ = b []

b' : TextString -> Html
b' t = b [] [text t]

bc : ClassString -> TextString -> Html
bc c t = b [class' c] [text t]

{-| [&lt;u&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/u) represents a non-textual annoatation for which the conventional
presentation is underlining, such labeling the text as being misspelt or
labeling a proper name in Chinese text.
-}
u_ : List Html -> Html
u_ = u []

u' : TextString -> Html
u' t = u [] [text t]

uc : ClassString -> TextString -> Html
uc c t = u [class' c] [text t]

{-| [&lt;mark&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/mark) represents text highlighted for reference purposes, that is for its
relevance in another context.
-}
mark_ : List Html -> Html
mark_ = mark []

mark' : TextString -> Html
mark' t = mark [] [text t]

markc : ClassString -> TextString -> Html
markc c t = mark [class' c] [text t]

{-| [&lt;ruby&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/ruby) represents content to be marked with ruby annotations, short runs of text
presented alongside the text. This is often used in conjunction with East Asian
language where the annotations act as a guide for pronunciation, like the
Japanese furigana.
-}
ruby_ : List Html -> Html
ruby_ = ruby []

rubyc : ClassString -> List Html -> Html
rubyc c = ruby [class' c]

{-| [&lt;rt&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/rt) represents the text of a ruby annotation .
-}
rt' : TextString -> Html
rt' t = rt [] [text t]

rtc : ClassString -> TextString -> Html
rtc c t = rt [class' c] [text t]

{-| [&lt;rp&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/rp) represents parenthesis around a ruby annotation, used to display the
annotation in an alternate way by browsers not supporting the standard display
for annotations.
-}
rp' : TextString -> Html
rp' t = rp [] [text t]

rpc : ClassString -> TextString -> Html
rpc c t = rp [class' c] [text t]

{-| [&lt;bdi&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/bdi) represents text that must be isolated from its surrounding for
bidirectional text formatting. It allows embedding a span of text with a
different, or unknown, directionality.
-}
bdi_ : List Html -> Html
bdi_ = bdi []

bdi' : TextString -> Html
bdi' t = bdi [] [text t]

bdic : ClassString -> TextString -> Html
bdic c t = bdi [class' c] [text t]

{-| [&lt;bdo&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/bdo) represents the directionality of its children, in order to explicitly
override the Unicode bidirectional algorithm.
-}
-- TODO: Probably want to use a tagged union type for this
--bdo' : TextDirection -> List Html -> Html
--bdo' dir = bdo []

--bdoc : ClassString -> TextDirection -> List Html -> Html
--bdoc c dir = bdo [class' c, dir]

{-| [&lt;span&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/span) represents text with no specific meaning. This has to be used when no other
text-semantic element conveys an adequate meaning, which, in this case, is
often brought by global attributes like class', lang, or dir.
-}
span_ : List Html -> Html
span_ = span []

spanc : ClassString -> List Html -> Html
spanc c = span [class' c]

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
-- TODO: Consider the defaults for this one a bit more carefully (cite and datetime)
--ins_ : List Html -> Html
--ins_ = ins []

--ins' :  -> List Html -> Html
--ins' = ins []

--insc : ClassString -> List Html -> Html
--insc c = ins [class' c]

{-| [&lt;del&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/del) defines a removal from the document.
-}
-- TODO: Consider the defaults for this one a bit more carefully (cite and datetime)
--del_ : List Html -> Html
--del_ = del []

--del' :  -> List Html -> Html
--del' = del []

--delc : ClassString -> List Html -> Html
--delc c = del [class' c]


-- EMBEDDED CONTENT

{-| [&lt;img&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/img) represents an image.
-}
img' : UrlString -> Int -> Int -> String -> Html
img' url w h alt = img [A.src url, A.width w, A.height h, A.alt alt] []

imgc : ClassString -> UrlString -> Int -> Int -> String -> Html
imgc c url w h alt = img [class' c, A.src url, A.width w, A.height h, A.alt alt] []

{-| [&lt;iframe&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe) embedded an HTML document.
-}
iframe' : UrlString -> Int -> Int -> Html
iframe' url w h = iframe [A.src url, A.width w, A.height h] []

iframec : ClassString -> UrlString -> Int -> Int -> Html
iframec c url w h = iframe [class' c, A.src url, A.width w, A.height h] []

{-| [&lt;embed&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/embed) represents a integration point for an external, often non-HTML,
application or interactive content.
-}
embed' : String -> UrlString -> Int -> Int -> Html
embed' typ url w h = embed [A.type' typ, A.src url, A.width w, A.height h] []

embedc : ClassString -> String -> UrlString -> Int -> Int -> Html
embedc c typ url w h = embed [class' c, A.type' typ, A.src url, A.width w, A.height h] []

{-| [&lt;object&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/object) represents an external resource , which is treated as an image, an HTML
sub-document, or an external resource to be processed by a plug-in.
-}
-- TODO: data attribute doesn't appear to be implemented yet
--object' : ... -> List Html -> Html
--object' dat typ = object [data' dat, A.type' typ]

--objectc : ClassString -> ... -> List Html -> Html
--objectc c = object [class' c, data' dat, A.type' typ]

{-| [&lt;param&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/param) defines parameters for use by plug-ins invoked by `object` elements.
-}
param' : String -> String -> Html
param' n v = param [A.name n, A.value v] []

{-| [&lt;video&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/video) represents a video, the associated audio and captions, and controls.

Doesn't allow for &lt;track&rt;s &lt;source&rt;s, please use `video` for that.
-}
video' : UrlString -> Html
video' url = video [A.src url] []

videoc : ClassString -> UrlString -> Html
videoc c url = video [class' c, A.src url] []

{-| [&lt;audio&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/audio) represents a sound or audio stream.

Doesn't allow for &lt;track&rt;s &lt;source&rt;s, please use `audio` for that.
-}
audio' : UrlString -> Html
audio' url = audio [A.src url] []

audioc : ClassString -> UrlString -> Html
audioc c url = audio [class' c, A.src url] []

{-| [&lt;source&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/source) allows authors to specify alternative media resources for media elements
like `video` or `audio`.
-}
-- TODO
--source' :  -> List Html -> Html
--source' = source []

--sourcec : ClassString -> List Html -> Html
--sourcec c = source [class' c]

{-| [&lt;track&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/track) allows authors to specify timed text track for media elements like `video`
or `audio`.
-}
-- TODO
--track' :  -> List Html -> Html
--track' = track []

--trackc : ClassString -> List Html -> Html
--trackc c = track [class' c]

{-| [&lt;canvas&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/canvas) represents a bitmap area for graphics rendering.

No defaults provided since you're probably best off using Elm's `Graphics`!
-}

{-- TODO: elm-html hasn't exposed these functions
{-| In conjunction with `area`, defines an image map.-}
map_ : List Html -> Html
map_ = map []

{-| In conjunction with `map`, defines an image map.-}
area_ : List Html -> Html
area_ = area []
--}

{-| [&lt;svg&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/svg) defines an embedded vectorial image.
-}
-- TODO
--svg_ : List Html -> Html
--svg_ = svg []

--svg' :  -> List Html -> Html
--svg' = svg []

--svgc : ClassString -> List Html -> Html
--svgc c = svg [class' c]

{-| [&lt;math&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/math) defines a mathematical formula.
-}
-- TODO
--math_ : List Html -> Html
--math_ = math []

--math' :  -> List Html -> Html
--math' = math []

--mathc : ClassString -> List Html -> Html
--mathc c = math [class' c]


-- TABULAR DATA

{-| [&lt;table&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/table) represents data with more than one dimension.
-}
table_ : List Html -> Html
table_ = table []

tablec : ClassString -> List Html -> Html
tablec c = table [class' c]

{-| [&lt;caption&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/caption) represents the title of a table.
-}
caption_ : List Html -> Html
caption_ = caption []

captionc : ClassString -> List Html -> Html
captionc c = caption [class' c]

{-| [&lt;colgroup&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/colgroup) represents a set of one or more columns of a table.
-}
-- TODO
--colgroup_ : List Html -> Html
--colgroup_ = colgroup []

--colgroup' :  -> List Html -> Html
--colgroup' = colgroup []

--colgroupc : ClassString -> List Html -> Html
--colgroupc c = colgroup [class' c]

{-| [&lt;col&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/col) represents a column of a table.
-}
-- TODO
--col_ : List Html -> Html
--col_ = col []

--col' :  -> List Html -> Html
--col' = col []

--colc : ClassString -> List Html -> Html
--colc c = col [class' c]

{-| [&lt;tbody&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/tbody) represents the block of rows that describes the concrete data of a table.
-}
tbody_ : List Html -> Html
tbody_ = tbody []

tbodyc : ClassString -> List Html -> Html
tbodyc c = tbody [class' c]

{-| [&lt;thead&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/thead) represents the block of rows that describes the column labels of a table.
-}
thead_ : List Html -> Html
thead_ = thead []

theadc : ClassString -> List Html -> Html
theadc c = thead [class' c]

{-| [&lt;tfoot&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/tfoot) represents the block of rows that describes the column summaries of a table.
-}
tfoot_ : List Html -> Html
tfoot_ = tfoot []

tfootc : ClassString -> List Html -> Html
tfootc c = tfoot [class' c]

{-| [&lt;tr&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/tr) represents a row of cells in a table.
-}
tr_ : List Html -> Html
tr_ = tr []

trc : ClassString -> List Html -> Html
trc c = tr [class' c]

{-| [&lt;td&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/td) represents a data cell in a table.
-}
td_ : List Html -> Html
td_ = td []

td' : TextString -> Html
td' t = td [] [text t]

tdc : ClassString -> TextString -> Html
tdc c t = td [class' c] [text t]

{-| [&lt;th&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/th) represents a header cell in a table.
-}
th_ : List Html -> Html
th_ = th []

th' : TextString -> Html
th' t = th [] [text t]

thc : ClassString -> TextString -> Html
thc c t = th [class' c] [text t]


-- FORMS

{-| [&lt;form&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/form) represents a form , consisting of controls, that can be submitted to a
server for processing.
-}
form_ : List Html -> Html
form_ = form []

form' : String -> String -> List Html -> Html
form' a m = form [A.action a, A.method m]

formc : ClassString ->  String -> String -> List Html -> Html
formc c a m = form [class' c, A.action a, A.method m]

{-| [&lt;fieldset&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/fieldset) represents a set of controls.
-}
fieldset_ : List Html -> Html
fieldset_ = fieldset []

fieldsetc : ClassString -> List Html -> Html
fieldsetc c = fieldset [class' c]

{-| [&lt;legend&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/legend) represents the caption for a `fieldset`.
-}
legend' : TextString -> Html
legend' t = legend [] [text t]

legendc : ClassString -> TextString -> Html
legendc c t = legend [class' c] [text t]

{-| [&lt;label&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/label) represents the caption of a form control.
-}
label_ : List Html -> Html
label_ = label []

label' : IdString -> TextString -> Html
label' for t = label [A.for for] [text t]

labelc : ClassString -> IdString -> TextString -> Html
labelc c for t = label [class' c, A.for for] [text t]

{-| [&lt;input&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input) represents a typed data field allowing the user to edit the data.
-}
-- TODO: It is not clear what the defaults should be given the variation that is possible with this element (also, can we simply use Elm's inputs most of the time?)
--input' : String -> IdString -> String -> TextString -> Html
--input' typ i n p = input [A.type' typ, id' i, name n, placeholder p] []

--inputc : ClassString -> List Html -> Html
--inputc c = input [class' c]

{-| [&lt;button&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button) represents a button.
-}
button_ : List Html -> Html
button_ = button []

button' : TextString -> Html
button' t = button [] [text t]

buttonc : ClassString -> TextString -> Html
buttonc c t = button [class' c] [text t]

submitButton_ : List Html -> Html
submitButton_ = button [A.type' "submit"]

submitButton' : TextString -> Html
submitButton' t = button [A.type' "submit"] [text t]

submitButtonc : ClassString -> TextString -> Html
submitButtonc c t = button [class' c, A.type' "submit"] [text t]

resetButton_ : List Html -> Html
resetButton_ = button [A.type' "reset"]

resetButton' : TextString -> Html
resetButton' t = button [A.type' "reset"] [text t]

resetButtonc : ClassString -> TextString -> Html
resetButtonc c t = button [class' c, A.type' "reset"] [text t]

--{-| [&lt;select&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/select) represents a control allowing selection among a set of options.
---}
-- TODO
--select_ : List Html -> Html
--select_ = select []

--select' :  -> List Html -> Html
--select' = select []

--selectc : ClassString -> List Html -> Html
--selectc c = select [class' c]

--{-| [&lt;datalist&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/datalist) represents a set of predefined options for other controls.
---}
-- TODO
--datalist_ : List Html -> Html
--datalist_ = datalist []

--datalist' :  -> List Html -> Html
--datalist' = datalist []

--datalistc : ClassString -> List Html -> Html
--datalistc c = datalist [class' c]

--{-| [&lt;optgroup&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/optgroup) represents a set of options , logically grouped.
---}
-- TODO
--optgroup_ : List Html -> Html
--optgroup_ = optgroup []

--optgroup' :  -> List Html -> Html
--optgroup' = optgroup []

--optgroupc : ClassString -> List Html -> Html
--optgroupc c = optgroup [class' c]

--{-| [&lt;option&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/option) represents an option in a `select` element or a suggestion of a `datalist` element.
---}
-- TODO
--option_ : List Html -> Html
--option_ = option []

--option' :  -> List Html -> Html
--option' = option []

--optionc : ClassString -> List Html -> Html
--optionc c = option [class' c]

--{-| [&lt;textarea&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/textarea) represents a multiline text edit control.
---}
-- TODO
--textarea_ : List Html -> Html
--textarea_ = textarea []

--textarea' :  -> List Html -> Html
--textarea' = textarea []

--textareac : ClassString -> List Html -> Html
--textareac c = textarea [class' c]

--{-| [&lt;keygen&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/keygen) represents a key-pair generator control.
---}
-- TODO
--keygen_ : List Html -> Htm
--keygen_ = keygen []

--keygen' :  -> List Html -> Html
--keygen' = keygen []

--keygenc : ClassString -> List Html -> Html
--keygenc c = keygen [class' c]

--{-| [&lt;output&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/output) represents the result of a calculation.
---}
-- TODO
--output_ : List Html -> Html
--output_ = output []

--output' :  -> List Html -> Html
--output' = output []

--outputc : ClassString -> List Html -> Html
--outputc c = output [class' c]

--{-| [&lt;progress&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/progress) represents the completion progress of a task.
---}
-- TODO
--progress_ : List Html -> Html
--progress_ = progress []

--progress' :  -> List Html -> Html
--progress' = progress []

--progressc : ClassString -> List Html -> Html
--progressc c = progress [class' c]

--{-| [&lt;meter&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/meter) represents a scalar measurement (or a fractional value), within a known range.
---}
-- TODO
--meter_ : List Html -> Html
--meter_ = meter []

--meter' :  -> List Html -> Html
--meter' = meter []

--meterc : ClassString -> List Html -> Html
--meterc c = meter [class' c]


-- INTERACTIVE ELEMENTS

--{-| [&lt;details&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/details) represents a widget from which the user can obtain additional information or controls.
---}
-- TODO
--details_ : List Html -> Html
--details_ = details []

--details' :  -> List Html -> Html
--details' = details []

--detailsc : ClassString -> List Html -> Html
--detailsc c = details [class' c]

--{-| [&lt;summary&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/summary) represents a summary , caption , or legend for a given `details`.
---}
-- TODO
--summary_ : List Html -> Html
--summary_ = summary []

--summary' :  -> List Html -> Html
--summary' = summary []

--summaryc : ClassString -> List Html -> Html
--summaryc c = summary [class' c]

--{-| [&lt;menuitem&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/menuitem) represents a command that the user can invoke.
---}
-- TODO
--menuitem_ : List Html -> Html
--menuitem_ = menuitem []

--menuitem' :  -> List Html -> Html
--menuitem' = menuitem []

--menuitemc : ClassString -> List Html -> Html
--menuitemc c = menuitem [class' c]

--{-| [&lt;menu&gt;](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/menu) represents a list of commands.
---}
-- TODO
--menu_ : List Html -> Html
--menu_ = menu []

--menu' :  -> List Html -> Html
--menu' = menu []

--menuc : ClassString -> List Html -> Html
--menuc c = menu [class' c]
