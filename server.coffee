express = require 'express'
request = require 'request'
app = express()

app.use('/', express.static('public'))
app.use('/modules', express.static('node_modules'))

riotAPIKey = 'nope'

# app.get('/', (httpRequest, httpResponse) ->
# 	httpResponse.send("POTATO!")
# )

app.get('/summonerInfoByName/:name', (httpRequest, httpResponse) ->
  request.get(encodeURI("https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/#{httpRequest.params.name}?api_key=#{riotAPIKey}"), (summonerError, summonerHttpResponse, summonerHttpBody) ->
    httpResponse.send(summonerHttpBody)
  )
)

app.get('/summonerStatsById/:id', (httpRequest, httpResponse) ->
  request.get(encodeURI("https://na.api.pvp.net/api/lol/na/v1.3/stats/by-summoner/#{httpRequest.params.id}/summary?api_key=#{riotAPIKey}"), (statsError, statsHttpResponse, statsHttpBody) ->
    httpResponse.send(statsHttpBody)
  )
)

app.get('/summonerMatchListById/:id', (httpRequest, httpResponse) ->
  request.get(encodeURI("https://na.api.pvp.net/api/lol/na/v2.2/matchlist/by-summoner/#{httpRequest.params.id}?api_key=#{riotAPIKey}"), (matchesError, matchesHttpResponse, matchesHttpBody) ->
    httpResponse.send(matchesHttpBody)
  )
)

app.get('/championDataById/:id', (httpRequest, httpResponse) ->
  request.get(encodeURI("https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion/#{httpRequest.params.id}?champData=image&api_key=#{riotAPIKey}"), (champError, champHttpResponse, champHttpBody) ->
    httpResponse.send(champHttpBody)
  )
)

app.get('/championData', (httpRequest, httpResponse) ->
  request.get(encodeURI("https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=image,stats&api_key=#{riotAPIKey}"), (champError, champHttpResponse, champHttpBody) ->
    httpResponse.send(champHttpBody)
  )
)

app.get('/matchDetailsById/:id', (httpRequest, httpResponse) ->
  request.get(encodeURI("https://na.api.pvp.net/api/lol/na/v2.2/match/#{httpRequest.params.id}&api_key=#{riotAPIKey}"), (matchError, matchHttpResponse, matchHttpBody) ->
    httpResponse.send(matchHttpBody)
  )
)

# app.post('/potato', (httpRequest, httpResponse) ->
#   httpResponse.send("zcvxzcvxzcv")
# )

port = 4000
server = app.listen(port)
console.log('Listening on port ' + port)
