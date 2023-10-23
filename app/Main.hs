{-# LANGUAGE NamedFieldPuns #-}
module Main where

import Text.Parsec
import Text.Parsec.String
import qualified Data.List.NonEmpty as NE
import Data.List.NonEmpty (NonEmpty((:|)))
import Control.Monad (guard)
import Data.Function (on)

lf :: Parser Char
lf = char '\n'

cr :: Parser Char
cr = char '\r'

lineEnd :: Parser String
lineEnd = (pure <$> lf) <|> (pure <$> cr) <|> ((:) <$> cr <*> (pure <$> lf))

comma :: Parser Char
comma = char ','

dquote :: Parser Char
dquote = char '"'

textData :: Parser Char
textData = oneOf $ " !#$%&'()*+-./:;<=>?@[\\]^_`{|}~" ++ ['0'..'9'] ++ ['A' .. 'Z'] ++ ['a'..'z']

nonEscaped :: Parser String
nonEscaped = many textData

escaped :: Parser String
escaped = dquote *> many (textData <|> comma <|> cr <|> lf <|> try (dquote *> dquote)) <* dquote

field :: Parser String
field = escaped <|> nonEscaped

name :: Parser String
name = field

record :: Parser [String]
record = (:) <$> field <*> many (comma *> field)

header :: Parser [String]
header = (:) <$> name <*> many (comma *> name)

data CSVFile = CSVFile { fileHeader :: Maybe [String], fileRecords :: NE.NonEmpty [String] } deriving Show

file :: Parser CSVFile
file = do
  fileHeader <- optionMaybe $ try (header <* lineEnd)
  first <- record
  rest <- many $ try $ lineEnd *> record
  optional lineEnd
  guard (all (((==) `on` length) first) rest) <?> "identical record lengths"
  let fileRecords = first :| rest
  return CSVFile { fileHeader, fileRecords }

rstrip :: String -> String
rstrip = reverse . dropWhile (=='\n') . reverse

main :: IO ()
main = interact $ show . parse file "STDIN" . reverse

