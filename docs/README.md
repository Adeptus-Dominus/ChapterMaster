<p align="center">
  <img src="https://github.com/user-attachments/assets/47772b42-59ad-4fdf-84de-ae9bcba999be" alt="Chapter Master - Adeptus Dominus Logo"/>
</p>

**NEW RELEASE HERE** https://github.com/KestasV/Chapter-Master-1.5-Adeptus-Indomitus/releases/tag/Exe1.1

# Chapter Master 1.5 – Adeptus Indomitus

**Chapter Master 1.5 – Adeptus Indomitus** is a major continuation fork of *Chapter Master: Adeptus Dominus*, expanding the game from a pure Space Marine Chapter command simulator into a broader Imperial war effort.

The central addition is a fieldable **Imperial Guard / Astra Militarum Auxilia** layer. The player can bargain with Imperial and Mechanicus authorities to raise Guardsmen, Guard Sergeants, Heavy Weapons Teams, Chimeras, Leman Russ tanks, and Basilisk artillery, then deploy them alongside the Chapter as a supporting Imperial force.

This fork adds new Guard unit profiles, Guard weapons, vehicle weapons, armour, Auxilia organization, and dedicated combat behaviour. Guardsmen are not just renamed Marines: they fight as mass infantry screens, split into capped lasgun volleys, shield more valuable forces behind them, and require armour, tanks, artillery, and Astartes support to survive serious threats.

Ground combat has been heavily reworked. Targeting now better distinguishes anti-infantry and anti-tank fire, armour walls no longer create absurd all-or-nothing shooting behaviour, partial volleys can pierce through vehicle screens, splash damage can carry over, vehicle weapons remain relevant at point-blank range, and dead or empty formations are cleaned up more reliably.

The campaign layer has also been expanded with Auxilia recruitment through diplomacy, Mechanicus armour support, per-ship assault capacity, local assault counters, lost-in-the-Warp ship events, Eldar incursion and craftworld-intel systems, improved fleet handling, better management UI, richer unit profile tooltips, and numerous bug fixes.

This is an unofficial fan fork intended to preserve and expand the spirit of *Chapter Master* while pushing it toward a larger, more dynamic Imperial command experience.

## The biggest concrete changes

*****_Imperial Guard / Auxilia system_. Added real Guard-side content: Guardsmen, Guard Squads, Heavy Weapons Teams, and Guard Sergeants, with human base stats, Flak Armour, Lasguns, Bayonets, Heavy Bolters, Guard Chainswords, and Laspistols.

*****_Diplomatic recruitment and attached armour_. Sector Governor trade now raises Guardsmen directly at the homeworld, adds one Guard Sergeant per full squad, one Chimera per 200 Guardsmen, and one Heavy Weapons Team per 100 Guardsmen; Mechanicus trade can now provide Leman Russ tanks and Basilisks for the Auxilia company.

*****_New Astra Militarum wargear and vehicles_. Added or integrated Flak Armour, Lasguns, Hellguns, Earthshaker Cannons, Battle Cannons, Multi-Lasers, Chimeras, Leman Russ loadouts, and Basilisk artillery loadouts.

*****_Combat model overhaul._ Guard screens occupy forward columns, anti-tank weapons now have a dedicated target-preference threshold, volleys pierce armour walls by depth instead of passing through for free or vanishing, and Guardsmen split into capped lasgun stacks instead of forming one giant unrealistic volley.

*****_Better targeting, armour, and casualty logic_. Enemy weapons now prefer vehicles only when their AP role justifies it, Guard screens can actually shield vehicles behind them, column piercing works on both sides, partial volleys scale damage correctly, stale casualty reports are cleared, and vehicle armour penetration was fixed so enemy anti-tank weapons can actually hurt vehicles.

*****_Fleet, assault, and campaign-layer additions._ Ships now have per-turn ground-assault support counters, planets have local assault counters, new ship defaults include Guard-related capacity fields, and lost-in-the-Warp ships can return with damage, corruption, mutiny, Chaos capture, or destruction outcomes.

*****_Eldar campaign restoration and improvement_. Eldar are no longer only a hidden craftworld oddity:  added incursion/intel settings, craftworld reveal requirements, first-contact clues, and Eldar ship speed tuning.

*****_Management UI and quality-of-life_. The management screen now recognizes an Auxilia company, includes richer unit profile UI/tooltips, and has buttons for squad view, profile, bio, and capture image.

## Compiling from source

1. Install the **GameMaker** IDE matching r system (available on the [GameMaker website](https://releases.gamemaker.io/release-notes/2026/0) or [Steam](https://store.steampowered.com/app/1670460/GameMaker/)).
2. Clone or download the repository (find the green **<>Code** button and select **Download ZIP**).
3. Find **ChapterMaster.yyp** in the downloaded folder and open it with **GameMaker**.
4. Select the target platform in the IDE: **Windows, macOS, Ubuntu**.
5. Select the output: **GMS2 VM** (no requirements; fast to compile; worse performance) or **GMS2 YYC** (requires a dedicated compiler; slow to compile; better performance).
6. Press **Run** (F5) to play the game or **Debug** (F6) to use debugger features.

## Contributing

**++**BIG thanks to **Tavish** for the combat changes adapted and worked on from his "LW_Beta_1.2" fork**++**

**++**Another big thanks to Tophat#7692 for testing and helping with the design. Half of the errors, bugs and design ideas wouldn't have been possible without you**++**

**++**And shoutouts to the developers at main for upkeeping this old legacy code so i can work on improvements!**++**

This mod was made with assistance from Claude Fable 5 and Opus 4.8 on code consultation




**To contribute to this fork please contact me on Discord, hopefully we can work together. I take ALL input and suggestions in, even if 're not a coder. If there's somethin  wanna personally see in the game then please tell me.** https://discord.com/channels/714022226810372107/1520160266120204409
Best bet is to ask about everything in our Discord, because things bellow are probably not very helpful at the moment.

- [CONTRIBUTING.md](https://github.com/Adeptus-Dominus/ChapterMaster/blob/main/docs/CONTRIBUTING.md) (required read before any contribution)
- [CODE_STYLE.md](https://github.com/Adeptus-Dominus/ChapterMaster/blob/main/docs/CODE_STYLE.md) (how we write our code)
- [TIPS.md](https://github.com/Adeptus-Dominus/ChapterMaster/blob/main/docs/TIPS.md) (about git and GameMaker)
- [ARCHITECTURE](https://github.com/Adeptus-Dominus/ChapterMaster/blob/main/docs/ARCHITECTURE.md) (explains the current code; probably outdated)
- [Useful Tools/Resources](https://github.com/Adeptus-Dominus/ChapterMaster/wiki/Useful-resources)
- [Working with GameMaker projects](https://github.com/Adeptus-Dominus/ChapterMaster/wiki/Working-with-GameMaker-projects)

This project exists thanks to all the people who have contributed:

[![Contributors](https://contrib.rocks/image?repo=Adeptus-Dominus/ChapterMaster)](https://github.com/Adeptus-Dominus/ChapterMaster/graphs/contributors)
