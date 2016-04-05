module TestEchoServer where
 
import EchoServer (runEchoServer)
import System.IO
import System.Process
import System.Directory
import Control.Concurrent
import Control.Monad

main = do 
       res <- testEchoServer "hello\n"
       print res

testEchoServer input = do    
       dir <- getCurrentDirectory 
       tid <- forkIO runEchoServer
       -- replicateM 10 $ putStrLn "waiting.." >> threadDelay 1000000
       (Just stdin', Just hout', _, pid) <-
         createProcess (proc "runhaskell" ["Main.hs","127.0.0.1","4243"]){ std_out = CreatePipe  , std_in = CreatePipe}
       hPutStr stdin' input
       hFlush stdin'
       hClose stdin'
       output <- hGetLine hout'
       killThread tid
       return output

