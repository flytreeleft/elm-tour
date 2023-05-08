module Main exposing (main)

import Browser exposing (Document)
import Html
    exposing
        ( Html
        , div
        , img
        , node
        , text
        )
import Html.Attributes exposing (src, style)


{-| 在 JS 侧通过 flags 传入该配置信息
-}
type alias Flags =
    { title : String
    }


type alias Model =
    { title : String
    }


type Msg
    = NoOp


main : Program Flags Model Msg
main =
    -- https://guide.elm-lang.org/webapps/
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = sub
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { title = flags.title
      }
    , Cmd.none
    )


view : Model -> Document Msg
view { title } =
    { title = title
    , body =
        [ div
            [ style "width" "100%"
            , style "height" "100%"
            , style "font-size" "18px"
            , style "display" "flex"
            , style "flex-direction" "column"
            , style "align-items" "center"
            , style "gap" "2em"
            , style "padding-top" "5em"
            ]
            [ img
                [ style "width" "10em"
                , style "height" "10em"
                , src "./logo.svg"
                ]
                []
            , text "Welcome to the Elm world!"
            ]

        -- 最后一个渲染节点，表示整个应用视图已处于就绪状态
        , hideLoadingAnimation
        ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


sub : Model -> Sub Msg
sub _ =
    Sub.none



--------------------------------------------------


hideLoadingAnimation : Html msg
hideLoadingAnimation =
    node "style"
        []
        [ -- 隐藏加载动画，并显示 body 下的元素
          text """
body::after { opacity: 0; }
body > * { opacity: 1; }
"""
        ]
