module Main where
import Network
import Network.Socket
import System.IO

main :: IO ()
main = withSocketsDo $ do
 addrInfos <- getAddrInfo Nothing (Just "127.0.0.1") (Just "4243")
 s <- socket (addrFamily (head addrInfos)) Stream defaultProtocol
 setSocketOption s KeepAlive 1
 connect s (addrAddress (head addrInfos))
 h <- socketToHandle s ReadWriteMode
 hSetBuffering h (BlockBuffering Nothing)
 let loop = do
   l <- hGetLine h
   putStrLn l
