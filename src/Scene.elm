module Scene exposing (scenes, Scene, SceneMsg(..), defaultScene)

import Dict


-- The => infix operator creates a new tuple from its arguments.
-- This gives a nicer syntax for creating a Dict from a definition list.


(=>) : a -> b -> ( a, b )
(=>) a b =
    ( a, b )


type alias SceneContext =
    { times_visited : Int
    }


defaultSceneContext =
    { times_visited = 0
    }


type alias Scene =
    { context : SceneContext
    , actions : List { label : String, action : SceneMsg }
    , text : SceneContext -> String
    }


defaultScene =
    { context = defaultSceneContext
    , actions = []
    , text = \context -> "ERROR"
    }


scenes =
    Dict.fromList
        [ ("initial"
            => { context =
                    defaultSceneContext
               , text =
                    \context -> """
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
                    defaultSceneContext
               , text =
                    \context ->
                        case context.times_visited of
                            1 ->
                                "Whatever, bro"

                            2 ->
                                "Seriously, again?"

                            _ ->
                                "I'm done with you."
               , actions =
                    [ { label = "Go back", action = Goto "initial" }
                    ]
               }
          )
        , ("gratitude"
            => { context =
                    defaultSceneContext
               , text =
                    \context -> """
Thanks! Your faith will be rewarded.
"""
               , actions =
                    [ { label = "Go back", action = Goto "initial" }
                    ]
               }
          )
        ]


type SceneMsg
    = Goto String
