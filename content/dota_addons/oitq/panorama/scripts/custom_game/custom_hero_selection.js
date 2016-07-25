"use strict";

function AutoUpdate()
{
    var hero = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
    
	$.Schedule( 0.1, AutoUpdate );
}



(function () {
    AutoUpdate();
})();

function AbilityShowTooltip(spellPosition)
{
	var abilityButton = $("#selection-ability-"+spellPosition+"").GetChild(1);
	var abilityName = $("#selection-ability-"+spellPosition+"").GetChild(1).GetChild(0).abilityname;

	$.DispatchEvent( "DOTAShowAbilityTooltip", abilityButton, abilityName );
}
      
function AbilityHideTooltip(spellPosition)
{
	var abilityButton = $("#selection-ability-"+spellPosition+"").GetChild(1);
	$.DispatchEvent( "DOTAHideAbilityTooltip", abilityButton );
}

function closeWindow()
{
    $("#heroSelection-background").AddClass("translator");
}

function openWindow()
{
    $("#heroSelection-background").RemoveClass("translator");
}