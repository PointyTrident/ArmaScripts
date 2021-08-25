// =====================================================================================================================
// Author: PointTrident
// Description: Disables stamina for players.
// Usage: Add to the players init: `execVm "scripts\disable_stamina.sqf"`
// =====================================================================================================================

// Only players past this point
if(!hasInterface) exitWith { };

// single & multiplayer setup
player enableStamina false;
player addEventHandler ["Respawn", {
    params["_player"];
    _player enableStamina false;
}];
