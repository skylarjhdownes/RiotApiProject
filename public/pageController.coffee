app = angular.module('potatoApp', [])

app.controller('potatoController', ($scope, $http) ->
  $scope.summoner = {}
  $scope.summonerMatchlist = {}
  $scope.summonerNameInput = ''
  # $http.get("http://ddragon.leagueoflegends.com/cdn/5.2.1/img/champion/Annie.png").then (response) ->
  #   $scope.annie = response.data
  # $scope.annie = "http://ddragon.leagueoflegends.com/cdn/5.2.1/img/champion/Annie.png"

  getChampionByChampId = (id) ->
    _.find($scope.champions, "id", id)

  attachChampionsToMatches = (matches) ->
    for match in $scope.summonerMatchlist.matches
      match.champion = getChampionByChampId(match.champion)

  determineWhetherSummonerHasPlayedMoreGamesAsMeleeOrRanged = (matches) ->
    meleeRangedGames = {ranged : 0, melee: 0}
    for match in matches
      if match.champion.stats.attackrange < 200
        meleeRangedGames.melee++
      else
        meleeRangedGames.ranged++
    return meleeRangedGames

  #I think this is assuming that attachChampionsToMatches has already finished, which doesn't work.
  determineWhetherSummonerPrefersMeleeOrRanged = (meleeRangedGames) ->
    if meleeRangedGames.ranged > meleeRangedGames.melee
      $scope.meleeRangedPreference = "ranged"
    else if meleeRangedGames.ranged < meleeRangedGames.melee
      $scope.meleeRangedPreference = "melee"
    else
      $scope.meleeRangedPreference = "neither ranged nor melee"

  attachMatchDataToMatchlist =  (matches) ->
    doTheThing = (match, index) ->
      $http.get("/matchDetailsById/#{match.matchId}").then (response) ->
        $scope.summonerMatchlist.matches[index].matchData = response.data
    for match, index in matches
      doTheThing(match,index)



  $scope.getSummonerData = () ->
    $http.get("/championData").then (response) ->
      $scope.champions = response.data.data
    $http.get("/summonerInfoByName/#{$scope.summonerNameInput}").then (response) ->
        $scope.summoner = response.data[$scope.summonerNameInput.toLowerCase()]
        $http.get("/summonerMatchlistById/#{$scope.summoner.id}").then (response) ->
          $scope.summonerMatchlist = response.data
          $scope.summonerMatchlistLength = Object.keys($scope.summonerMatchlist)
          attachChampionsToMatches($scope.summonerMatchlist)
          meleeRangedGames = determineWhetherSummonerHasPlayedMoreGamesAsMeleeOrRanged($scope.summonerMatchlist.matches)
          determineWhetherSummonerPrefersMeleeOrRanged(meleeRangedGames)
          attachMatchDataToMatchlist($scope.summonerMatchlist.matches)
            # $http.get("/matchDetailsById/#{match.matchId}").then (response) ->
              # match.matchData = response.data
              # userTeam =

)
