module Trik.Brick where

import Data.Function.Uncurried
import Data.Unit
import Trik.Brick.Keys
import Trik.Brick.Ports
import Trik.Brick.Accelerometer
import Trik.Brick.Battery
import Trik.Brick.Camera
import Trik.Brick.Gyroscope
import Trik.Brick.Motor
import Trik.Brick.Display
import Trik.Brick.LED
import Trik.Brick.Sensor
import Trik.Brick.Encoder

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
    sensors :: Array Sensor
}

foreign import getBrickUncurried :: Fn3 (Array EncoderPort) (Array MotorPort) (Array SensorPort) Brick 
getBrick :: Array EncoderPort -> Array MotorPort -> Array SensorPort -> Brick
getBrick = runFn3 getBrickUncurried

foreign import playSoundUncurried :: Fn2 Brick String Unit
playSound :: Brick -> String -> Unit
playSound = runFn2 playSoundUncurried

foreign import brickStop :: Brick -> Unit

foreign import brickSayUncurried :: Fn2 Brick String Unit
brickSay :: Brick -> String -> Unit
brickSay = runFn2 brickSayUncurried
