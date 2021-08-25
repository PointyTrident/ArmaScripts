// =====================================================================================================================
// Author: PointTrident
// Description: Saves loudout when exiting virtual arsenal. When respawning, gear will be automatically re-equipped.
// Usage: Add to the player's init: `execVm "scripts\save_loadout.sqf"`
// =====================================================================================================================

// Only players past this point
if(!hasInterface) exitWith { };

// Save initial loadout & after closing the arsenal
[missionNamespace, "arsenalClosed", { player setVariable["PT_loadout", getUnitLoadout player] }] call bis_fnc_addScriptedEventHandler;
player setVariable["PT_loadout", getUnitLoadout player];

// Reload loadout after respawn
player addEventHandler ["Respawn", {
    params["_player", "_body"];
    _loadout = _player getVariable["PT_loadout", objNull];
    if(typeName _loadout == "ARRAY") then {
        _player setUnitLoadout _loadout;
    }
}];
