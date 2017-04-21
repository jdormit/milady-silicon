module Main exposing (..)

import List exposing (map)
import Dict
import Maybe exposing (withDefault)
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


-- The => infix operator creates a new tuple from its arguments.
-- This gives a nicer syntax for creating a Dict from a definition list.


(=>) : a -> b -> ( a, b )
(=>) a b =
    ( a, b )


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- Model


type alias SceneContext =
    { times_visited : Int
    }


defaultSceneContext =
    { times_visited = 0
    }


type alias Scene =
    { context : SceneContext
    , actions : List { label : String, action : Msg }
    , text : SceneContext -> String
    }


defaultScene =
    { context = defaultSceneContext
    , actions = []
    , text = \context -> "ERROR"
    }


type alias Model =
    { currentScene : String
    , scenes : Dict.Dict String Scene
    }


scenes =
    Dict.fromList
        [ ("initial"
            => { context =
                    { times_visited = 0
                    }
               , text =
                    \context ->
                        """
                        This is a fascinating story, more magical then Harry Potter, more insightful than
                        Moby Dick, more weighty that War and Peace. It will surely be the next Great
                        American Novel.

                        Visted """ ++ toString context.times_visited ++ """ times
                        """
               , actions =
                    [ { label = "I don't buy it", action = Goto "little_faith" }
                    , { label = "Cool!", action = Goto "gratitude" }
                    ]
               }
          )
        , ("little_faith"
            => { context =
                    { times_visited = 0
                    }
               , text =
                    \context ->
                        """
                        Whatever, bro.
                        """
               , actions =
                    [ { label = "Go back", action = Goto "initial" }
                    ]
               }
          )
        , ("gratitude"
            => { context =
                    { times_visited = 0
                    }
               , text =
                    \context ->
                        """
                        Thanks! Your faith will be rewarded.
                        """
               , actions =
                    [ { label = "Go back", action = Goto "initial" }
                    ]
               }
          )
        ]


model : Model
model =
    { currentScene = "initial"
    , scenes = scenes
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


type Msg
    = Goto String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Goto scene ->
            visit scene { model | currentScene = scene }



-- View


view : Model -> Html Msg
view model =
    div []
        [ div
            []
            [ text
                (let
                    scene =
                        withDefault defaultScene (Dict.get model.currentScene model.scenes)
                 in
                    scene.text scene.context
                )
            ]
        , div [] (map (\{ label, action } -> button [ onClick (action) ] [ text label ]) (withDefault defaultScene (Dict.get model.currentScene model.scenes)).actions)
        ]
