module Main where
import Network
import Network.Socket
import System.IO
import System.Environment
import Control.Monad
import Control.Concurrent

main :: IO ()
main = withSocketsDo $ do
 args <- getArgs 
 if args == [] then 
   putStrLn "Usage: ip port"
 else
   rest args

rest args = do
 let portarg = drop 1 args
     port = head $ (drop 1 args) ++ ["21"]
     ip = head args
 when (portarg == []) (putStrLn "using port 21")
 addrInfos <- getAddrInfo Nothing (Just ip) (Just port)
 s <- socket (addrFamily (head addrInfos)) Stream defaultProtocol
 setSocketOption s KeepAlive 1
 connect s (addrAddress (head addrInfos))
 h <- socketToHandle s ReadWriteMode
 hSetBuffering h LineBuffering
 hSetBuffering stdout LineBuffering
 let loop = do {
   ;y <- getLine
   ;hPutStrLn h y
   ;hFlush h
   ;loop
   }
  in forkIO $ loop
 let loop = do {
   ;l <- hGetLine h
   ;putStrLn l
   ;loop
   }
  in loop
 return ()
