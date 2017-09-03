module Home exposing (home)

import Html            exposing (..)
import Html.Attributes exposing (..)

import Types           exposing (..)

home : Html Msg
home = div [ class "main" ] 
        [ h2 [ style [("textAlign", "center")] ] [ text "Welcome"] 
        , p [] [ text "Feel free to have a look around. My interests "
               , text "include functional programming, formal logic"
               , text ", and web development." 
               ]
        , h2 [ style [("textAlign", "center")] ] [ text "Projects" ] 
        , div []
          [ h3 [] [ text "HTML Tutorial" ]
          , p [] [ text "A small HTML tutorial that I've created. Feel "
                 , text "free to make a PR." ]
          , a [ href "https://rstefanic.github.io/HTML-Tutorial" ] 
            [ text "HTML Tutorial" ]
          ]
        , div []
          [ h3 [] [ text "Typeline" ]
          , p [] [ text "A CSS preprocessor" ]
          , a [ href "#"] [ text "Typeline" ]
          ]
        , div []
          [ h3 [] [ text "My Github" ]
          , a [ href "https://github.com/rstefanic" ] [ text "Github" ]
          ]
        ]