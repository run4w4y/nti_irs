module Main where

import Prelude
import Data.Function.Uncurried
import Trik.Brick
import Trik.Ports

solution :: Unit -> Unit
solution n = do
    let brick = getBrick 
                    [EncoderPort 1, EncoderPort 2]
                    [MotorPort 1, MotorPort 2]
                    [SensorPort 1, SensorPort 2]
    brickStop brick

main = solution
