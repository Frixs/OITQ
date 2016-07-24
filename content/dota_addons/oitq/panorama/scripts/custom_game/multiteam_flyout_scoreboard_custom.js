"use strict";

function AutoUpdate()
{
    GetScore();
    
	$.Schedule( 0.1, AutoUpdate );
}

function GetScore()
{
    var teamScore = CustomNetTables.GetTableValue( "gameinfo", "teamScore" );
    if(teamScore)
    {
        for (var key in teamScore)
        {
            if (!teamScore.hasOwnProperty(key)) continue;
            var value = teamScore[key];
            
            // flyout + endscreen
            $("#_dynamic_team_"+key+"").GetChild(0).GetChild(2).GetChild(0).text = value;
            //endscreen
            $("#_dynamic_team_"+key+"").GetChild(0).GetChild(3).GetChild(0).text = GetTeamKills(parseInt(key));
        }
    }
}

///-----CUSTOM-----///
function GetTeamKills( teamID ) {
	var playersOnTeam = Game.GetPlayerIDsOnTeam( teamID )
	var killsForTeam = 0;

	for (var i = 0; i < playersOnTeam.length; i++) {
		killsForTeam+=Players.GetKills( playersOnTeam[i] );
	}

	return killsForTeam;
}

(function()
{
    AutoUpdate();
})();