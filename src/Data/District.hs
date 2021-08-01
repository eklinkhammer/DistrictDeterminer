module Data.District 
    ( District (..)
    , Coords (..)
    ) where

import Data.Csv (FromNamedRecord, ToNamedRecord, DefaultOrdered)
import Data.Text (Text)
import Data.Vector (Vector)
import GHC.Generics (Generic)

data District = District {
    latLongs :: Vector Coords,
    districtType :: Text,
    districtName :: Text
} deriving (Show, Eq)

data Coords = Coords {
    x :: Double,
    y :: Double
} deriving (Generic, Show, Eq)

instance FromNamedRecord Coords
instance ToNamedRecord Coords
instance DefaultOrdered Coords
