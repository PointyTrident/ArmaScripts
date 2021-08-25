// =====================================================================================================================
// Author: PointTrident
// Description: IFF (Identify Friend or Foe) allows players to attach chemlights or IR strobes to their helmet.
// Usage: Add `execVm "scripts\iff.sqf"` to the player's init.
// TODO: Attach to vehicles
// =====================================================================================================================

// Only players past this point
if(!hasInterface) exitWith { };

PT_fnc_iff_setup = {
    _fnc_iff_action = {
        params["_name", "_type", "_spawnType"];
        player addAction[format["Attach %1 to Helmet", _name], {
            (_this select 3) params["_name", "_type", "_spawnType"];
            _iffDevice = player getVariable [format["iff_%1", _type], objNull];
            if (isNull _iffDevice) then {
                _iffDevice = _spawnType createVehicle [0,0,0];
                _iffDevice attachTo [player, [-0.045, 0, 0.3], "Head"];
                if (_spawnType == '#lightpoint') then {
                    _iffDevice setLightColor [0.25, 0.25, 0.25];
                    _iffDevice setLightAmbient [0, 0, 0];
                    _iffDevice setLightIntensity 0.25;
                    _iffDevice setLightUseFlare true;
                    _iffDevice setLightFlareSize 2.5;
                    _iffDevice setLightFlareMaxDistance 3000;
                    _iffDevice setLightBrightness 0.1;
                    _iffDevice setLightDayLight true;
                    _iffDevice setLightIR true;
                };
                player removeMagazine _type;
                // Fixes Arma bug where you can no longer switch to the throwable after removeMagazine was called on it
                if (_type in magazines player) then {
                    player removeMagazine _type;
                    player addMagazine _type;
                };
                player setVariable [format["iff_%1", _type], _iffDevice];
                player setUserActionText [_this select 2, format["Remove %1 from Helmet", _name]];
            } else {
                deleteVehicle _iffDevice;
                player addMagazine _type;
                player setVariable [format["iff_%1", _type], objNull];
                player setUserActionText [_this select 2, format["Attach %1 to Helmet", _name]];
            };
        }, _this, 0, false, false, "", format["'%1' in magazines player || !(isNull (player getVariable ['iff_%1', objNull]))", _type], 0.01];
    };

    ["IR Strobe (NATO)", "B_IR_Grenade", "#lightpoint"] call _fnc_iff_action;
    ["IR Strobe (AAF)", "I_IR_Grenade", "#lightpoint"] call _fnc_iff_action;
    ["IR Strobe (LDF)", "I_E_IR_Grenade", "#lightpoint"] call _fnc_iff_action;
    ["IR Strobe (CSAT)", "O_IR_Grenade", "#lightpoint"] call _fnc_iff_action;
    ["IR Strobe (SPTZ)", "O_R_IR_Grenade", "#lightpoint"] call _fnc_iff_action;
    ["Chemlight (Blue)", "Chemlight_blue", "Chemlight_blue"] call _fnc_iff_action;
    ["Chemlight (Green)", "Chemlight_green", "Chemlight_green"] call _fnc_iff_action;
    ["Chemlight (Red)", "Chemlight_red", "Chemlight_red"] call _fnc_iff_action;
    ["Chemlight (Yellow)", "Chemlight_yellow", "Chemlight_yellow"] call _fnc_iff_action;
};

// single & multiplayer setup
player addEventHandler ["Respawn", { [] call PT_fnc_iff_setup }];
[] call PT_fnc_iff_setup;
