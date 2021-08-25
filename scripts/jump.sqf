// =====================================================================================================================
// Author: PointTrident
// Description: Replaces the default get over action with contextual jump which will vault while moving or climb
// medium/tall objects using different vanilla animations.
// Usage: Add this script to the player's init: `execVm "scripts\jump.sqf"`
// =====================================================================================================================

// Only players past this point
if(!hasInterface) exitWith { };

waitUntil {!(IsNull findDisplay 46)};
findDisplay 46 displayAddEventHandler ["keydown", {
    if((_this select 1) in actionKeys "GetOver") then {
        if(!(player getVariable["jumping", false]) && vehicle player == player) then {
            player setVariable["jumping", true];

            // Climb check
            _climbHeight = -1;
            for [{_height = 2.5}, {_height >= 0.5}, {_height = _height - 0.05}] do {
                _obstacles = lineIntersectsSurfaces [AGLtoASL (player modelToWorld [0, 0, _height]), AGLtoASL (player modelToWorld [0, 1.5, _height]), player, objNull, true, -1, "GEOM", "VIEW"];
                if(count _obstacles > 0) then {
                    height + 0.05;
                    _no_roof = lineIntersectsSurfaces [AGLtoASL (player modelToWorld [0, 0, 1]), AGLtoASL (player modelToWorld [0, 0, _height + 1]), player, objNull, true, -1, "GEOM", "VIEW"];
                    _no_space = lineIntersectsSurfaces [AGLtoASL (player modelToWorld [0, 1.2, _height + 0.05]), AGLtoASL (player modelToWorld [0, 1.2, _height + 1.8]), player, objNull, true, -1, "GEOM", "VIEW"];
                    if(count _no_space == 0 && count _no_roof == 0) then { _climbHeight = _height };
                    break;
                };
            };

            // Climb
            if(_climbHeight != -1) then {
                _animation = "GetInHeli_Transport_02Cargo";
                _offset = [0, 0, _climbHeight - 1.4];
                _finished = [0, 1.2, _climbHeight];
                if(_climbHeight > 1.8) then { // Climb higher
                    _animation = "GetInHemttBack";
                    _offset = [0, -0.5, _climbHeight - 2];
                    _finished = [0, 1.5, _climbHeight];
                };
                player action ["SwitchWeapon", player, player, -1]; // Animation only works with weapon away :(
                [player, _animation] remoteExec ["switchMove", 0];
                player setPos (player modelToWorld _offset);
                [_climbHeight, _animation, _finished] spawn {
                    params ["_height", "_animation", "_finished"];
                    waitUntil { animationState player != _animation };
                    player setPos (player modelToWorld _finished);
                    player setVariable["jumping", nil];
                };
            } else {
                // Vault
                if(speed player > 5) then {
                    _height = 4;
                    if(currentWeapon player == primaryWeapon player && primaryWeapon player != "") then {
                        [player, "AovrPercMrunSrasWrflDf"] remoteExec ["switchMove", 0];
                        _height = 2;
                    };
                    _velocity = velocity player;
                    player setVelocity [_velocity # 0, _velocity # 1, _height];

                } else { // Use the default step over if we can't vault or climb
                    player playActionNow "GetOver";
                };
                [] spawn { sleep 1; player setVariable["jumping", nil]; };
            };
        };
        true;
    };
}];
