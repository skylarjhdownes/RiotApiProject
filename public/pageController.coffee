app = angular.module('potatoApp', [])

app.controller('potatoController', ($scope, $http) ->
  $scope.summoner = {}
  $scope.summonerStats = {}
  $scope.summonerMatchList = {}
  $scope.summonerNameInput = 'j1mm'
  $scope.doTheThing = () ->
    console.log("WakaWaka!")
    $http.get("/summonerInfoByName/#{$scope.summonerNameInput}").then (response) ->
        $scope.summoner = response.data[$scope.summonerNameInput]
        $http.get("/summonerStatsById/#{$scope.summoner.id}").then (response) ->
          $scope.summonerStats = response.data
        $http.get("/summonerMatchListById/#{$scope.summoner.id}").then (response) ->
          $scope.summonerMatchList = response.data
        return null
    return null
  return null
)
