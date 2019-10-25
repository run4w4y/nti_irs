module Trik.Brick.Gyroscope where

type GyroscopeValue = Array Number
data Gyroscope 
    = Gyroscope

-- foreign import readGyro :: Gyroscope -> GyroscopeValue