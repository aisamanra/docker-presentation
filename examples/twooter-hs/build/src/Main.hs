{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Control.Monad.IO.Class (liftIO)
import Database.SQLite.Simple (Connection, open)
import Data.Text.Lazy (Text, length)
import Web.Scotty

import Prelude hiding (length)

import Templates
import Types

main :: IO ()
main = do
  db <- open "tmp.db"
  scotty 80 $ do
    get  "/"      (pTimeline db)
    post "/"      (pAddTwoot db)
    get  "/t/new" pTwootForm
    get  "/t/:tw" (pShowTwoot db)

pTimeline :: Connection -> ActionM ()
pTimeline c = do
  tws <- liftIO (getTwoots c)
  html (tTimeline tws)

isValidTwoot :: Text -> Bool
isValidTwoot t = length t > 1 && length t < 142

pAddTwoot :: Connection -> ActionM ()
pAddTwoot c = do
  tw <- param "twoot"
  if isValidTwoot tw
    then do liftIO (addTwoot c tw)
            html tPostSuccess
    else html tPostFailure

pTwootForm :: ActionM ()
pTwootForm = html tForm

pShowTwoot :: Connection -> ActionM ()
pShowTwoot c = do
  twid <- param "tw"
  tw <- liftIO (getTwoot c twid)
  html $ case tw of
    Nothing  -> tTwootFailure
    Just tw' -> tSingleTwoot tw'
