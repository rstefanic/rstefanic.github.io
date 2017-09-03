module Blog exposing (blog)

import Html                    exposing (..)
import Html.Attributes         exposing (..)
import Json.Decode     as Json exposing (string)
import Http                    exposing (..)
import Task

import Types                   exposing (..)

-- getPost : String -> Cmd Msg
-- getPost postId =
--   let 
--     url = "./blog/posts.json"
--   in 
--     Task.perform FetchFail FetchSucceed (Http.get decodePosts url)

-- decodePosts : Json.Decoder BlogPost
-- decodePosts = 
--   decode BlogPost
--     |> Json.Pipeline.required "postId" string 
--     |> Json.Pipeline.required "content" string 

blog : BlogPost -> Html Msg
blog blogPost = div [ class "main" ] [ text ("Hello! This is the blog. Post Number: " ++ blogPost.postId) ]
