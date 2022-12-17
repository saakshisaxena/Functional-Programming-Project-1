{-# LANGUAGE OverloadedStrings #-}


-- |Database initialization

module Database (
    initialiseDB,
    saveDrinks,
    queryAllDrinks,
    queryAllDrinksWithName,
    queryAllReceipes
) where

import Types
import Database.SQLite.Simple

-- |Method to create our two tables 

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

-- |Method to insert id, name, ingredient and glass values into the first table 
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

-- |Method to insert id and instructions values into the second table
createReceipes :: Connection -> Drink ->  IO ()
createReceipes conn drink = do 
    c <- getOrCreateDrink conn drink
    execute conn "INSERT INTO recipes(fk_drinkId, Instructions) VALUES (?,?)" (id_ c, strInstructions drink)

-- |Method to save Drinks table
saveDrinks :: Connection -> [Drink] -> IO ()
saveDrinks conn = mapM_ (createReceipes conn)
    

-- |Method to retrieve all the URLs on the database.
queryAllDrinks :: Connection -> IO [String]
queryAllDrinks conn = do
    results <- query_ conn "SELECT * FROM entries" :: IO [Entry]
    return $ map (\entry -> strDrink_ entry) results

-- |Method to get information for a drink name
queryAllDrinksWithName :: Connection -> IO [Entry]
queryAllDrinksWithName conn = do 
    putStr "Enter name: > "
    name <- getLine
    putStrLn $ "Looking for " ++ name ++ " entries..."
    let sql = "SELECT * FROM entries WHERE name=?"
    query conn sql [name]

-- |Method to display both tables by linking them with foreign key
queryAllReceipes :: Connection -> IO [Drink]
queryAllReceipes conn = do 
    let sql = "SELECT entries.idDrink, entries.name, entries.mainIngredient, entries.glass, recipes.Instructions FROM entries,recipes WHERE entries.id = recipes.fk_drinkId"
    results <- query_ conn sql :: IO [Drink]
    return results





