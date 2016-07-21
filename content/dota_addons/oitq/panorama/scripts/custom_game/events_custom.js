"use strict";

/*
// if you want to keep camera on target - disable Schedule
function InitialCameraRelocate()
{
    var hero = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
    InitialCameraRelocate_targetOn(hero);
    
    // set cycle for delay action
    var delay = $.Schedule( 0.5, InitialCameraRelocate );
    var delay_process = $("#CustomEvent_InitialCamera_Delay").GetAttributeInt("delay_process",0);
    //$.Msg(delay_process);
    
    // !!! IMPORTANT to change same value in settings.lua
    var start_respawn_time = 5;
    
    // untarget camera after start_respawn_time + 1/2sec. for relocate delay
    if( delay_process >= ((start_respawn_time * 2) +1) )
    {
        $.CancelScheduled( delay, InitialCameraRelocate );
        InitialCameraRelocate_targetOff();
    }
    
    // increment number calculating delay
    var delay_process_incremented = delay_process + 1;
    $("#CustomEvent_InitialCamera_Delay").SetAttributeInt("delay_process", delay_process_incremented);
}

function InitialCameraRelocate_targetOn( hero )
{
    GameUI.SetCameraTarget( hero );
}

function InitialCameraRelocate_targetOff()
{
    GameUI.SetCameraTarget( -1 );
}
*/

function InitCameraRelocate()
{
    var hero = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
    // !!! IMPORTANT to change same value in settings.lua
    var start_respawn_time = 5;
    
    GameUI.SetCameraTargetPosition( Entities.GetAbsOrigin( hero ), 1.0 )
}

(function () {
    //InitialCameraRelocate();
    GameEvents.Subscribe( "InitCameraRelocate", InitCameraRelocate);
})();