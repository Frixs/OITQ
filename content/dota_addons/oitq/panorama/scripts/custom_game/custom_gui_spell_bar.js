"use strict";

function AutoUpdateAbility()
{
    var player = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
    
	UpdateAbilityCooldown(player);
	UpdateAbilitySilence(player);
    UpdateAbilityLPoints(player);
    UpdateShurikenCharges(player);
    
	$.Schedule( 0.1, AutoUpdateAbility );
}

function UpdateAbilityCooldown(player)
{
    for( var i = 0; i < 6; i++ )
    {
        var abilityIndex = Entities.GetAbility( player, i );
        /**
        *   0 = primary
        *   1 = secondary
        *   2 = normal1
        *   3 = normal2
        *   4 = normal3
        *   5 = ultimate
        */
        if( Abilities.IsCooldownReady(abilityIndex) )
        {
            //cooldown remaining
            $("#abilityBox-"+i+"").GetChild(0).GetChild(1).style.backgroundColor = "#00000000";
            $("#abilityBox-"+i+"").GetChild(0).GetChild(1).GetChild(0).RemoveClass("cooldownActive");
        }
        else
        {
            //cooldown remaining
            var CDRemaining = Abilities.GetCooldownTimeRemaining(abilityIndex);
            CDRemaining = CDRemaining < 3 ? CDRemaining.toFixed(1) : Math.ceil(CDRemaining);
            $("#abilityBox-"+i+"").GetChild(0).GetChild(1).style.backgroundColor = "#000000DA";
            $("#abilityBox-"+i+"").GetChild(0).GetChild(1).GetChild(0).text = CDRemaining;
            $("#abilityBox-"+i+"").GetChild(0).GetChild(1).GetChild(0).AddClass("cooldownActive");
        }
    }
}

function UpdateAbilitySilence(player)
{
    var silence_bool = Entities.IsSilenced(player);
    var silence_bool_stored = $("#abilityBox-0").GetAttributeInt("silence_bool", 0);
    var silence_bool_numb = 0;

    if( silence_bool && (silence_bool_stored || !silence_bool_stored) )
    {
        for( var i = 0; i < 6; i++ )
        {
            $("#abilityBox-"+i+"").GetChild(0).GetChild(3).AddClass("silenceBox-on");
        }
        silence_bool_numb = 1;
    }
    else if( !silence_bool && silence_bool_stored )
    {
        for( var i = 0; i < 6; i++ )
        {
            $("#abilityBox-"+i+"").GetChild(0).GetChild(3).AddClass("silenceBox-on");
        }
    }
    else
    {
        for( var i = 0; i < 6; i++ )
        {
            $("#abilityBox-"+i+"").GetChild(0).GetChild(3).RemoveClass("silenceBox-on");
        }
    }
    
    $("#abilityBox-0").SetAttributeInt("silence_bool", silence_bool_numb);
}

function UpdateAbilityLPoints(player)
{    
    var player_lp = Entities.GetAbilityPoints(player);
    
    //Learning Button
    $("#LPAdd-text").text = "+" + player_lp;
    
    if( player_lp == 0 )
    {
        $("#LPAdd-box").style.opacity = 0;
    }
    else
    {
        $("#LPAdd-box").style.opacity = 1;        
    }
    
    //pokud nastaví learning point, tak se automaticky vypne learn mode || nebo pokud se vypne learning mode jiným způsobem, tak se vypne overlay barva
    var learnColorStatus = false;
    //cycle pro zjištění, zda-li je aktivní overlay learn color po vypnutí learn mode
    for( var i = 2; i < 5; i++ ) //only normal1/2/3
    {
        if( $("#abilityBox-"+i+"").GetChild(0).GetChild(2).style.backgroundColor != "#00000000" )
        {
            learnColorStatus = true;
            break;
        }
    }
        
	if ( (Game.IsInAbilityLearnMode() && player_lp == 0) || (!Game.IsInAbilityLearnMode() && learnColorStatus == true) )
	{
		Game.EndAbilityLearnMode();
        SetIconOverlayColor(player,"#00000000");
	}
    
    //Learning Points indicator on each spell
    for( var i = 2; i < 5; i++ ) //only normal1/2/3
    {
        var abilityIndex = Entities.GetAbility( player, i );        
        //Learning Points
        if( Abilities.GetMaxLevel(abilityIndex) > 1 )
        {
            var abilityLevel = Abilities.GetLevel(abilityIndex);
            for( var y = 0; y < 6; y++ )
            {
                if( y == abilityLevel )
                {
                    break;
                }
                else
                {
                    $("#abilityBox-"+i+"").GetChild(2).GetChild(y).AddClass("LPActive");                    
                }
            }
        }
    }
}

function UpdateShurikenCharges(player)
{
    var buffIndex = Entities.GetBuff( player, 0 );
    var buff_charges = Buffs.GetStackCount( player, buffIndex );
    
    $("#shurikenCharges").text = buff_charges;
}

function OnLoadAbilities()
{
    var player = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
    
    for( var i = 0; i < 6; i++ )
    {
        var abilityIndex   = Entities.GetAbility( player, i );
        var ability_name   = Abilities.GetAbilityName( abilityIndex );        
        var ability_hotkey = Abilities.GetKeybind( abilityIndex );
        
        if( Abilities.IsPassive( abilityIndex ) )
        {
            ability_hotkey = "\\/\\";
            $("#abilityBox-"+i+"").GetChild(0).GetChild(4).AddClass("passiveBox-on");
        }
        else
        {
            $("#abilityBox-"+i+"").GetChild(0).GetChild(4).RemoveClass("passiveBox-on");
        }
        
        $("#abilityBox-"+i+"").GetChild(0).GetChild(0).abilityname = ability_name;
        $("#abilityBox-"+i+"").GetChild(1).GetChild(0).text = ability_hotkey;
    }
    
    $.Schedule( 1.0, OnLoadAbilities );
}



(function () {
    OnLoadAbilities();
    AutoUpdateAbility();
})();



function AbilityShowTooltip(spellPosition)
{
    var player = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
    var abilityIndex = Entities.GetAbility( player, spellPosition );
    
	var abilityButton = $("#abilityBox-"+spellPosition+"").GetChild(0);
	var abilityName = Abilities.GetAbilityName( abilityIndex );

	$.DispatchEvent( "DOTAShowAbilityTooltip", abilityButton, abilityName );
}
      
function AbilityHideTooltip(spellPosition)
{
	var abilityButton = $("#abilityBox-"+spellPosition+"").GetChild(0);
	$.DispatchEvent( "DOTAHideAbilityTooltip", abilityButton );
}

function ActivateAbility(spellPosition)
{
    var player = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
    var abilityIndex = Entities.GetAbility( player, spellPosition );
    
	if ( Game.IsInAbilityLearnMode() )
	{
		Abilities.AttemptToUpgrade( abilityIndex );
		return;
	}
	Abilities.ExecuteAbility( abilityIndex, player, false );
}

function OnLevelUpClicked()
{
    var learnColor;
    var player = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
    
	if ( Game.IsInAbilityLearnMode() )
	{
		Game.EndAbilityLearnMode();
        learnColor = "#00000000";
	}
	else
	{
		Game.EnterAbilityLearnMode();
        learnColor = "#FFCE0055";
	}
    
    SetIconOverlayColor(player,learnColor);
}

function SetIconOverlayColor(player,color)
{
    //set icon overlay learn color
    for( var i = 0; i < 6; i++ )
    {
        var abilityIndex    = Entities.GetAbility( player, i );
        var abilityLevel    = Abilities.GetLevel(abilityIndex);
        var abilityMaxLevel = Abilities.GetMaxLevel(abilityIndex);
        
        if( abilityMaxLevel != 1 && (abilityLevel < abilityMaxLevel || (color == "#00000000" && abilityLevel <= abilityMaxLevel)) )
        {
            $("#abilityBox-"+i+"").GetChild(0).GetChild(2).style.backgroundColor = color;
        }
    }
}