---
title: 'Switching from Elm to Hakyll'
author: 'Robert'
---

Before this site was generated using Hakyll, it was written in Elm. Elm\’s appeal is that it offers a way to write purely functional, static, strongly typed code that compiles to JavaScript. This sounded way better than writing JavaScript, which is why I jumped into using Elm. 

There are some things that I really liked about Elm, and while I only used it for a small project, I wanted to draw attention to some of these features. Afterwards, I\’m going to talk about why I switched from Elm to a static site generator, and why I settled on Hakyll as my static site generator. 

### Elm and State
For one, I **love** how Elm handles State. As John Carmack once said, \"A large fraction of the flaws in software development are due to programmers not fully understanding all the possible states their code may execute in\", and this is where Elm shines because it *forces* you to account for all the possible states that you code may execute in.

So in the previous iteration of my site, I had a very simple SPA, and the only state that the user could change was the page that they were on. So I defined my state like this:

```elm
type alias State = 
    { currentRoute : Navigation.Location }
```

I type aliased this record as State, which contains a `Navigation.Location` called currentRoute.

The `main` function in Elm takes a `Program`, which is a another record type that contains our State, Update, View, and Subscription functions. Once we\'ve defined these, we can construct `main` and Elm will handle the rest. Elm generates code putting these pieces together. So we will have to define these functions, and build a `Program` which we\'ll define as `main`. Since we\'ve started by creating `State`, let\'s continue by initializing the state of our program that will be passed to Main.

```elm
init : Navigation.Location -> (State, Cmd Msg)
init loc =
    ({ currentRoute = loc }, 
       Cmd.none)
```

`init` is a function that takes a `Navigation.Location`, and morphs it to a `(State, Cmd Msg)`. The `State` type is the one that I\'d aliased earlier, and `Cmd` is a type that\'s built into Elm.

Next we\'ll build `update`:

```elm
update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        UrlChange location ->
            ({ state | currentRoute = location }, Cmd.none)
```

This is a function that takes a `Msg` and a `State`, and outputs a `(State, Cmd Msg)`.

As a quick side note here, this was another feature that I reallyed liked from Elm: their record syntax to create a new record from an existing record. It\'s clean and it\'s clear.

Using the example from above, `{ state | currentRoute = location }` is taking what\'s already defined in state and saying that it will swap the currentRoute that\'s defined in the state that\'s passed in with the value that\'s to the right of `|`. Of course, in this example, since `State` is dead simple, I could have omitted everything to the left of currentRoute and constructed a whole new `State` without referencing the old one. But that\'s besides the point. The syntax here used to build a new record is very nice.

Now that I\'ve built my `init` function, I can build main.

```elm
main : Program Never State Msg
main =
  Navigation.program UrlChange
   { init = init
   , update = update
   , view = view 
   , subscriptions = subscriptions 
   }
```

