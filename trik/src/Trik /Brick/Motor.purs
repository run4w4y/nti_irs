module Trik.Brick.Motor where

import Trik.Brick.Ports

data Motor 
    = Motor { port :: MotorPort }