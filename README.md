# Html shorthand

[elm-html-shorthand][shorthand] is a modest, lightweight shorthand for supplementing [Html][elm-html] using three forms of notation:

* A single argument form...

  ```elm
  span_     -- No attributes
  span []   -- expands to this
  ```

* A canonical form...

  ```elm
  img' "http://elm-lang.org/logo.png" "The Elm logo"             -- takes a common sense list of arguments
  img [ src "http://elm-lang.org/logo.png", alt "The Elm logo" ] -- expands to this
  ```

* A classy (-canonical) form...

  ```elm
  codec "lang-elm" "Signal Float"                   -- takes a css class string + common sense arguments
  code [ class "lang-elm" ] [ text "Signal Float" ] -- expands to this
  ```

Shorthand does not attempt to create a template for every concievable use case. In fact, we encourage you to look for patterns in your html and factor out your own! We only intend to provide defaults for extremely common, single element patterns.

A quick comparison!

In [elm-html-shorthand][shorthand]:

```elm
import Html
import Html (Html, text)
import Html.Shorthand (..)

let container = divc "container"
    row = divc "row"
    col = divc "col-md-9"
    comment entryNo commentNo contents = 
      articlec "comment" ("b" ++ toString entryNo ++ "-c" ++ toString commentNo)
      [ -- header
      , p' "Elmo is my hero"
      ]
    entry entryNo title contents comments =
      articlec "blogentry" title
      [ contents
      , sectionc "comments"
        (title ++ "-comments")
        (map2 (comment entryNo) [1..] comments)
      ]
in  sectionc "container" "blog"
    container 
    [ row
      [ col
        [ entry "Elmo teaches Elm!" 
          [ {- blog entry -} 
          ]
          [ "Elmo is my hero"
          ]
        , entry "Sesame street presses charges..."
          [ {- blog entry -}
          ]
          [ "Well, that escalated quickly!"
          , "I am sad"
          ]
        ]
      ]
    ]
```

In [elm-html][elm-html]:

```elm
-- TODO
```

Please note that this API is highly experimental and very likely to change! Use this package at your own risk.

## Features

### Reduced namespace pollution

Shorthand can help you deal with namespace pollution. Since the suffixed names used in `Html.Shorthand` are unlikely to clash with names in your application logic it may make sense to import `Html.Shorthand` unqualified, while using a qualified import for `Html`. 

```elm
import Html                                      -- you can use your own short u, i, b, p variable names!
import Html.Shorthand (..)                       -- bringing u',i',b',p',em' etc...
import Html (blockquote)                         -- if you really want something unqualified, just import it individually...
import Html (Html, text, toElement, fromElement) -- perhaps in future Html.Shorthand will re-export these automatically
```

### Correct use of semantic tags

Notice that the definition of `h2'` doesn't allow for an id string to be supplied to it.

```elm
h2' : TextString -> Html
```

How then do I target my headings in URLs, you ask? Well, this is a job better suited to `section'` and `article'`! Notice that these *do* take ids in their canonical forms.

```elm
section' : IdString -> List Html -> Html
```

This encourages you to use `&lt;section id="..."&gt; and &lt;article id="..."&lt;` in order to add url-targetable ids to your page.

```elm
section' "ch-5"
[ h2' "Chapter 5"
]
```

This adherence to the HTML 5 spec is a theme we've tried to encourage in both the design of and the documentation accompanying this API.

## Future work

The approach of lightly constraining the Html API to reinforce pleasant patterns, seems like an interesting idea... Who wants to dig through gobs of Html with a linter when you can just get it right from the get go? One might argue that Html.Shorthand doesn't take this nearly far enough though.

* **Restricted embedding**

    It seems clear that one should be able to restrict the hierarchy of elements by type. Perhaps this complaint will disintegrate as work proceeds on [Graphics.Element][core-element] in elm-core, subsuming the need for this package... or perhaps some other brave soul will take the time to tackle it*.
    
    *Aside: Of course, one naive approach would be to try and recreate HTML's structure using Elm's tagged unions. However making this work would be somewhat problematic given that the same tag cannot be reused in two different tagged union types.

* **Catalog of templates**

    Another option is simply to create a catalog of templates which encode a particular piece of semantic layout instead of enforcing things at a type level. This is something we're currently investigating in the form of [elm-bootstrap-html][elm-bootstrap-html], so give me a shout if you want to help out. It is possible that some of the advice linked in the documentation could be incorporated into the templates themselves.

[elm-bootstrap-html]: http://package.elm-lang.org/packages/circuithub/elm-bootstrap-html/latest

* ***Uniqueness of ids***

    Another nice property would be enforced uniqueness of id attributes. We don't do this :)

* ***No broken links***

    Sorry, this package doesn't use any sort of restricted URL scheme to prevent broken links.

* ***Namespace pollution A mini version!***

    It would be nice to explore a `-mini` versions of [this library][shorthand] as well as [elm-html][elm-html] that excludes elements like &lt;b&gt;, &lt;i&gt; and &lt;u&gt; that are rarely used correctly anyway.
    
    This would further assist the battle against namespace pollution as well.

### Comparison to other libraries

Chris Done recently worked on a new EDSL called [Lucid][lucid] for templating HTML in Haskell. It uses a `with` combinator in order to supply attributes to elements only when necessary. We have not chosen to try this route, however it may be worth revisiting this design at some future time (probably as a new package).

<!--
For now, [elm-html-shorthand][shorthand] is dead simple and immediately usable, so have fun!
-->

[elm-html]: http://package.elm-lang.org/packages/evancz/elm-html/latest
[shorthand]: http://package.elm-lang.org/packages/circuithub/elm-html-shorthand/latest
[lucid]: http://chrisdone.com/posts/lucid
[core-element]: http://package.elm-lang.org/packages/elm-lang/core/latest/Graphics-Element

## Contributing 

Feedback and contributions are very welcome. 

In particular, documenting the do's and don't's and adding examples for every semantic element is very time consuming. This doesn't require any sort of in-depth knowledge of the library though, just the ability to use a search engine and some patience researching what is considered best practice. All we ask is that you try and keep it short and to the point. Please help us to tidy up and flesh out the documentation!

---
[![CircuitHub team](http://docs.circuithub.com/press/logo/circuithub-lightgray-extratiny.jpg)][team]
[team]: https://circuithub.com/about/team
