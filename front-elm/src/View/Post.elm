module View.Post exposing
    ( body
    , btnHead
    , headElement
    , name
    , time
    )

import Env
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Extra exposing (..)
import Msg
import Url.Builder
import View.Time as Time


name style post =
    let
        htmlTrip =
            if String.isEmpty post.trip then
                nothing

            else
                span [ style.postTrip ] [ text ("!" ++ post.trip) ]

        htmlName =
            span [ style.postName ] [ text <| String.left 32 post.name ]
    in
    headElement style [] [ htmlName, htmlTrip ]


time style zone post =
    headElement style [] [ Time.view zone post.ts ]


body style threadID post =
    div
        [ style.postBody
        , Html.Attributes.style "white-space" "pre-wrap"
        , Html.Attributes.style "word-wrap" "break-word"
        ]
        [ div [ style.postMediaContainer ] <|
            List.map (viewMedia style threadID post.no) post.media
        , text post.text
        ]


headElement style attrs =
    div <| [ style.postHeadElement ] ++ attrs


btnHead style btnText =
    headElement style
        []
        [ span [ style.fgButton ] [ text "[" ]
        , span [ style.hypertextLink ] [ text btnText ]
        , span [ style.fgButton ] [ text "]" ]
        ]


viewMedia style threadID postNo media =
    if media.isMinimized then
        viewMediaPreview style threadID postNo media

    else
        viewMediaFull style threadID postNo media


viewMediaPreview style threadID postNo media =
    let
        urlPreview =
            Url.Builder.crossOrigin Env.urlThumb [ media.id ] []

        whRatio =
            toFloat media.width / toFloat media.height

        computeSizes big small attrBig attrSmall =
            let
                pBig =
                    Basics.min 200 big

                pSmall =
                    round <| toFloat pBig * (toFloat small / toFloat big)
            in
            [ attrBig pBig, attrSmall pSmall ]

        attrsSizes =
            if media.width >= media.height then
                computeSizes media.width media.height width height

            else
                computeSizes media.height media.width height width
    in
    img
        (attrsSizes
            ++ [ onClick <| Msg.PostMediaPreviewClicked threadID postNo media.id
               , style.postMedia
               , style.buttonEnabled
               , src urlPreview
               ]
        )
        []


viewMediaFull style threadID postNo media =
    let
        urlFull =
            Url.Builder.crossOrigin Env.urlThumb [ media.id ] []
    in
    img
        [ onClick <| Msg.PostMediaFullClicked threadID postNo media.id
        , style.postMedia
        , style.buttonEnabled
        , src urlFull
        ]
        []
