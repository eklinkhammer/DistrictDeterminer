module Polygon.PointInDistrict
    (
        isPointInDistrict
    ,   filterDistrictsIfCoord
    ) where

import Data.District (District (..), Coords (..))
import Data.Ext ( ext, type (:+) )
import Data.Geometry.Boundary (PointLocationResult (..))
import Data.Geometry.Point (Point (..))
import Data.Geometry.Polygon
    ( inPolygon, fromPoints, SimplePolygon )
import qualified Data.Vector as V (map, toList)


filterDistrictsIfCoord :: Coords -> [District] -> [District]
filterDistrictsIfCoord coords =  filter (isPointInDistrict coords)


isPointInDistrict :: Coords -> District -> Bool
isPointInDistrict coords district = isInsideOrOnBoundary $ inPolygon point polygon
    where
        point = coordToPoint coords
        polygon = districtToPolygon district

districtToPolygon :: District -> SimplePolygon () Double
districtToPolygon = fromPoints . districtPoints

districtPoints :: District -> [Point 2 Double :+ ()]
districtPoints = V.toList . V.map (ext . coordToPoint) . latLongs

isInsideOrOnBoundary :: PointLocationResult -> Bool
isInsideOrOnBoundary result = case result of
    Inside -> True
    OnBoundary -> True
    Outside -> False

coordToPoint :: Coords -> Point 2 Double
coordToPoint (Coords x y) = Point2 x y