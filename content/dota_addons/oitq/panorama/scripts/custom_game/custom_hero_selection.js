"use strict";

function AutoUpdate()
{
    RemainingTime();
    
	$.Schedule( 0.1, AutoUpdate );
}

function RemainingTime()
{
    var GameTime = Game.GetDOTATime(false, true).toFixed(0).replace("-","");
    var game_times = CustomNetTables.GetTableValue( "gameinfo", "game_times" );
    if( game_times )
    {
        var pregame_time = game_times['pregame'] - game_times['hero_selection'];
        var selection_remaining = GameTime - pregame_time;

        GameEvents.SendCustomGameEventToServer( "is_game_paused", {} );

        if(selection_remaining <= 0)
        {
            selection_remaining = 0;
            
            //auto pick default hero
            if( Players.GetPlayerSelectedHero( Game.GetLocalPlayerID() ) == "npc_dota_hero_wisp" )
            {
                SelectHero();
            }
        };
        
        $("#selection-time").text = selection_remaining;
    }
}

function HeroSelectionPauseInfo( status )
{
    if( status["pause"] == 1 )
    {
        $("#selection-time").style.color="#620000";
        $("#selection-time-info").style.color="#620000";
        $("#selection-time-info").style.opacity=1;
    }
    else
    {
        $("#selection-time").style.color="#ffefcc";
        $("#selection-time-info").style.color="#ffefcc";
        $("#selection-time-info").style.opacity=0;
    }
}

function OpenHeroSelectionScreen()
{
    $("#selection-screen").RemoveClass("translator");
}


(function () {
    AutoUpdate();
    ChangeHeroSelection(0); //initial select
    GameEvents.Subscribe( "HeroSelectionPauseInfo", HeroSelectionPauseInfo);
    GameEvents.Subscribe( "OpenHeroSelectionScreen", OpenHeroSelectionScreen);
    // bug fix
    GameUI.SetRenderTopInsetOverride( 0 );
    GameUI.SetRenderBottomInsetOverride( 0 );
})();



function SelectHero()
{
    if( !$("#selection-screen").BHasClass("translator") )
    {
        var selectedHero = $("#selection-button").GetChild(1).text;
        GameEvents.SendCustomGameEventToServer( "selectHero", { "playerID" : Game.GetLocalPlayerID(), "heroName" : selectedHero } );
        
        // close hero selection screen
        $("#selection-screen").AddClass("translator");
        //relocate camera to new hero
        var hero = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
        GameUI.SetCameraTargetPosition( Entities.GetAbsOrigin( hero ), 1.0 );
    }
}

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
    var heroNames = $("#selection-hero-"+heroNumb+"").GetChild(2).text;
    heroNames = heroNames.split("|");
    var heroName = heroNames[0];
    var heroOriginalName = heroNames[1];
    // set hero name
    $("#selection-hero-name").text = heroName;
    // set hero image
    $("#selection-hero-preview-wrapper").GetChild(0).SetImage("file://{resources}/videos/heroes/npc_dota_hero_"+ heroName.toLowerCase().replace(" ","_") +".gif");
    // set output hero name
    $("#selection-button").GetChild(1).text = "npc_dota_hero_"+ heroOriginalName.toLowerCase().replace(" ","_");
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
    $("#selection-screen").AddClass("translator");
}

function openWindow()
{
    $("#selection-screen").RemoveClass("translator");
}