// Generated by CoffeeScript 1.10.0
var app, defaultRegion, express, leagueApiClient, leagueApiWrapper, port, request, riotAPIKey, server;

express = require('express');

request = require('request');

leagueApiWrapper = require('lol-js');

defaultRegion = 'na';

riotAPIKey = process.env.RIOT_API_KEY || 'nope';

leagueApiClient = leagueApiWrapper.client({
  apiKey: riotAPIKey,
  cache: leagueApiWrapper.lruCache({
    max: 2000
  })
});

app = express();

app.use('/', express["static"]('public'));

app.use('/modules', express["static"]('node_modules'));

app.get('/', function(httpRequest, httpResponse) {
  return httpResponse.redirect('page.html');
});

app.get('/summonerInfoByName/:name', function(httpRequest, httpResponse) {
  return leagueApiClient.getSummonersByName(defaultRegion, [httpRequest.params.name]).then(function(response) {
    return httpResponse.send(response);
  });
});

app.get('/summonerMatchlistById/:id', function(httpRequest, httpResponse) {
  return leagueApiClient.getMatchlistBySummoner(defaultRegion, [httpRequest.params.id]).then(function(response) {
    return httpResponse.send(response);
  });
});

app.get('/championDataById/:id', function(httpRequest, httpResponse) {
  return leagueApiClient.getChampionById(defaultRegion, [httpRequest.params.id]).then(function(response) {
    return httpResponse.send(response);
  });
});

app.get('/championData', function(httpRequest, httpResponse) {
  return request.get(encodeURI("https://global.api.pvp.net/api/lol/static-data/na/v1.2/champion?champData=image,stats&api_key=" + riotAPIKey), function(champError, champHttpResponse, champHttpBody) {
    console.log(champHttpBody);
    return httpResponse.send(champHttpBody);
  });
});

app.get('/matchDetailsById/:id', function(httpRequest, httpResponse) {
  return leagueApiClient.getMatch(defaultRegion, [httpRequest.params.id]).then(function(response) {
    return httpResponse.send(response);
  });
});

port = process.env.PORT || 4000;

server = app.listen(port);

console.log('Listening on port ' + port);
