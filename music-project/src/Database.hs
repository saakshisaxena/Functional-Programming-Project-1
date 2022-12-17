{-# LANGUAGE OverloadedStrings #-}


-- or, on GHCI:
-- > :set -XOverloadedStrings

module Database (
    initialiseDB,
    -- getOrCreateRecipe,
    saveDrinks,
    queryAllDrinks,
    queryAllDrinksWithName,
    queryAllReceipes
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
            \fk_drinkId INTEGER,\
            \Instructions VARCHAR(80) NOT NULL \
            \)"
        execute_ conn "CREATE TABLE IF NOT EXISTS entries (\
            \id INTEGER PRIMARY KEY AUTOINCREMENT,\
            \idDrink VARCHAR(40) NOT NULL, \
            \name VARCHAR(40) NOT NULL, \
            \mainIngredient VARCHAR(40) NOT NULL, \
            \glass VARCHAR(40) NOT NULL \
            \)"
        return conn


getOrCreateDrink :: Connection -> Drink -> IO Entry
getOrCreateDrink conn drink = do
    results <- queryNamed conn "SELECT * FROM entries WHERE idDrink =:fk_idDrink" [":fk_idDrink" := idDrink drink]   
    if length results > 0 then
        return . head $ results
    else do
        let drinkid = idDrink drink
        putStrLn drinkid
        -- putStrLn  strDrink_ drink
        execute conn "INSERT INTO entries(idDrink, name, mainIngredient, glass) VALUES (?,?,?, ?)" (idDrink drink, strDrink drink, strIngredient1 drink, strGlass drink)
        getOrCreateDrink conn drink

createReceipes :: Connection -> Drink ->  IO ()
createReceipes conn drink = do 
    c <- getOrCreateDrink conn drink
    execute conn "INSERT INTO recipes(fk_drinkId, Instructions) VALUES (?,?)" (id_ c, strInstructions drink)


saveDrinks :: Connection -> [Drink] -> IO ()
saveDrinks conn = mapM_ (createReceipes conn)
    

-- |Method to retrieve all the URLs on the database.
queryAllDrinks :: Connection -> IO [String]
queryAllDrinks conn = do
    results <- query_ conn "SELECT * FROM entries" :: IO [Entry]
    return $ map (\entry -> strDrink_ entry) results

queryAllDrinksWithName :: Connection -> IO [Entry]
queryAllDrinksWithName conn = do 
    putStr "Enter name: > "
    name <- getLine
    putStrLn $ "Looking for " ++ name ++ " entries..."
    let sql = "SELECT * FROM entries WHERE name=?"
    query conn sql [name]

queryAllReceipes :: Connection -> IO [Drink]
queryAllReceipes conn = do 
    -- putStr "Enter name: > "
    -- name <- getLine
    -- putStrLn $ "Looking for " ++ name ++ " entries..."
    let sql = "SELECT entries.idDrink, entries.name, entries.mainIngredient, entries.glass, recipes.Instructions FROM entries,recipes WHERE entries.id = recipes.fk_drinkId"
    results <- query_ conn sql :: IO [Drink]
    return results





