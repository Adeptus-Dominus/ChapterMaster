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

// First candidate TTF used when a language needs CJK glyphs that the latin fonts lack.
#macro STR_CJK_FALLBACK_FONT "fonts/simhei.ttf"

// Locale codes of shipped languages.
#macro LANG_EN "en"
#macro LANG_ZH "zh"

// Language JSON file layout under datafiles/. Path is: working_directory + LANG_FILE_DIR + <code> + LANG_FILE_EXT
#macro LANG_FILE_DIR "/lang/"
#macro LANG_FILE_EXT ".json"

// Field keys of the { text, variables } struct used for keys with {0}, {1} placeholders in
// localize_array()/localize_button_text()/power flavour text. Centralized so the array-entry
// contract stays explicit across LocalizationManager, scr_buttons and scr_powers.
#macro LANG_ENTRY_TEXT "text"
#macro LANG_ENTRY_VARIABLES "variables"

#macro MANAGE_MAN_SEE 34
#macro MANAGE_MAN_MAX array_length(obj_controller.display_unit) + 7
#macro LARGE_PLANET_MOD 1000000000 // Population threshold for large planet classification

// Ground combat message log: per-stage frame timeout before force-advancing.
#macro COMBAT_STAGE_TIMEOUT_FRAMES 1200

// Offmap shove distance for non-combatant fleets during battle resolution; must exceed room size so they read as !in_room().
#macro FLEET_BATTLE_DISPLACEMENT 100000

#macro STR_ANY_POWER_ARMOUR "Any Power Armour"
#macro STR_ANY_TERMINATOR_ARMOUR "Any Terminator Armour"

#macro SHIP_WEAPON_SLOTS 8
#macro STANDARD_EQUIP_SLOT_COUNT 5

#macro PATH_SAVE_FILES "Save Files/save{0}.json"
#macro PATH_AUTOSAVE_FILE "Save Files/save0.json"
#macro PATH_CUSTOM_ICONS "Custom Files/Custom Icons/"
#macro PATH_CHAPTER_ICONS working_directory + "/images/creation/chapters/icons/"
#macro PATH_INCLUDED_ICONS working_directory + "/images/creation/customicons/"
#macro PATH_LOG_DIRECTORY "Logs/"
#macro LAST_MESSAGES_LOG "last_messages.log"
#macro PATH_LAST_MESSAGES PATH_LOG_DIRECTORY + LAST_MESSAGES_LOG
#macro PATH_HELP_INI "main/help.ini"
