app = angular.module('potatoApp', [])

app.controller('potatoController', ($scope, $http) ->
  $scope.summoner = {}
  $scope.summonerStats = {}
  $scope.summonerMatchList = {}
  $scope.summonerNameInput = 'j1mm'
  # $http.get("http://ddragon.leagueoflegends.com/cdn/5.2.1/img/champion/Annie.png").then (response) ->
  #   $scope.annie = response.data
  $scope.annie = "http://ddragon.leagueoflegends.com/cdn/5.2.1/img/champion/Annie.png"
  $http.get("/championData").then (response) ->
    $scope.champions = response.data.data


  $scope.doTheThing = () ->
    $http.get("/summonerInfoByName/#{$scope.summonerNameInput}").then (response) ->
        $scope.summoner = response.data[$scope.summonerNameInput]
        $http.get("/summonerStatsById/#{$scope.summoner.id}").then (response) ->
          $scope.summonerStats = response.data
        $http.get("/summonerMatchListById/#{$scope.summoner.id}").then (response) ->
          $scope.summonerMatchList = response.data
          # for match in $scope.summonerMatchList.matches

        return null
    return null
  return null
)
