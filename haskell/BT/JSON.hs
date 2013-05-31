module BT.JSON (getRequestMap, verifyMap) where 
import BT.Types
import BT.Util
import BT.User
import Control.Exception (throw)
import Crypto.Hash.MD5
import Data.Aeson (decode)
import Data.List (sortBy)
import Data.Hex (hex)
import Data.Char (toUpper)
import Data.Map (Map, toList)
import Network.Wai (Request)
import qualified Data.ByteString.Char8 as BC

getRequestMap :: Request -> IO (Map String String)
getRequestMap req = do
    body <- getRequestBody req
    let obj = decode body :: Maybe (Map String String)
    return $ getMaybe (UserException "Invalid Json Object") obj

verifyMap :: PersistentConns -> Map String String -> IO ()
verifyMap conn mapd = do
    let al = toList mapd
    let signWrap = lookup "sign" al
    let sign = getMaybe (UserException "no sign") signWrap
    let al_minus_sign = filter (\s -> fst s /= "sign") al
    let username = BC.pack $ getMaybe (UserException "Missing username field") $ lookup "username" al
    secretWrap <- get_user_secret conn username
    let secret = BC.unpack $ getMaybe (UserException "Invalid User") secretWrap
    if not $ validateSign al_minus_sign sign secret
    then throw $ UserException "Invalid Sign"
    else return ()

keyComp :: (String, String) -> (String, String) -> Ordering
keyComp a b = compare (fst a) (fst b)

validateSign :: [(String, String)] -> String -> String -> Bool
validateSign sec_rec sign secret = (BC.pack $ map toUpper sign) == (hex $ hash $ BC.pack $ concat $ (map snd sort_sec_rec) ++ [secret])
    where sort_sec_rec = sortBy keyComp sec_rec


