module EchoServer where

import Control.Monad (forever)                                                                                        
import System.IO                                                                                                      
import Control.Concurrent                                                                                             
import Network.Socket                                                                                                 
import Data.Char

main = runEchoServer

runEchoServer = do
  sock <- socket AF_INET Stream 0                                                                                     
  setSocketOption sock ReuseAddr 1                                                                                    
  bind sock (SockAddrInet 4243 iNADDR_ANY)                                                                            
  listen sock 2                                                                                                       
  loop sock                                                                                                 
  return ()

loop socket = do                                                                                                      
  (sock, _) <- accept socket                                                                                          
  forkIO $ do                                                                                                         
     hdl <- socketToHandle sock ReadWriteMode                                                                         
     hSetBuffering hdl NoBuffering                                                                                    
     forever $ do
      s <- hGetLine hdl;
      hPutStrLn hdl (map toUpper s);



