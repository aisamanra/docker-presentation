{-# LANGUAGE OverloadedStrings #-}

module Types ( Twoot(..)
             , addTwoot
             , getTwoot
             , getTwoots
             ) where

import Control.Applicative
import Database.SQLite.Simple (Connection, Only(..), query, query_, execute)
import Database.SQLite.Simple.FromRow
import Data.Maybe (listToMaybe)
import Data.Time.Clock.POSIX
import Data.Text.Lazy

data Twoot = Twoot
  { twId   :: Int
  , twTime :: Int
  , twText :: Text
  } deriving (Eq, Show)

instance FromRow Twoot where
  fromRow = Twoot <$> field <*> field <*> field

addTwoot :: Connection -> Text -> IO ()
addTwoot c text = do
  time <- round <$> getPOSIXTime
  execute c "INSERT INTO twoot (time, text) VALUES (?, ?)"
    (time :: Int, text)

getTwoots :: Connection -> IO [Twoot]
getTwoots c = query_ c "SELECT * FROM twoot"

getTwoot :: Connection -> Int -> IO (Maybe Twoot)
getTwoot c id =
  listToMaybe <$> query c "SELECT * FROM twoot WHERE id = ?" (Only id)
