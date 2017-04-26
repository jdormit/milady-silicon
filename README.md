# Milady Silicon
> An interactive fiction written in Elm

## Project structure
The app entry point is [`src/Main.elm`](./src/Main.elm). All the scenes are defined in
[`src/Scenes.elm`](./src/Scenes.elm).

## Running the app
To run the development server:

    $ elm reactor

To compile the app to Github pages (make sure to configure the repository settings properly):

    $ elm make --output docs/index.html src/Main.elm

## License
This project is licenced under the [MIT license](./LICENSE.md).
