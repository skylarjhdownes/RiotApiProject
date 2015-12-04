// Generated by CoffeeScript 1.10.0
var app, express, port, request, riotAPIKey, server;

express = require('express');

request = require('request');

app = express();

app.use('/', express["static"]('public'));

app.use('/modules', express["static"]('node_modules'));

riotAPIKey = 'nope';

app.get('/summonerInfoByName/:name', function(httpRequest, httpResponse) {
  return request.get("https://na.api.pvp.net/api/lol/na/v1.4/summoner/by-name/" + httpRequest.params.name + "?api_key=" + riotAPIKey, function(summonerError, summonerHttpResponse, summonerHttpBody) {
    return httpResponse.send(summonerHttpBody);
  });
});

app.get('/summonerStatsById/:id', function(httpRequest, httpResponse) {
  return request.get("https://na.api.pvp.net/api/lol/na/v1.3/stats/by-summoner/" + httpRequest.params.id + "/summary?api_key=" + riotAPIKey, function(statsError, statsHttpResponse, statsHttpBody) {
    return httpResponse.send(statsHttpBody);
  });
});

app.get('/summonerMatchListById/:id', function(httpRequest, httpResponse) {
  return request.get("https://na.api.pvp.net/api/lol/na/v2.2/matchlist/by-summoner/" + httpRequest.params.id + "?api_key=" + riotAPIKey, function(matchesError, matchesHttpResponse, matchesHttpBody) {
    console.log(matchesHttpBody);
    return httpResponse.send(matchesHttpBody);
  });
});

port = 4000;

server = app.listen(port);

console.log('Listening on port ' + port);
