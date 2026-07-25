#macro MAX_STC_PER_SUBCATEGORY 6
#macro DEFAULT_TOOLTIP_VIEW_OFFSET 32
#macro DEFAULT_LINE_GAP -1
#macro LB_92 "############################################################################################"
#macro DATE_TIME_1 $"{current_day}-{current_month}-{current_year}-{format_time(current_hour)}{format_time(current_minute)}{format_time(format_time(current_second))}"
#macro DATE_TIME_2 $"{current_day}-{current_month}-{current_year}|{format_time(current_hour)}:{format_time(current_minute)}:{format_time(current_second)}"
#macro DATE_TIME_3 $"{current_day}-{current_month}-{current_year} {format_time(current_hour)}:{format_time(current_minute)}:{format_time(current_second)}"
#macro TIME_1 $"{format_time(current_hour)}:{format_time(current_minute)}:{format_time(current_second)}"
#macro CM_GREEN_COLOR #34bc75
#macro CM_RED_COLOR #bf4040
#macro COL_REQUISITION #2398F8
#macro COL_FORGE_POINTS #af5a00

#macro MANAGE_MAN_SEE 34
#macro MANAGE_MAN_MAX array_length(obj_controller.display_unit) + 7
#macro LARGE_PLANET_MOD 1000000000 // Population threshold for large planet classification

// Ground combat message log: per-stage frame timeout before force-advancing.
#macro COMBAT_STAGE_TIMEOUT_FRAMES 1200

// Offmap shove distance for non-combatant fleets during battle resolution; must exceed room size so they read as !in_room().
#macro FLEET_BATTLE_DISPLACEMENT 100000

#macro STR_ANY_POWER_ARMOUR "Any Power Armour"
#macro STR_ANY_TERMINATOR_ARMOUR "Any Terminator Armour"

//slots align with enum eEQUIPMENT_SLOT ordering for cross compatability
#macro UNIT_EQUIP_SLOTS [ "wep1", "wep2", "armour", "gear", "mobi", "all"]

#macro UNIT_EQUIP_SLOTS_DISPLAY [ "First Weapon", "Second Weapon", "Armour", "Gear", "Back/Mobility", "ALL"]

#macro EQUIPMENT_QUALITIES ["shoddy", "standard", "master_crafted", "artifact"]

#macro SHIP_WEAPON_SLOTS 8
