module Languages.Show exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id, href, style, src)
import Languages.Models exposing (..)
import Languages.Messages exposing (..)


styles : Html.Attribute a
styles =
    style
        [ ( "float", "left" )
        ]


view : Language -> Html Msg
view language =
    div [ styles ]
        [ h2 [ id "titleLanguage" ] [ text language.name ]
        , img [ src ("/images/" ++ language.image ++ ".png") ] []
        , tags language
        ]


tags : Language -> Html Msg
tags language =
    div [] (List.map tag language.tags)


tag : String -> Html Msg
tag tagName =
    span []
        [ text (tagName ++ ", ")
        ]
