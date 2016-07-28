"use strict";

function UpdateTimer( data )
{
	//$.Msg( "UpdateTimer: ", data );
	//var timerValue = Game.GetDOTATime( false, false );

	//var sec = Math.floor( timerValue % 60 );
	//var min = Math.floor( timerValue / 60 );

	//var timerText = "";
	//timerText += min;
	//timerText += ":";

	//if ( sec < 10 )
	//{
	//	timerText += "0";
	//}
	//timerText += sec;
    //var timerText = "";
//	timerText += data.timer_minute_10;
//	timerText += data.timer_minute_01;
//	timerText += ":";
//	timerText += data.timer_second_10;
//	timerText += data.timer_second_01;
//
//	$( "#Timer" ).text = timerText;

    var timerValue = Game.GetDOTATime(false,true);
    
    if( timerValue > 0 )
    {
        var min = Math.floor( timerValue / 60 );
        var sec = Math.floor( timerValue % 60 );

        var timerText = "";

        timerText += min < 10 ? 0 : "";
        timerText += min;
        timerText += ":";
        timerText += sec < 10 ? 0 : "";
        timerText += sec;
    }
    else if( timerValue > (-10) && timerValue < 0 )
    {
        // Countdown
        if( $( "#Timer" ).BHasClass("needToEmit_initialSound_1") )
        {
            $( "#Timer" ).RemoveClass( "needToEmit_initialSound_1" );
            GameEvents.SendCustomGameEventToServer( "OnEmitSound_countdown", { "soundName" : "announcer_dlc_defensegrid_announcer_count_battle_10" } );
            GameEvents.SendCustomGameEventToServer( "OnEmitSound_countdown", { "soundName" : "Game.Start.Countdown" } );
        }
        
        // Call Battle begins!
        if( $( "#Timer" ).BHasClass( "needToEmit_initialSound_2" ) && timerValue > (-1.5) )
        {
            $( "#Timer" ).RemoveClass( "needToEmit_initialSound_2" );
            GameEvents.SendCustomGameEventToServer( "OnEmitSound_countdown", { "soundName" : "announcer_dlc_defensegrid_announcer_battle_begin" } );
            GameEvents.SendCustomGameEventToServer( "SendGameStart", { "forWhom" : 0, "textMessage" : "THE BATTLE BEGINS!" } );
        }
        
        timerText = "PRE-GAME";
    }
    else
    {
        timerText = "PRE-GAME";
    }
    
	$( "#Timer" ).text = timerText;
    
	$.Schedule( 0.1, UpdateTimer );
}

function AddClassToEmitInitialSounds()
{
    $( "#Timer" ).AddClass( "needToEmit_initialSound_1" );
    $( "#Timer" ).AddClass( "needToEmit_initialSound_2" );
}

function ShowTimer( data )
{
	$( "#Timer" ).AddClass( "timer_visible" );
}

function AlertTimer( data )
{
	$( "#Timer" ).AddClass( "timer_alert" );
}

function HideTimer( data )
{
	$( "#Timer" ).AddClass( "timer_hidden" );
}

function UpdateKillsToWin()
{
	var victory_condition = CustomNetTables.GetTableValue( "game_state", "victory_condition" );
	if ( victory_condition )
	{
		$("#VictoryPoints").text = victory_condition.kills_to_win;
	}
}

function OnGameStateChanged( table, key, data )
{
	$.Msg( "Table '", table, "' changed: '", key, "' = ", data );
	UpdateKillsToWin();
}

(function()
{
	// We use a nettable to communicate victory conditions to make sure we get the value regardless of timing.
	UpdateKillsToWin();
	CustomNetTables.SubscribeNetTableListener( "game_state", OnGameStateChanged );

    //GameEvents.Subscribe( "countdown", UpdateTimer );
    GameEvents.Subscribe( "show_timer", ShowTimer );
    GameEvents.Subscribe( "timer_alert", AlertTimer );
    GameEvents.Subscribe( "overtime_alert", HideTimer );
    GameEvents.Subscribe( "AddClassToEmitInitialSounds", AddClassToEmitInitialSounds);
	UpdateTimer();
})();

