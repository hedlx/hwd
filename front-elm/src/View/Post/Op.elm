module View.Post.Op exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Extra exposing (..)
import Msg
import Route
import View.Post as Post


view style cfg thread =
    let
        op =
            thread.op

        opHead =
            div [ style.postHead ]
                [ no style thread
                , subject style thread
                , Post.name { style | postName = style.opName } op
                , Post.time style cfg.timeZone op
                , reply style thread
                , showAll style thread
                ]
    in
    div [ style.post ] [ opHead, Post.body style thread.id op ]


no style thread =
    threadLink thread [ Post.btnHead style (String.fromInt thread.id) ]


reply style thread =
    span
        [ style.buttonEnabled
        , onClick <| Msg.ReplyTo thread.id 0
        ]
        [ Post.btnHead style "Reply" ]


showAll style thread =
    threadLink thread [ Post.btnHead style "Show All" ]


subject style thread =
    case thread.subject of
        Nothing ->
            nothing

        Just subjectText ->
            threadLink thread <|
                [ Post.headElement style
                    [ style.buttonEnabled, style.threadSubject ]
                    [ text subjectText ]
                ]


threadLink thread =
    a [ href <| Route.internalLink [ String.fromInt thread.id ] ]
