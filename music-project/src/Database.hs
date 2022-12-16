{-# LANGUAGE OverloadedStrings #-}


-- or, on GHCI:
-- > :set -XOverloadedStrings

module Database (
    initialiseDB,
    -- getOrCreateRecipe,
    saveDrinks,
    queryAllDrinks
    -- queryCountryAllEntries, -- queries
    -- queryCountryTotalCases -- queries
) where

import Types
import Database.SQLite.Simple

-- See more Database.SQLite.Simple examples at
-- https://hackage.haskell.org/package/sqlite-simple-0.4.18.0/docs/Database-SQLite-Simple.html

initialiseDB :: IO Connection
initialiseDB = do
        conn <- open "cocktail.sqlite"
        execute_ conn "CREATE TABLE IF NOT EXISTS recipes (\
            \id INTEGER PRIMARY KEY AUTOINCREMENT,\
            \fk_idDrink INTEGER,\
            \Instructions VARCHAR(80) NOT NULL \
            \)"
        execute_ conn "CREATE TABLE IF NOT EXISTS entries (\
            \idDrink VARCHAR(40) NOT NULL, \
            \name VARCHAR(40) NOT NULL, \
            \mainIngredient VARCHAR(40) NOT NULL, \
            \glass VARCHAR(40) NOT NULL \
            \)"
        return conn

        

createDrink :: Connection -> Drink -> IO ()
createDrink conn drink = do
    -- c <- getOrCreateRecipe conn (idDrink drink) (strInstructions drink) 
    let entry = Entry {
        idDrink_ = idDrink drink,
        strDrink_ = strDrink drink,
        strIngredient1_ = strIngredient1 drink,
        strGlass_ = strGlass drink
    }
    return ()

saveDrinks :: Connection -> [Drink] -> IO ()
saveDrinks conn = mapM_ (createDrink conn)
    

-- |Method to retrieve all the URLs on the database.
queryAllDrinks :: Connection -> IO [String]
queryAllDrinks conn = do
    results <- query_ conn "SELECT name FROM entries" :: IO [Entry]
    return $ map (\entry -> strDrink_ entry) results
    -- let sql = "SELECT * FROM entries"
    -- query conn sql
    -- drinknames <- queryAllDrinks conn
    -- return drinknames


-- getOrCreateRecipe :: Connection -> String -> String -> Maybe Int -> IO Recipes
-- getOrCreateRecipe conn coun cont pop = do
--     results <- queryNamed conn "SELECT * FROM receipes WHERE idDrinks=:idDrinks AND strInstructions=:strInstructions" [":idDrinks" := idD, ":strInstructions" := instr]    
--     if length results > 0 then
--         return . head $ results
--     else do
--         execute conn "INSERT INTO recipes (idDrinks, strInstructions) VALUES (?, ?)" (idD, instr)
--         getOrCreateRecipe conn idD instr
