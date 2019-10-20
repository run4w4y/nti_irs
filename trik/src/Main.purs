module Main where

import Prelude

import Trik

solution :: forall a. a -> Number
solution n = do
    readAccelerometer 1 

main = solution
