"use strict";

function AutoUpdate()
{
    CurrentVoteStatus();
    
	$.Schedule( 0.1, AutoUpdate );
}

function CurrentVoteStatus()
{
    var votes = CustomNetTables.GetTableValue( "gameinfo", "votes" );
    if( votes )
    {
        var playerIDs = Game.GetAllPlayerIDs();
        var playerCount = playerIDs.length;
        var voteCount = 0;
        var VoteYes   = 0;
        var VoteNo    = 0;
        
        for (var key in votes)
        {
            if (!votes.hasOwnProperty(key)) continue;
            
            for( var y = 0; y < playerCount; y++ )
            {
                if( playerIDs[y] == key )
                {
                    if( votes[key] == 2 ){ VoteYes++; }
                    else{ VoteNo++; }
                    voteCount++;
                }
            }
        }
        
        var percentualWidth = VoteYes / (voteCount/100);
        $("#voting-progress-wrapper").GetChild(0).GetChild(0).style.width = percentualWidth+"%";
    }
}



(function () {
    AutoUpdate();
})();



function PlayerVote(status)
{
    var playerID = Game.GetLocalPlayerID();
    GameEvents.SendCustomGameEventToServer( "SetPlayerVote", { "playerID" : playerID, "voteStatus" : status } );
}