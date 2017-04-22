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
    , actions : SceneContext -> List { label : String, action : SceneMsg }
    , text : SceneContext -> String
    }


defaultScene =
    { context = defaultSceneContext
    , actions = \context -> []
    , text = \context -> "ERROR"
    }


scenes =
    Dict.fromList
        [ ("Broken Circuit Common Room"
            => { context =
                    defaultSceneContext
               , text =
                    \context ->
                        case context.times_visited of
                            0 ->
                                """
The Broken Circuit is the largest coffeehouse in Arch. Probably the largest in all of the Silicon
Isles. It squats on the bottom three floors of an ancient skyscraper. Businessmen and nobility
rub elbows with thieves and drug dealers here. Tinkers sell scrap metal, wires, bits of circuitry
from jury-rigged stalls in the coffeehouse's numerous rooms. They say you can buy anything or meet
anyone at the Broken Circuit.

It's a good place to plot a revenge.

You sit in a corner booth in the cavernous common room. Threadbare velvet cushions cover the bench.
A low hum of conversation washes over you as you scan the room, one hand always at the hilt of your
rapier  .

A doorway in the far wall opens onto stairs leading to the higher levels of the Broken Circuit.
Through a curtained archway, a balcony overlooks Arch's jagged skyline.
"""

                            _ ->
                                """
Hookah smoke and fragrant steam blend in the dim common room.

A doorway in the far wall opens onto stairs leading to the higher levels of the Broken Circuit.
Through a curtained archway, a balcony overlooks Arch's jagged skyline.
"""
               , actions =
                    \context ->
                        [ { label = "Go upstairs", action = Goto "Broken Circuit Upper Levels" }
                        , { label = "Go out to the balcony", action = Goto "Sunset over Arch" }
                        ]
               }
          )
        , ("Broken Circuit Upper Levels"
            => { context =
                    defaultSceneContext
               , text =
                    \context ->
                        """
The upper floors of the Broken Circuit are quieter than the common room. Scholars jot notes in the
margins of hand-copied research papers, while fortunes are lost or made in private back rooms
"""
               , actions =
                    \context ->
                        [ { label = "Go down to the common room", action = Goto "Broken Circuit Common Room" }
                        ]
               }
          )
        , ("Sunset over Arch"
            => { context =
                    defaultSceneContext
               , text =
                    \context -> """
The setting sun turns Arch's skyscrapers and tenements into silhouettes. Against the sky's orange
and pink backdrop, you can't tell which of the buildings are sound and which are crumbling into
decay. The river bisects the view. It fractures the sunset into a hundred reflected red-gold sparks.

The ambient sounds of the coffee house seem muted out here. Somewhere in your chest you can feel
the humming of the Machines, deep beneath the streets.
"""
               , actions =
                    \context ->
                        [ { label = "Go back inside", action = Goto "Broken Circuit Common Room" }
                        ]
               }
          )
        ]


type SceneMsg
    = Goto String
