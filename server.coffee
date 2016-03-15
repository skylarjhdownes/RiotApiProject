express = require 'express'
request = require 'request'
leagueApiWrapper = require 'lol-js'

defaultRegion =  'na'
riotAPIKey = process.env.RIOT_API_KEY
# redis = require 'redis'
# redisClient = redis.createClient()

# redisClient.on('connect', () ->
#     console.log 'connected'
# )
leagueApiClient = leagueApiWrapper.client {
  apiKey: riotAPIKey,
  cache: leagueApiWrapper.lruCache({max:2000})
}
app = express()

app.use('/', express.static('public'))
app.use('/modules', express.static('node_modules'))

app.get('/summonerInfoByName/:name', (httpRequest, httpResponse) ->
  leagueApiClient.getSummonersByName(defaultRegion, [httpRequest.params.name]).then (response) ->
    httpResponse.send(response)
)

app.get('/summonerMatchlistById/:id', (httpRequest, httpResponse) ->
  leagueApiClient.getMatchlistBySummoner(defaultRegion, [httpRequest.params.id]).then (response) ->
    # console.log(response)
    httpResponse.send(response)
)

app.get('/championDataById/:id', (httpRequest, httpResponse) ->
  leagueApiClient.getChampionById(defaultRegion, [httpRequest.params.id]).then (response) ->
    httpResponse.send(response)
)

app.get('/championData', (httpRequest, httpResponse) ->
  request.get(encodeURI("https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=image,stats&api_key=#{riotAPIKey}"), (champError, champHttpResponse, champHttpBody) ->
    console.log(champHttpBody)
    httpResponse.send(champHttpBody)
  )
  # leagueApiClient.getChampions({champData:'stats','image'}).then (response) ->
  #   console.log(response)
  #   httpResponse.send(response)
)

app.get('/matchDetailsById/:id', (httpRequest, httpResponse) ->
  leagueApiClient.getMatch(defaultRegion, [httpRequest.params.id]).then (response) ->
    httpResponse.send(response)
)


port = process.env.PORT || 4000
server = app.listen(port)
console.log('Listening on port ' + port)
