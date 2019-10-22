module Trik where

import Data.Either

foreign import readtrik :: Sensor a -> SensorValue a

data Sensor 
    = Accelerometer
    | Ultrasonic
    | Gyroscopre
    | Light

readSensor :: Sensor -> Either Number [Number]
readSensor sen =
    case sen of
        Accelerometer -> Right $ readtrik sen
        Ultrasonic -> Left $ readtrik sen
        Gyroscopre -> Right $ readtrik sen
        Light -> Left $ readtrik sen