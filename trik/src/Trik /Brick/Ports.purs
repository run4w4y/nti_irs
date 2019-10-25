module Trik.Brick.Ports where

data MotorPort
    = MotorPort Int

data SensorPort
    = AnalogPort Int
    | DigitalPort Int

data EncoderPort
    = EncoderPort Int