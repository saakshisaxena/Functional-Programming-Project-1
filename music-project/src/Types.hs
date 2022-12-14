{-# LANGUAGE DeriveGeneric #-}

module Types (
    Entry (..),
    Ability (..),
    AbilityProxi (..),
    Abilities (..)
) where

import GHC.Generics

import Database.SQLite.Simple.FromRow
import Database.SQLite.Simple.ToRow

import Data.Aeson

data Entry = Entry {
    -- pokId_ :: Int,
    name_ :: String,
    url_ :: String
} deriving (Show)

data Ability = Ability {
    -- pokId :: Int,
    name :: String,
    url :: String
    -- population :: Maybe Int
} deriving (Show, Generic)

data AbilityProxi = AbilityProxi {
    ability :: Ability
} deriving (Show, Generic)

data Abilities = Abilities {
    abilities :: [AbilityProxi]
} deriving (Show, Generic)

{-- Making above datatype instances of FromRow and ToRow type classes --}

instance FromRow Entry where
    fromRow = Entry <$> field <*> field

instance ToRow Entry where
    toRow (Entry na ur)
        = toRow (na, ur)

instance FromRow Ability where
    fromRow = Ability <$> field <*> field

instance ToRow Ability where
    toRow (Ability na ur)
        = toRow (na, ur)

{-- Making above datatype instances of FromJSON type class --}

renameFields :: String -> String
renameFields other = other

customOptions :: Options
customOptions = defaultOptions {
    fieldLabelModifier = renameFields
}

instance FromJSON Ability where
    parseJSON = genericParseJSON customOptions

instance FromJSON AbilityProxi
instance FromJSON Abilities
