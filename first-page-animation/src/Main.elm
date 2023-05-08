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
        , update = update
        , subscriptions = sub
        , view =
            \({ title } as model) ->
                { title = title
                , body = view model
                }
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { title = flags.title
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


sub : Model -> Sub Msg
sub _ =
    Sub.none


view : Model -> List (Html Msg)
view _ =
    [ welcome

    -- 最后一个视图函数，表示整个应用视图已处于就绪状态
    , hideLoadingAnimation
    ]



--------------------------------------------------


welcome : Html msg
welcome =
    div
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
