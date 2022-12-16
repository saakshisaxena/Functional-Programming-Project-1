{-# LANGUAGE DeriveGeneric #-}

module Types (
    Entry (..),
    Recipes (..),
    Drink (..),
    Drinks (..)
) where

import GHC.Generics

import Database.SQLite.Simple.FromRow
import Database.SQLite.Simple.ToRow

import Data.Aeson

data Entry = Entry {
    -- pokId_ :: Int,
    -- name_ :: String,
    -- url_ :: String
    idDrink_ :: String,
    strDrink_ :: String,
    strIngredient1_ :: String,
    strGlass_ :: String
} deriving (Show)

data Recipes = Recipes {
    idDrinks :: String,
    strInstructions_ :: String
} deriving (Show)

data Drink = Drink {
    idDrink :: String,
    strDrink :: String,
    strIngredient1 :: String,
    strGlass :: String,
    strInstructions :: String
    -- population :: Maybe Int
} deriving (Show, Generic)

data Drinks = Drinks {
    drinks :: [Drink]
} deriving (Show, Generic)

{-- Making above datatype instances of FromRow and ToRow type classes --}

instance FromRow Entry where
    fromRow = Entry <$> field <*> field <*> field <*> field

instance ToRow Entry where
    toRow (Entry d n m g)
        = toRow (d, n, m, g)

instance FromRow Drink where
    fromRow = Drink <$> field <*> field <*> field <*> field  <*> field

instance ToRow Drink where
    toRow (Drink d n m g i)
        = toRow (d, n, m, g, i)

instance FromRow Recipes where
    fromRow = Recipes <$> field <*> field

instance ToRow Recipes where
    toRow (Recipes d i)
        = toRow (d, i)

{-- Making above datatype instances of FromJSON type class --}

renameFields :: String -> String
renameFields "idDrink" = "idDrink"
renameFields "name" = "strDrink" 
renameFields "mainIngredient" = "strIngredient1" 
renameFields "glass" = "strGlass"
renameFields other = other

customOptions :: Options
customOptions = defaultOptions {
    fieldLabelModifier = renameFields
}

instance FromJSON Drink where
    parseJSON = genericParseJSON customOptions

instance FromJSON Drinks
