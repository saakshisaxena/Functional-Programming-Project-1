-- module Fetch (
--     download
-- ) where

-- import qualified Data.ByteString.Lazy.Char8 as L8
-- import Network.HTTP.Simple
-- import qualified Data.ByteString.Lazy as L

-- type URL = String

--  download :: URL -> IO L8.ByteString
--  download url = do
--      request <- parseRequest url
--      response <- (httpLBS request) `X.catch` statusExceptionHandler
--      case response of x | x == L.empty -> return () 
--                    | otherwise    -> return $ getResponseBody response
    
module Fetch (
    download
) where

import qualified Data.ByteString.Lazy.Char8 as L8
import Network.HTTP.Simple

type URL = String

download :: URL -> IO L8.ByteString
download url = do
    request <- parseRequest url
    response <- httpLBS request
    return $ getResponseBody response


-- statusExceptionHandler ::  HttpException -> IO L.ByteString
-- statusExceptionHandler (StatusCodeException status headers) = 
-- putStr "An error occured during download: "
-- >> (putStrLn $ show status)
-- >> (return L.empty)