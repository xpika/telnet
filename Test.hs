import Test.Tasty
import Test.Tasty.HUnit

import Data.Char
import TestEchoServer (testEchoServer)

main = do    
       let v1 = "hello"
       v2 <- testEchoServer "hello"
       defaultMain (tests (v1,v2))

tests vs = testGroup "Tests" [unitTests vs ]

unitTests (v1,v2) = 
  testGroup "Unit tests"
  [ testCase "List comparison (different length)" (assertEqual "test uppercase" (map toUpper v1) v2) ]

