module Trik.Brick where

import Data.Function.Uncurried
import Trik.Keys
import Trik.Ports
import Trik.Accelerometer
import Trik.Battery
import Trik.Camera
import Trik.Gyroscope
import Trik.Motor
import Trik.Display
import Trik.LED
import Trik.Sensor
import Trik.Encoder

data Brick = Brick {
    accelerometer :: Accelerometer,
    battery :: Battery,
    colorSensor :: ColorSensor,
    display :: Display,
    gyroscope :: Gyroscope,
    keys :: Keys,
    led :: LED,
    encoders :: Array Encoder,
    motors :: Array Motor,
    ports :: Array Port
}

-- foreign import playSoundUncurried :: Fn2 Brick String Number

-- playSound :: Brick -> String -> Number
-- playSound = runFn2 playSoundUncurried

-- foreign import getMotor :: Port -> Motor
-- foreign import readAccelerometer :: Accelerometer -> AccelerometerValue
-- foreign import readSensor :: Sensor -> SensorValue
-- foreign import readEncoder :: Encoder -> EncoderValueв
