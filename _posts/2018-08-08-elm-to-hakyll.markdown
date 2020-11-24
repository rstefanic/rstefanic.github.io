---
layout: post
title: 'Switching from Elm to Hakyll'
author: 'Robert Stefanic'
---

Before this site was generated using [Hakyll](https://jaspervdj.be/hakyll/), it was written in [Elm](http://elm-lang.org/). Elm\'s appeal is that it offers a way to write purely functional, static, strongly typed code with ML like syntax that compiles to JavaScript. This sounded way better than writing JS,[<sup>1</sup>](#note-1) which is why I jumped into using Elm. 

There are some things that I really liked about Elm, and while I only used it for a small project, I wanted to draw attention to a couple of the features that I really liked and how they worked. I then wanted to talk about why I switched from Elm to a static site generator, and why I settled on Hakyll as my static site generator. 

___
### Elm and State
For one, I **love** how Elm handles State. As John Carmack once said: 

>\"A large fraction of the flaws in software development are due to programmers not fully understanding all the possible states their code may execute in.\"

And this is where Elm shines because it *forces* you to account for all the possible states that your code may execute in.

So in the previous iteration of my site, I had a very simple SPA, and the only state that the user could change was the page that they were on. So I defined my state like this:

```haskell
type alias State = 
    { currentRoute : Navigation.Location }
```
I type aliased this record as `State`, which contains a field for `Navigation.Location` called currentRoute.

Navigation is a package that can be imported into your Elm project, and `Location` is a type that\'s available in Navigation. `Navigation.Location` is a record that has information regarding the user\'s location on your site. Unfortunately, Elm doesn\'t have typeclasses, but `Navigation.Location` does have some handy functions such as `toString` which is what we would want from giving `Navigation.Location` an instance of `Show`.

I now need to define all the possible Routes that my site can have, and a function that will morph my `Navigation.Location` to `Route`. But since as I\'ve just pointed out that `Navigation.Location` has `toString`, I\'m just going to create a function with the type of `String -> Route`, and then I\'ll call `toString` on the URL before passing it to my function.

```haskell
type Route
  = DefaultRoute
  | Home
  | About
  | Photography
  | RouteNotFound

fromUrl : String -> Route
fromUrl url =
  let 
    urlList = url |> String.split "/" |> drop 1
  in 
    case urlList of
      []                 -> DefaultRoute
      [ "home" ]         -> Home
      [ "about" ]        -> About
      [ "photography" ]  -> Photography
      _                  -> RouteNotFound 
```

This `fromUrl` function takes a `String` (which is the path in this case), breaks it up on the \"/\", and drops the first part of the path because it is garbage in my case.[<sup>2</sup>](#note-2)

Now the `main` function in Elm takes a `Program`, which is another record type that contains our Model (State), Update, View, and Subscription functions. This is the heart of Elm. Once we\'ve defined these, we can construct `main` using our functions and Elm will handle the rest. Elm will generate the code for our site by putting these pieces together. 

So we will have to define these functions, and build a `Program` which we\'ll define as `main`. Since we\'ve started by creating `State`, let\'s continue by initializing the state of our program that will be passed to `main`.

#### Building Model

```haskell
init : Navigation.Location -> (State, Cmd Msg)
init loc =
    ({ currentRoute = loc }, 
       Cmd.none)
```

`init` provides the *initial* input and state for our application. Since I\'m keeping track of where the user is, and the user can come in from any URL, I need it to be a function that takes a `Navigation.Location`, embeds it in our `State` type. `init` returns a `(State, Cmd Msg)` which holds our `State`, and an initial command to run. `Cmd a` is a type that allows you to add inject a type into the `Cmd` context, and `Cmd a` tells the Elm runtime how to execute things that involve side effects. Since I don\'t have an initial command to run, I\'m going to pass it `Cmd.none`.

Here\'s my definition for `Msg`:

```haskell
type Msg = UrlChange Navigation.Location
```

It\'s standard to define the type passed to `Cmd` as `Msg`, however, it\'s up to the author to write it. `Msg` holds any actions that can happen in our application, and since in my application, the only thing that the user can change in the URL, that\'s what I\'m keeping track of.

The Elm documentation also gives an example of `Msg` that would include a sum type of all of the actions that could happen, like so: 

```haskell
type Msg
  = ShowUserInfo
  | HideUserInfo
  | NavigateBack
  | CheckOut
```

#### Building Update

```haskell
update : Msg -> State -> (State, Cmd Msg)
update msg state =
    case msg of
        UrlChange location ->
            ({ state | currentRoute = location }, Cmd.none)
```

This is a function that takes a `Msg` and a `State`, and outputs a `(State, Cmd Msg)`.

As a quick side note here, this was another feature that I really liked from Elm: their record syntax to create a new record from an existing record. It\'s clean and it\'s clear.

Using the example from above, `{ state | currentRoute = location }` is taking what\'s already defined in state and saying that it will swap the currentRoute that\'s defined in the state that\'s passed in with the value that\'s to the right of `|`. Of course, in this example, since `State` is dead simple, I could have omitted everything to the left of currentRoute and constructed a whole new `State` without referencing the old one. But that\'s beside the point. The syntax here used to build a new record is very nice.

#### Building View

Next up is `view`. Building the view in my case is a bit more complex since the body of the page can change based on `State` of where the user is. On top of that, we\'re using Elm to write our HTML. But I guarantee that once you see how all four of these pieces of `Program` fit together, you\'ll see the power and how easy it is to expand upon what\'s here. 

I\'ve included the `Route` type that I\'ve defined that\'s used in my `view` along with a helper function called `pageBody`.

```haskell
view : State -> Html Msg
view state =   
  div [] 
    [ div [ class "wrapper" ]
      [ node "link" [ rel "stylesheet", href "styles.css" ] []
      , hero
      , pageBody state
      ]
    , div [ class "push" ] []
    , div [ class "footer" ] 
      [ p [] [ text "Ⓒ Robert Stefanic 2017" ]
      , link "https://google.com" "View Source" 
      ]
]

pageBody : State -> Html Msg
pageBody state =
  case (fromUrl state.currentRoute.hash) of
      DefaultRoute  -> home
      Home          -> home
      About         -> about
      Photography   -> photography
      RouteNotFound -> pageNotFound
```

The `view` takes a state, and renders it to `Html Msg` (which is what the user sees). There are a couple of calls to other functions that help clean up `view` (such as `hero` which loads my hero image and navigation, and `link` which was a helper function that I created to build links). But the main idea is that my view takes a state, and passes it to another function here called `pageBody` where it will figure out where the user is on my site, and return the proper page body depending on the `State` (i.e. \the the user\'s location).

#### Building Subscription

```haskell
subscriptions : State -> Sub Msg
subscriptions _ = Sub.none
```

Subscriptions listen for external input into our application, like a keyboard event. Think of it as a subscription to an external event.

I will not be using any, so I\'m just going to ignore the `State` that\'s passed to it, and return `Sub.none`.

*Note: You could have handled the user\'s location through Subscription by subscribing to the user\'s browser change location.*

#### Putting it all together in main

Now that I all of the parts that I need for a `Program`, I can build `main`.

```haskell
main : Program Never State Msg
main =
  Navigation.program UrlChange
   { init = init
   , update = update
   , view = view 
   , subscriptions = subscriptions 
   }
```

This wires everything together and produces the HTML that will be rendered. 

You can now see how easy it would be to expand upon this program. Do you want to add a new route? No problem! Just add your new route to the `Route` type, accommodate for it `pageBody` function written here, and write a new function of type `State -> Html Msg`, and you have your new page!

## Why switch from Elm to Hakyll?

After talking about how great Elm was to work with, I did find some pain points. Some were very minor,[<sup>3</sup>](#note-3) and others were large. Writing a JSON decoder and encoder with Elm was a pain. It\'s difficult, and I endlessly searched through the documentation to find out how to write it. This is a problem, but it points out a bigger problem that Elm has in my view: it lacks typeclasses.

If Elm had typeclasses, I could define an instance of `FromJSON` and `ToJSON` (like you can using Aeson for Haskell), and just implement everything that\'s needed for them. Then it wouldn\'t be so difficult! But the fact that I had to dig through the documentation to find a `Decoder` and `Encoder` type and then add it to the project my self while trying to just copy examples of versions that worked for my application, I just kept thinking \"this would be a couple of lines max if there were typeclasses\".

I wanted to create this blog, but the problems I was having with JSON decoding using Elm turned me off from it. On top of that, I would have to add markdown support for my site as well. So in the end, I decided that I wanted to switch my site. 

I was always curious about using a static site generator like Jekyll, but I never pulled the trigger on it. I like the idea of building a simple site using another language. I eventually stumbled upon Hakyll. This gave me exactly what I wanted. I liked the type safety that Elm gave me, but I could now get that safety in a static site generator! On top of that, Hakyll has support for Pandoc, which would allow me to take any format that Pandoc supports, and convert it to HTML! This seemed like a no-brainer. I can now use Markdown, Multi-Markdown, reStructured Text, LaTeX (for writing out all of those symbols!), and more. It just looked like I gained a lot by using Hakyll, on top of the speed that\'s gained using a static site.

On top of that, Hakyll is great and easy to use. It\'s written using a configurable DSL that makes it easy to specify the output. There are tons of tutorials on Hakyll, and I strongly recommend giving both Hakyll and Elm a try.

___
<span id="note-1">1</span>: I\'m actually quite fond of JS, but I\'ll take any form of type safety over nothing.

<span id="note-2">2</span>: The first part of the paths on my site starts with \"#/\", so I drop the first element from the list because the first part of the list is just \"#\". So in this case, if the route was \"#/photography", I just want to drop the \"#\", so that way my list is just `[ "photography" ]`.

<span id="note-3">3</span>: The output of index.html for my old site was literally over 10,000 lines of code. It was mostly Javascript with a hook for HTML, but I could not believe the size of this file when I saw it. This is a very minor point as most computers and internet connections are fast nowadays, but sending over 10,000 lines in a single HTML document? That still seems a bit ridiculous to me. 