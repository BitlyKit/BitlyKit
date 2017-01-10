## Shorten URL Request
curl -X "GET" "https://api-ssl.bitly.com/v3/shorten?access_token=*****%20Hidden%20credentials%20*****&longUrl=https:%2F%2Fen.wikipedia.org%2Fwiki%2FRichard_Feynman&format=json"

## Shorten URL Request (Missing Access Token)
curl -X "GET" "https://api-ssl.bitly.com/v3/shorten?access_token&longUrl=https:%2F%2Fen.wikipedia.org%2Fwiki%2FRichard_Feynman&format=json"

## Shorten URL Request (Missing Args)
curl -X "GET" "https://api-ssl.bitly.com/v3/shorten?access_token=*****%20Hidden%20credentials%20*****"

## Expand URL Request
curl -X "GET" "https://api-ssl.bitly.com/v3/expand?access_token=*****%20Hidden%20credentials%20*****&shortUrl=http:%2F%2Fsstools.co%2F2iWad1L&format=json"

## Expand URL Request (Missing Access Token)
curl -X "GET" "https://api-ssl.bitly.com/v3/expand?access_token&shortUrl=http:%2F%2Fsstools.co%2F2iWad1L&format=json"

## Expand URL Request (Missing Args)
curl -X "GET" "https://api-ssl.bitly.com/v3/expand?access_token=*****%20Hidden%20credentials%20*****"
