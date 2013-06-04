{-# LANGUAGE OverloadedStrings #-}
module BT.Routing(route) where

import Data.Map
import BT.EndPoints
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as BL
import Network.Wai (Request)
import BT.Types (PersistentConns)
import Data.Aeson.Encode (encode)
import BT.Log

jstostring :: (Request -> PersistentConns -> IO [(String, String)]) -> Request -> PersistentConns -> IO BL.ByteString
jstostring obj r p= do
    resp <- obj r p
    return . encode . Data.Map.fromList $ resp ++ [("error_code", "0")]

router :: Map B.ByteString (Request -> PersistentConns -> IO BL.ByteString)
router = Data.Map.fromList [
        ("/register",   jstostring BT.EndPoints.register),
        ("/balance",    jstostring BT.EndPoints.getBalance),
        ("/withdraw",   jstostring BT.EndPoints.sendBTC),
        ("/deposit",    jstostring BT.EndPoints.deposit),
        ("/request",    jstostring BT.EndPoints.createPayment),
        ("/mine",       BT.EndPoints.mine),
        ("/",           BT.EndPoints.mine),
        ("/pay",        jstostring BT.EndPoints.makePayment)]

route :: B.ByteString -> Request -> PersistentConns -> IO BL.ByteString
route path info conns = case Data.Map.lookup path router of
                Nothing -> return "{\"error\":\"No Such Method\",\"error_code\":\"1\"}"
                Just a -> do
                    logMsg $ "Handling" ++ show path
                    resp <- a info conns
                    logMsg $ "Handled" ++ show resp
                    return resp
