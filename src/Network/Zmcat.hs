
module Network.Zmcat where

import System.ZMQ
import Control.Monad (forM_,forever,liftM)
import Data.ByteString.Char8 (pack, unpack)
import System.IO

runCtx t blk = withContext 1 $ \ctx -> do
        withSocket ctx t $ \skt -> do
            blk skt

pub uri k = runCtx Pub $ \skt -> do
        bind skt uri
        forever $ do
            pkt <- hGetLine stdin
            send skt (pack $ k ++ pkt) []

sub uri k = runCtx Sub $ \skt -> do
        subscribe skt k
        connect skt uri
        forever $ do
            line <- receive skt []
            putStrLn $ drop (length k) (unpack line)
            hFlush stdout
                
pull uri = runCtx Pull $ \skt -> do
        bind skt uri
        forever $ do
            line <- receive skt []
            putStrLn $ unpack line
            hFlush stdout

push uri = runCtx Push $ \skt -> do
        connect skt uri
        forever $ do
            pkt <- hGetLine stdin
            send skt (pack pkt) []

