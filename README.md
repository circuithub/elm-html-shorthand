# Html shorthand

[elm-html-shorthand][shorthand] is a modest shorthand supplementing [Html][elm-html] with two suffix notations:

* A shorthand / elision form where arguments are supplied directly...

  ```haskell
  div_ [ text "contents" ]          -- Most elements simply take a list of children, eliding any attributes
  Html.div [] [ text "contents" ]   -- normalizes to this

  h1_ "heading"                     -- Some elements take strings arguments instead of nodes
  Html.h1 [] [ text "heading" ]     -- normalizes to this
  ```

* An idiomatic form where...

  ```haskell
  img'                                         -- Takes a common sense list of arguments:
    { class = ""
    , src = "http://elm-lang.org/logo.png"     -- * probably all images should have a src attribute
    , alt = "The Elm logo"                     -- * probably all images should have an alt attribute
    , width  = 50                              -- * width and height helps the browser to predict the
    , height = 50                              --   dimensions of unloaded media so that popping does not occur
    }
  Html.img                                     -- * normalizes to this
    [ Html.class ""
    , Html.src "http://elm-lang.org/logo.png"
    , Html.alt "The Elm logo"
    , Html.width 50
    , Html.height 50
    ]

  inputInt' ""                                 -- Some elements are a bit special:
    { name        = "my count"
    , placeholder = Nothing
    , value       = count
    , min         = Just 0
    , max         = Nothing
    , update      = fieldUpdateContinuous      -- * e.g. let's update this field continuously
                    { onInput val = Channel.send action (UpdateCount val)
                    }
    }
  Html.input                                   -- * normalizes to something rather more elaborate
    [ Html.type' "number"
    , Html.id "my-count"
    , Html.name "my-count"
    , Html.valueAsInt count
    , Html.min "0"
    , Html.required True
    , Html.on "input"     {- ... magic ... -}
    , Html.on "blur"      {- ... magic ... -}
    , Html.on "keydown"   {- ... magic ... -}
    -- , Html.on "keypress"  {- ... magic ... -} (TODO: input masking)
    ]
  ```

Shorthand does not attempt to create a template for every concievable use case. In fact, we encourage you to look for patterns in your own html and create your own widgets! The intention here is to make the common case easy. Another project we're working on, [elm-bootstrap-html][elm-bootstrap-html], aims to eventually provide more sophisticated templates on top of [Bootstrap][bootstrap].

Please note that this API is highly experimental and very likely to change! Use this package at your own risk.

## Features

### Reduce namespace pollution

Shorthand can help you deal with namespace pollution. Since the suffixed names used in `Html.Shorthand` are unlikely to clash with names in your application logic it may make sense to import `Html.Shorthand` unqualified, while using a qualified import for `Html`.

```haskell
import Html                                      -- you can use your own short u, i, b, p variable names!
import Html.Events as Html
import Html.Attributes as Html
import Html.Shorthand (..)                       -- bringing u',i',b',p',em' etc...
import Html (blockquote)                         -- if you really want something unqualified, just import it individually...
import Html (Html, text, toElement, fromElement) -- perhaps in future Html.Shorthand will re-export these automatically
```

### Correct use of semantic tags

Notice that the definition of `h2_` doesn't allow for an id string to be supplied to it.

```haskell
h2_ : TextString -> Html
```

How then do I target my headings in URLs, you ask? Well, this is a job better suited to `section'` and `article'`! Notice that these *do* take ids in both forms.

```haskell
section_ : IdString -> List Html -> Html
section' : { class : ClassString, id : IdString } -> List Html -> Html
```

This encourages you to use &lt;`section id="..."`&gt; and &lt;`article id="..."`&gt; in order to add url-targetable ids to your page.

```haskell
section_ "ch-5"
  [ h2_ "Chapter 5"
  ]
```

This adherence to the HTML 5 spec is a theme we've tried to encourage in both the design of and the documentation accompanying this API.

### Reactive inputs with customizable update behaviour

It is actually very difficult to use html form inputs correctly, especially in a reactive setting with numeric and/or formatted input types.

```haskell
inputMaybeFloat'
  { class       = ""
  , name        = "val"
  , placeholder = Just "Enter value"
  , value       = Just 1
  , min         = Just -10
  , max         = Just 40
  , update      = fieldUpdateFallbackFocusLost
                  { -- Send an error message if the field doesn't parse correctly
                    onFallback _ = Channel.send action <| TemperatureError "Expected degrees celcius"
                  , -- Update the temperature if it parsed correctly
                    onInput val = Channel.send action <| SetTemperature val
                  }
  }
```
This does more work under the hood, though more can still be done to make form elements play well with reactivity...

## Future work

The approach of lightly constraining the Html API to reinforce pleasant patterns, seems like an interesting idea... Who wants to dig through gobs of Html with a linter when you can just get it right from the get go? One might argue that Html.Shorthand doesn't take this nearly far enough though.

* **Restricted embedding**

    It seems clear that one should be able to restrict the hierarchy of elements by type. Perhaps this complaint will disintegrate as work proceeds on [Graphics.Element][core-element] in elm-core, subsuming the need for this package... or perhaps some other brave soul will take the time to tackle it*.

    *Aside: One naive approach would be to try and recreate HTML's structure using Elm's tagged unions.However, the same tag cannot be reused in two different tagged union types.*

* **Catalog of templates**

    Another option is simply to create a catalog of templates which encode a particular piece of semantic layout instead of enforcing things at a type level. This is something we're currently investigating in the form of [elm-bootstrap-html][elm-bootstrap-html], so give me a shout if you want to help out. It is possible that some of the advice linked in the documentation could be incorporated into the templates themselves.

* **Uniqueness of ids**

    Another nice property would be enforced uniqueness of id attributes. We don't do this :)

* **No broken links**

    Sorry, this package doesn't use any sort of restricted URL scheme to prevent broken links.

* **Namespace pollution + mini version!**

    It would be nice to explore a `-mini` versions of [this library][shorthand] as well as [elm-html][elm-html] that excludes elements like &lt;b&gt;, &lt;i&gt; and &lt;u&gt; that are rarely used correctly anyway.

    This would further assist the battle against namespace pollution as well.

* **Better reactive behaviour**

    It is extremely difficult to work around buggy and inconsistent browser behaviour when it comes to text input fields.
    The wrappers provided here does a pretty good job of working around the issues, but more can be done still to improve the user experience.
    In particular, it would be great to have masking similar to say [this jquery inputmask plugin][jquery.inputmask] in order to prevent invalid inputs in the first place and to allow for advanced formatting for things like telephone numbers etc.
    One major challenge at the moment is managing the keyboard cursor selection, so that the caret does not jump around due to updates to the field.

### Comparison to other libraries

Chris Done recently worked on a new EDSL called [Lucid][lucid] for templating HTML in Haskell. It uses a `with` combinator in order to supply attributes to elements only when necessary. We have chosen not to go this route for now, however it may be worth revisiting this design at some future time (probably as a new package).

[elm-html]: http://package.elm-lang.org/packages/evancz/elm-html/latest
[shorthand]: http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest
[elm-bootstrap-html]: http://package.elm-lang.org/packages/circuithub/elm-bootstrap-html/latest
[bootstrap]: http://getbootstrap.com
[jquery.inputmask]: https://github.com/RobinHerbots/jquery.inputmask
[lucid]: http://chrisdone.com/posts/lucid
[core-element]: http://package.elm-lang.org/packages/elm-lang/core/latest/Graphics-Element

## Contributing

Feedback and contributions are very welcome.

In particular, documenting the do's and don't's and adding examples for every semantic element is very time consuming. This doesn't require any sort of in-depth knowledge of the library though, just the ability to use a search engine and some patience researching what is considered best practice. All we ask is that you try and keep it short and to the point. Please help us to tidy up and flesh out the documentation!

---
[![CircuitHub team](http://docs.circuithub.com/press/logo/circuithub-lightgray-extratiny.jpg)][team]
[team]: https://circuithub.com/about/team
