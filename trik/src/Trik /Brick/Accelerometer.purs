module Trik.Brick.Accelerometer where

type AccelerometerValue = Array Number
data Accelerometer 
    = Accelerometer

-- foreign import readAccelerometer :: Accelerometer -> AccelerometerValue