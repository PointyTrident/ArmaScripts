// =====================================================================================================================
// Author: PointTrident
// Description: Lowers the quality of NVGs by lowering contrast & adding some blur & grain to make them feel realstic
// Usage: Add to the player's init: `execVm "scripts\realistic_nvg.sqf"`
// TODO: Replace default border with one for single/double/quad tube NVGs
// =====================================================================================================================
// Configuration:
PT_NVG_WHITE = [ // Use white phosphorus tubes instead of green
    "O_NVGoggles_ghex_F",
    "O_NVGoggles_grn_F",
    "O_NVGoggles_hex_F",
    "O_NVGoggles_urb_F",
    "NVGogglesB_blk_F",
    "NVGogglesB_grn_F",
    "NVGogglesB_gry_F",
    "CUP_NVG_GPNVG_black",
    "CUP_NVG_GPNVG_green",
    "CUP_NVG_GPNVG_Hide",
    "CUP_NVG_GPNVG_tan",
    "CUP_NVG_GPNVG_winter",
    "CUP_NVG_HMNVS",
    "CUP_NVG_HMNVS_Hide",
    "rhsusf_ANPVS_14",
    "rhsusf_ANPVS_15"
];
// =====================================================================================================================

// Only players past this point
if(!hasInterface) exitWith { };

while {true} do {
    // Wait until player turns on NVGs
    waitUntil { currentVisionMode player == 1 && isNull(curatorCamera) && isNull(uiNamespace getVariable ["BIS_fnc_arsenal_cam", objNull]) };
    _effects = [];

    // Add some blur
    _e1 = ppEffectCreate ["DynamicBlur", 101];
    _e1 ppEffectAdjust [0.4];
    _e1 ppEffectForceInNVG true;
    _e1 ppEffectEnable true;
    _e1 ppEffectCommit 0;
    _effects pushBack _e1;

    // Add some grain
    _e2 = ppEffectCreate ["FilmGrain", 102];
    _e2 ppEffectAdjust [0.1, 2, 3, 0.5, 0.5, false];
    _e2 ppEffectForceInNVG true;
    _e2 ppEffectEnable true;
    _e2 ppEffectCommit 0;
    _effects pushBack _e2;

    // Optionally switch from green to blue
    _vehicle = vehicle player;
    _view = cameraView;
    if(hmd player in PT_NVG_WHITE) then {
        _e3 = ppEffectCreate ["ColorCorrections", 1502];
        _e3 ppEffectAdjust [1, 0.8, 0, [1, 1, 1, 0], [0.5, 1, 1.2, 0], [1, 1, 1, 0]];
        _e3 ppEffectForceInNVG true;
        _e3 ppEffectEnable true;
        _e3 ppEffectCommit 0;
        _effects pushBack _e3;
    };

    // Remove effects once NVGs are taken off
    waitUntil { currentVisionMode player != 1 || _vehicle != vehicle player || _view != cameraView || !isNull(curatorCamera) || !isNull(uiNamespace getVariable ["BIS_fnc_arsenal_cam", objNull]) };
    { ppEffectDestroy _x; } forEach _effects;
};
