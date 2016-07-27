"use strict";

function AutoUpdate()
{
    var hero = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
    
	$.Schedule( 0.1, AutoUpdate );
}



(function () {
    AutoUpdate();
    ChangeHeroSelection(0); //initial select
    // bug fix
    GameUI.SetRenderTopInsetOverride( 0 );
    GameUI.SetRenderBottomInsetOverride( 0 );
})();

function ChangeHeroSelection(heroNumb)
{
    var abilityArray = [
                        [
                            "shuriken_spell",
                            "shuriken_spell",
                            "shuriken_spell",
                            "shuriken_spell",
                            "shuriken_spell"
                        ], 
                        [
                            "dash_spell",
                            "anger_aura_spell",
                            "fork_spell",
                            "ground_pound_spell",
                            "vanishing_act_spell"
                        ],
                        [
                            "ability_evasion",
                            "ability_evasion",
                            "ability_evasion",
                            "ability_evasion",
                            "ability_evasion"
                        ],
                        [
                            "",
                            "",
                            "",
                            "",
                            ""
                        ],
                        [
                            "ability_time_lapse",
                            "ability_time_lapse",
                            "ability_time_lapse",
                            "ability_time_lapse",
                            "ability_time_lapse"
                        ],
                        [
                            "ice_block_spell",
                            "ice_block_spell",
                            "ice_block_spell",
                            "ice_block_spell",
                            "ice_block_spell"
                        ]
                       ];
    
    for(var i = 0; i < 5; i++)
    {
        // unset hover on hero icon
        $("#selection-hero-"+i+"").RemoveClass("selection-hero-active");
        // set hero abilities
        $("#selection-ability-"+i+"").GetChild(1).GetChild(0).abilityname = abilityArray[i][heroNumb];
    }
    // set true hover
    $("#selection-hero-"+heroNumb+"").AddClass("selection-hero-active");
    
    // get hero name
    var heroName = $("#selection-hero-"+heroNumb+"").GetChild(2).text;
    // set hero name
    $("#selection-hero-name").text = heroName;
    // set hero image
    $("#selection-hero-preview-wrapper").GetChild(0).SetImage("file://{resources}/videos/heroes/npc_dota_hero_"+ heroName.toLowerCase().replace(" ","_") +".gif");
    // set output hero name
    $("#selection-button").GetChild(1).text = "npc_dota_hero_"+ heroName.toLowerCase().replace(" ","_");
}

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