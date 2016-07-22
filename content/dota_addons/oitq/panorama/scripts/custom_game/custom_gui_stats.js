"use strict";

function AutoUpdate()
{
    var hero = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );

    UpdateStats(hero);
    
	$.Schedule( 0.1, AutoUpdate );
}

function UpdateStats(hero)
{
    var player = Players.GetLocalPlayer();

    var currentLevel = Entities.GetLevel( hero );
    var currentXP    = Entities.GetCurrentXP( hero );
    var neededXP     = Entities.GetNeededXPToLevel( hero );
    var heroName     = Entities.GetUnitName( hero );
    var strength     = Entities.GetDamageMax( hero );
    var attkSpeed    = Entities.GetAttacksPerSecond( hero );
    var resistance   = Entities.GetBaseMagicalResistanceValue( hero );
    var movSpeed     = Entities.GetIdealSpeed( hero );
    var goldAmount   = Players.GetGold( player );
    
    if( currentLevel < 7 )
    {
        var xp_level_table = CustomNetTables.GetTableValue( "gameinfo", "xp_level_table" );
        if ( xp_level_table )
        {
            //xp_level_table.XPlevel_2;
            var xpTableOnCurrentLvl  = xp_level_table["XPlevel_"+currentLevel+""];
            var percentOnLevel       = (neededXP - xpTableOnCurrentLvl) / 100;
            var xpOnLevel            = (currentXP - xpTableOnCurrentLvl);
            var currentXPpercentage  = xpOnLevel / percentOnLevel;
            if ( percentOnLevel == 0 ) { currentXPpercentage = 0; } // because of hero spaws later in game
            var XPbarWidthPercentage = (130 / 100) * currentXPpercentage; //max width of XP progress bar
            if (!XPbarWidthPercentage){ XPbarWidthPercentage = 0; }
        }
    }
    else
    {
        var XPbarWidthPercentage = 130;
    }
    
    switch( heroName )
    {
        case "npc_dota_hero_juggernaut":
            heroName = "Jumper";
            break;
        case "npc_dota_hero_bloodseeker":
            heroName = "Brawler";
            break;
        case "npc_dota_hero_dark_seer":
            heroName = "Enchanter";
            break;
        case "npc_dota_hero_meepo":
            heroName = "Slam Shooter";
            break;
        case "npc_dota_hero_bounty_hunter":
            heroName = "Ninja";
            break;
        default:
            heroName = "Undefined";
    }
    
    $("#XPprogress").style.width = XPbarWidthPercentage + "px";
    $("#levelNumber").text = currentLevel;
    $("#heroName").text = heroName;
    $("#strengthNumber").text = strength;
    $("#attkSpeedNumber").text = attkSpeed.toFixed(2) + "/s";
    $("#resistanceNumber").text = resistance;
    $("#speedNumber").text = movSpeed;
    $("#goldNumber").text = goldAmount;
}



(function () {
    AutoUpdate();
})();