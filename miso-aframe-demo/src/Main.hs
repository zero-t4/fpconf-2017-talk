{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
module Main where

import Data.Aeson
import GHC.Generics
import GHCJS.Marshal
import Miso.String

import Miso (App(..), startApp, defaultEvents, noEff, onClick)
import Miso.AFrame
import Miso.AFrame.Core

-- ==========================================================
-- Шаг 1. Пустая сцена
-- ==========================================================

step1 :: IO ()
step1 = startHtmlOnlyApp $
  scene [] []

-- ==========================================================
-- Шаг 2. Красный куб
-- ==========================================================

step2 :: IO ()
step2 = startHtmlOnlyApp $
  scene []
  [
    box defaultBoxAttrs { boxColor = Just "red" }
      [ position (Vec3 0 2 (-5))
      , rotation (Vec3 0 45 45)
      , scale    (Vec3 2 2 2) ] []
  ]

-- ==========================================================
-- Шаг 3. Окружение и фон (интеграция внешней компоненты)
-- ==========================================================

data Env = Env
  { preset      :: MisoString
  , numDressing :: Int
  } deriving (Generic, ToJSON)

instance ToJSVal Env where toJSVal = toJSVal . toJSON

environment :: Env -> Component action
environment = foreignComponent "environment"

step3 :: IO ()
step3 = startHtmlOnlyApp $
  scene []
  [
    box defaultBoxAttrs { boxColor = Just "red" }
      [ position (Vec3 0 2 (-5))
      , rotation (Vec3 0 45 45)
      , scale    (Vec3 2 2 2) ] []
  , entity
      [ environment Env
         { preset      = "forest"
         , numDressing = 500
         }
      ] []
  ]

-- ==========================================================
-- Шаг 4. Текстура
-- ==========================================================

step4 :: IO ()
step4 = startHtmlOnlyApp $
  scene []
  [
    box defaultBoxAttrs
      { boxColor = Just "red"
      , boxSrc   = Just "https://i.imgur.com/mYmmbrp.jpg"
      }
      [ position (Vec3 0 2 (-5))
      , rotation (Vec3 0 45 45)
      , scale    (Vec3 2 2 2) ] []
  , entity
      [ environment Env
         { preset      = "forest"
         , numDressing = 500
         }
      ] []
  ]

-- ==========================================================
-- Шаг 5. Система управления ассетами
-- ==========================================================

step5 :: IO ()
step5 = startHtmlOnlyApp $
  scene []
  [
    assets Nothing
    [
      img "boxTexture" "https://i.imgur.com/mYmmbrp.jpg"
    ]
  , box defaultBoxAttrs
      { boxColor = Just "red"
      , boxSrc   = Just "#boxTexture"
      }
      [ position (Vec3 0 2 (-5))
      , rotation (Vec3 0 45 45)
      , scale    (Vec3 2 2 2) ] []
  , entity
      [ environment Env
         { preset      = "forest"
         , numDressing = 500
         }
      ] []
  ]

-- ==========================================================
-- Шаг 6. Анимация
-- ==========================================================

step6 :: IO ()
step6 = startHtmlOnlyApp $
  scene []
  [
    assets Nothing
    [
      img "boxTexture" "https://i.imgur.com/mYmmbrp.jpg"
    ]
  , box defaultBoxAttrs
      { boxColor = Just "red"
      , boxSrc   = Just "#boxTexture"
      }
      [ position (Vec3 0 2 (-5))
      , rotation (Vec3 0 45 45)
      , scale    (Vec3 2 2 2) ]
      [
        animation "position" Nothing (Vec3 0 5 (-5)) defaultAnimationAttrs
          { animationDirection = Just AnimationAlternate
          , animationDur       = Just 2000
          , animationRepeat    = Indefinite
          }
      ]
  , entity
      [ environment Env
         { preset      = "forest"
         , numDressing = 500
         }
      ] []
  ]

-- ==========================================================
-- Шаг 7. Взаимодействие
-- ==========================================================

step7 :: IO ()
step7 = startHtmlOnlyApp $
  scene []
  [
    assets Nothing
    [
      img "boxTexture" "https://i.imgur.com/mYmmbrp.jpg"
    ]
  , box defaultBoxAttrs
      { boxColor = Just "red"
      , boxSrc   = Just "#boxTexture"
      }
      [ position (Vec3 0 2 (-5))
      , rotation (Vec3 0 45 45)
      , scale    (Vec3 2 2 2) ]
      [
        animation "scale" Nothing (Vec3 2.3 2.3 2.3) defaultAnimationAttrs
          { animationBegin = Just "mouseenter"
          , animationDur   = Just 300
          }
      , animation "scale" Nothing (Vec3 2 2 2) defaultAnimationAttrs
          { animationBegin = Just "mouseleave"
          , animationDur   = Just 300
          }
      , animation "rotation" Nothing (Vec3 360 405 45) defaultAnimationAttrs
          { animationBegin = Just "click"
          , animationDur   = Just 2000
          }
      ]
  , entity
      [ environment Env
        { preset      = "forest"
        , numDressing = 500
        }
      ] []
  , camera defaultCameraAttrs []
      [
        cursor defaultCursorAttrs [] []
      ]
  ]

-- ==========================================================
-- Шаг 8. Текст
-- ==========================================================

step8 :: IO ()
step8 = startHtmlOnlyApp $
  scene []
  [
    assets Nothing
    [
      img "boxTexture" "https://i.imgur.com/mYmmbrp.jpg"
    ]
  , box defaultBoxAttrs
      { boxColor = Just "red"
      , boxSrc   = Just "#boxTexture"
      }
      [ position (Vec3 0 2 (-5))
      , rotation (Vec3 0 45 45)
      , scale    (Vec3 2 2 2) ]
      [
        animation "scale" Nothing (Vec3 2.3 2.3 2.3) defaultAnimationAttrs
          { animationBegin = Just "mouseenter"
          , animationDur   = Just 300
          }
      , animation "scale" Nothing (Vec3 2 2 2) defaultAnimationAttrs
          { animationBegin = Just "mouseleave"
          , animationDur   = Just 300
          }
      , animation "rotation" Nothing (Vec3 360 405 45) defaultAnimationAttrs
          { animationBegin = Just "click"
          , animationDur   = Just 2000
          }
      ]
  , text "Hello, world!" defaultTextAttrs
      { textColor = Just (ColorName "black")
      }
      [ position (Vec3 (-0.9) 0.2 (-3))
      , scale    (Vec3 1.5 1.5 1.5) ] []
  , entity
      [ environment Env
        { preset      = "forest"
        , numDressing = 500
        }
      ] []
  , camera defaultCameraAttrs []
      [
        cursor defaultCursorAttrs [] []
      ]
  ]

-- ==========================================================
-- Шаг 9. Интерактивное приложение Miso + A-Frame
-- ==========================================================

data Model = Model
  { modelText    :: MisoString
  , modelPhrases :: [MisoString]
  } deriving (Eq)

data Action
  = NextPhrase
  | Reset

step9 :: IO ()
step9 = startApp App {..}
  where
    initialAction = Reset
    mountPoint = Nothing
    events = defaultEvents
    subs   = []

    model  = Model "Click the box!" $
      [ "You did it! Now click once again :)"
      , "Not bad! Click more?"
      , "Ok, I think that's enough."
      , "Really, stop clicking on the box."
      , "Ok. Let's play the repeating game."
      ]

    update Reset _ = noEff model
    update NextPhrase m = case modelPhrases m of
      [] -> noEff model
      (new : rest) -> noEff m
        { modelText    = new
        , modelPhrases = rest
        }

    view Model{..} =
      scene []
      [
        assets Nothing
        [
          img "boxTexture" "https://i.imgur.com/mYmmbrp.jpg"
        ]
      , box defaultBoxAttrs
          { boxColor = Just "red"
          , boxSrc   = Just "#boxTexture"
          }
          [ position (Vec3 0 2 (-5))
          , rotation (Vec3 0 45 45)
          , scale    (Vec3 2 2 2)
          , onClick NextPhrase ]
          [
            animation "scale" Nothing (Vec3 2.3 2.3 2.3) defaultAnimationAttrs
              { animationBegin = Just "mouseenter"
              , animationDur   = Just 300
              }
          , animation "scale" Nothing (Vec3 2 2 2) defaultAnimationAttrs
              { animationBegin = Just "mouseleave"
              , animationDur   = Just 300
              }
          , animation "rotation" Nothing (Vec3 360 405 45) defaultAnimationAttrs
              { animationBegin = Just "click"
              , animationDur   = Just 2000
              }
          ]
      , text modelText defaultTextAttrs
          { textColor = Just (ColorName "black")
          , textAlign = Just TextAlignmentCenter
          }
          [ position (Vec3 0 0.2 (-3))
          , scale    (Vec3 1.5 1.5 1.5) ] []
      , entity
          [ environment Env
            { preset      = "forest"
            , numDressing = 500
            }
          ] []
      , camera defaultCameraAttrs []
          [
            cursor defaultCursorAttrs [] []
          ]
      ]


main :: IO ()
main = step9
