module Main (main) where

import System.IO
import Types
import Fetch
import Parse
import Database

main :: IO ()
main = fetchFunction

fetchFunction = do
    putStrLn "-----------------------------------------------"
    putStrLn "  Welcome to the Cocktail Margarita data app  "
    putStrLn "  (1) Download data                           "
    putStrLn "  (2) All margarita cocktail names            "
    putStrLn "  (3) Quit                                    "
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
        3 -> print "Byee! Drink safely~"
        _ -> print "Invalid option"
        
             
