module Trik.Sensor where

import Trik.Ports

data Sensor 
    = Sensor { port :: SensorPort }