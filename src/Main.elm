module Main exposing (..)

import Scene exposing (SceneMsg(..))
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
    , scenes : Dict.Dict String Scene.Scene
    }


model : Model
model =
    { currentScene = "Broken Circuit Common Room"
    , scenes = Scene.scenes
    }



-- Update


visit : String -> Model -> Model
visit sceneName model =
    case Dict.get sceneName model.scenes of
        Just scene ->
            let
                oldContext =
                    scene.context

                newContext =
                    { oldContext | times_visited = oldContext.times_visited + 1 }
            in
                { model | scenes = (Dict.insert sceneName { scene | context = newContext } model.scenes) }

        Nothing ->
            model


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
            withDefault Scene.defaultScene (Dict.get model.currentScene model.scenes)
    in
    div [ class "container"
        ]
        [ css "./style.css" 
        , div
            [ class "scene"
            ]
            [ h2 [] [ text model.currentScene ]
            , Markdown.toHtml [] (scene.text scene.context)
            ]
        , ul
            [ class "actions"
            ]
            (map
                (\{ label, action } ->
                    li [] [ button [ onClick (action) ] [ text label ] ]
                )
                (scene.actions scene.context)
            )
        ]
