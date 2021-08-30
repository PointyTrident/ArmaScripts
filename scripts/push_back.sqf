// =====================================================================================================================
// Author: PointTrident
// Description: Allows you to reverse a plane while stationary & engine is running
// Usage: Add `execVm "scripts\push_back.sqf"` to the player's init.
// =====================================================================================================================

PT_fnc_push_back_setup = {
    player addAction["Push Back", {
        vehicle player setVelocityModelSpace [0, -10, -1];
    }, [], 0, true, false, "", "vehicle player isKindOf 'Plane' && driver vehicle player == player && speed player < 1 && isTouchingGround vehicle player && isEngineOn vehicle player"];
};

// single & multiplayer setup
player addEventHandler ["Respawn", { [] call PT_fnc_push_back_setup }];
[] call PT_fnc_push_back_setup;
