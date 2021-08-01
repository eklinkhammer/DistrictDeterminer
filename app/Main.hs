module Main where

import qualified Data.Vector as V
import qualified Data.ByteString.Lazy as BL
import qualified Control.Foldl as Fold
import Data.Csv
import GHC.Generics (Generic)
import Data.Text hiding (empty)

import Lib
import Turtle hiding (x, err, f)

data District = District {
    latLongs :: V.Vector Coords,
    districtType :: Text,
    districtName :: Text
} deriving (Show, Eq)

data Coords = Coords {
    x :: Int,
    y :: Int
} deriving (Generic, Show, Eq)

instance FromNamedRecord Coords
instance ToNamedRecord Coords
instance DefaultOrdered Coords

file :: String
file = "resources/example_type/example_district_1.csv"

lsAsList :: Turtle.FilePath -> IO [Turtle.FilePath]
lsAsList fileDir = fold (ls fileDir) Fold.list

getAllDistrictTypeDirs :: IO [Turtle.FilePath]
getAllDistrictTypeDirs = do
    doesResourceDirExist <- testdir "resources"
    if doesResourceDirExist then
        lsAsList "resources"
    else 
        return []

getAllDistricts :: IO [[Turtle.FilePath]]
getAllDistricts = do
    typeDirs <- getAllDistrictTypeDirs :: IO [Turtle.FilePath]
    mapM lsAsList typeDirs

readableFilePath :: Turtle.FilePath -> Maybe Text
readableFilePath filePath = case toText filePath of
    Left _ -> Nothing
    Right decodedFilePath -> Just decodedFilePath

getPartOfPath :: Int -> Turtle.FilePath -> Text
getPartOfPath i filePath = case readableFilePath filePath of
    Nothing -> ""
    (Just path) -> (splitOn "/" path) !! i

districtTypeFromFilePath :: Turtle.FilePath -> Text
districtTypeFromFilePath = getPartOfPath 1

districtNameFromFilePath :: Turtle.FilePath -> Text
districtNameFromFilePath = getPartOfPath 2

readDistrict :: Turtle.FilePath -> IO District
readDistrict filePath = do
    let districtType = districtTypeFromFilePath filePath
    let districtName = districtNameFromFilePath filePath
    f <- BL.readFile (encodeString filePath)
    case decodeByName f of
        Left err -> do
            print err
            return $ District V.empty districtType districtName
        Right (_, xs) -> return $ District xs districtType districtName

getAllOfTheDistricts :: IO [District]
getAllOfTheDistricts = do
    districtFiles <- getAllDistricts
    let listFiles = Prelude.concat districtFiles
    districts <- mapM readDistrict listFiles
    return districts

main :: IO ()
main = do 
    someFunc
    pwd >>= print
    getAllDistrictTypeDirs >>= print
    fold (ls "resources") Fold.list >>= print
    let cmd = "ls resources"
    districtTypes <- shell cmd empty
    case districtTypes of
        ExitSuccess -> return ()
        ExitFailure n -> die (cmd <> " failed with exit code: " <> repr n)
    f <- BL.readFile file
    case decodeByName f of
        Left err -> print err
        Right (_, xs) -> V.forM_ xs $ \(Coords x y) -> print (x, y)
    getAllOfTheDistricts >>= mapM_ print
