module Trans_Thai exposing (transl)

import Dict
import Set exposing (Set)

latThai : Dict.Dict String String
latThai = Dict.fromList [("k" , "\u{0E01}") ,("k'","\u{0E02}"),("k\"","\u{0E03}")
                         ,("k-", "\u{0E04}"),("k'-","\u{0E05}"),("k\"-","\u{0E06}")
                         , ("G" , "\u{0E07}")

                         ,("c" , "\u{0E08}"), ("c'" , "\u{0E09}")
                         ,("c-" , "\u{0E0A}"), ("s-", "\u{0E0B}"),("c'-" , "\u{0E0C}"), ("y'","\u{0E0D}")

                         ,("D" , "\u{0E0E}"),("T" , "\u{0E0F}"), ("T'", "\u{0E10}")
                         , ("T-", "\u{0E11}"), ("T'-", "\u{0E12}"), ("N" , "\u{0E13}")

                         ,("d" , "\u{0E14}"),("t" , "\u{0E15}"), ("t'" , "\u{0E16}")
                         , ("t-" , "\u{0E17}"), ("t'-" , "\u{0E18}"), ("n" , "\u{0E19}")

                         ,("b" , "\u{0E1A}"),("p" , "\u{0E1B}"), ("p'" , "\u{0E1C}"), ("f" , "\u{0E1D}")
                         , ("p-" , "\u{0E1E}"), ("f-" , "\u{0E1F}"), ("p'-" , "\u{0E20}")
                         , ("m" , "\u{0E21}")

                         ,("y" , "\u{0E22}"), ("r" , "\u{0E23}"), ("r'" , "\u{0E24}")
                         ,("l" , "\u{0E25}"), ("l\"" , "\u{0E26}"),("w" , "\u{0E27}")
                         ,("s'" ,"\u{0E28}"), ("s\"","\u{0E29}"), ("s" , "\u{0E2A}")
                         ,("h'" , "\u{0E2B}"),("l'" , "\u{0E2C}")
                         ,("h" , "\u{0E2D}"), ("h-" , "\u{0E2E}"), ("." , "\u{0E2F}")

                         ,("a" , "\u{0E30}"),("a'" , "\u{0E31}"),("a:" , "\u{0E32}"),("aM" , "\u{0E33}")
                         ,("i" , "\u{0E34}"),("i:" , "\u{0E35}")
                         ,("ü" , "\u{0E36}"),("ü:" , "\u{0E36}\u{0E2D}"),("ü'" , "\u{0E37}")
                         ,("u" , "\u{0E38}"),("u:" , "\u{0E39}")
                         ,("e" , "\u{0E40}\u{0E30}"),("e'","\u{0E40}\u{0E36}"),("e:","\u{0E40}") -- https://www.w3.org/International/sealreq/thai/
                         ,("ä" , "\u{0E41}\u{0E30}"),("ä'","\u{0E41}\u{0E36}"),("ä:" , "\u{0E41}")
                         ,("o" , "\u{0E42}\u{0E30}"),("o:" , "\u{0E42}")
                         ,(")" , "\u{0E40}\u{0E32}\u{0E30}"),("):" , "\u{0E2D}")
                         ,("ö" , "\u{0E40}\u{0E2D}\u{0E30}"),("ö:" , "\u{0E40}\u{0E2D}")
                         ,("aï" , "\u{0E43}"),("a'ï" , "\u{0E44}")

                         ,("0","\u{0E50}"),("1","\u{0E51}"),("2","\u{0E52}"),("3","\u{0E53}"),("4","\u{0E54}")
                         ,("5","\u{0E55}"),("6","\u{0E56}"),("7","\u{0E57}"),("8","\u{0E58}"),("9","\u{0E59}")
                         , ("`" , "\u{0E48}") --  tone marker MAI EK
                         , ("`'", "\u{0E49}") --  tone marker MAI THO
                         , ("`\"","\u{0E4A}") --  tone marker MAI TRI
                         , ("+" , "\u{0E4B}") --  tone marker MAI CHATTAWA

                         , ("_" , "") -- filter _
                         ]

latThai_ : Dict.Dict String String -- characters being preceded by _ (underscore)
latThai_= Dict.fromList  [(")" , ")") -- ) is used for  ึ, so type _) to get )
                         ,("(" , "(")  -- ( is used for open o, so type _( to get (
                         ]

diacritics : List String
diacritics = ["'", "\"","ï","M","-",":"]

prevowels : List String
prevowels = ["เ", "แ", "โ", "ใ", "ไ"]

pair1 : List String
pair1 = ["ก", "ข", "ค", "ต", "ป", "ผ"]

pair2 : List String
pair2 = ["ร", "ล", "ว"]

subst : String -> (Dict.Dict String String) -> String -- substitute one char (or char + diacritics) on the basis of dictionary
subst car dict =
  Maybe.withDefault car (Dict.get car dict) -- if car is in dict, substitute, else keep car

subst_ : (String,String) -> String -- select dictionary on the basis of previous char : _ or not _, and substitute char
subst_ dble =
  let
     (carac, sub) = dble
  in
    if sub == "_" then subst carac latThai_
    else subst carac latThai

szip : List String -> List (String,String) -- zip s with a right shift of itself
szip s =
    List.map2 Tuple.pair s (" " :: s)

foldp : List String -> List String -> List String -- concatenate letters with their diacritics, if any
foldp acc list =
  case list of
    [] ->
      acc
    x::xs ->
      case xs of
        [] ->
          x::acc
        y::ys ->
          if List.member y diacritics then -- 1 diacritic
            case ys of
              [] ->
                (x++y)::acc
              z::zs ->
                if List.member z diacritics then -- 2 diacritics
                  case zs of
                    [] ->
                      (x++y++z)::acc
                    w::ws ->
                      if List.member w diacritics then -- 3 diacritics
                        foldp ((x++y++z++w)::acc) ws
                      else
                        foldp ((x++y++z)::acc) zs
                else
                  foldp ((x++y)::acc) ys
          else
            foldp (x::acc) xs

folds : List String -> List String -> List String -- permute prevowels with their consonant
folds acc list =
    case list of
      [] ->
        acc
      x::xs ->
        case xs of
          [] ->
            x::acc
          y::ys ->
            if List.member y prevowels && x /= " " then -- y one of เ แ โ ใ ไ
              folds (x::y::acc) ys
            else
              case ys of
                [] ->
                  y::x::acc
                z::zs ->
                  if List.member z prevowels then
                    if List.member y pair2 then
                      if List.member x pair1 then
                        folds (y::x::z::acc) zs
                      else
                        folds (y::z::x::acc) zs
                    else
                      folds (y::z::x::acc) zs
                  else
                    folds (z::y::x::acc) zs

trich : String -> String -- sort diacritics, if more than 1 present
trich s =
  if String.length s < 3 then s -- 0 or 1 diacritic, no need to sort
  else
    let
      h = String.slice 0 1 s -- head character
      b = String.slice 1 5 s -- b contains the diacritics, which will be sorted according to Unicode value
    in
      h ++ (b |> String.toList |> List.map String.fromChar |> List.sort |> List.foldr (++) "")

transl : String -> String
transl chaine =
    chaine -- initial string from HTML input
    |> String.toList -- => list of chars
    |> List.map String.fromChar -- => list of strings
    |> foldp [] -- append diacritics to characters
    |> List.reverse --necessary after foldp
    |> List.map trich -- order diacritics according to unicode so that initial ordering does not matter
    |> szip -- zip list with shifted list to capture _ (underscore)
    |> List.map subst_ -- perform the substitution latin => thai
    |> List.map String.toList -- => list of lists of chars
    |> List.foldr (++) [] -- flatten list: back to list of chars
    |> List.map String.fromChar -- => list of strings
    |> folds [] --  permute prevowels with their consonant
    |> List.reverse -- necessary after fold
    |> List.foldr (++) "" -- back to String
