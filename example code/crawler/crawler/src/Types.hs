{-# LANGUAGE DeriveGeneric #-}

module Types (
    Entry (..),
) where

import GHC.Generics

import Database.SQLite.Simple.FromRow
import Database.SQLite.Simple.ToRow

data Entry = Entry {
        url_ :: String,
        processed_ :: Bool
    } deriving (Show)

-- See more Database.SQLite.Simple examples at
-- https://hackage.haskell.org/package/sqlite-simple-0.4.18.0/docs/Database-SQLite-Simple.html

instance FromRow Entry where
    fromRow = Entry <$> field <*> field

instance ToRow Entry where
    toRow (Entry u p) = toRow (u, p)
