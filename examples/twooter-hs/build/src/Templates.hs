{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Templates ( tTimeline
                 , tPostSuccess
                 , tPostFailure
                 , tSingleTwoot
                 , tTwootFailure
                 , tForm
                 ) where

import Data.Monoid ((<>), mconcat)
import qualified Data.Text as T
import Data.Text.Lazy (Text)
import Data.Time.Clock (UTCTime)
import Data.Time.Clock.POSIX
import Data.Time.Format
import System.Locale (defaultTimeLocale)
import Lucid

import Types

scaffolding :: Text -> Html () -> Text
scaffolding header contents = renderText $ html_ $ do
  head_ $ return ()
  body_ $ do
    h1_ (toHtml header)
    div_ [class_ "main"] contents

tTimeline :: [Twoot] -> Text
tTimeline ts = scaffolding "Twooter" $ do
  p_ (em_ "Proudly accepting venture capital since 2015.")
  p_ (a_ [href_ "/t/new"] "Post a Twoot")
  h1_ "Twootline:"
  mconcat (map tTwoot ts)

tUrl :: Int -> T.Text
tUrl i = "/t/" <> (T.pack (show i))

tTime :: UTCTime -> Html ()
tTime n = toHtml ("Twooted at " <> time)
  where time = formatTime defaultTimeLocale fmt n
        fmt  = "%H:%M on %a, %d %b %Y"

tTwoot :: Twoot -> Html ()
tTwoot (Twoot { .. }) = div_ $ do
  p_ (toHtml twText)
  p_ (a_ [href_ (tUrl twId)]
      (tTime (posixSecondsToUTCTime (fromIntegral twTime))))

tSingleTwoot :: Twoot -> Text
tSingleTwoot t = scaffolding "A Twoot:"
  (tTwoot t <> p_ (a_ [href_ "/"] "Return to Twootline"))

tForm :: Text
tForm = scaffolding "Post a Twoot:" $ do
  form_ [name_ "a-form", action_ "/", method_ "POST"] $ do
    textarea_ [cols_ "60", rows_ "4", name_ "twoot"] ""
    br_ []
    input_ [type_ "submit", value_ "Post a Twoot!"]

tErrMsg :: Text -> Text -> Text
tErrMsg head body =
  scaffolding head (toHtml body <> p_ (a_ [href_ "/"] "Return to timeline"))

tPostSuccess :: Text
tPostSuccess = tErrMsg "Successfully Twooted!" ""

tPostFailure :: Text
tPostFailure = tErrMsg
  "Twooting Unscucessful"
  ("There was some problem! Maybe your twoot was over the maximum " <>
   "number of characters (141, much better than that other service)?")

tTwootFailure :: Text
tTwootFailure = tErrMsg
  "No Such Twoot"
  "There ain't no twoot by that id, friend!"
