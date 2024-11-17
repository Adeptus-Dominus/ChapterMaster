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
### Events and Quests:
- `event (name*)` - triggers a random event if no name specified.
    - `crusade` - triggers the Crusade event.
    - `tomb` - triggers the Awakening of a Necron Tomb event.
    - `techuprising` - triggers the Tech Heretics Uprising event.
    - `inspection` - triggers the Inquisitorial Inspection event.
    - `slaughtersong` - triggers the Starship event.
- `inquisarti` - triggers the Artifact Loan quest.
- `govmission` - spawns governor missions on all planets.
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

