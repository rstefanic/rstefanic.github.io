module About exposing (about)

import Html            exposing (..)
import Html.Attributes exposing (..)

import Types           exposing (..)

about : Html Msg
about = div [ class "main" ] 
         [ h2 [ style [("textAlign", "center")] ] [ text "About Me" ]
         , img [ class "me", src "./images/me.jpg" ] []
         , p [] 
           [ text "I currently work at "
           , a [ href "https://www.clubexpress.com" ] [ text "ClubExpress" ]
           , text " doing tech support. Beyond computers, I enjoy drumming, "
           , text "wrestling, board games, gaming, photography, reading, "
           , text "and spending time with family and friends."
           ]
         , h2 [ style [("textAlign", "center")] ] [ text "Contact Me"]
            , ul [ style [("textAlign", "center")] ] 
              [ li [] 
                [ a [ href "mailto:rstefanic72@gmail.com" ] [ text "Email" ] ]
              , li [] 
                [ a [ href "https://twitter.com/RobertStefanic"] [ text "Twitter" ] ]
              ]
         ]