# CHANGELOG
All notable changes to this project will be documented in this file.

----------------------------------
## [0.0.0.0]

### New:
- example list
  - example nested list

### Changed:
- example list
  - example nested list

### Fixed:
- example list
  - example nested list

### Under The Hood:
- here go changes that are important only to other collaborators.
  - everything that a normal player doesn't need to know.
----------------------------------
## [0.10.0.0]


## [0.9.6]

### Fixed:
Crashes:
  - When assigning marines to forge, loading saves and probably some other weird cases (`gml_Script_scr_ui_advisors (line 864)`).
  - On creation screen role equip (`gml_Object_obj_creation_popup_Draw_0 (line 132)`).

### Under The Hood:
- Made the garbage collector run every minute. Doesn't seem to inflict performance loss and fixes the array corruption. Let's see if there are any caveats.
- Reduced redundancy a bit in error report functions.

## [0.9.5]

### Changed:
- Build Date is displayed in the main menu.
- Error logging edits:
  - Error logs now have the pre-built title for the bug report on their first most line. You can just cut and paste it into the title.
  - Errors now display a system message and not an in-game popup, as there are some unintended consequences with popup.
  - Error message itself is edited a bit, for clarity and to include new instructions.
  - Error itself is now wrapped in markdown codeblock.
  - Error logs now also display Build Date, for when there are different builds of the same version.
- Chapter fleet tab is edited ([#69](https://github.com/EttyKitty/ChapterMaster/pull/69)).
  - Carrying is now displayed in the tooltip, when hovering over a ship.
  - Ship list is edited, overlapping text fixed, headers added.
  - Ship images are now white on black.
- Welcome message is edited ([#70](https://github.com/EttyKitty/ChapterMaster/pull/70)).
  - Added units that were missed from the listing: Champions, Librarians, Sergeants, Veteran Sergeants.
  - Edited bits of text a little and changed some formatting, so it's more nice and readable (I hope).
  - Increased the amount of info on each page after the first, removing the need for the 4th page.

### Fixed:
- Crashes:
  - Garrisons crashing and returning the game to star map.
  - Crash during enemy end turn with chaos fleets.
  - Crash from trying to spawn chaos warlord with poor methods.
  - Crash from bombarding due to old planet name methods.
  - Crash when entering company management screen (`tooltip_text`).
  - Battle crashes related to `obj_pnunt` ([#29](https://github.com/EttyKitty/ChapterMaster/pull/29)).
  - Unknown amount of crashes caused by garbage collector (GC).
  - Crash cause by GC on the role equipment slide of creation screen.
  - Crash when calculation fleet speed ([#39](https://github.com/EttyKitty/ChapterMaster/pull/39)).
- Inquisitor inspection target fleet getting invalid ([#36](https://github.com/EttyKitty/ChapterMaster/pull/36)).
- Most of the librarium artifact list bugs should be fixed ([#32](https://github.com/EttyKitty/ChapterMaster/pull/32)).
- Duplicate inquisition inspection ([#33](https://github.com/EttyKitty/ChapterMaster/pull/33)).
- Health values going over 100% ([#43](https://github.com/EttyKitty/ChapterMaster/pull/43)).
- Bombard target planet display name ([#46](https://github.com/EttyKitty/ChapterMaster/pull/46)).
- Fleet tab ship sprites centred, some text issues are also fixed.
- Fix and finish hunt beast governor audience ([#76](https://github.com/EttyKitty/ChapterMaster/pull/76)).
- Some weird cases where you had to click two times on stuff for the click to register may be fixed now.

### Under The Hood:
- `obj_ini.experience` deprecated in favour of unit struct `experience` variable ([#37](https://github.com/EttyKitty/ChapterMaster/pull/37)).
- Game Version and Build Date are now handled through an external json file.
- Game Version is tracked through `global.game_version`, Build Date through `global.build_date`.
- `scr_fleet_advisor` is refactored a bit. Less hardcoding, should be easier to adjust ([#69](https://github.com/EttyKitty/ChapterMaster/pull/69)).
- All string manupulation functions are moved into `scr_string_functions` ([#70](https://github.com/EttyKitty/ChapterMaster/pull/70)).
- `handle_exception()` in all catch statements.
- `scr_click_left` now sets the cooldown, in addition to checking it.
- Click detection functions now accept a custom cooldown value.
- New functions: 
  - `array_to_string_list()` - renamed `format_stacktrace()`, array into a string, with each element on a newline.
  - `json_to_gamemaker()` - accepts path to json file and outputs a struct or a dslist.
  - `markdown_codeblock()` - accepts a string and wraps it with markdown codeblock symbols.
  - `handle_exception()` - accepts an exception struct, usually from a try-catch loop, displays an error and creates an error log.
  - `integer_to_letters()` - converts an integer to an english word, supports ordinal forms.

## [0.9.4.0]

### IMPORTANT:
- Due to a fix to save/loading of equipment stockpiles, that involved the usage of new save/loading methods, when you load a save from another version, stockpiles of your equipment will not be loaded with a 98% chance.
- I'm unaware if it's possible to fix this by save editing and assume that it's not.
- As such, either equip all of your important stuff on your marines on an older version, save and then load it on the new version (equipped gear should be untouched).
- Or just use `additem "Item Name" quantity" to cheat all lost items in, remember to write all of them down on an older version beforehand.
- You've been warned. :)

### Changed:
- Artifacts and Librarium:
	- Now able to unequip artifacts from the Librarium screen.
	- `artifact` cheat now supports quantity parameter. `CHEATCODES.md` updated.
	- Added support for mouse wheel scrolling of the artifact list, just hover over the general artifact box and scroll.
	- Added tooltips to scroll arrows that remind you about the mouse wheel.
	- The limit for artifacts now is 200. Getting new artifacts above this limit, will simply poof them.
- Battle debug (d) now only works with debug mode enabled (no more 1k+ messages purgatory on a missinput).
- Tartaros sprite is replaced with a clean, tweaked version (by Abomination).
- Various, minor error popup changes.
- Reducing population via bombardment to 0 will now destroy genestealer cults and set Tyranid influence to 0.
- All normal Dreadnoughts will now spawn with Twin Linked Lascannons, as normal ones were unsupported on them by default.

### Fixed:
- Crashes:
	- Spelling error in `scr_navy_planet_action` "orbiting" causing crash.
	- Possible fix of some weird stuff and some crashes in battles, caused by `obj_ini.hp`, pointing to `TTRPG_stats_scr_marine_struct`.
	- Crashes pointing to `scr_company_order_scr_company_order`.
	- Diplomacy dialogue crashes, particularly with Chaos Emissary.
	- Fixed a typo in Spyrer mission, may fix a related crash.
	- [Possible fix to crashes related to vehicle movement/transfer (#18)](https://github.com/EttyKitty/ChapterMaster/pull/18).
	- [Possible fix to various battle crashes, pointing to `scr_clean` (#20)](https://github.com/EttyKitty/ChapterMaster/pull/20).
	- Crash from destroying inquisitor ship.
	- Crash from non-star instance with end location when calculating travel ETA (`calculate_fleet_eta`).
	- `gml_Object_obj_p_fleet_Alarm_1` crash on turn end.
	- [Crash after ruins battle, related to an artifact reward](https://github.com/EttyKitty/ChapterMaster/pull/25).
- Probably a lot of missclicks, when one screen opens and you immediately click on something, should be fixed.
- Vehicle loss and recovery flavour text now should be repaired.
- Fixed formula for vehicle recovery score from Techmarines, as it was a bit overblown by stats.
- STC fleet speed bonus reducing speed instead.
- Warp portal selectable through other UI elements.
- Inquisitor inspection throwing errors (`fleets_next_location`).
- Adjustments to Artifact preview screen. Fixed button font, bigger description box.
- Equipped artifacts breaking on save/loading after their count goes over 20.
- Fixed artifact list ping-pong that didn't work properly when going backwards.
- Artifact list being limited to 30, even if the player has more.
- Psyker Intolerant stuff breaking if the disadvantage is in the 5+ slot.
- Melee (unarmed) flavour text is fixed.
- Loading a save wiping armamentarium equipment stockpiles (was this the case before?).
- Floating "Manage" button in the troop viewer.
- Reset zoom level on group selection (to assign to a forge, for example) window opening.

### Under The Hood:
- **All constructors from now on use PascalCase, to prevent variable name overlaps with the YYC compiler.**
- UI:
	- `point_and_click()` now sets `obj_controller` cooldown and checks for it to be allowed to execute.
	- `obj_popup` cooldown on creation is reduced to 8k to fix the UI lock caused by the above change, may have unintended consequences.
	- `obj_managment_panel` is now drawn in GUI layer, mouse event merged into draw.
	- Minor refactors to Artifact preview screen. Use `draw_unit_button()`.
	- Added cooldown check to `scr_click_left()`, to be able to use it nested in scr_hit, when point_and_click is unneeded.
- Combat code:
	- Generally a gvadzillion of combat related code overhauls and refactors.
	- Many repeats and bad array practices are removed from the combat related code.
	- Various minor efficiency improvements and refactors. 
	- Recovery (vehicle and marine) code variable naming changes.
	- A lot of major refactors, rewrites and overhauls of `scr_clean`.
	- Refactor of alarm 7 `obj_n_combat`.
	- `obj_enunit` alarm_0 refactor.
- [Refactored a lot of load-to-ship stuff(#22)](https://github.com/EttyKitty/ChapterMaster/pull/22).
	- Use dynamic array resizing with `array_resize` and `array_push`.
	- Remove manual array initialization and reset loops.
	- Replace `script_execute` calls with direct function invocations.
	- Add boundary checks in `scr_company_view` for valid company indices.
	- Update comments to clarify ship management array usage.
- [Ensure correct fleet target handling and recursion (#26)](https://github.com/EttyKitty/ChapterMaster/pull/26).
	- Refactored `scr_valid_fleet_target`. 
		- Now takes a `target` parameter for consistent validation.
	- Improved `fleets_next_location`:
		- Added recursion with a visited check to prevent infinite loops.
		- Simplified following the logic for recursion.
	- Standardized calls to `scr_valid_fleet_target`.
		- Ensured consistency across the codebase.
	- These changes fix potential issues with fleet chasing loops and enhance code readability.
- New functions:
	- `draw_rectangle_outline()` to draw rectangles with an outline backed in.
	- `choose_weighted_range()` to generate a random number, from one of the ranges, with custom weights per each range.
	- `array_random_index()` to pick a random valid index within an array.
	- `target_block_is_valid()`.
	- `get_rightmost()` and `get_leftmost()`.
	- `block_has_armour()`.
	- `get_block_distance()`.
	- `move_unit_block()`.
- [Various adjustments to the log and report system (#12)](https://github.com/EttyKitty/ChapterMaster/pull/12).
- Diplomacy dialogue refactored and reworked.
- `obj_ini.hp[][]` is replaced with `unit.hp()` in the majority (all?) places.
- Refactored a lot of lines in the `obj_popup` step event, to use `$` instead of `string()`, to improve readability.
- [`point_and_click()` efficiency improvements (#17)](https://github.com/EttyKitty/ChapterMaster/pull/17).
- Refactored `scr_company_order`.
- [New, unused Psychotic and Lobotomized traits (#14)](https://github.com/EttyKitty/ChapterMaster/pull/14).
- Minor refactor of `scr_destroy planet`.
- Deprecate some `int_strings[]` in `scr_load`.
- `array_random()` is renamed into `array_random_element()`.
- Save/loading of equipment stockpiles now uses json methods. This will break equipment stockpiles on old saves.


## [0.9.3.3-YYC]

### New:
- The game is compiled with YYC, which may improve various calculation times and error reporting.
    - As well as create unknown problems. You're here to test it.
- Super new and shiny error handling system.
    - You don't need to know much. When an error appears, you'll be given instructions on what to do.

### Changed:
- Artifact possession string is on a new line, for clarity.
- Honour Guard, Veteran, Terminator, Veteran Sergeant, Dreadnought and Venerable Dreadnought age edits.
- App name is changed to "Chapter Master - Adeptus Dominus", from "Chapter Master Adeptus Dominus 0.9.0.0".

### Fixed:
- Custom chapter saving with 4+ advantages.
- Trade input should be fixed and foolproofed against wrong input now.
- Artifact gifting and destroying.
- Venerable and normal Dreadnought spawning, with and without equal distribution and/or Venerable Ancients advantage.
- Mass role equip crash.
- Apothecaries, Techmarines and Librarians vanishing on drop select if you deselect and select them again.
- Tooltip going off screen.
- `ork_ship_production` crash.
- Inquisition inspection crash.

### Under The Hood:
- `scr_log` massive overhaul.
- All constructors that used snake_case are renamed to use PascalCase.
	- To avoid possible and existing errors with YYC compiler, when a constructor has the same name as some variable.

## [0.9.3.2]

### New:
- Introduction of a bug log file `message_log.log`, located in `AppData\Local\Chapter Master`.
- Introduction of proper error handling of end turn sequences should vastly reduce crashes for player on turn end and will provide error log codes stored in message_log.log and displayed in to the player at turn end.
- Maximum advantage/disadvantage count is now 8.
- New cheat - "ruinspopulate" to put an ancient ruins on every planet.
- Carcharodons are now playable.

### Changed:
- Hidden game settings that currently don't do anything.
- Normal Dreadnoughts have 600 as max age at chapter generation.
- Artifacts now have more relevant stat info in their descriptions.
- Artifact equip window buttons.

### Fixed:
- Crash from building forges at secret lairs.
- Crash from fleets arriving at player fleets trying to trade.
- Tooltips will now always draw as the top layer.
- Crash from guard attempting to recruit new guard.
- Ship occupancy sometimes breaking.
- Crash from moving vehicles possibly fixed and being monitored.
- Error log obj_controller.x = ii.x; when arriving at ork fleet.
- Attempt to fix squad view screen bugging and not appearing. Fix status to be determined following play testing.
- Custom formations not loading correctly upon save load.
- Artifact arrays making some artifacts unusable.
- Ork fleets will no longer death stack.
- Role settings on the creation screen being click through.
- Crash from deprecated onceh variable.
- Added fail safes to stop crash when viewing some planetary features.
- Artifact screen text overlap, broken strings are fixed.
- Some of the tooltip issues.

- new cheat "ruinspopulate" to put an ancient ruins on every planet


### Under The Hood:
- `scr_has_adv` and `scr_has_disadv` functions.
- New error handling method - `try_and_report_loop`, described [>here<](https://discord.com/channels/714022226810372107/1121959429546455050/1293597133093470269).
- Partly refactored artifact equip popup.

## [0.9.3.1]

### Changed:
- Infernus pistol melee burden is now 0, like on other pistols.

### Fixed:
- Crashes: 
	- Upon ending turn, when forge items complete (`scr_evaluate_forge_item_completion`).
	- (Probably fixed) After battle (`obj_centerline_Step_0`).
	- Mid-battle caused by enunit rework (`obj_enunit_Alarm_0`).
	- Upon ending turn (`obj_en_fleet_Alarm_1`).
	- When purging planets (`scr_purge_world`).
	- When using select all (ships) before battle.
	- Chaplain duplication on drop select causing a crash (yet again).
- Select All and Select (role) on the company view are now working properly.
- Land raiders/land speeders being not buildable.
- Zooming affecting attack/raid window.
- Crafters advantage not affecting crafter trait rate, due to typo.
- Aspirant duplication on drop select and a related crash.
- (Maybe fixed?) Player fleet being unselectable.

## [0.9.3.0]

### New:
- Warp travel:
    - Fast warp routes (appear as warp holes).
	- "Warp hub systems" that have multiple fast warp routes.
	- Ability to cancel warp travel within the same turn you commanded fleet to travel.
- New Squad type - Breachers.
- New cheats:
	- Refer to CHEATCODES.md in the game folder for a full reference with input rules.
	- Many of the old cheatcodes are a bit changed, so make SURE to read the reference.
	- sisterofbattle - spawns a Sister of Battle.
	- skitarii - spawns a Skitarii.
	- flashgit - spawns a Flash Git.
	- crusader - spawns a Crusader (fixed).
	- techpriest - spawns a Tech Priest (fixed).
	- additem - used to spawn specific items.
- Equipment and weapons:
	- Conversion Beamer Pack backpack item.
		- Basically just a backpack item with an integrated conversion beamer.
	- Laspistols for Tech Priests.
- Marine stats affect after-battle outcomes.
	- Techmarine Technology and Luck stats affect the cap of vehicles that one can save.
	- Apothecary Intelligence and Luck affect the cap of marines that one can save.
	- Luck also affects the chance of a marine not dying and getting injured instead.
- Requisition points reward for winning battles, depending on the strength of the enemy that you fought.
	- Code-wise it's just a simple table with static rewards. I can't bother with more.
- Genestealer cults now have names.
- Medium and larger forges now have the option to have vehicle hangers built, allowing vehicles to be built at the forge.
	- Built vehicles will spawn at locations with said hangers.

### Changed:
- Stars will no longer spawn on top of each other.
- Player should now be able to move camera closer to the edge of the screen.
- Purging with fire now also removes Genestealer population influence.
- A lot of flavour text adjustments, for both enemies and the player. If someone attacks - it should be displayed always, nothing is skipped or "not displayed".
- Warp travel:
	- Warp lane travel drawing moved to it's own layer.
	- Warp lane widths now expand to be more visible when zoomed.
- Advantages tweaks:
    - "Kings of Space" advantage now provides +1 Battle Barge.
    - "Boarders" now provides +2 Frigates.
    - "Lightning Warriors" now increases number of starting Biker Squads.
	- Melee Enthusiast now decreases starting devastators as well as increasing assaults.
	- Display and description text tweaks.
- Equipment and weapons:
    - Boarding Shields now provide advantages to boarders.
    - Underslung Flamers now have light armour piercing.
	- Little Damage Resistance bonus to some Master Crafted and Artifact quality gear pieces.
	- Servo-arm (Servo Arms) and Servo-harness (Master Servo Arms) are overhauled.
		- Both now use the backpack slot.
		- Servo-arm only has an integrated melee arm, harness has a flamer, plasma cutter and melee arms.
		- Servo-harness can save 2 times more lost vehicles per Techmarine, in comparison to Servo-arm.
		- You can use addi tem to get these, if old items got broken because of the rename.
	- Tech Priest loadout is now more or less similar to lore friendly Enginseer loadout.
	- Tankbusta bombs have less ammo (2>1) and max kills(3>0).
- Visual:
	- Eviscerator and Relic Blade sprites are now vertical again and can display a second weapon.
	- Deathwing color now is a tiny bit darker.
	- Minor Power Spear sprite adjustments.
	- Techmarines now have eye attachments.
	- Edited Servo-arm and Servo-harness sprites.
	- Star sprites edited. Black backgrounds removed and slight blur is applied, to reduce jaggedness.

### Fixed:
- Crashes: 
	- Caused Inquisitors snooping on player bases.
	- Caused by Chaplain duplication on drop select.
	- (Possibly fixed) After ancient ruins ambush with a single unit.
	- (Possibly fixed) Magic crash caused by `obj_turn_end_Alarm_0`.
	- During save loading caused by `gml_Script_return_json_from_ini`.
	- End turn crash caused by `gml_Script_ork_ship_production`.
	- During save loading caused by `obj_event_log.event = json_parse(base64_decode(ini_read_string("Event","log","")));`.
- Visual:
	- Eviscerator and Relic Blade sprites display on Terminators properly now.
	- Deathwing knights color scheme is no longer broken.
	- Promotion gear text overlapping.
	- Fix button placement on the livery/color chapter creation page.
- In-game wiki should now work (kinda).
- Travelling without waypoints while pressing shift now fixed.
- Vanguard Sergeants, Honour Guard and Dark Angels Veterans no longer spawn overburdened.
- No more recruiting Psykers in Psyker Intolerant chapters (all recruiting set to 0 at game start).
- Advantages Kings of Space and Boarders work properly for both chapter start types.
- Chaplains equip proper items on game start.
- 1 Dreadnought to Equal Specialist Distribution custom chapters.
- Fixed Force Staff getting double damage bonus because of a code mistake.
- Stars should no longer spawn very close to the right or bottom edge of the map.
- Will no longer be able to select all ships globally with select all on bombard.
- Selecting vehicles globaly, bypassing location checks.
	- Related negative space on spaceships bug.
- Hopefully fixed squad view sometimes not coming up and related problems.
- Max artifact count is increased to 50.
- Inquisitor should no longer try inspect fleets heading out of system.
- Player will now be able to build vehicles in the forge correctly.
- Livery and color unit preview switching, on chapter creation, now supports non-custom chapters.

### Under The Hood:
- Warp travel route grading support.
- Ork Warbosses are now stored in the fleet carge_data area and the struct is transferred directly to a planet.
- Git: resource_order is now in gitignore.
- is_specialist supports Space Wolves and Iron Hands.
- In-game Wiki refactored (part one).
- Refactor of drop select.
    - alarm_1
    - step_0
    - scr_drop_fiddle
- Some refactors to scr_draw_unit_image.
- Pass scr_add_man through a formatter.
- Almost completely refactor cheatcodes.
- Minor variable name changes in ncombat and related files.
- A lot of files were passed through a formatter, to fix indentations and other syntax issues.
- New function `string_upper_first`, used to capitalize only the first letter of a string.
- GUI drawing layer:
	- obj_controller drawing mostly moved to the GUI layer of drawing.
	- Fleet select panel moved to the GUI layer of drawing.
	- Point and click updated in function to now work in both the GUI layer and standard draw layer and take into account literal or relative screen loc.
	- obj_star_select drawing now moved to the GUI drawing layer.


## [0.9.2.4]

### Changed:
- jump packs hp and resistance mods buffed by X2
- removed a black square from under the chapter icon on the creation screen
- a brighter dark gray colour for chaos owned systems

### Fixed:
- planet sprites numbering fixed (planets will display correctly)
- stc gifting fixed
- fix and refactor lair construction window
- hopefully solved MC chance to work properly
- fixed crash when ship with artifact attempts ot join fleet

## [0.9.2.3]

### Fixed:
- a crash occurring when ending turn (gml_Script_scr_enemy_ai_d)

## [0.9.2.2]

### Fixed:
- crash the press t method of ending turn not being updated with modern sequence
- crash with colonists from spelling error
- missions will now trigger their end sequences

## [0.9.2.1]

### Fixed:
- crash from attempting to build new ship
- incrementing not occurring on missions
- crash from requesting colonists on colonist arrival

## [0.9.2.0]

### Fixed:
- recruit trial being wrong on game start occasionally
- updating garrison log creating crashes due to vehicle arrays
- some recruit trials used to produced no recruits
- data leak from sprites causing game to randomly crash when doing lots of troop movement
- general reliability improvements with game memory usage
- hopefully fixed problem where faction sprites could occasionally corrupt making the main map a cluster fuck
- no longer able to attempt to zoom to terra to see training techs causing a crash
- marines on terra no longer selectable

### Changed:
- player will now get alerts when ship production ceases due to a lack of active forge worlds
- new cheat "artifactpopulate" adds a artifact to every planet
- promotion thresholds modified and reworked to be inline with equipment exp limits 
- general promotion improvements

- decentralised much of company code so theoretically able to now have chapters with more than 10 companies (full implementation a long way off)

- lots of under the hood restructuring of fleets

### Added:
- from company manage
    - tooltips on numbers 1 through 0(10) to automatically jump to companies in the company view screen
    - M to go to next company
    - N to previous
    - Q,E,R,T,Y, to travel between the specialist manage areas from manage
    - new filter mode in spreadsheet manage view that allows the select buttons to be used to filter marines 
    - shift + keys in order to utilize load, set to boarders and other functions (tooltips provide keys)

- from map area
    - alt F for fleet
    - alt M for manage
    - alt A for apothcarium
    - alt F for fleet
    - alt S for settings
    - alt R for reclusiam
    - alt L for librarium
    - alt N for armamentarium
    - alt T for recruiting
    - alt D for diplomacy
    - alt O for event log
    - alt E for end turn

- new governor missions, complete missions for planetary governors to increase disposition or gain other rewards.
    - bear in mind these are broad and varied and currently are mostly unimplemented but they are a slow route to giving governors their own personalities and creating a juxtoposition between population influence and governor dispositions.
    - in time these will lead into much more politicking and small scale engagements but will require a writing team we currently don't have, if any story people are interested in helping please contact nelsonh on the cm discord.

- added new chapter advantages:
    - venerable ancients : increases start dreadnoughts but reduced chapter strength

- ability to have a more in-depth view of population and it's influences (needs much extension and work)
- ability to spend req in order to fund colonisation attempts to increase populations or repopulate worlds from 0
    - new colonists may bring with them genestealer cults, heretics or have greater good thinkings...

## [0.9.1.1-0.9.1.12] Bug fix and stability versions

## [0.9.1.0]

### Fixed:
- Certain Hirelings crashing the game when viewed
- STC armour bonus' not displaying
- item quality not always displaying
- forge worlds not returning to mechanicus if spawned with non mechanicus control
- more fixes to unit spawning
    - techmarines shouls always return from mars
    - scouts should always spawn in a logical and accessible location
- slaughter song now completable without crash
- inquisition purging now no longer breaks saves
- all loading screen images fixed
- tithe alerts now no longer break the rest of
- reordering management screen marines by stats so that player can see best marine with a given stat
- various sprite adjustments to fix alignment
- armour equip issues
- general stability improvements to management screens
- fixed inquisitor inspection and chase functions
- governor serf execution crash fix
- vehicle weapons fixed
- jump pack hammer of wrath fixed

### Changed:
- Overhaul of managing so that it is not directly linked to companies
- removal of lid variable in favour of unit.ship_location
- Complete overhaul of unit view in the manage area to be more cohesive
    - new colour palette
    - better ui to be more informative
    - colours to represent item quality
- tooltips improved both visually and in terms of content
- Siege Masters trait doubles marine effectiveness at garrisoning
- garrison leader bonus for garrisoning doubled increased by 50%
- psyker abundance and psyker intolerant respectively increase and decrease psionic spawn levels
- jailing heretics now stops them corrupting even if in the same location as other marines
- remove planet tithe alerts
- press shift for 3 times map scroll
- complete overhaul of weapon descriptions
- biography descriptions tweaked
- item quality display now uses colour system
- weapons now have distinct hit rates balancing combat
- shader options for cloth
- colour improvements for many base chapters
- improved item sprites like iron halos
- optimised draw sequence for sprites
- gui code for fleet combat overhauled
- complete overhaul of mission problem text so we can start adding and creating new missions
- tech heretics won't now spawn and spread till after turn 70

### Added:
- crozius sprite
- fleet viewer to quickly see fleets and zoom to fleet locations
- quick view event log locations by pressing view button
- quick view garrisons with new troop logger
- quick view missions with new mission logger
- manage marines by planet location instead of being locked to company manage screens
- stat boosts and new traits for spawn captains
- ability to demote/promote sgts with a loyalty hit to the demoted sgt
- genestealer cults actually exist hidden from player view so mechanic can now be expanded upon
- casualty descriptions now added to battle log flavour
- ability to reshuffle squad loadouts
- full set of dark angle and da successor sprites
    - going forward hopefully all chapters will get the same treatment
- factions other than tau can now exert influence on a planet
- custom selection of sgt, vet_sgt and captain helmet options
- genestealer cults are now viewable planet features
- all planets now have an influence bar to show how much of the populace is influenced by various factions (to be expanded)

## [0.9.0.1]

### Fixed:
- boarding and ship ammo limits fixed
- bulk stcs being added upon collection of one fixed
- perils of the warp crash resolved
- location id sometimes causing crash due to array being deleted
- stops the rapidly spiralling tech heresy numbers
- specific armour type artifacts now equipping properly
- potential crash when gifting chaos artifacts fixed
- fixes being able to assign to forge when marines not in location
- recruit spawning no longer spawning scouts in impossible locations fixed
- stops duplicating forge score from assigning to forge
- stops the tech heresy schism occurring when no loyal techs left
- hand full of other bug fixes from the bug reports
- completely rebuild ship and ground healing scripts so that all healing functions correctly
- stop crash from purchasing one of the manufacturing researches in the forge
- fixed command/ normal marine logger so it's always accurate (sometime this means turn 1 changes the numbers this will be sorted later)
- reduced crashes from moving vehicles
- occasional crash when trying to promote sgts in squads with no members left
- orks no longer capable of defeating pdf on some planets fixed
- power spears causing an error
- stops duplicating by having no limit to forge assignment
- Fix champions deselecting working properly but not returning back if you select them on the drop screen.
- correct artifact saving

### Changed:
- increased camera move speed 
- made ork waagh spawn 100-300 turns in, instead of almost instantly
- increased starting planets to 100 (from 70)
- gives forgemaster a built in forge point boost
- reduces tech heretic spawn numbers
- makes tech heresy more slow burn
- tech corruption is capped so a tech cannot make another tech more corrupt than he is himself again stopping run away numbers
- total corruption capped to 100 as originally intended
- moves forge resource marker to the center top of screen so announcements are visible
- brings mass equip inline with new artifact system	
- integrate forge points into main resource bar (etty)
- lots more ui tweaks by etty
- more tooltip improvements (etty)
- new textures for rack and pinion button
- chapter management screen overhaul
- additions of sgts and vet sgts to chapter manage screen lists
- stop spill over on the shop screen
- add pages and generally overhaul shop ui
- balancing of previous garrison numbers
- minor revamp of planet screen
- tetures for rack and pinion forge button
- crafters trait on marines now improves the forge point output of a marine when assigned to a forge much more
- minotaurs and black templar chapters better fleshed out including custom artifacts
- all sprites now properly aligned
- tooltips majorly improved so that players get a better understanding of backend damage calculations
- tooltips get a dataslate like ui skin
- improved trial descriptions
- the display of special properties of weapons improved
- Rework how possible promotion and critical health are displayed. Promotions recolour XP value, critical health recolour HP value.
- Added tooltips to these values, when there is an active interaction.	
- Rework how potential is displayed

### Added:
- new dreadnought sprites to represent more weapons
- new backpack sprites
- bionics will now automatically be applied if marine health is below 0 and bionics are in stock and there is an apothecary and the techmarine present
- cheat to finish forge queue instantly "finishforge"
- cheat to spawn slaughtersong ship "slaughtersong" (location will appear in event log)
- cheat to start tech uprising prematurely "techuprising"
- cheat to launch crusade event "crusade" (location will appear in event log)
- cheat to instantly awaken a necron tomb "tomb"
- A new script to replace characters that get beyond a set string width with "...".
- new force weapon selection (force axe force sword and force staff) each weapon gives a different bonus to psychic attacks or are more focussed to melee force work
- new modifier  to calculate force weapons attack based of psionic rating, intelligence and experience
- improved garrison screen 
- having a garrison present allows player to see the relevant defence score of the local pdf
- having a garrison present modifies disposition with the planet based on teh squad leaders charisma (further modifiers to be expanded upon)
- power spears added to shop
- The crozius now added to game (awaiting sprite asset)

## [0.9000]

### Added:
- companies now require command squads, which are automatically created (this also means that building a company from scratch will also automatically setup squads)
- moving all units of a squad will also move the squad
- squads are now automatically restocked with new recruits as needed
- added new squad types: assault terminators, vanguard, sternguard veterans, scouts and scout snipers
- new Squad UI
- Raven Guard chapter
- squads can now be ordered to garrison
- squads can now be specifically ordered to certain formation positions
- promoting scouts to marines and vice versa adds/removes Black Carapace (except Space Wolves) 
- ending a battle shows a total of earned exp
- a lot of new sprites: terminators, bionic leggs, ultra honor guard, and others
- basic modding: most names are now moddable. Simply go to <game_folder>\datafiles\main\names, and open the .json file that you want to modify
	- currently this allows modding of names for: Sector, Stars, Space Marines, Imperials (including Inquisitors), Orks, Eldar, Tau, Chaos, Imperial & Marine Ships, Ork Ships, Space Hulks
- new cheat "eventcrusade" to launch the crusade event (check event log to see the rally point for the crusade)
- crusading marines will now get their heroic deeds logged, including tracking of new traits for maines
- new equipment: Heavy Weapons Pack
- new choices for Chaos Emissary's Khorne path (which includes a brand new trait for marines)
- tehcmarines now undergoes stc research very slowly and passively
- New Rescource : Forge Points
	- All techmarines now yield a tech score each turn
	- items can be queued at the forge for manufactoring by techmarines
	- manufactoring research to determine what items can be built with forge points (sperate from the stc system)
- techmarines can now become tech heretics and start to corrupt other tech based units
- tech uprising schisms can occur if the player has too many tehcmarines with differing views
- new forge master selection system
- ability to filter units by stats by clicking on stat icons in the company manage screens
- enhanced feature view on planets
	- planet features now provide clues as to what a player should do
	- contruction of forges on fortress monestaries and secret bases
	- assignment of techmarines to forges to increase forge point yield
	- techmarines assigned to the forge slowly increase their tech scores

### Changed:
- sector map UI rework
- marine traits now effect which weapons they are suited to in a few instances (gain bonus's from use)
- stcs will no longer allow the buying of new items only the construction of new items in the forge
- final price of buying goods determined by the qualities of forge master (charisma and tech skills)
- cost of buying items increased to account for the ability to manufacture
- a lot of under the hood changes
	- refactored weapons and equipment, started migrating weapons and gear to json
	- better squad loading algorithm
	- better squad role search algorithms
	- multiple faction changes and tweaks
	- started organizing companies into structs, to simplify code
	- zoom functionality refactor
	- crusade code refactor
	- laid down groundwork for future corruption rework
	- [PENDING] multiple GMS2 erors fixed
- sharpshooter squad got a new loadout, to make it standout more
- multiple tweaks for existing chapters
- identifying STC will now prioritize the category with the least amount of identified STCs 
- scouts now have slight lower stats
- every 15exp points now add a random stat point to one of the following (weapon skill, ballistic skill, wisdom (or a specialist area for specialists))
- crusades should be a bit safer for marines
- all heavy_ranged weapons now have 2.25 ranged carry
- boarders now properly use the new weapon profiles
- boarders now don't use decimilisation in the marines age to determine if they are a boarder or not
- new ui designs
- many other changes

### Fixed:
- fixed fleet select screen so player can now select or deselect all of a fleet
- slaughtersong event should now work correctly
- Blood Trial will no longer waste gene-seed if recruitment is halted
- bombing worlds should work properly again
- combat should no longer happen if no troops are present
- CTD caused by troop counter going over the vehicles index
- CTD caused by accessing a non-existent veh-ranged variable
- blocked overspending STC fragments, if a category has already been fully researched (caveat: the button is still clickable, but it won't waste fragments anymore)
- apothecaries should now properly heal units on ground at turn end
- game freeze on end turn should now be fixed
- star names should never get duplicated anymore
- loading selected marines should now only load the selected marines, instead of all of them
- removed duplicate Assault Cannot entry in the Armamentarium
- CTD related to enemy fleets missing targets
- CTD caused by a planetary feature error
- some instances of gear being improperly displayed in equip view
- CTD when adding bionics
- CTD during crusade fleet check
- necron tombs should now properly display their name after being sealed or awakened
- death company dreadnoughts should now be able to equip dreadnought armour properly
- CTD after cancelling a squad mission
- CTD caused by chaos emissary interactions
- [PENDING] selecting marines as boarders should now be more stable
- many other fixes



## [0.8.1.1]

This version is purely fixing bugs, especially ones that crashed to desktop

Changing battle formations and gene slaves are now correctly working as well.

A rework of how squads function and some UI is planned for an upcoming update :)

Here is our discord with 500 people, and about a dozen devs where we constantly work on the game, feel free to join the dev process!

https://discord.gg/zAGpqHzsXQ

-----------------------

Version 0.8.1.0.0

This version is to mainly ensure stability and add
content that wasn't quite ready for 0.8

++++
Added
++++

The Sons of Dorn, The Imperial Fists!

In a future update, Imperial Fists' Huscarls will start with storm shields :)

++++
Changed
++++

Companies are now numbered using roman numerals. Like Terra intended

++++
Fixed
++++
Some various Crash to desktop bug fixes

----------------

Version: 0.8.0.0.0

We have skipped a few versions to ensure clarity with other projects


++++
Added
++++

All Marines can now be old guards. Spawning them with different armour than what they are meant to. Expect Assault marines to have the best melee!
Starting armours for command marines have been changed. For example all company champions are MK4.
Veterans given combi-flamers by default
new sprites for weapons and armour
many new weapons and gear
including Electro-flail, Sarissa, Seraphim Pistols, Stalker Pattern Bolter and many others
MK5 Armor
new artifact: Thunder Hammer (replaced Relic Blade)
killing a warboss should now create a victory shrine on the planet
changelog for the repo
cheatcodes

++++
Changed
++++

many weapon and gear stat tweaks
numerous under-the-hood refactors and changes (they won't have an effect on gameplay, but they make development easier)
changed all instances of 'Armor' to 'Armour'
moved some chapter icons into the custom icons folder, allowing players to toggle their visibility in-game

++++
Fixed
++++

vehicles should load on ships now at the start of the game
vehicles should no longer have unlimited ammo
marines should no longer duplicate during battles
some stuff not appearing in Armamentarium (including Void Shield Heavy, Assault Cannon and some other things)
the UI should now show proper amount of marines after a defensive battle
it should now be possible to recruit from planets containing billions of pops (previous it had to be either below 1 billion or above 50 billions)
enemy escorts should not teleport around after another enemy ship gets boarded. Also escorts should be fully boardable now
text typos
numerous CTDs
Removed:
faith (temporily, it was causing crashes when attacking Sisters of Battle, will be readded in the future)

---------------------------

Version 0.6702

Hotfixes a critical error regarding not being able to save the game lol oops


----------------
Version 0.6701

changelog:

Hot fixed lamenters, they no longer get black rage, they have 2 strike cruisers, as well as 30 gene seed

buffed bolter just a little so it's actually better than a pistol

if your chapter master dies, game over!

-----------------
Version 0.67000

Hello I'm Zab1019. Head dev ( i guess) of the restoration and renewed development of Chapter Master

There's about 8 active contributors total. A few being artists, but mostly coders.

Our github is open source, and linked on our discord in our dev channels

Chapter Master Discord has made an open source project of this. Now titled "Chapter Master Adeptus Dominus"

We hope you enjoy the ride along this awesome project with us!

Discord:
https://discord.gg/zAGpqHzsXQ


Changelog:

++++
Added the Soul Drinkers:
They are daemon binder using, and soon shall turn renegade. Their numbers aren't great, but start with 60 gene seed, and 4 (FOUR!) battle barges!
++++

++++
Completely reworked the recruitment system for neophytes from the ground up.
Recruitment trials are mostly planet based, and none of them are strictly the best. They all have their own different scenarios where they are good.
If a planet has under 50% of it's max possible population, you recruit 20% less neophytes from there.
Currently there's no way to increase pop on a planet you have, but will be added soon.
++++

----
Hives by far have the most recruits, but very little exp
Lava,death, ice, and desert have the least, but have more exp
everything else is in the middle
----

----
xp and promotion amounts have been reworked, reminder you can simply disable requirements in chapter settings. But you cannot for terminators or thunder hammers

terminators = 180
thunder hammers = 140

1st: 150
2nd: 120
3rd: 110
4th: 100
5th: 80
6th: 70
7th: 60
8th: 50
9th: 40
----


A decent amount of enemies have been rebalanced. Expect ground combat to be harsher. A more thorough rework is still due for ground combat

++++
The marine's equipment has been entirely redone. Now mostly more expensive, but more worth it.
Duel wielding has been reduced massively. No longer will you be able to have a heavy bolter and a chain sword. 
Some exceptions exist. Such as axe's purpose now is to be duel wielded, or be used with heavier things.
++++

Chaos marines equipment has been matched to be the same or slightly better than the player's 

++++
Rhinos,predators,whirlwhinds,dreadnoughts and land raiders can now have sponsons, turrets, mounts and launchers. 
Customised with different weapons (plasma sponsons, heavy bolter sponsons, lascannon sponsons, ect.)
++++

----
Made tau a confirmed spawn 100% of the time. Also increased numbers massively. They can have 3-7 planets at start

Increased mechanicus planet spawn rate. 2-6 planets tops. Rarely get's 6 though
----


++++There are now three different types of chaos cults:++++

Stronghold worlds are somewhat rare, but incredibly powerful. They are named systems (Isstvan, Badab, ect.) and start spawning fleets straight away. Their corruption and traitor presence is rampant. Deal with them quickly!

Rebellion cults are worlds that haven't won over the planet's government yet, but shall within a few dozen turns. They have their name already changed to that colour at game start, so you can tell easily.

Underground cults are the old version of them. You'll only know they exist on a planet via PDF being killed. Rarer than the other forms but still present.


----
Many things in the code have been improved upon, and bugs fixed. Which makes our lives easy as coders. Also did I mention we are open source? Just join and help us in the discord link above!

++++Chapter Master Adeptus Dominus++++

Version 0.6602
Notes
-Sorry for the delay.
-I was unable to replicate the Eldar crash but I re-wrote it anyways. 

Fixed
	-Bombardment menu now has a close button (Conversion Error)
	-Scouts being created but have no location. (Source Error)
	-Promotions to tacticals (My Error.)
	-Some events causing crashes (These are tricky as I suspect some are conversion errors)
	
Changes
-Increased the range required to find the eldar by 25% (300 to 400), increased the chance of finding them by 5% (now 10%).

New Cheats
recruit# = Created # of recruits with 20xp, that will be ready in one turn (No extra equipment)
eventg8 = "meet_eldar"


Version 0.6601 GMS2 Hotfix
Fixed
-Artifacts can now be equipped (Conversion Error)
-Ships that are purchased should now function correctly, included a fix on load in case one is bugged. (Source Error?)
-Choosing random will now give you advantages and disadvantages (Source Error, incomplete content)


Version 0.6600 GMS2
Notes
-With the conversion to GMS2, I cannot guarantee stability.  I am only 90% confident nothing of note is broken.

Fixed
-Crash caused by getting the STC bonus to vehicle accuracy ad then sending vehicles into combat.
-Crash caused by a typo in obj_turn_end_Alarm_0 when Orks invaded.
-Transfer showing empty boxes for unit roles company screen.
-Ship/world names overlapping with armour in company screen.
-Lost ships now return after a random amount of time (10-100 turns).
-Splintered ships on creation to now work as intended (I think it's being weird).
-Changed the range of boarding to the max range on the parent ship.
-Daemon binders no longer resaults in instant failure, instead it will take several encounters with the inquisition before they freak out.

Changes
-Made it, so you always get loot after you clear a space hulk and added a small chance to get Tartaros armour. 
-Added the option to decrypt saves in the options menu, BACK UP YOUR SAVES; if you break them, you are on your own.
-Changed the fleet selection menu, selecting a category (de)selects all within, selecting names (de)selects as well.
	--Selecting the background no longer selects all.
-Changed how company screen logic works D
	--DOUBLE CLICK has been disabled.
	--Right-click selected all of the selected unit types.
	--All multi-select options no longer inverse selection, but instead select all targeted, and if all are selected, deselects them.
	--If none are selected, the group with the most units at a location will be selected.
-Made planets random features (????) generate on creation, but also made more of on gen. (Will be adding more options at a later date.)
-Added symbols on the planets when they have features of interest or require help. (! Coloured threats)
-Activated "Cave Network" planetary feature, however temporarily make it equal to Ancient Ruins.
-Assault a Necron tomb without a mission, land troops, end turn. (requires plasma bomb, still decent chance of failure)
-Removed the need to have the chapter master present to control the fleet. (It's too buggy without control.)
-Increased the chances of the tau spawning on gen from 33% to 66%.

Code Changes
-Refactored unit selection and unit selection buttons on the company screen. 
-Converted project from GMS 1.4 to GMS 2. 
-Added proper documentation (Jsdoc) to some of the existing code.
-Started converting dedicated object scripts into object functions.

New Cheats (Many of these events will proc but will not create a popup)
eventg0="space_hulk";
eventg1="promotion";
eventg2="strange_building";
eventg3="sororitas";
eventg4="rogue_trader";
eventg5="inquisition_mission";
eventg6="inquisition_planet";
eventg7="mechanicus_mission";

eventn0="strange_behavior";
eventn1="fleet_delay";
eventn2="harlequins";
eventn3="succession_war";
eventn4="random_fun";

eventb0="warp_storms";
eventb1="enemy_forces";
eventb2="crusade";
eventb3="enemy";
eventb4="mutation";
eventb5="ship_lost";
eventb6="chaos_invasion";
eventb7="necron_awaken";


Version 0.6571
Notes
-Just a quick fix, feeling ill from my second covid vaccination, taking it easy for now.

Fixed
-A few bugs in promotions.
-Clicking out from the promotions/transfer/rearm menu now exits the menu, in addition to clicking cancel.
-Bottom part of companies now enters into selected company.

Changes
-

Code Changes
-

Version 0.6570
https://ufile.io/xyy05hi3
https://anonfiles.com/jd84ff4fua/Chapter_Master_0.6570_rar
-Saves should be forward compatible but ARE NOT BACKWARDS COMPATIBLE.
-There are several options of things I can look at next as everything needs work.
	-Finish the role/weapon/armour overhaul to bring in more equipment and chapter options.
	-Overhaul space combat to be more strategic by creating basic ai and better controls for the player.
	-Overhaul ground combat to be more engaging and include controls for the player.
	-Make going renegade/chaos viable.
	-Finish the diplomatic options with different races.
	-Find out what is causing the infinite guard bug.
	
Fixed
-Marines being overloaded into escorts on generation.
-Ships not despawning after being defeated in battle.
-Transfers to allow all units to be in all companies.
-You can now promote units to HQ positions if they are empty.
-Board Next Nearest now works with no limit on the number of marines.
	-Note you can now take on fairly large fleets with minimal losses, 
	-Enemy escorts are still an issue that I am looking into.
-Fixed a bug where strike cruisers would not get close enough to shoot. (I think?)

Changes
-Game no longer ends when your chapter master dies, the most experienced marine is automatically promoted.
-Changed ship loading to one company per frigate, including vehicles and 2 companies for battle barges.
-Overhauled promoting to be more in line with the lore, 1st = veterans, 2nd-5th = battle, 6-9th = support.
	--You can only promote in order scout->support->battle->1st-> honour; exceptions are made for command positions.
-Increased the max number of promotion options that "can" be shown from 6 to 9.
-Randomized starting experince of all units.
-Change promotion experience to a single rational number "40", to which most ranks require a multiple of.
	-Companies 6th-9th= 20
	-Companies 2nd-5th= 40
	-Company 1st= 80, Terminators= 100
	-HQ Honor guard=120.
	-HQ command positions= 200
	----Command positions, 1st company adds +40
	Captian=120, Champion= 100, Standard Bearer= 80 
	-Dreadnought= 100, Venerable Dreadnought= 400
	-Specialists exp requires increase 40 per rank, eg: X asprant/Lexicanum= 40, techmarine/Codiciery= 80, Epistolary= 120
	
Code Changes
-Created refactored role name system (Role_Enums) to allow the changing/adding of roles, which needs to be implemented across all code structures.
-Rewrote the entire chapter management screen and company management view using Enums as a testbed.
-Created a ton of helper tools.

----------------------------------------------------------------------------------------------------
Version 0.6560
Changes
-More elaborate cheats with the option to turn off debug mode (see cheats)

Fixes
-Fixed vehicles disappearing when tranfered to HQ
-Fixed a boarding bug, unsure which one.
-Tons of small things.
-*Forgot about this, fixed crash when replacing governer with serf.

-------Cheats--------
-Cheats have been updated to allow semi logical strings.
-Several cheats can be toggled on and off, just repeat the same cheat.
-Several cheats use numbers eg: to use "req#" you could type "req10000"
-To start once on the sector/map screen press "p", then enter text that is before the = sign.

infreq = Toggle infinate requisition
infseed = Toggle, gain 9999 geneseed.
debug = Toggle debugmode, use at your own peril.
		(Right click on sector map to create/destroy fleets/invasions)
		(On planet view, increase or decrease forces)
		(On Armanentarium screen add STC research for free)
test = Test dialogue, dont use.
req# = Set requisition to # amount
seed# = Set geneseed to # amount
recruit# = Created # of recruits with 20xp, that will be ready in one turn (No extra equipment)

*Note all deposition cheats can be negative and are capped between -100 and 100.
*Deposition has the format of "depXYZ#" where XYZ is the first 3 letters of a factions name.
*EG: "depimp100" sets deposition with the imperium to 100; whereas, depimp-100 sets it to -100.
depall# = Set deposition of all factions to an amount.
depimp# = Imperium
depmec# = Mechanicus
depinq# = Inquisition
depecc# = Ecclesiarchy
depeld# = Eldar
depork# = Ork
deptau# = Tau
deptyr# = Tyranids, this probably wont do anything.
depcha# = Chaos

(Many of these events will proc but will not create a popup)
eventg0="space_hulk";
eventg1="promotion";
eventg2="strange_building";
eventg3="sororitas";
eventg4="rogue_trader";
eventg5="inquisition_mission";
eventg6="inquisition_planet";
eventg7="mechanicus_mission";
eventg8 = "meet_eldar"

eventn0="strange_behavior";
eventn1="fleet_delay";
eventn2="harlequins";
eventn3="succession_war";
eventn4="random_fun";

eventb0="warp_storms";
eventb1="enemy_forces";
eventb2="crusade";
eventb3="enemy";
eventb4="mutation";
eventb5="ship_lost";
eventb6="chaos_invasion";
eventb7="necron_awaken";

http://www.bay12forums.com/smf/index.php?topic=142620.4035
https://1d4chan.org/wiki/Chapter_Master_(game)

---------------------
Version 0.XXXX
Notes
-

Fixed
-

Changes
-

Code Changes
-



scr_weapon -sets description and damage for the player
scr_en_weapon -sets the damage for npc's.