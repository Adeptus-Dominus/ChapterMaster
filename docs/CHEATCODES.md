# Cheat codes reference:
Most of the time the input is: (cheatcode) (number or type) (number or type) (unused for now).  
Spaces between arguments are required.  
Most of the time it's case insensitive, but rarely may not be.  
Arguments with stars `(argument*)` can be omitted.

### General:
- `infreq` - infinite requisition.
- `infseed`- gives 9999 Geneseed.
- `debug` - turns the debug mode on.
- `test` - does something unholy.
- `req (number)` - sets Requisition to specified amount.
- `seed (number)` - sets Geneseed to specified amount.
- `stc (number)` - adds specified amount of STC fragments. 
- `finishforge` - gives 1 million Forge Points (ending all crafting).
### Spawning:
- `recruit (number*)` - spawns a new recruit (or amount specified) with 1 month of remaining training and 20 XP.
- `artifact (type*) (number*)` - spawns an artifact of a random type, if unspecified.
    - `(type*)` - possible values: random, random_nodemon, Weapon, Armour, Gear, Device, Robot, Tome, chaos_gift, good. Case sensitive.
- `artifactpopulate` - spawns artifacts on all planets.
- `stcpopulate` - spawns an STC fragment on all planets.
- `additem "(name)" (number*) (quality*)` - spawns an item(s) with specified parameters.
    - `"(name)"` - item name in quotes, as it's written in the game. Case sensitive. "Bolter", "Power Axe", etc.
    - `(quality*)` - possible values: standard, master_crafted, artificer, artifact, exemplary. Case insensitive.
- `newapoth` - spawns an Apothecary (40 points, Needs testing).
- `newpsyk` - spawns a Librarian (70 points, Needs testing).
- `newtech` - spawns a Techmarine (400 points, Needs testing).
- `newchap` - spawns a Chaplain (50 points, Needs testing).
- `sisterhospitaler (number*)` - spawns a Sister Hospitaller.
- `sisterofbattle (number*)` - spawns a Sister of Battle.
- `skitarii (number*)` - spawns a Skitarii.
- `techpriest (number*)` - spawns a Tech Priest.
- `crusader (number*)` - spawns a Crusader.
- `flashgit (number*)` - spawns a Flash Git.
- `chaosfleetspawn` - spawns a chaos fleet.
- `neworkfleet` - spawns an ork fleet.
- `shiplostevent` - looses a random traveling player ship to the warp
- `recoverlostship` - recovers a random lost ship from the warp

### Events and Quests:
- `event (name*)` - triggers a random event if no name specified.
    - `crusade` - triggers the Crusade event.
    - `tomb` - triggers the Awakening of a Necron Tomb event.
    - `techuprising` - triggers the Tech Heretics Uprising event.
    - `inspection` - triggers the Inquisitorial Inspection event.
    - `slaughtersong` - triggers the Starship event.
    - `surfremove` - triggers inquisition surf removal
    - `strangebuild` - triggers strange build event
    - `factionenemy` - triggers the made a faction enemy event
    - `stopall` - stops random events
    - `startevents` - restart random events
- `inquisarti` - triggers the Artifact Loan quest.
- `govmission (mission*)` - spawns governor missions on all planets. run with a mission name to spawn a particular mission
    - `provide_garrison`
    - `join_communion` 
    - `hunt_beast`
    - `protect_raiders` 
    - `recover_artifacts`
    - `purge_enemies`    
    - `raid_black_market`
    - `show_of_power`
- `inquismission (mission*)` - triggers an inquisition mission. You must have met the inquisition for this to work
    - `planet` - investigate planet mission
    - `purge` - purge planet mission
    - `artifact` - hold artifact mission
    - `spyrer` - hunt spyrer mission
    - `tomb_world` - destroy tomb world mission. Needs at least 1 planet with a dormant necron tomb on the map
    - `ethereal` - not implemented yet
    - `tyranid_organism` - capture tyranis mission
    - `demon` clear demon world mission. Requires at least one planet to have demons on it
- `mechmission (mission*)` - triggers a mechaniicus mission, can be run as is or with an optional missiono parameter to specify a particular mission
    - `mech_mars`
    - `mech_raider`
    - `mech_bionics`

    
### Disposition:
- `depall (number*)` - sets disposition of everyone to specified value.
- `depmec (number*)` - sets disposition of Mechanicus to specified value.
- `depinq (number*)` - sets disposition of Inquisition. to specified value.
- `depecc (number*)` - sets disposition of Ecchlesiarchy to specified value.
- `depeld (number*)` - sets disposition of Eldar. to specified value.
- `depork (number*)` - sets disposition of Orkz. to specified value.
- `deptau (number*)` - sets disposition of T'au to specified value.
- `depcha (number*)` - sets disposition of Chaos to specified value.
- `deptyr (number*)` - sets disposition of...Tyranids? (probably does nothing) to specified value.

