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
 if null args then
   putStrLn "Usage: ip port"
 else
   rest args

rest args = do
 let portarg = drop 1 args
     port = head $ drop 1 args ++ ["21"]
     ip = head args
 when (null portarg) (putStrLn "using port 21")
 addrInfos <- getAddrInfo Nothing (Just ip) (Just port)
 s <- socket (addrFamily (head addrInfos)) Stream defaultProtocol
 setSocketOption s KeepAlive 1
 connect s (addrAddress (head addrInfos))
 h <- socketToHandle s ReadWriteMode
 hSetBuffering h LineBuffering
 hSetBuffering stdout LineBuffering
 forkIO $ forever $ do
   y <- getLine
   hPutStrLn h y
   hFlush h
 whileM_ (fmap not $hIsEOF h) $ do
   l <- hGetLine h
   putStrLn l



-- |Execute an action repeatedly as long as the given boolean expression
-- returns True.  The condition is evaluated before the loop body.
-- Discards results.
whileM_ :: (Monad m) => m Bool -> m a -> m ()
whileM_ p f = go
    where go = do
            x <- p
            if x
                then f >> go
                else return ()
