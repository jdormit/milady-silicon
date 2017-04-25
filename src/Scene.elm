module Scene exposing (Scene, SceneMsg(..), renderScene, renderActionLabel)

import Template exposing (Template, template, render)


type alias Action local_context =
    { label : Template local_context
    , action : SceneMsg
    }


type alias Scene local_context global_context =
    { context : global_context -> local_context
    , template : global_context -> Template local_context
    , actions : global_context -> List (Action local_context)
    }


type SceneMsg
    = Goto String


renderScene : Scene local_context global_context -> global_context -> String
renderScene scene global_context =
    render (scene.template global_context) (scene.context global_context)


renderActionLabel : Action local_context -> Scene local_context global_context -> global_context -> String
renderActionLabel action scene global_context =
    render action.label (scene.context global_context)
