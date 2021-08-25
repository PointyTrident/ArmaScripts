// =====================================================================================================================
// Author: PointTrident
// Description: Allows the player to holster their weapon by hitting 4 on the keyboard.
// Usage: Add to the player's init: `execVm "scripts\holster.sqf"`
// TODO: Sling over left sholder (if you dont have a launcher) allowing players to carry two primaries 
// =====================================================================================================================

// Only players past this point
if(!hasInterface) exitWith { };

waitUntil {!(IsNull findDisplay 46)};
(FindDisplay 46) displayAddEventHandler ["keydown", {
    if((_this select 1) == 5) then { // Hotkey: 4
        player action ["SwitchWeapon", player, player, -1];
    };
}];
