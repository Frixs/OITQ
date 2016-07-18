"use strict";

function UpdatePlayerHP()
{
    var player = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
    
    var playerHealth = Entities.GetHealth( player );
    var playerMaxHealth = Entities.GetMaxHealth( player );

    if( playerMaxHealth > 20 ) //20 = base HP value
    {
        $("#hp-bar-bonus").RemoveClass("hiddenBox");
        
        var settedMaxHealth = playerMaxHealth;
        for( var i = 0; i < 20; i++ ) //20 hearts
        {
            if( settedMaxHealth >= 2 )
            {
                $("#heart-"+i+"").RemoveClass("hiddenBox");
                settedMaxHealth -= 2;
            }
            else
            {
                $("#heart-"+i+"").AddClass("hiddenBox");
            }
        }
    }
    else if( playerMaxHealth < 20 )
    {
        var settedMaxHealth = playerMaxHealth;
        for( var i = 0; i < 10; i++ ) //10 hearts
        {
            if( settedMaxHealth >= 2 )
            {
                $("#heart-"+i+"").RemoveClass("hiddenBox");
                settedMaxHealth -= 2;
            }
            else
            {
                $("#heart-"+i+"").AddClass("hiddenBox");
            }
        }
        
        $("#hp-bar-bonus").AddClass("hiddenBox");
    }
    else
    {
        $("#hp-bar-bonus").AddClass("hiddenBox");
    }
    
    var settedHealth = playerHealth;
    var maxHearts = (playerMaxHealth / 2) > 20 ? 20 : (playerMaxHealth / 2);
    for( var i = 0; i < maxHearts; i++ )
    {
        $("#heart-"+i+"").RemoveClass("hiddenBox"); //nastavit viditelnost, pokud hráč zvětší max zásobu HP z 20 na 21 nebo více - nedošlo by k zviditelnění, tak nastavuji zde.
        
        if( settedHealth >= 2 )
        {
            $("#heart-"+i+"").RemoveClass("heart_1");
            $("#heart-"+i+"").RemoveClass("heart_0");
            $("#heart-"+i+"").AddClass("heart_2");
            settedHealth    -= 2;
        }
        else if( settedHealth == 1 )
        {
            $("#heart-"+i+"").RemoveClass("heart_2");
            $("#heart-"+i+"").RemoveClass("heart_0");
            $("#heart-"+i+"").AddClass("heart_1");
            settedHealth    -= 1;
        }
        else
        {
            $("#heart-"+i+"").RemoveClass("heart_2");
            $("#heart-"+i+"").RemoveClass("heart_1");
            $("#heart-"+i+"").AddClass("heart_0");
        }
    }
    
    $.Schedule( 0.1, UpdatePlayerHP );
}

function UIpositionByAspectRation()
{
    var height = Game.GetScreenHeight();
    var width  = Game.GetScreenWidth();
    var ar = width / height;

    if( ar < 1.6 ) // 16:10
    {
        $("#hp-wrapper").RemoveClass("AspectRatio-normal");
        $("#hp-wrapper").AddClass("AspectRatio-small");
    }
    else
    {
        $("#hp-wrapper").RemoveClass("AspectRatio-small");
        $("#hp-wrapper").AddClass("AspectRatio-normal");
    }
    
    $.Schedule( 30, UIpositionByAspectRation );
}

(function () {
    UIpositionByAspectRation();
    UpdatePlayerHP();
})();