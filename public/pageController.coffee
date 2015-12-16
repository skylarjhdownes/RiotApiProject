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

  determineWhetherSummonerHasPlayedMoreGamesAsMeleeOrRanged = (matches) ->
    meleeRangedGames = {ranged : 0, melee: 0}
    for match in matches
      if match.champion.stats.attackrange < 200
        meleeRangedGames.melee++
      else
        meleeRangedGames.ranged++
    return meleeRangedGames

  determineWhetherSummonerPrefersMeleeOrRanged = (meleeRangedGames) ->
    if meleeRangedGames.ranged > meleeRangedGames.melee
      $scope.meleeRangedPreference = "ranged"
    else if meleeRangedGames.ranged < meleeRangedGames.melee
      $scope.meleeRangedPreference = "melee"
    else
      $scope.meleeRangedPreference = "neither ranged nor melee"

  attachMatchDataToMatchList =  (matches) ->
    doTheThing = (match, index) ->
      $http.get("/matchDetailsById/#{match.matchId}").then (response) ->
        $scope.summonerMatchList.matches[index].matchData = response.data
    for m, i in matches
      doTheThing(m,i)


  $scope.getSummonerData = () ->
    $http.get("/summonerInfoByName/#{$scope.summonerNameInput}").then (response) ->
        $scope.summoner = response.data[$scope.summonerNameInput.toLowerCase()]
        $http.get("/summonerStatsById/#{$scope.summoner.id}").then (response) ->
          $scope.summonerStats = response.data
        $http.get("/summonerMatchListById/#{$scope.summoner.id}").then (response) ->
          $scope.summonerMatchList = response.data
          $scope.summonerMatchListLength = Object.keys($scope.summonerMatchList)
          attachChampionsToMatches($scope.summonerMatchList)
          meleeRangedGames = determineWhetherSummonerHasPlayedMoreGamesAsMeleeOrRanged($scope.summonerMatchList.matches)
          determineWhetherSummonerPrefersMeleeOrRanged(meleeRangedGames)
          attachMatchDataToMatchList($scope.summonerMatchList.matches)
            # $http.get("/matchDetailsById/#{match.matchId}").then (response) ->
              # match.matchData = response.data
              # userTeam =

)
