module Blog exposing (blog)

import Html                    exposing (..)
import Html.Attributes         exposing (..)
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

-- BlogPost = postId, title, content
{-
allPosts = "./blog/posts.json"

postDecoder : Decoder BlogPost
postDecoder =
    map3 BlogPost
        (at ["postId"] string)
        (at ["title"] string)
        (at ["content"] string)
           
requestPosts : Request BlogPost
requestPosts =
    Http.get allPosts postDecoder
        
fetchPosts =
    Http.send GetBlogPosts requestPosts
-}

blog : String -> String -> Html Msg
blog blogPost title = div [ class "main" ] [ text ("Hello! This is the blog. Title:" ++ title ) ]

{-
decodePosts payload =
    case decodeValue posts payload of
        Ok val  -> val
        Err msg -> Null

posts : Decoder BlogPost
posts =
    succeed BlogPost
        |: ("posts" := string)
                
getPost : String -> BlogPost
getPost string =
    let 
        req =
            Http.get "./blog/posts.json" readPosts
    in
        Http.send readPosts req

readPosts : Json.Decoder BlogPost
readPosts =
    Json.at [ "postId", "title", "content" ] (Json.list decodePost)

decodePost : Json.Decoder BlogPost
decodePost =
    Json.map4 BlogPost
        (Json.at ["postId", "title", "content" ] Json.string)
-}
