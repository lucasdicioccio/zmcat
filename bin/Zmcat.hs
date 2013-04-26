{-# LANGUAGE OverloadedStrings #-}

module Main where

import System.Exit (exitFailure)
import System.IO
import System.Environment (getArgs)
import qualified Data.ByteString.Char8 as C

import Network.Zmcat

main :: IO ()
main = do 
	args  <- getArgs
	case args of
		["pub", uri, k]		-> pub uri k
		["sub", uri, k] 	-> sub uri $ C.pack k
		["pub", uri]		-> pub uri ""
		["sub", uri] 		-> sub uri ""
		["push", uri] 		-> push uri
		["pull", uri] 		-> pull uri
		["req", uri] 		-> req uri
		["rep", uri] 		-> rep uri
		_	  		-> (hPutStrLn stderr usage) >> exitFailure
	where usage = "cli <pub|sub|push|pull|rep|req> <uri> [key-for-pub-or-sub='']"
