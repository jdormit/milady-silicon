module Main exposing (..)

import Scene
import Markdown
import List exposing (map)
import Dict
import Maybe exposing (withDefault)
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- Model


type alias Model =
    { currentScene : String
    , scenes : Dict.Dict String Scene.Scene
    }


model : Model
model =
    { currentScene = "initial"
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
        Scene.Goto scene ->
            visit scene { model | currentScene = scene }



-- View


view : Model -> Html Scene.SceneMsg
view model =
    div []
        [ div
            []
            [ Markdown.toHtml []
                (let
                    scene =
                        withDefault Scene.defaultScene (Dict.get model.currentScene model.scenes)
                 in
                    scene.text scene.context
                )
            ]
        , div [] (map (\{ label, action } -> button [ onClick (action) ] [ text label ]) (withDefault Scene.defaultScene (Dict.get model.currentScene model.scenes)).actions)
        ]
