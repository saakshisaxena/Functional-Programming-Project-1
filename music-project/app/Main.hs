module Main (main) where

import Lib
import Fetch
import Parse

main :: IO ()
main = fetchFunction

fetchFunction = do
    let url = "https://opendata.ecdc.europa.eu/covid19/casedistribution/json/"
    print "Downloading..."
    json <- download url
    print "Parsing..."
    case (parseRecords json) of
        Left err -> print err
        Right recs -> do
            print "Done Parsing"
            main
