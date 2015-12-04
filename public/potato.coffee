app = angular.module('potatoApp', [])

app.controller('potatoController', ($scope, $http) ->
  $scope.summoner = {}
  $scope.summonerStats = {}
  $scope.summonerMatchList = {}
  $scope.summonerName = 'j1mm'
  $http.get("/summonerInfoByName/#{$scope.summonerName}").then (response) ->
      $scope.summoner = response.data[$scope.summonerName]
      $http.get("/summonerStatsById/#{$scope.summoner.id}").then (response) ->
        $scope.summonerStats = response.data
      $http.get("/summonerMatchListById/#{$scope.summoner.id}").then (response) ->
        $scope.summonerMatchList = response.data
      return null
  return null
)
