module Main exposing (main)

import Browser
import Html
    exposing
        ( Html
        , a
        , div
        , img
        , node
        , span
        , text
        )
import Html.Attributes
    exposing
        ( attribute
        , class
        , href
        , src
        )
import Html.Events exposing (onClick)


{-| 在 JS 侧通过 flags 传入该配置信息
-}
type alias Flags =
    { title : String
    }


type alias Model =
    { title : String
    , theme : Theme
    }


type Msg
    = NoOp
    | ChangeTheme Theme


type Theme
    = Light
    | Dark


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
                , body = [ view model ]
                }
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { title = flags.title
      , theme = Light
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( case msg of
        ChangeTheme theme ->
            { model | theme = theme }

        NoOp ->
            model
    , Cmd.none
    )


sub : Model -> Sub Msg
sub _ =
    Sub.none


view : Model -> Html Msg
view ({ theme } as model) =
    div
        -- 在最外层 div 节点控制启禁视图的暗黑模式
        [ attribute "theme"
            (case theme of
                Dark ->
                    "dark"

                Light ->
                    ""
            )
        , class "w-full h-full"
        ]
        [ welcome model

        -- 最后一个视图函数，表示整个应用视图已处于就绪状态
        , hideLoadingAnimation
        ]



--------------------------------------------------


welcome : Model -> Html Msg
welcome { theme } =
    div
        [ class "text-slate-500 dark:text-slate-400 bg-white dark:bg-slate-900"
        , class "w-full h-full px-8"
        , class "flex flex-col items-center"
        ]
        [ div
            [ class "pt-16"
            , class "flex flex-col sm:flex-row gap-4 items-center"
            ]
            [ img
                [ class "w-40 h-40"
                , src "./elm-logo.svg"
                ]
                []
            , div
                [ class "w-10 h-10"
                , class "text-center text-4xl font-bold text-sky-500"
                , class "rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700"
                , class "cursor-pointer"
                , class "transition-colors duration-300 transform"
                , onClick
                    (ChangeTheme
                        (case theme of
                            Dark ->
                                Light

                            Light ->
                                Dark
                        )
                    )
                ]
                [ span
                    [ class "dark:hidden"
                    ]
                    [ text "&" ]
                , span
                    [ class
                        (case theme of
                            Dark ->
                                ""

                            Light ->
                                "hidden"
                        )
                    ]
                    [ text "+" ]
                ]
            , img
                [ class "w-40 h-40"
                , src "./tailwindcss-logo.svg"
                ]
                []
            ]
        , span
            [ class "pt-8"
            , class "text-center text-xl"
            ]
            [ text "Welcome to the world of "
            , a
                [ class "text-blue-600 visited:text-purple-600"
                , href "https://elm-lang.org/"
                ]
                [ text "Elm" ]
            , text
                (case theme of
                    Dark ->
                        " + "

                    Light ->
                        " & "
                )
            , a
                [ class "text-blue-600 visited:text-purple-600"
                , href "https://tailwindcss.com/"
                ]
                [ text "Tailwind CSS" ]
            , text " !"
            ]
        ]


hideLoadingAnimation : Html msg
hideLoadingAnimation =
    node "style"
        []
        [ -- 隐藏开屏动画，并显示 body 下的元素
          text """
body::after { opacity: 0; }
body > * { opacity: 1; }
"""
        ]
