function scr_wep_abbreviate(argument0) {

	// argument0: weapon/item/gear name

	var we,we2,artifact;
	we="";we2="";artifact=false;

	if (string_count("&",argument0)=0) then we=argument0;
	if (string_count("&",argument0)>0){var ttt;ttt=0;we=argument0;ttt=string_pos("&",we);we="*"+string(string_delete(we,ttt,99)+"*");}
	if (string_count("Master Crafted ",argument0)>0){
	    we=string_replace(argument0,"Master Crafted ","^");
	    // var ttt;ttt=0;we=argument0;ttt=string_pos("Master Crafted ",we);we="^"+string(string_delete(we,0,string_length("Master Crafted ")));
	}

	if (we="Scout Armour") then we2="Scout";
	if (we="MK3 Iron Armour") then we2="MK3";
	if (we="MK4 Maximus") then we2="MK4";
        if (we="MK5 Heresy") then we2="MK5";
	if (we="MK6 Corvus") then we2="MK6";
	if (we="MK7 Aquila") then we2="MK7";
	if (we="MK8 Errant") then we2="MK8";
	if (we="Power Armour") then we2="PA";
	if (we="Artificer Armour") then we2="Arti";
	if (we="Terminator Armour") then we2="Termi";
	if (we="Tartaros") then we2="Tarta";
	if (we="Dreadnought") then we2="Dread";
	if (we="Jump Pack") then we2="Jump";
	if (we="Narthecium") then we2="Narth";
	if (we="Psychic Hood") then we2="Hood";
	if (we="Rosarius") then we2="Rosa";
	if (we="Iron Halo") then we2="Halo";
	if (we="Plasma Bomb") then we2="Bomb";
	if (we="Exterminatus") then we2="Exter";
	if (we="Bike") then we2="Bike";
	if (we="Company Standard") then we2="Stand";

	if (we="Storm Shield") then we2="StShield";
	if (we="Boarding Shield") then we2="BoShield";
	if (we="Hellgun") then we2="HGun";
	if (we="Hellrifle") then we2="HRifle";
	if (we="Archeotech Laspistol") then we2="Archeo";
	if (we="Combat Knife") then we2="Knife";
	if (we="Chainsword") then we2="ChSword";
	if (we="Chainaxe") then we2="ChAxe";
	if (we="Eviscerator") then we2="Evisc";
	if (we="Power Sword") then we2="PoSword";
	if (we="Eldar Power Sword") then we2="ElSword";
	if (we="Power Weapon") then we2="PoWeap";
	if (we="Power Axe") then we2="PoAxe";
	if (we="Power Fist") then we2="PoFist";
	if (we="Lightning Claw") then we2="LiClaw";
	if (we="Chainfist") then we2="ChFist";
	if (we="Lascutter") then we2="LCutter";
	if (we="Force Staff") then we2="FoWeap";
	if (we="Thunder Hammer") then we2="Hammer";

	if (we="Bolt Pistol") then we2="BoltPist";
	if (we="Webber") then we2="Web";
	if (we="Bolter") then we2="Bolter";
	if (we="Combiflamer") then we2="CombiFl";
	if (we="Twin Linked Bolters") then we2="TL Bolt";
	if (we="Heavy Bolter") then we2="HVYBolt";
	if (we="Storm Bolter") then we2="StrmBolt";
	if (we="Flamer") then we2="Flamer";
	if (we="Incinerator") then we2="Incin";
	if (we="Heavy Flamer") then we2="HVYFlamer";
	if (we="Inferno Cannon") then we2="Inferno";
	if (we="Meltagun") then we2="Melta";
	if (we="Multi-Melta") then we2="M Melta";
	if (we="Plasma Pistol") then we2="PlaPist";
	if (we="Infernus Pistol") then we2="InfPist";
	if (we="Plasma Gun") then we2="PlaGun";
	if (we="Sniper Rifle") then we2="Snipe";
        if (we="Stalker Pattern Bolter") then we2="Stalker";
	if (we="Assault Cannon") then we2="Assa";
	if (we="Autocannon") then we2="AutoC";
	if (we="Missile Launcher") then we2="Missi";
	if (we="Lascannon") then we2="LasCan";
	if (we="Conversion Beam Projector") then we2="CBP";
	if (we="Integrated Bolter") then we2="IntBolt";
	if (we="Power Fists") then we2="2 PoFist";
	if (we="Close Combat Weapon") then we2="CCW";
	if (we="Twin Linked Heavy Bolter") then we2="TL Hvy Bolt";
	if (we="Twin Linked Lascannon") then we2="TL LasCan";
	if (we="Heavy Bolters") then we2="2 HvyBolt";
	if (we="Whirlwind Missiles") then we2="Whirl";
	if (we="HK Missile") then we2="HK Miss";

	if (we="Armoured Ceramite") then we2="Cera";
	if (we="Artificer Hull") then we2="Art Hull";
	if (we="Heavy Armour") then we2="Hvy Arm";
	if (we="Void Shield") then we2="V Shld";
	if (we="Lucifer Pattern Engine") then we2="Luc Eng";

	if (we="Dozer Blades") then we2="Doz Blad";
	if (we="Searchlight") then we2="Light";
	if (we="Smoke Launchers") then we2="Smoke";

	if (we="Twin Linked Heavy Bolter Mount") then we2="TL Hvy Bolt";
	if (we="Twin Linked Lascannon Mount") then we2="TL Lascan";
	if (we="Twin Linked Assault Cannon Mount") then we2="TL AssaCan";
	if (we="Reaper Autocannon Mount") then we2="Reap AC";

	if (we="Quad Linked Heavy Bolter Sponsons") then we2="QL Hvy Bolts";
	if (we="Twin Linked Lascannon Sponsons") then we2="TL Lascans";
	if (we="Hurricane Bolter Sponsons") then we2="Hurc Bolts";
	if (we="Flamestorm Cannon Sponsons") then we2="FStorm Cans";
	if (we="Twin Linked Heavy Flamer Sponsons") then we2="TL Hvy Flams";
	if (we="Twin Linked Multi-Melta Sponsons") then we2="TL M Meltas";
	if (we="Twin Linked Volkite Culverin Sponsons") then we2="TL VolCuls";

	if (we="Twin Linked Lascannon Turret") then we2="TL Lascan";
	if (we="Autocannon Turret") then we2="AutoCan";
	if (we="Twin Linked Assault Cannon Turret") then we2="TL AssaCan";
	if (we="Flamestorm Cannon Turret") then we2="FStorm Can";
	if (we="Magna-Melta Turret") then we2="Mag-Melta";
	if (we="Plasma Destroyer Turret") then we2="Plas Dest";
	if (we="Heavy Conversion Beamer Turret") then we2="Hvy CBeam";
	if (we="Neutron Blaster Turret") then we2="NBlaster";
	if (we="Volkite Saker Turret") then we2="Vol Saker";

	if (we="Lascannon Sponsons") then we2="Lascans";
	if (we="Heavy Bolter Sponsons") then we2="Hvy Bolts";
	if (we="Heavy Flamer Sponsons") then we2="Hvy Flams";
	if (we="Volkite Culverin Sponsons") then we2="VolCuls";

	return(we2);


}
