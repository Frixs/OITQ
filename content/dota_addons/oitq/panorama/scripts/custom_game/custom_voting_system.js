"use strict";

function AutoUpdate()
{
    CurrentVoteStatus();

	$.Schedule( 0.1, AutoUpdate );
}

function AutoUpdateSec()
{
    CountdownTimer();

	$.Schedule( 1.0, AutoUpdateSec );
}

function CurrentVoteStatus()
{
    var votes         = CustomNetTables.GetTableValue( "gameinfo", "votes" );
    var specialValues = CustomNetTables.GetTableValue( "gameinfo", "special_values" );
    if( votes && specialValues )
    {
        var playerIDs = Game.GetAllPlayerIDs();
        var playerCount = playerIDs.length;
        var voteCount = 0;
        var VoteYes   = 0;
        var VoteNo    = 0;
        
        // increment votes
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
        
        // set progress bar
        var percentualWidth = VoteYes / (voteCount/100);
        if(!percentualWidth){percentualWidth = 0;}
        $("#voting-progress-wrapper").GetChild(0).GetChild(0).style.width = percentualWidth+"%";
        
        // set remaining votes
        var neededVotes = specialValues['minimumVotes'] - VoteYes;
        if(neededVotes < 0){neededVotes = 0;}
        $("#voting-progress-wrapper").GetChild(1).GetChild(1).text = neededVotes;
    }
    else if( specialValues )
    {
        // set default remaining votes
        $("#voting-progress-wrapper").GetChild(1).GetChild(1).text = specialValues['minimumVotes'];
    }
}

function CountdownTimer()
{
    var votes         = CustomNetTables.GetTableValue( "gameinfo", "votes" );
    var specialValues = CustomNetTables.GetTableValue( "gameinfo", "special_values" );
    var gameTimes     = CustomNetTables.GetTableValue( "gameinfo", "game_times" );
    if( specialValues && gameTimes )
    {
        //voting countdown
        gameTimes['post_game'];
        var remainingVotingTime = $("#voting-time").GetAttributeInt( "countdown", specialValues['rematchVotingTime'] );
        
        if( remainingVotingTime >= 0 )
        {
            $("#voting-time").GetChild(0).text = remainingVotingTime;
            $("#voting-time").SetAttributeInt( "countdown", (remainingVotingTime - 1) );
        }
        else
        {
            
        }
    }
}



(function () {
    AutoUpdate();
    AutoUpdateSec();
})();



function PlayerVote(status)
{
    var playerID = Game.GetLocalPlayerID();
    GameEvents.SendCustomGameEventToServer( "SetPlayerVote", { "playerID" : playerID, "voteStatus" : status } );
}