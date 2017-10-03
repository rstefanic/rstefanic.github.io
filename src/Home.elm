module Home exposing (home)

import Html            exposing (..)
import Html.Attributes exposing (..)

import Types           exposing (..)

home : Html Msg
home = div [ class "main" ] 
        [ h2 [ style [("textAlign", "center")] ] [ text "Welcome to my website" ]
        , h3 [ style [("textAlign", "center")] ] [ text "Feel free to look around" ] 
        , div []
          [ h3 [] [ text "HTML Tutorial" ]
          , p [] [ text "A small HTML tutorial that I've created. Feel "
                 , text "free to make a PR." ]
          , a [ href "https://rstefanic.github.io/HTML-Tutorial" ] 
            [ text "HTML Tutorial" ]
          ]
        , div []
          [ h3 [] [ text "Backup" ]
          , p [] [ text "A small script that can be used to backup "
                 , text " up your files" ]
          , a [ href "https://github.com/rstefanic/backup"] [ text "Backup" ]
          ]
        , div []
          [ h3 [] [ text "CE-Folder Finder" ]
          , p [] [ text "Lists the folders from an EWS account "
                 , text "with a GUI." ]
          , a [ href "https://github.com/rstefanic/CE-Folder-Finder" ] [ text "CE Folder Finder" ]
          ]
        ]
