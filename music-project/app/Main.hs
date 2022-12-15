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
    print "Please enter what pokemon's ability you want to see..."
    poke_id <- getLine :: IO String  
    let url = "https://pokeapi.co/api/v2/pokemon/" ++ poke_id
    print url
    print "Downloading..."
    json <- download url
    print "Parsing..."
    case (parseAbilities json) of
        Left err -> print err
        Right recs -> do
            print "Done parsing"
            
             
