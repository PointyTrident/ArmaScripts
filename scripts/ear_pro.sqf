// =====================================================================================================================
// Author: PointTrident
// Description: Adds a keybinding (END) to put on ear protection & reduce the environmental volume.
// Usage: include the file 'images\mute.paa' in mission & add `execVm "scripts\ear_pro.sqf"` to the players init
// =====================================================================================================================

// Only players past this point
if(!hasInterface) exitWith { };

waitUntil {!(IsNull findDisplay 46)};
findDisplay 46 displayAddEventHandler ["keydown", {
    if((_this select 1)  == 207) then { // Hotkey: END
        if (soundVolume == 1) then { // Put on
            1 fadeSound 0.2;
            ["<img image='assets\images\mute.paa' />", 1.15, -0.15, 9.9999e14, 0.5, 0, 63178] spawn bis_fnc_dynamicText;
        } else { // Take off
            1 fadeSound 1;
            63178 cutText ["", "PLAIN"];
        };
    };
}];
