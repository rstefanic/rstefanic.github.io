module Photography exposing (photography)

import Html exposing (..)
import Html.Attributes    exposing (..)
import Types exposing (..)

photography : Html Msg
photography = div [ class "main" ] 
              [ h2 [ style [("textAlign", "center")] ] [ text "Photography" ]
              , p [] [ text "I like to pretend that I'm a photographer. I " 
                     , text "enjoy photographing natural landscapes, "
                     , text "cityscapes, and graffiti. Some of my pictures "
                     , text "are here below." ]
              , img 
                 [ class "photograph" 
                 , src "https://farm9.staticflickr.com/8828/28222281662_dcf0067290_z.jpg" ]
                 []
              , img 
                 [ class "photograph"
                 , src "https://farm8.staticflickr.com/7567/28291899826_8d40320d39_z.jpg" ]
                 []     
              , img 
                 [ class "photograph"
                 , src "https://farm8.staticflickr.com/7317/28124163426_c4e69f8a0f_z.jpg" ]
                 []
              , img 
                 [ class "photograph"
                 , src "https://farm8.staticflickr.com/7282/27766804562_21e4b56865_z.jpg" ]
                 []
              , img 
                 [ class "photograph"
                 , src "https://farm8.staticflickr.com/7187/27867669395_0ae9232513_z.jpg" ]
                 []
              , img 
                 [ class "photograph"
                 , src "https://farm8.staticflickr.com/7574/27256235193_7e330336d2_z.jpg" ]
                 []
              , img 
                 [ class "photograph"
                 , src "https://farm8.staticflickr.com/7495/27256224734_7176603d91_z.jpg" ]
                 []
              , img 
                 [ class "photograph"
                 , src "https://farm8.staticflickr.com/7274/27912249392_35b82b8459_z.jpg" ]
                 []
              ]
