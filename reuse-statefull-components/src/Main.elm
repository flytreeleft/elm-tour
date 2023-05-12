module Main exposing (main)

import Browser
import Html
    exposing
        ( Html
        , div
        , input
        , label
        , node
        , span
        , text
        )
import Html.Attributes
    exposing
        ( attribute
        , checked
        , class
        , placeholder
        , type_
        , value
        )
import Html.Events
    exposing
        ( on
        , onClick
        )
import Json.Decode as Decode


{-| 在 JS 侧通过 flags 传入该配置信息
-}
type alias Flags =
    { title : String
    }


type alias Model =
    { title : String
    , lang : EditorLang
    , mode : EditorMode
    , markdown : String
    }


type Msg
    = NoOp
    | EditorValueChange String
    | EditorModeChange EditorMode
    | EditorLangChange EditorLang


type EditorMode
    = Auto
    | Split
    | Tab


type EditorLang
    = Zh_Hans
    | En


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
      , lang = Zh_Hans
      , mode = Auto
      , markdown = sampleMarkdown
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( case msg of
        EditorValueChange val ->
            { model | markdown = val }

        EditorModeChange val ->
            { model | mode = val }

        EditorLangChange val ->
            { model | lang = val }

        NoOp ->
            model
    , Cmd.none
    )


sub : Model -> Sub Msg
sub _ =
    Sub.none


view : Model -> Html Msg
view model =
    div
        [ class "w-full h-full"
        , class "px-8 md:px-32 py-8"
        , class "flex flex-col items-center"
        ]
        [ heading
        , toolbar model
        , playground model

        -- 最后一个视图函数，表示整个应用视图已处于就绪状态
        , hideLoadingAnimation
        ]



--------------------------------------------------


playground : Model -> Html Msg
playground { lang, mode, markdown } =
    node "bytemd-editor"
        [ value markdown
        , placeholder "现在就用 Markdown 来写点什么吧 :)"
        , class "w-full lg:w-3/4"
        , class "grow flex flex-col"
        , attribute "inner-class" "grow"
        , attribute "lang"
            (case lang of
                Zh_Hans ->
                    "zh_Hans"

                En ->
                    "en"
            )
        , attribute "mode"
            (case mode of
                Auto ->
                    "auto"

                Split ->
                    "split"

                Tab ->
                    "tab"
            )
        , on "change"
            (Decode.at
                [ "detail", "value" ]
                Decode.string
                |> Decode.andThen
                    (\val ->
                        Decode.succeed
                            (EditorValueChange val)
                    )
            )
        ]
        []


toolbar : Model -> Html Msg
toolbar { mode, lang } =
    div
        [ class "pb-2"
        , class "flex flex-col md:flex-row"
        , class "gap-2 items-center justify-center"
        ]
        [ div
            [ class "flex items-center"
            ]
            (text "Mode:"
                :: ([ Auto, Split, Tab ]
                        |> List.map
                            (\m ->
                                div
                                    [ class "flex items-center"
                                    , class "ml-2 cursor-pointer"
                                    , onClick (EditorModeChange m)
                                    ]
                                    [ input
                                        [ class "form-radio"
                                        , type_ "radio"
                                        , checked (mode == m)
                                        ]
                                        []
                                    , label
                                        [ class "font-medium cursor-pointer"
                                        ]
                                        [ text
                                            (case m of
                                                Auto ->
                                                    "auto"

                                                Split ->
                                                    "split"

                                                Tab ->
                                                    "tab"
                                            )
                                        ]
                                    ]
                            )
                   )
            )
        , div
            [ class "h-full w-0"
            , class "border-r-2 border-gray-300"
            , class "hidden md:block"
            ]
            []
        , div
            [ class "flex items-center"
            ]
            (text "Locale:"
                :: ([ Zh_Hans, En ]
                        |> List.map
                            (\l ->
                                div
                                    [ class "flex items-center"
                                    , class "ml-2 cursor-pointer"
                                    , onClick (EditorLangChange l)
                                    ]
                                    [ input
                                        [ class "form-radio"
                                        , type_ "radio"
                                        , checked (lang == l)
                                        ]
                                        []
                                    , label
                                        [ class "font-medium cursor-pointer"
                                        ]
                                        [ text
                                            (case l of
                                                Zh_Hans ->
                                                    "中文简体"

                                                En ->
                                                    "English"
                                            )
                                        ]
                                    ]
                            )
                   )
            )
        ]


heading : Html msg
heading =
    span
        [ class "pb-8"
        , class "text-4xl font-bold text-blue-500 text-center"
        ]
        [ text "Elm with Web Components"
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


sampleMarkdown : String
sampleMarkdown =
    -- https://bytemd.js.org/playground/
    """## Markdown Basic Syntax

I just love **bold text**. Italicized text is the _cat's meow_. At the command prompt, type `nano`.

My favorite markdown editor is [ByteMD](https://github.com/bytedance/bytemd).

1. First item
2. Second item
3. Third item

> Dorothy followed her through many of the beautiful rooms in her castle.

```js
import gfm from '@bytemd/plugin-gfm'
import { Editor, Viewer } from 'bytemd'

const plugins = [
  gfm(),
  // Add more plugins here
]

const editor = new Editor({
  target: document.body, // DOM to render
  props: {
    value: '',
    plugins,
  },
})

editor.on('change', (e) => {
  editor.$set({ value: e.detail.value })
})
```

## GFM Extended Syntax

Automatic URL Linking: https://github.com/bytedance/bytemd

~~The world is flat.~~ We now know that the world is round.

- [x] Write the press release
- [ ] Update the website
- [ ] Contact the media

| Syntax    | Description |
| --------- | ----------- |
| Header    | Title       |
| Paragraph | Text        |

## Footnotes

Here's a simple footnote,[^1] and here's a longer one.[^bignote]

[^1]: This is the first footnote.
[^bignote]: Here's one with multiple paragraphs and code.

    Indent paragraphs to include them in the footnote.

    `{ my code }`

    Add as many paragraphs as you like.

## Gemoji

Thumbs up: :+1:, thumbs down: :-1:.

Families: :family_man_man_boy_boy:

Long flags: :wales:, :scotland:, :england:.

## Math Equation

Inline math equation: $a+b$

$$
\\displaystyle \\left( \\sum_{k=1}^n a_k b_k \\right)^2 \\leq \\left( \\sum_{k=1}^n a_k^2 \\right) \\left( \\sum_{k=1}^n b_k^2 \\right)
$$

## Mermaid Diagrams

```mermaid
graph TD;
  A-->B;
  A-->C;
  B-->D;
  C-->D;
```
"""
