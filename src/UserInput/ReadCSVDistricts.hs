module UserInput.ReadCSVDistricts
    (
        readDistricts
    ) where

import Data.Functor ((<&>))
import qualified Data.Vector as V (empty, Vector)
import qualified Data.ByteString.Lazy as BL (readFile)
import qualified Control.Foldl as Fold
import Data.Csv
import Data.Text hiding (empty)

import Turtle (FilePath, fold, ls, testdir, toText, encodeString)

import Data.District (District (..), Coords (..))

readDistricts :: IO [District]
readDistricts = getAllDistrictFilePaths >>= mapM readDistrict

-- Districts are stored in a hierarchy that looks like
-- ./resources/
--    -- fire/
--         -- fire_1.csv
--    -- ross_water/
--         -- ross_water_1.csv
--         -- ross_water_2.csv
--    -- districtType/
--         -- districtName.csv
getAllDistrictFilePaths :: IO [Turtle.FilePath]
getAllDistrictFilePaths = do
    typeDirs <- getAllDistrictTypeDirs
    mapM lsAsList typeDirs <&> Prelude.concat


lsAsList :: Turtle.FilePath -> IO [Turtle.FilePath]
lsAsList fileDir = fold (ls fileDir) Fold.list

getAllDistrictTypeDirs :: IO [Turtle.FilePath]
getAllDistrictTypeDirs = do
    doesResourceDirExist <- testdir "resources"
    if doesResourceDirExist then
        lsAsList "resources"
    else 
        return []


getPartOfPath :: Int -> Turtle.FilePath -> Text
getPartOfPath i filePath = case toText filePath of
    Left decodeAttempt -> decodeAttempt
    Right decodedFilePath -> splitOn "/" decodedFilePath !! i

-- FilePath is resources/districtType/districtName.csv
-- This returns districtType
districtTypeFromFilePath :: Turtle.FilePath -> Text
districtTypeFromFilePath = getPartOfPath 1

-- FilePath is resources/districtType/districtName.csv
-- This returns districtName
districtNameFromFilePath :: Turtle.FilePath -> Text
districtNameFromFilePath = stripFileExtension . getPartOfPath 2

stripFileExtension :: Text -> Text
stripFileExtension = intercalate "." . Prelude.init . splitOn "."

readDistrict :: Turtle.FilePath -> IO District
readDistrict filePath = do
    let districtType = districtTypeFromFilePath filePath
    let districtName = districtNameFromFilePath filePath
    coords <- readDistrictCoords filePath
    return $ District coords districtType districtName

readDistrictCoords :: Turtle.FilePath -> IO (V.Vector Coords)
readDistrictCoords filePath = do
    csvFile <- BL.readFile (encodeString filePath)
    case decodeByName csvFile of
        Left err -> do
            print err
            return V.empty
        Right (_, xs) -> return xs
