module Main exposing (..)

import Scene exposing (renderScene, renderActionLabel, Msg(..))
import Scenes exposing (global_context)
import Markdown
import List exposing (map)
import Dict
import Maybe exposing (withDefault)
import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, rel, href)


main =
    Html.program 
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



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

init : (Model, Cmd Scene.Msg)
init =
    (model, Cmd.none)

scenes : Scenes.Scenes
scenes = Scenes.scenes


-- Subscriptions


subscriptions : Model -> Sub Scene.Msg
subscriptions model =
    Sub.none

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


update : Scene.Msg -> Model -> (Model, Cmd Scene.Msg)
update msg model =
    case msg of
        Goto scene ->
            (visit scene { model | currentScene = scene }, Cmd.none)



-- View


css : String -> Html Scene.Msg
css path =
    node "link" [ rel "stylesheet", href path ] []


view : Model -> Html Scene.Msg
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
                (List.map
                    (\action ->
                        li [] [ button [ onClick (action.action) ] [ text (renderActionLabel action scene model.global_context) ] ]
                    )
                    (scene.actions model.global_context)
                )
            ]
