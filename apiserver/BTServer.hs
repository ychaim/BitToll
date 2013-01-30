{-# LANGUAGE OverloadedStrings #-}
import Network.Wai
import Network.Wai.Handler.Warp (run)
import Network.HTTP.Types (status200)
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString as B
import Data.ByteString.Char8 (split)
import Control.Monad.IO.Class (liftIO)
import BT.Routing

getPathCheck :: B.ByteString -> B.ByteString
getPathCheck path = let splitpath = split '/' path
                    in case length splitpath of
                        0 -> ""
                        1 -> ""
                        _ -> (splitpath !! 1)

application :: Application
application info = do
    let path = rawPathInfo info
    response <- liftIO $ BT.Routing.route path info
    return $
        responseLBS status200 [("Content-Type", "text/plain")] response

main = run 3000 application
