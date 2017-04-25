module Main exposing (..)

import Scene exposing (renderScene, renderActionLabel, SceneMsg(..))
import Scenes exposing (global_context)
import Markdown
import List exposing (map)
import Dict
import Maybe exposing (withDefault)
import Html exposing (Html, button, div, text, node, ul, li, h1, h2, h3, h4, h5)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, rel, href)


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- Model


type alias Model =
    { currentScene : String
    , global_context : Scenes.GlobalContext
    }


model : Model
model =
    { currentScene = "Broken Circuit Common Room"
    , global_context = global_context
    }


scenes : Scenes.Scenes
scenes = Scenes.scenes


-- Update


visit : String -> Model -> Model
visit sceneName model =
    let
        old_context =
            model.global_context

        num_times_visited =
            withDefault 0 (Dict.get sceneName old_context.times_visited)

        new_times_visited =
            Dict.insert sceneName (num_times_visited + 1) old_context.times_visited

        new_context =
            { old_context | times_visited = new_times_visited }
    in
        { model | global_context = new_context }


update : Scene.SceneMsg -> Model -> Model
update msg model =
    case msg of
        Goto scene ->
            visit scene { model | currentScene = scene }



-- View


css : String -> Html Scene.SceneMsg
css path =
    node "link" [ rel "stylesheet", href path ] []


view : Model -> Html Scene.SceneMsg
view model =
    let
        scene =
            withDefault Scenes.default_scene (Dict.get model.currentScene scenes)
    in
        div
            [ class "container"
            ]
            [ css "./style.css"
            , div
                [ class "scene"
                ]
                [ h2 [] [ text model.currentScene ]
                , Markdown.toHtml [] (renderScene scene model.global_context)
                ]
            , ul
                [ class "actions"
                ]
                (map
                    (\action ->
                        li [] [ button [ onClick (action.action) ] [ text (renderActionLabel action scene model.global_context) ] ]
                    )
                    (scene.actions model.global_context)
                )
            ]
