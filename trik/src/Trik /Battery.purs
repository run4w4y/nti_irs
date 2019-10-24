module Trik.Battery where

type BatteryValue = Number
data Battery 
    = Battery

-- foreign import readVolatage :: Battery -> BatteryValue