module Main where

import Prelude
import Data.Function.Uncurried
import Effect
import Effect.Aff
import Trik.Brick
import Trik.Brick.Ports
import Trik.Brick.Motor

brick :: Brick
brick = getBrick 
            [EncoderPort 1, EncoderPort 2]
            [PowerMotorPort 1, PowerMotorPort 2]
            []

solution :: Effect Unit
solution = do
    foreachE brick.motors $ (flip setMotorPower) 90

main = solution
