{-# LANGUAGE DeriveGeneric #-}

module Parse (
    parseRecords,
) where

import Types
import Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as L8

parseRecords :: L8.ByteString -> Either String Records
parseRecords j = eitherDecode j :: Either String Records