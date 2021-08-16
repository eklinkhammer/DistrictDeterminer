module Main where

import Data.District (Coords (..))
import Lib ( readDistricts )
import Polygon.PointInDistrict (filterDistrictsIfCoord)
import Turtle

parser :: Parser (Double, Double)
parser = (,) <$> argDouble "lat"  "The latitude of the user address"
             <*> argDouble "long" "The longitude of the user address"
main :: IO ()
main = do
    (lat, long) <- options "Parsing the location of the voter" parser
    districts <- readDistricts
    let midpointCoord = Coords lat long
    let matchDistrict = filterDistrictsIfCoord midpointCoord districts
    putStrLn $ "Looking for which districts location (lat, long): " ++ show lat ++ ", " ++ show long ++ " is in"
    putStrLn "That location is in the following districts:"
    mapM_ print matchDistrict
