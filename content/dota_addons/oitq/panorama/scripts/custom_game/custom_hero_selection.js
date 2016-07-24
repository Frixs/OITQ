"use strict";

function AutoUpdate()
{
    var hero = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
    
	$.Schedule( 0.1, AutoUpdate );
}



(function () {
    AutoUpdate();
})();

function closeWindow()
{
    $("#heroSelection-background").AddClass("translator");
}

function openWindow()
{
    $("#heroSelection-background").RemoveClass("translator");
}