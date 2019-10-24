module Trik.Motor where

import Trik.Ports

data Motor 
    = Motor { port :: MotorPort }