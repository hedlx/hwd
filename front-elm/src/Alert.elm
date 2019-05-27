module Alert exposing (Alert(..), Description, Title, fromHttpError)

import Http


type Alert
    = None
    | Warning Title Description
    | Error Title Description
    | Batch (List Alert)


type alias Title =
    String


type alias Description =
    String


fromHttpError : Http.Error -> Alert
fromHttpError error =
    let
        pleaseCheckConnection =
            "Please check your Internet connection and try again."

        pleaseReport =
            "\n Please, report this issue to developers."
    in
    case error of
        Http.Timeout ->
            Error "Server took to long to respond"
                pleaseCheckConnection

        Http.NetworkError ->
            Error "Network error "
                pleaseCheckConnection

        Http.BadUrl str ->
            Error "Bad request URL"
                (str ++ pleaseReport)

        Http.BadStatus statusCode ->
            Error "Server error"
                (String.fromInt statusCode ++ pleaseReport)

        Http.BadBody str ->
            Error "Bad request body"
                (str ++ pleaseReport)
