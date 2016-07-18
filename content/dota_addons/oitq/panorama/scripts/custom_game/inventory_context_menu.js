"use strict";

function DismissMenu()
{
	$.DispatchEvent( "DismissAllContextMenus" );
}

function OnSell()
{
	Items.LocalPlayerSellItem( $.GetContextPanel().Item );
	DismissMenu();
}

function OnShowInShop()
{
	var itemName = Abilities.GetAbilityName( $.GetContextPanel().Item );
	
	var itemClickedEvent = {
		"link": ( "dota.item." + itemName ),
		"shop": 0,
		"recipe": 0
	};
	GameEvents.SendEventClientSide( "dota_link_clicked", itemClickedEvent );
	DismissMenu();
}

function OnDropItem()
{
    var hero = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
    var item_index = $.GetContextPanel().Item;
    var itemName = Abilities.GetAbilityName( item_index );

    GameEvents.SendCustomGameEventToServer( "OnDropItemInfo", { "itemName" : itemName, "hero" : hero } );
    
    DismissMenu();
}