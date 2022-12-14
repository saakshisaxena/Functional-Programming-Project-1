module Main (main) where

import Lib
import Fetch
import Parse

main :: IO ()
main = fetchFunction

fetchFunction = do
    print "Please enter what pokemon's ability you want to see..."
    poke_id <- getLine  
    let url = "https://pokeapi.co/api/v2/pokemon/" ++ poke_id
    print url
    print "Downloading..."
    json <- download url
    print "Parsing..."
    case (parseAbilities json) of
        Left err -> print err
        Right recs -> do
            print "Done Parsing"
            -- main
