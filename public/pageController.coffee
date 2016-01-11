app = angular.module('leagueApp', [])

app.controller('mainController', ($scope, $http, $q) ->
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

  determineWhetherSummonerPrefersMeleeOrRanged = (meleeRangedGames) ->
    if meleeRangedGames.ranged > meleeRangedGames.melee
      $scope.meleeRangedPreference = "ranged"
    else if meleeRangedGames.ranged < meleeRangedGames.melee
      $scope.meleeRangedPreference = "melee"
    else
      $scope.meleeRangedPreference = "neither ranged nor melee"

  attachMatchDataToMatchlist =  (matches) ->
    meleeGamesWon = 0
    meleeGamesLost = 0
    rangedGamesWon = 0
    rangedGamesLost = 0
    promiseArray = []

    for match, index in matches
      promiseArray.push($http.get("/matchDetailsById/#{match.matchId}"))  # $q.all  ???
    $q.all(promiseArray).then (responses) ->
      for response, index in responses
          $scope.summonerMatchlist.matches[index].matchData = response.data
          $scope.summonerMatchlist.matches[index].winner = determineIfSummonerWonOrLost(response.data)
          if $scope.summonerMatchlist.matches[index].winner && $scope.summonerMatchlist.matches[index].champion.stats.attackrange < 200
            meleeGamesWon++
          else if !$scope.summonerMatchlist.matches[index].winner && $scope.summonerMatchlist.matches[index].champion.stats.attackrange < 200
            meleeGamesLost++
          else if $scope.summonerMatchlist.matches[index].winner
            rangedGamesWon++
          else
            rangedGamesLost++
      $scope.percentMeleeGamesWon = Math.round(meleeGamesWon/(meleeGamesWon+meleeGamesLost)*100)
      $scope.percentRangedGamesWon = Math.round(rangedGamesWon/(rangedGamesWon+rangedGamesLost)*100)
  determineIfSummonerWonOrLost = (matchData) ->
    summonerMatchParticipantId = _.find(matchData.participantIdentities, "player.summonerId", $scope.summoner.id).participantId
    return _.find(matchData.participants, "participantId", summonerMatchParticipantId).stats.winner


  $scope.getSummonerData = () ->
    $http.get("/championData").then (response) ->
      $scope.champions = response.data.data
      $http.get("/summonerInfoByName/#{$scope.summonerNameInput}").then (response) ->
        $scope.summoner = response.data[$scope.summonerNameInput.toLowerCase()]
        $http.get("/summonerMatchlistById/#{$scope.summoner.id}").then (response) ->
          $scope.summonerMatchlist = response.data
          attachChampionsToMatches($scope.summonerMatchlist)
          meleeRangedGames = determineWhetherSummonerHasPlayedMoreGamesAsMeleeOrRanged($scope.summonerMatchlist.matches)
          determineWhetherSummonerPrefersMeleeOrRanged(meleeRangedGames)
          attachMatchDataToMatchlist($scope.summonerMatchlist.matches)
          $q.when()
)
