express = require 'express'
request = require 'request'
leagueApiWrapper = require 'lol-js'
# redis = require 'redis'
# redisClient = redis.createClient()

# redisClient.on('connect', () ->
#     console.log 'connected'
# )
leagueApiClient = leagueApiWrapper.client {
  apiKey: 'nope',
  defaultRegion: 'na',
  cache: leagueApiWrapper.lruCache({max:2000})
}
app = express()

app.use('/', express.static('public'))
app.use('/modules', express.static('node_modules'))

riotAPIKey = 'nope'

# app.get('/', (httpRequest, httpResponse) ->
# 	httpResponse.send("POTATO!")
# )

app.get('/summonerInfoByName/:name', (httpRequest, httpResponse) ->
  leagueApiClient.getSummonersByNameAsync([httpRequest.params.name], {}).then (response) ->
    httpResponse.send(response)
)

app.get('/summonerStatsById/:id', (httpRequest, httpResponse) ->
  leagueApiClient.getSummonersByIdAsync([httpRequest.params.id], {}).then (response) ->
    httpResponse.send(response)
)

app.get('/summonerMatchListById/:id', (httpRequest, httpResponse) ->
  leagueApiClient.getMatchHistoryForSummonerAsync([httpRequest.params.id], {}).then (response) ->
    httpResponse.send(response)
)

app.get('/championDataById/:id', (httpRequest, httpResponse) ->
  request.get(encodeURI("https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion/#{httpRequest.params.id}?champData=image&api_key=#{riotAPIKey}"), (champError, champHttpResponse, champHttpBody) ->
    httpResponse.send(champHttpBody)
  )
)

app.get('/championData', (httpRequest, httpResponse) ->
  leagueApiClient.getChampionsAsync({}).then (response) ->
    httpResponse.send(response)
)

app.get('/matchDetailsById/:id', (httpRequest, httpResponse) ->
  request.get(encodeURI("https://na.api.pvp.net/api/lol/na/v2.2/match/#{httpRequest.params.id}?api_key=#{riotAPIKey}"), (matchError, matchHttpResponse, matchHttpBody) ->
    httpResponse.send(matchHttpBody)
  )
)

# app.post('/potato', (httpRequest, httpResponse) ->
#   httpResponse.send("zcvxzcvxzcv")
# )

port = 4000
server = app.listen(port)
console.log('Listening on port ' + port)
