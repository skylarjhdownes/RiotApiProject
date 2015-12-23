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
  leagueApiClient.getChampionByIdAsync([httpRequest.params.id], {}).then (response) ->
    httpResponse.send(response)
)

app.get('/championData', (httpRequest, httpResponse) ->
  leagueApiClient.getChampionsAsync({champData:'stats','image'}).then (response) ->
    httpResponse.send(response)
)

app.get('/matchDetailsById/:id', (httpRequest, httpResponse) ->
  leagueApiClient.getMatchAsync([httpRequest.params.id], {}).then (response) ->
    httpResponse.send(response)
)


port = 4000
server = app.listen(port)
console.log('Listening on port ' + port)
