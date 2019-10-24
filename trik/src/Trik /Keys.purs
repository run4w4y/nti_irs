module Trik.Keys where

data Keys
    = Keys

data Key
    = Left
    | Up
    | Down
    | Enter
    | Right
    | Power
    | Esc

getKeyCode :: Key -> Int
getKeyCode key = 
    case key of
        Left -> 105
        Up -> 103
        Down -> 108
        Enter -> 28
        Right -> 106
        Power -> 116
        Esc -> 1