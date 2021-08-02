module Polygon.PointInDistrictSpec (spec) where

    import Test.Hspec
    -- import Polygon.PointInDistrict (isPointInDistrict)

    spec :: Spec
    spec = do 
        describe "isPointInDistrict" $ do
            it "square district" $ do
                True `shouldBe` False