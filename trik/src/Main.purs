module Main where

import Prelude
import Data.Function.Uncurried
import Trik.Brick
import Trik.Brick.Ports
import Trik.Brick.Motor

solution :: Unit -> Unit
solution n = do
    let brick = getBrick 
                    [EncoderPort 1, EncoderPort 2]
                    [PowerMotorPort 1, PowerMotorPort 2]
                    []
    map ((flip setMotorPower) 90) $ brick.motors

main = solution
