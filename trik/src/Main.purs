module Main where

import Prelude
import Data.Function.Uncurried
import Trik.Brick
import Trik.Brick.Ports
import Trik.Brick.Motor
import Data.Traversable

solution :: Unit -> Unit
solution n = do
    let brick = getBrick 
                    [EncoderPort 1, EncoderPort 2]
                    [MotorPort 1, MotorPort 2]
                    []
    map ((flip setMotorPower) 90) $ brick.motors

main = solution
