-- |Module that performs http requests as well as parsing returned html.
module Fetch where

import Data.Maybe
import Data.Either
import Data.Word
import qualified Data.ByteString.Lazy as L
import Control.Exception

import qualified Data.ByteString.Lazy.Char8 as L8
import Network.HTTP.Simple

type URL = String
type HTML = String

downloadURL :: URL -> IO String
downloadURL url = do
    request <- parseRequest url
    response <- httpLBS request
    return $ L8.unpack $ getResponseBody response

-- |Basic method for extracting all urls of a given text (String)
parseURLs :: HTML              -- ^ String representation of html file
          -> [URL]
parseURLs [] = []
parseURLs ('h':'t':'t':'p':':':'/':'/':xs) = ("http://" ++ url) : (parseURLs rest)
   where 
      (url, rest) = break space xs
      space c = elem c [' ','\t','\n','\r','\"','\'',')',';','<']
parseURLs (_:xs) = parseURLs xs

isHTML :: URL -> Bool
isHTML = (==".html"). reverse . (take 5) . reverse 

getHTMLpages :: HTML -> [URL]
getHTMLpages = filter isHTML . parseURLs
