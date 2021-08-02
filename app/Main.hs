module Main where

import Lib

main :: IO ()
main = do 
    readDistricts >>= mapM_ print
