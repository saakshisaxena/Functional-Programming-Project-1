{-# LANGUAGE DeriveGeneric #-}

module Parse (
    parseAbilities,
) where

import Types
import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as L8

parseAbilities :: L8.ByteString -> Either String Abilities
parseAbilities j = eitherDecode j :: Either String Abilities