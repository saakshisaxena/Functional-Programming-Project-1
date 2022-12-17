module Main (main) where

import System.IO
import Types
import Fetch
import Parse
import Database
import Control.Exception

main :: IO ()
main = fetchFunction

fetchFunction = do
    putStrLn "-----------------------------------------------"
    putStrLn "  Welcome to the Cocktail Margarita data app  "
    putStrLn "  (1) Download data                           "
    putStrLn "  (2) All margarita cocktail names            "
    putStrLn "  (3) Enter drink name                        "
    putStrLn "  (4) View all recipes                        "
    putStrLn "  (5) Quit                                    "
    putStrLn "----------------------------------------------"
    conn <- initialiseDB
    hSetBuffering stdout NoBuffering
    putStr "Choose an option > "
    option <- readLn :: IO Int
    case option of
        1 -> do 
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
                    main
        2 -> do
            print "Query"
            drinknames <- queryAllDrinks conn
            print drinknames
            print "Done"
            main
        3 -> do
            print "Query"
            entries <- queryAllDrinksWithName conn
            print entries
            print "Done"
            main
        4 -> do
            entries <- queryAllReceipes conn
            print entries
            main
        5 -> print "Bye!"
        _ -> throw SyntaxError
        
             
