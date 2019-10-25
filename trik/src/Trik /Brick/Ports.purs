module Trik.Brick.Ports where

data MotorPort
    = PowerMotorPort Int
    | ServoMororPort Int

data SensorPort
    = AnalogPort Int
    | DigitalPort Int

data EncoderPort
    = EncoderPort Int