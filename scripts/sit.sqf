// =====================================================================================================================
// Author: PointTrident
// Description: Allows player to sit on chairs via action
// Usage: Add to the init of a chair you want to sit on: `[this] execVm "scripts\sit.sqf"`
// =====================================================================================================================

params ["_chair"];
_chair addAction["<t size='2'>Sit</t>", {
    // Sit player on chair
    params ["_chair", "_caller"];
    _chair setVariable ["PT_chair", true, true];
    _caller setVariable ["PT_chair", getPosATL _caller];
    _caller setPosATL (getPosATL _chair);
    _caller setDir ((getDir _chair) - 180);
    [_caller, "Crew"] remoteExec ["switchMove", 0];

    // Add stand action
    _caller addAction["<t size='2'>Stand</t>", {
        params ["_target", "_caller", "_action", "_args"];
        _args params ["_chair"];
        _caller setPos (_caller getVariable["PT_chair", (_chair getRelPos [-1, 0])]);
        [_caller, ""] remoteExec ["switchMove", 0];
        _caller removeAction _action;
        _caller setVariable ["PT_chair", nil];
        _chair setVariable ["PT_chair", nil, true];
    }, [_chair], 100, true, true, "GetOut", "true", 0];
}, nil, 100, true, true, "", "!(_target getVariable['PT_chair', false]) && typeName (_this getVariable['PT_chair', objNull]) != 'ARRAY'", 2];
