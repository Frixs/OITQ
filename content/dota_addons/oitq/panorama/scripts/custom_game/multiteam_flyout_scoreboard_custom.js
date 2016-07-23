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
            
            $("#_dynamic_team_"+key+"").GetChild(0).GetChild(2).GetChild(0).text = value;
        }
    }
}

(function()
{
    AutoUpdate();
})();