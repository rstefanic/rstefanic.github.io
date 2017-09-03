module Types exposing (..)

import Navigation

type Msg
    = UrlChange Navigation.Location

type alias PostId = String

type alias Content = String

-- ROUTING

type alias BlogPost =
  { postId  : PostId
  , content : Content
  }

type Route
  = DefaultRoute
  | Home
  | About
  | Blog BlogPost
  | Photography
  | RouteNotFound