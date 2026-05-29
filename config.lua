Config = {}

-- ==========================================
-- FRAMEWORK SETTINGS (ALTYAPI AYARLARI)
-- ==========================================
-- Choose your framework: 'qb' for QBCore, 'esx' for ESX
Config.Framework = 'qb' 

-- The duration of the robbery progress bar in milliseconds (5000 = 5 seconds).
Config.RobberyTime = 5000 

-- The percentage chance (1-100) of alerting the police when a robbery starts.
Config.PoliceAlertChance = 100

-- Minimum and maximum amount of cash the player can steal from an NPC.
Config.MinMoney = 500
Config.MaxMoney = 1000

-- The list of ALL allowed weapons that can be used to initiate a robbery.
-- You can disable any weapon by changing 'true' to 'false'.
Config.AllowedWeapons = {
    -- Handguns
    [`WEAPON_PISTOL`] = true,
    [`WEAPON_PISTOL_MK2`] = true,
    [`WEAPON_COMBATPISTOL`] = true,
    [`WEAPON_APPISTOL`] = true,
    [`WEAPON_STUNGUN`] = true,
    [`WEAPON_PISTOL50`] = true,
    [`WEAPON_HEAVYPISTOL`] = true,
    [`WEAPON_VINTAGEPISTOL`] = true,
    [`WEAPON_REVOLVER`] = true,

    -- Submachine Guns
    [`WEAPON_MICROSMG`] = true,
    [`WEAPON_SMG`] = true,
    [`WEAPON_ASSAULTSMG`] = true,
    [`WEAPON_COMBATPDW`] = true,
    [`WEAPON_MACHINEPISTOL`] = true,
    [`WEAPON_MINISMG`] = true,

    -- Shotguns
    [`WEAPON_PUMPSHOTGUN`] = true,
    [`WEAPON_SAWNOFFSHOTGUN`] = true,
    [`WEAPON_ASSAULTSHOTGUN`] = true,
    [`WEAPON_BULLPUPSHOTGUN`] = true,
    [`WEAPON_HEAVYSHOTGUN`] = true,
    [`WEAPON_DBSHOTGUN`] = true,

    -- Assault Rifles
    [`WEAPON_ASSAULTRIFLE`] = true,
    [`WEAPON_CARBINERIFLE`] = true,
    [`WEAPON_ADVANCEDRIFLE`] = true,
    [`WEAPON_SPECIALCARBINE`] = true,
    [`WEAPON_BULLPUPRIFLE`] = true,
    [`WEAPON_COMPACTRIFLE`] = true,

    -- Melee Weapons
    [`WEAPON_DAGGER`] = true,
    [`WEAPON_BAT`] = true,
    [`WEAPON_BOTTLE`] = true,
    [`WEAPON_CROWBAR`] = true,
    [`WEAPON_FLASHLIGHT`] = true,
    [`WEAPON_KNUCKLE`] = true,
    [`WEAPON_KNIFE`] = true,
    [`WEAPON_MACHETE`] = true,
    [`WEAPON_SWITCHBLADE`] = true,
}