{-# LANGUAGE OverloadedStrings #-}


-- or, on GHCI:
-- > :set -XOverloadedStrings

module Database (
    initialiseDB,
    -- getOrCreateCountry,
    -- saveAbilities,
    -- queryCountryAllEntries, -- queries
    -- queryCountryTotalCases -- queries
) where

import Types
import Database.SQLite.Simple

-- See more Database.SQLite.Simple examples at
-- https://hackage.haskell.org/package/sqlite-simple-0.4.18.0/docs/Database-SQLite-Simple.html

initialiseDB :: IO Connection
initialiseDB = do
        conn <- open "pokemon.sqlite"
        -- execute_ conn "CREATE TABLE IF NOT EXISTS countries (\
        --     \id INTEGER PRIMARY KEY AUTOINCREMENT,\
        --     \country VARCHAR(80) NOT NULL, \
        --     \continent VARCHAR(50) NOT NULL, \
        --     \population INT DEFAULT NULL \
        --     \)"  ENTRIED HAS Pokemon id, name of the ability  and url of that ability
        execute_ conn "CREATE TABLE IF NOT EXISTS entries (\
            \name VARCHAR(40) NOT NULL, \
            \url VARCHAR(40) NOT NULL\
            

          \)"
        return conn

createAbility :: Connection -> Ability -> IO ()
createAbility conn ability = do
    let entry = Entry {
        name_ = name ability,
        url_ = url ability
    }
    return ()

saveAbilities :: Connection -> [Ability] -> IO ()
saveAbilities conn = mapM_ (createAbility conn)
    

-- getOrCreateCountry :: Connection -> String -> String -> Maybe Int -> IO Country
-- getOrCreateCountry conn coun cont pop = do
--     results <- queryNamed conn "SELECT * FROM countries WHERE country=:country AND continent=:continent" [":country" := coun, ":continent" := cont]    
--     if length results > 0 then
--         return . head $ results
--     else do
--         execute conn "INSERT INTO countries (country, continent, population) VALUES (?, ?, ?)" (coun, cont, pop)
--         getOrCreateCountry conn coun cont pop

-- createAbility :: Connection -> Ability -> IO ()
-- createAbility conn Ability = do
--     c <- getOrCreateCountry conn (country record) (continent record) (population record)
--     let entry = Entry {
--         date_ = date record,
--         day_ = day record,
--         month_ = month record,
--         year_ = year record,
--         cases_ = cases record,
--         deaths_ = deaths record,
--         fk_country = id_ c
--     }
--     execute conn "INSERT INTO entries VALUES (?,?,?,?,?,?,?)" entry

-- saveAbilities :: Connection -> [Ability] -> IO ()
-- saveAbilities conn = mapM_ (createAbility conn)

-- queryCountryAllEntries :: Connection -> IO [Record]
-- queryCountryAllEntries conn = do
--     putStr "Enter country name > "
--     countryName <- getLine
--     putStrLn $ "Looking for " ++ countryName ++ " entries..."
--     let sql = "SELECT date, day, month, year, cases, deaths, country, continent, population FROM entries inner join countries on entries.fk_country == countries.id WHERE country=?"
--     query conn sql [countryName]

-- queryCountryTotalCases :: Connection -> IO ()
-- queryCountryTotalCases conn = do
--     countryEntries <- queryCountryAllEntries conn
--     let total = sum (map cases countryEntries)
--     print $ "Total entries: " ++ show(total)
-- createAbility : : Connection -> entries -> IO()
