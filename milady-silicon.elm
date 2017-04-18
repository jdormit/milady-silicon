module Main exposing (..)

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
    , scenes : Dict.Dict String { text : String, buttons : List { label : String, goto : String } }
    }


model : Model
model =
    { currentScene = "initial"
    , scenes =
        Dict.fromList
            [ ( "initial"
              , { text =
                    """
                    This is a fascinating story, more magical then Harry Potter, more insightful than Moby Dick,
                    more weighty that War and Peace. It will surely be the next Great American Novel.
                    """
                , buttons =
                    [ { label = "I don't buy it", goto = "little_faith" }
                    , { label = "Cool!", goto = "gratitude" }
                    ]
                }
              )
            , ( "little_faith"
              , { text =
                    """
                        Whatever, bro.
                        """
                , buttons =
                    [ { label = "Go back", goto = "initial" }
                    ]
                }
              )
            , ( "gratitude"
              , { text =
                    """
                        Thanks! Your faith will be rewarded.
                        """
                , buttons =
                    [ { label = "Go back", goto = "initial" }
                    ]
                }
              )
            ]
    }



-- Update


type Msg
    = Goto String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Goto scene ->
            { model | currentScene = scene }



-- View


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text (withDefault { text = "ERROR", buttons = [] } (Dict.get model.currentScene model.scenes)).text ]
        , div [] (map (\{ label, goto } -> button [ onClick (Goto goto) ] [ text label ]) (withDefault { text = "ERROR", buttons = [] } (Dict.get model.currentScene model.scenes)).buttons)
        ]
