module Types exposing (..)

import Navigation exposing (..)
import Http       exposing (Error)

type Msg
    = UrlChange Navigation.Location

{-
type alias PostId  = String
type alias Title   = String
type alias Content = String
-}

-- ROUTING

{-
type alias BlogPost =
  { postId  : PostId
  , title   : Title
  , content : Content
  }
-}

type Route
  = DefaultRoute
  | Home
  | About
  | Photography
  | RouteNotFound
