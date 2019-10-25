module Trik.Brick.Motor where

import Data.Function.Uncurried
import Data.Unit
import Trik.Brick.Ports

data Motor 
    = Motor MotorPort

foreign import motorBrakeUncurried :: Fn2 Motor Int Unit
motorBrake :: Motor -> Int -> Unit
motorBrake = runFn2 motorBrakeUncurried

foreign import getMotorPower :: Motor -> Int

foreign import motorPowerOff :: Motor -> Unit

foreign import setMotorPowerUncurried :: Fn2 Motor Int Unit
setMotorPower :: Motor -> Int -> Unit
setMotorPower = runFn2 setMotorPowerUncurried
