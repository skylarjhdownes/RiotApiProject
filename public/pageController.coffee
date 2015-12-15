app = angular.module('potatoApp', [])

app.controller('potatoController', ($scope, $http) ->
  $scope.summoner = {}
  $scope.summonerStats = {}
  $scope.summonerMatchList = {}
  $scope.summonerNameInput = ''
  # $http.get("http://ddragon.leagueoflegends.com/cdn/5.2.1/img/champion/Annie.png").then (response) ->
  #   $scope.annie = response.data
  # $scope.annie = "http://ddragon.leagueoflegends.com/cdn/5.2.1/img/champion/Annie.png"
  $http.get("/championData").then (response) ->
    $scope.champions = response.data.data

  getChampionByChampId = (id) ->
    _.find($scope.champions, "id", id)

  attachChampionsToMatches = (matches) ->
    for match in $scope.summonerMatchList.matches
      match.champion = getChampionByChampId(match.champion)

  determineMeleeRangedPreference = (matches) ->
    $scope.meleeRangedGames = {ranged : 0, melee: 0}
    for match in matches
      if match.champion.stats.attackrange < 200
        $scope.meleeRangedGames.melee++
        # if match.matchData.
      else
        $scope.meleeRangedGames.ranged++
    if $scope.meleeRangedGames.ranged > $scope.meleeRangedGames.melee
      $scope.meleeRangedPreference = "ranged"
    else if $scope.meleeRangedGames.ranged < $scope.meleeRangedGames.melee
      $scope.meleeRangedPreference = "melee"
    else
      $scope.meleeRangedPreference = "neither ranged nor melee"


  $scope.getSummonerData = () ->
    $http.get("/summonerInfoByName/#{$scope.summonerNameInput}").then (response) ->
        $scope.summoner = response.data[$scope.summonerNameInput.toLowerCase()]
        $http.get("/summonerStatsById/#{$scope.summoner.id}").then (response) ->
          $scope.summonerStats = response.data
        $http.get("/summonerMatchListById/#{$scope.summoner.id}").then (response) ->
          $scope.summonerMatchList = response.data
          $scope.summonerMatchListLength = Object.keys($scope.summonerMatchList)
          attachChampionsToMatches($scope.summonerMatchList)
          determineMeleeRangedPreference($scope.summonerMatchList.matches)
          # for match in $scope.summonerMatchList.matches
            # $http.get("/matchDetailsById/#{match.matchId}").then (response) ->
              # match.matchData = response.data
              # userTeam =

)
