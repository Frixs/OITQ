"use strict";

function AutoUpdate()
{
    var player = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
    
    UpdateItem(player);
    UpdateItemCooldown(player);
    
	$.Schedule( 0.1, AutoUpdate );
}

function UpdateItem(player)
{
    for( var i = 0; i < 6; i++ )
    {
        var item_index = Entities.GetItemInSlot( player, i );
        var item_name = Abilities.GetAbilityName( item_index );
        var item_hotkey = Abilities.GetKeybind( item_index );
        var item_charges = Items.GetCurrentCharges( item_index );
        if( item_charges < 1 ) item_charges = "";
        $("#itemPanel-"+i+"").GetChild(0).GetChild(0).itemname = item_name;
        $("#itemPanel-"+i+"").GetChild(1).GetChild(0).text = item_hotkey;
        $("#itemPanel-"+i+"").GetChild(0).GetChild(2).text = item_charges;
    }
}

function UpdateItemCooldown(player)
{
    for( var i = 0; i < 6; i++ )
    {
        var item_index = Entities.GetItemInSlot( player, i );
            
        if( Abilities.IsCooldownReady(item_index) || item_index == -1 )
        {
            //cooldown remaining
            $("#itemPanel-"+i+"").GetChild(0).GetChild(1).RemoveClass("cooldownActive");
        }
        else
        {
            //cooldown remaining
            var CDRemaining = Abilities.GetCooldownTimeRemaining(item_index);
            CDRemaining = CDRemaining < 3 ? CDRemaining.toFixed(1) : Math.ceil(CDRemaining);
            $("#itemPanel-"+i+"").GetChild(0).GetChild(1).GetChild(0).text = CDRemaining;
            $("#itemPanel-"+i+"").GetChild(0).GetChild(1).AddClass("cooldownActive");
        }
    }
}



(function () {
    AutoUpdate();
})();



function MoveItemLeft(currentSlot)
{
    MoveItem( 0, currentSlot );
}

function MoveItemRight(currentSlot)
{
    MoveItem( 1, currentSlot );
}

function MoveItem(direction, currentSlot)
{
    var player = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
    var item_index = Entities.GetItemInSlot( player, currentSlot );
    
    var targetSlot = direction == 0 ? (currentSlot - 1) : (currentSlot + 1);
    
	var moveItemOrder =
	{
		OrderType: dotaunitorder_t.DOTA_UNIT_ORDER_MOVE_ITEM,
		TargetIndex: targetSlot,
		AbilityIndex: item_index
	};
	Game.PrepareUnitOrders( moveItemOrder );
}

function ItemShowTooltip(itemSlot)
{
    var player = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
    var item_index = Entities.GetItemInSlot( player, itemSlot );
    
	if ( item_index == -1 )
		return;

    var itemButton = $("#itemPanel-"+itemSlot+"").GetChild(0);
	var itemName = Abilities.GetAbilityName( item_index );
    
    $.DispatchEvent( "DOTAShowAbilityTooltip", itemButton, itemName );
}

function ItemHideTooltip(itemSlot)
{
	var itemButton = $("#itemPanel-"+itemSlot+"").GetChild(0);
	$.DispatchEvent( "DOTAHideAbilityTooltip", itemButton );
}

function ActivateItem(itemSlot)
{
    var hero = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
    var item_index = Entities.GetItemInSlot( hero, itemSlot );

	Abilities.ExecuteAbility( item_index, hero, false );
}

function RightClickItem(itemSlot)
{
	ItemHideTooltip(itemSlot);
    var hero = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
    var item_index = Entities.GetItemInSlot( hero, itemSlot );
    
	var bControllable = Entities.IsControllableByPlayer( hero, Game.GetLocalPlayerID() );
	var bSellable     = Items.IsSellable( item_index ) && Items.CanBeSoldByLocalPlayer( item_index );
	var bShowInShop   = Items.IsPurchasable( item_index );
	var bDroppable    = Items.IsDroppable( item_index );

	if ( !bSellable && !bShowInShop )
	{
		// don't show a menu if there's nothing to do
		return;
	}

	var contextMenu = $.CreatePanel( "ContextMenuScript", $.GetContextPanel(), "" );
	contextMenu.AddClass( "ContextMenu_NoArrow" );
	contextMenu.AddClass( "ContextMenu_NoBorder" );
	contextMenu.GetContentsPanel().Item = item_index;
	contextMenu.GetContentsPanel().SetHasClass( "bSellable", bSellable );
	contextMenu.GetContentsPanel().SetHasClass( "bShowInShop", bShowInShop );
	contextMenu.GetContentsPanel().SetHasClass( "bDropFromStash", bDroppable ); //Drop Item
	contextMenu.GetContentsPanel().BLoadLayout( "file://{resources}/layout/custom_game/inventory_context_menu.xml", false, false );
}