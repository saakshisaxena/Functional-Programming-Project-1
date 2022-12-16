{-# LANGUAGE DeriveGeneric #-}

module Parse (
    parseCocktails,
) where

import Types
import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as L8

parseCocktails :: L8.ByteString -> Either String Drinks
parseCocktails j = eitherDecode j :: Either String Drinks