module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h1, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Task
import Time


main =
    Browser.element
        { init = init, update = update, subscriptions = subscriptions, view = view }



-- MODEL


type alias Model =
    { time : Time.Posix
    , zone : Time.Zone
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model (Time.millisToPosix 0) Time.utc
    , Task.perform AdjustTimeZone Time.here
    )



-- UPDATE


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick value ->
            ( { model | time = value }, Cmd.none )

        AdjustTimeZone value ->
            ( { model | zone = value }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick



-- VIEW


view : Model -> Html Msg
view model =
    let
        hour =
            String.fromInt (Time.toHour model.zone model.time)

        minute =
            String.fromInt (Time.toMinute model.zone model.time)

        second =
            String.fromInt (Time.toSecond model.zone model.time)
    in
    div [ class "box is-radiusless has-text-centered" ]
        [ h1 [ class "title is-1" ]
            [ text (hour ++ ":" ++ minute ++ ":" ++ second)
            ]
        ]
