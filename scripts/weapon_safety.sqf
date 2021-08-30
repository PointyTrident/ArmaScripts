// =====================================================================================================================
// Author: PointTrident
// Description: Adds weapon safety to player. Can be controlled manually or by adding markers to the config bellow.
// Usage: Add to init: `execVm "scripts\weapon_safety.sqf"`, then add markers or enable/disable manually with:
// `[player] call PT_fnc_safety_on` / `[player] call PT_fnc_safety_off`
// =====================================================================================================================
// Configure:
PT_SAFE_ZONES = ["safe_zone_1"]; // Turn on safety inside marker (Automatically turns off)
PT_UNSAFE_ZONES = ["unsafe_zone_1"]; // Does opposite; Turns off safety when entering marker (turns on when leaving)
// =====================================================================================================================

// Enables weapon safety
PT_fnc_safety_on = {
    (_this select 0) setVariable["PT_safety", true];
};

// Disables weapon safety
PT_fnc_safety_off = {
    (_this select 0) setVariable["PT_safety", nil];
};

// Only players past this point
if(!hasInterface) exitWith { };

// Setup that needs to be run on each player
PT_fnc_safety_setup = {
    // Block firing keybinding
    player addAction["Weapon Safety", {
        titleText["Weapon Safety", "PLAIN"];
        titleFadeOut 1;
    }, null, -1, false, false, "defaultAction", "player getVariable['PT_safety', false]"];

    // Catch anything else (Grenades, explosives, etc)
    player addEventHandler ["Fired", {
        if(player getVariable['PT_safety', false]) then {
            deleteVehicle (_this select 6);
            player addMagazine (_this select 5);
            titleText["Weapon Safety", "PLAIN"];
            titleFadeOut 1;
        };
    }];
};

// single & multiplayer setup
player addEventHandler ["Respawn", { [] call PT_fnc_safety_setup }];
[] call PT_fnc_safety_setup;

// Turn markers into triggers
_fnc_create_trigger = {
    params["_marker", "_triggerStatements"];
    _area = getMarkerSize _marker;
    _trigger = createTrigger["EmptyDetector", getMarkerPos _marker];
    _trigger setTriggerArea[_area select 0, _area select 1, markerDir _marker, markerShape _marker == "RECTANGLE"];
    _trigger setTriggerActivation ["anyPlayer", "present", true];
    _trigger setTriggerStatements [
        "this && vehicle player in thisList",
        _triggerStatements select 0,
        _triggerStatements select 1
    ];
};

// Setup local safe & unsafe zones
{ [_x, ["[player] call PT_fnc_safety_on;", "[player] call PT_fnc_safety_off;"]] call _fnc_create_trigger } forEach PT_SAFE_ZONES;
{ [_x, ["[player] call PT_fnc_safety_off;", "[player] call PT_fnc_safety_on;"]] call _fnc_create_trigger } forEach PT_UNSAFE_ZONES;
