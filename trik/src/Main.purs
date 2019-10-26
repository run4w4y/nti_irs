module Main where

import Prelude
import Data.Array
import Data.Maybe
import Trik
import Trik.Brick
import Trik.Brick.Ports
import Trik.Brick.Motor

brick :: Brick
brick = getBrick 
            [EncoderPort 1, EncoderPort 2]
            [PowerMotorPort 1, PowerMotorPort 2]
            []

solution :: Array Unit
solution = do [
    (flip setMotorPower) 90 $ fromJust $ brick.motors !! 0,
    (flip setMotorPower) 90 $ fromJust $ brick.motors !! 1,
    unit
]

main = solution
