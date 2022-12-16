module Main (main) where

import System.IO
import Types
import Fetch
import Parse
import Database

main :: IO ()
main = fetchFunction

fetchFunction = do
    conn <- initialiseDB
    hSetBuffering stdout NoBuffering
    -- print "Please enter what pokemon's ability you want to see..."
    -- poke_id <- getLine :: IO String  
    let url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=margarita"
    print url
    print "Downloading..."
    json <- download url
    print "Parsing..."
    case (parseCocktails json) of
        Left err -> print err
        Right recs -> do
            print "Saving on DB..."
            saveDrinks conn (drinks recs)
            print "Saved!"
            print "Query"
            drinknames <- queryAllDrinks conn
            print drinknames
            print "Done"
             
