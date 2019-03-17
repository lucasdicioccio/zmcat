
module Network.Zmcat where

import System.ZMQ4
import Control.Monad (forever)
import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as C
import Data.ByteString.Char8 (pack, unpack)
import System.IO

runCtx :: SocketType a1 => a1 -> (Socket a1 -> IO a) -> IO a
runCtx t blk = withContext $ \ctx -> do
        withSocket ctx t $ \skt -> do
            blk skt

pub :: String -> String -> IO a
pub uri k = runCtx Pub $ \skt -> do
        bind skt uri
        forever $ do
            pkt <- hGetLine stdin
            send skt [] (pack $ k ++ pkt)

sub :: String -> BS.ByteString -> IO a
sub uri k = runCtx Sub $ \skt -> do
        subscribe skt k
        connect skt uri
        forever $ do
            line <- receive skt
            putStrLn $ drop (BS.length k) (unpack line)
            hFlush stdout
                
pull :: String -> IO a
pull uri = runCtx Pull $ \skt -> do
        bind skt uri
        forever $ do
            line <- receive skt
            putStrLn $ unpack line
            hFlush stdout

push :: String -> IO a
push uri = runCtx Push $ \skt -> do
        connect skt uri
        forever $ do
            pkt <- hGetLine stdin
            send skt [] (pack pkt)

rep :: String -> IO a
rep uri = runCtx Rep $ \skt -> do
    bind skt uri
    forever $ do
        line <- receive skt
        putStrLn $ unpack line
        hFlush stdout
        pkt <- hGetLine stdin
        send skt [] (pack pkt)

req :: String -> IO a
req uri = runCtx Req $ \skt -> do
    connect skt uri
    forever $ do
        pkt <- hGetLine stdin
        send skt [] (pack pkt)
        lines' <- receiveMulti skt
        mapM_ C.putStrLn lines'
        hFlush stdout
