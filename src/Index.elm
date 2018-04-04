module Main            exposing (..)

import Html            exposing (..)
import Html.Attributes exposing (..)
import Html.Events     exposing (..)
import List            exposing (..)
import Navigation      exposing (..)
import Markdown        exposing (..)
import Json.Decode     exposing (Decoder, int, string, map3, at)
import Http            exposing (..)


import Types           exposing (..)
import Home            exposing (home)
import About           exposing (about)
import Photography     exposing (photography)

-- MAIN

main : Program Never State Msg
main =
 Navigation.program UrlChange
   { init = init
   , update = update
   , view = view 
   , subscriptions = subscriptions 
   }

-- INIT

init : Navigation.Location -> (State, Cmd Msg)
init loc =
  ({ currentRoute = loc
   }, Cmd.none)
    
-- SUBSCRIPTION

subscriptions : State -> Sub Msg
subscriptions _ = 
  Sub.none

-- STATE/MODEL

type alias State = 
  { currentRoute : Navigation.Location
  }

-- ROUTING 

fromUrl : String -> Route
fromUrl url =
  let 
    urlList =
      url |> String.split "/" |> drop 1
  in 
    case urlList of
      []                 -> DefaultRoute
      [ "home" ]         -> Home
      [ "about" ]        -> About
      [ "photography" ]  -> Photography
      _                  -> RouteNotFound 

toUrl : Navigation.Location -> String
toUrl currentRoute = 
  "/" ++ (String.join "/" [(toString currentRoute)])
  
-- UPDATE

{-| The start of a blog for a later time -}

{-
allPosts = "../blog/posts.json"

postDecoder : Decoder BlogPost
postDecoder =
    Json.Decode.map3 BlogPost
        (at ["postId"] string)
        (at ["title"] string)
        (at ["content"] string)
           
requestPosts : Request BlogPost
requestPosts =
    Http.get allPosts postDecoder
        
fetchPosts =
    Http.send GetBlogPosts requestPosts
-}

update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        UrlChange location ->
            ({ state | currentRoute = location }, Cmd.none)

-- VIEW

pageBody : State -> Html Msg
pageBody state =
  case (fromUrl state.currentRoute.hash) of
      DefaultRoute  -> home
      Home          -> home
      About         -> about
      Photography   -> photography
      RouteNotFound -> pageNotFound

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
      , link "https://github.com/rstefanic/rstefanic.github.io" "View Source" 
      ]
    ]

link : String -> String -> Html Msg
link url linkText = 
  a [ href url ] [ text linkText ]

hero : Html Msg
hero = 
  Html.header []
    [ h1 [] [ text "Robert Stefanic" ] 
    , nav [] 
       [ ul [] 
          [ li [] [ link "#/home" "Home" ] 
          , li [] [ link "#/about" "About" ] 
          , li [] [ link "#/photography" "Photography" ] 
          ]
       ]
    ]

pageNotFound : Html Msg
pageNotFound = div [ class "main" ] [ text "404 -- Page not found" ] 