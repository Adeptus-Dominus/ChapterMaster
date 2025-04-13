
var a1;a1="";

if (ally>0) and (ally_forces>0){
    if (ally=3){
        if (ally_forces>=1) then a1="Joining your forces are 10 Techpriests and 20 Skitarii.  Omnissian Power Axes come to life, crackling and popping with disruptive energy, and Conversion Beam Projectors are levelled to fire.  The Tech-Guard are silent as they form a perimeter around their charges, at contrast with their loud litanies and Lingua-technis bursts.";
    }
}



// Player crap here
var p1,p2,p3,p4,p5,p6,p8,temp,temp2,temp3,temp4,temp5,temp6;
p1="";p2="";p3="";p4="";p5="";p6="";p8="";temp=0;temp2=0;temp3=0;temp4=0;temp5=0;temp6=0;
var d1,d2,d3,d4,d5,d6,d7,d8;
d1="";d2="";d3="";d4="";d5="";d6="";d7="";d8="";


temp=scouts+tacticals+veterans+devastators+assaults+librarians;
temp+=techmarines+honors+dreadnoughts+terminators+captains;
temp+=standard_bearers+champions+important_dudes+chaplains+apothecaries;
temp+=sgts+vet_sgts

var color_descr;
color_descr="";

if (obj_ini.main_color!=obj_ini.secondary_color) then color_descr=string(obj_controller.col[obj_ini.main_color])+" and "+string(obj_controller.col[obj_ini.secondary_color]);
if (obj_ini.main_color=obj_ini.secondary_color) then color_descr=string(obj_controller.col[obj_ini.main_color]);

/*show_message(scouts+tacticals+veterans+devastators+assaults+librarians);
show_message(techmarines+honors+dreadnoughts+terminators+captains);
show_message(standard_bearers+important_dudes+chaplains+apothecaries);
show_message(temp);*/

// Random variations; dark out, rain pooling down, dawn shining off of the armour, etc.
var variation;variation="";
variation=choose("","dawn","rain");


if (battle_special="ship_demon"){
    p1="As the Artifact is smashed and melted down some foul smoke begins to erupt from it, spilling outward and upward.  After a sparse handful of seconds it takes form into a ";
    p1+=string(obj_enunit.dudes[1]);
    p1+=".  Now free, it seems bent upon slaying your marines.  Onboard you have ";
}

if (battle_special="ruins") or (battle_special="ruins_eldar"){
    p1="Your marines place themselves into a proper fighting position, defensible and ready to fight whatever may come.  Enemies may only come from a few directions, though the ancient corridors and alleyways are massive, and provide little cover.";
    p1+="  You have ";
}

if (string_count("mech",battle_special)>0){
    p1="Large, hulking shapes advance upon your men from every direction.  The metal corridors and blast chambers prevent escape.  Soon 4 Thallax and half a dozen Praetorian Servitors can be seen, with undoubtably more to come.";
    p1+="  You have ";
}

if (battle_special="space_hulk"){
    if (hulk_forces>0) then p1="Your marines manuever through the hull of the Space Hulk, shadows dancing and twisting before their luxcasters.  The hallway integrity is nonexistant- twisted metal juts out in hazardous ways or opens into bottomless pits.  Still, there is loot and knowledge to be gained.  It is not long before your men's sensorium pick up hostile blips.  Your own forces are made up of ";
    if (hulk_forces=0) then p1="Your marines manuever through the hull of the Space Hulk, shadows dancing and twisting before their luxcasters.  The hallway integrity is nonexistant- twisted metal juts out in hazardous ways or opens into bottomless pits.  Your forces are made up of ";
}


if (battle_special=""){
    if (dropping=0){
        if (temp-dreadnoughts>0){
            if (variation=""){p1="Dirt crunches beneath the soles of "+string(temp)+" "+string(global.chapter_name)+" as they form up.  Your ranks are made up of ";}
            if (variation="rain"){p1="Rain pelts the ground and fogs the air, partly veiling the "+string(temp)+" "+string(global.chapter_name)+".  Your ranks are made up of ";}
            if (variation="dawn"){p1="The bright light of dawn reflects off the "+string_lower(color_descr)+" ceremite of "+string(temp)+" "+string(global.chapter_name)+".  Your ranks are made up of ";}
        }
    }
    if (dropping=1){
        if (temp-dreadnoughts>0){// lyman
            p1="The air rumbles and quakes as "+string(temp)+" "+string(global.chapter_name)+" descend in drop-pods.  ";
        
        
            /*if (variation=""){
                if (lyman=0) then p1="The air rumbles and quakes as "+string(temp)+" "+string(global.chapter_name)+" descend in drop-pods.  Before the enemy can bring their full ranged power to bear the pods smash down.  With practiced speed your marines pour on free.  Their ranks are made up of ";
                if (lyman=1) then p1="The air rumbles and quakes as "+string(temp)+" "+string(global.chapter_name)+" descend in drop-pods.  Before the enemy can bring their full ranged power to bear the pods smash down.  Your marines exit the vehicles, shaking off their vertigo and nausea with varying degrees of success.  Your ranks are made up of ";
            }
            */
        }
    }
}
if (string_count("spyrer",battle_special)>0){
    p1="Your marines search through the alleyways and corridors likely to contain the Spyrer.  It does not take long before the lunatic attacks, springing off from a wall to fall among your men.  Your ranks are made up of ";
}
if (string_count("fallen",battle_special)>0){
    p1="Your marines search through the alleyways and dens likely to contain the Fallen.  Several days pass before the search is succesful; the prey is located by Auspex and closed in upon.  ";
    if (battle_climate="Lava") then p1="Your marines search through the broken craggs and spires of the molten planet.  Among the bubbling lava, and cracking earth, they search for the Fallen.  After several days of searching Auspex detect the prey.  ";
    if (battle_climate="Dead") then p1="Your marines search through the cratered surface of the debris field.  Among the cracking earth and dust they search for the Fallen.  After several days of searching Auspex detect the prey.  ";
    if (battle_climate="Agri") then p1="Endless fields of wheat and barley are an unlikely harbor for a renegade, but your marines search the agri world all the same.  After several days of searching Auspex detect the prey.  ";
    if (battle_climate="Death") then p1="Deadly carniverous plants and endless canopy blot out the surface of the planet.  Among the disheveled hills, and heavy underbrush, your marines search for the Fallen.  After several days of searching Auspex detect the prey.  ";
    if (battle_climate="Ice") then p1="Your marines search through the endless glaciers and peaks of the frozen planet.  Among the howling wind, and cracking ice, they search for the Fallen.  After several days of searching Auspex detect the prey.  ";
    if (obj_enunit.dudes_num[1]=1) then p1+="The coward soon realizes he has been located, and reacts like a cornered animal, brandishing weapons.";
    if (obj_enunit.dudes_num[1]>1) then p1+="The cowards soon realize they have been located, and react like cornered animals, brandishing weapons.";
    p1+="  Your ranks are made up of ";
}







if (string_count("_attack",battle_special)>0){
    var wh;wh=choose(1,2);
    if (wh=1) then p1="Cave dirt crunches beneath the soles of your marines as they continue their descent.  There is little warning before ";
    if (wh=2) then p1="The shadows stretch and morph as the lights cast by your marines move along.  One large shadow begins to move on its own- ";

    if (string_count("wake",battle_special)>0){
        p1="Cave dirt crunches beneath the soles of your marines as they continue their descent.  There is little warning when the ground begins to shake.  An old, dusty breeze seems to flow through the tunnel, followed by rumbling sensations and distant mechanical sounds.  ";
        if (string_count("1",battle_special)>0) then p1+="Within minutes Necrons begin to appear from every direction.  There appears to be nearly fourty, cramped in the dark tunnels.";
        if (string_count("2",battle_special)>0) then p1+="Within minutes Necrons begin to appear from every direction.  There appears to be nearly a hundred, cramped in the dark tunnels.";
        if (string_count("3",battle_special)>0) then p1+="Within minutes Necrons begin to appear from every direction.  Their numbers are wihout number.";
    }
    
    
    
    
    if (string_count("wraith",battle_special)>0) then p1+="two Necron Wraiths appear out of nowhere and begin to attack.";
    if (string_count("spyder",battle_special)>0) then p1+="a large Canoptek Spyder launches towards your marines, a small group of scuttling Scarabs quickly following.";
    if (string_count("stalker",battle_special)>0) then p1+="the tunnel begins to shake and a massive Tomb Stalker scuttles into your midst.";
    newline=p1;
    scr_newtext();
    exit;
}






if (tacticals>0) and (veterans>0){
    p2=string(tacticals+veterans)+" "+string(obj_ini.role[100][8])+"s, ";
}
if (tacticals>0) and (veterans=0){
    if (tacticals=1) then p2=string(tacticals)+" "+string(obj_ini.role[100][8])+", ";
    if (tacticals>1) then p2=string(tacticals)+" "+string(obj_ini.role[100][8])+"s, ";
}
if (tacticals=0) and (veterans>0){
    if (veterans=1) then p2=string(veterans)+" "+string(obj_ini.role[100][3])+", ";
    if (veterans>1) then p2=string(veterans)+" "+string(obj_ini.role[100][3])+"s, ";
}

if (assaults>0){
    if (assaults=1) then p2+=string(assaults)+" "+string(obj_ini.role[100][10])+", ";
    if (assaults>1) then p2+=string(assaults)+" "+string(obj_ini.role[100][10])+"s, ";
}
if (devastators>0){
    if (devastators=1) then p2+=string(devastators)+" "+string(obj_ini.role[100][9])+", ";
    if (devastators>1) then p2+=string(devastators)+" "+string(obj_ini.role[100][9])+"s, ";
}

if (temp<200) and (terminators>0){
    if (terminators=1) then p2+=string(terminators)+" Terminator, ";
    if (terminators>1) then p2+=string(terminators)+" Terminators, ";
}

if (temp<200) and (chaplains>0){
    if (chaplains=1) then p2+=string(chaplains)+" "+string(obj_ini.role[100][14])+", ";
    if (chaplains>1) then p2+=string(chaplains)+" "+string(obj_ini.role[100][14])+", ";
}

if (temp<200) and (apothecaries>0){
    if (apothecaries=1) then p2+=string(apothecaries)+" "+string(obj_ini.role[100][15])+", ";
    if (apothecaries>1) then p2+=string(apothecaries)+" "+string(obj_ini.role[100][15])+", ";
}

if (temp<200) and (librarians>0){
    if (librarians=1) then p2+=string(librarians)+" "+string(obj_ini.role[100,17])+", ";
    if (librarians>1) then p2+=string(librarians)+" "+string(obj_ini.role[100,17])+", ";
}

if (temp<200) and (techmarines>0){
    if (techmarines=1) then p2+=string(techmarines)+" "+string(obj_ini.role[100][16])+", ";
    if (techmarines>1) then p2+=string(techmarines)+" "+string(obj_ini.role[100][16])+", ";
}
if (temp<200) and (sgts>0){
    if (techmarines=1) then p2+=string(techmarines)+" "+string(obj_ini.role[100][18])+", ";
    if (techmarines>1) then p2+=string(techmarines)+" "+string(obj_ini.role[100][18])+", ";
}
if (temp<200) and (vet_sgts>0){
    if (techmarines=1) then p2+=string(techmarines)+" "+string(obj_ini.role[100][19])+", ";
    if (techmarines>1) then p2+=string(techmarines)+" "+string(obj_ini.role[100][19])+", ";
}


if (scouts>0){
    if (scouts=1) then p2+=string(scouts)+" "+string(obj_ini.role[100][12])+", ";
    if (scouts>1) then p2+=string(scouts)+" "+string(obj_ini.role[100][12])+"s, ";
}


// temp5=string_length(p2);p2=string_delete(p2,temp5-1,2);// p2+=".";
temp6=honors+captains+important_dudes+standard_bearers;
if (temp>=200) then temp6+=terminators;
if (temp>=200) then temp6+=chaplains;
if (temp>=200) then temp6+=apothecaries;
if (temp>=200) then temp6+=techmarines;
if (temp>=200) then temp6+=librarians;
if (temp6>0) then p2+=string(temp6)+" other various Astartes, ";

var woo;woo=string_length(p2);
p2=string_delete(p2,woo-1,2);

if (string_count(", ",p2)>1){
    var woo;woo=string_rpos(", ",p2);
    p2=string_insert(" and",p2,woo+1);
}
if (string_count(", ",p2)=1){
    var woo;woo=string_rpos(", ",p2);
    p2=string_delete(p2,woo-1,2);
    p2=string_insert(" and",p2,woo+1);
}
p2+=".";





if (standard_bearers>1) and (dropping=0) then p5="  Chapter Ancients hold your Chapter heraldry high and proud.";



if (dreadnoughts+predators+land_raiders>3){
    p6="  Forming up the armoured division is ";
    if (dreadnoughts=1) then p6+=string(dreadnoughts)+" "+string(obj_ini.role[100][6])+", ";
    if (dreadnoughts>1) then p6+=string(dreadnoughts)+" "+string(obj_ini.role[100][6])+"s, ";
    
    if (rhinos=1) then p6+=string(rhinos)+" Rhino, ";
    if (rhinos>1) then p6+=string(rhinos)+" Rhinos, ";
    
    if (predators=1) then p6+=string(predators)+" Predator, ";
    if (predators>1) then p6+=string(predators)+" Predators, ";
    
    if (land_raiders=1) then p6+=string(land_raiders)+" Land Raider, ";
    if (land_raiders>1) then p6+=string(land_raiders)+" Land Raiders, ";
    
    if (whirlwinds=1) then p6+=string(whirlwinds)+" Whirlwind, ";
    if (whirlwinds>1) then p6+=string(whirlwinds)+" Whirlwinds, ";
        
    // Other vehicles here?
    
    var woo;woo=string_length(p6);
    p6=string_delete(p6,woo-1,2);
    
    if (string_count(", ",p6)>1){
        var woo;woo=string_rpos(", ",p6);    
        p6=string_insert(" and",p6,woo+1);
    }
    if (string_count(", ",p6)=1){
        var woo;woo=string_rpos(", ",p6);
        p6=string_delete(p6,woo-1,2);
        p6=string_insert(" and",p6,woo+1);
    }
    p6+=".";
    
}
// If less than three spell out the individual vehicles


if (battle_special="space_hulk"){
    newline=p1+p2;scr_newtext();
    if (a1!=""){newline=a1;scr_newtext();}
    if (hulk_forces>0){newline="There are "+string(hulk_forces)+" or so blips.";scr_newtext();}
    
    exit;
}
if (dropping=0){
    newline=p1+p2+p3+p4+p5+p6;
    scr_newtext();
    if (a1!=""){newline=a1;scr_newtext();}
}

if (dropping=1) and (battle_special!="space_hulk"){
    d1=p1;d2=p2;
    d3=p3;d4=p4;
    d5=p5;d6=p6;
}


if (battle_special="ruins") or (battle_special="ruins_eldar"){
    newline="The enemy forces are made up of "+string(enemy_dudes);
    
    if (enemy=6) then newline+=" Craftworld Eldar.";
    if (enemy=10) then newline+=" Cultists and Mutants.";
    if (enemy=11) then newline+=" Chaos Space Marines.";
    if (enemy=12) then newline+=" Daemons.";
    
    scr_newtext();exit;
}




// Enemy crap here
var rand;
p1="";p2="";p3="";p4="";p5="";p6="";
temp2=0;temp3=0;temp4=0;temp5=0;

/*if (terrain=""){rand=choose(1,2,3);// Variations for terrain
    if (rand<4) then 
    // if (rand=2) then p1="Encroaching upon your forces are ";
    // if (rand=3) then p1="Advancing upon your forces are ";
}

// p1+=string(enemy_dudes);// The number descriptor*/


if (enemy=2){
    p1="Opposing your forces are a total of "+scr_display_number(floor(guard_effective))+" Guardsmen, including Heavy Weapons and Armour.";
    p2="";p3="";
}



if (enemy=5) and (dropping=0){
    p1="Marching to face your forces ";
    if (threat=1) then p2="are a squad of Adepta Sororitas, back up by a dozen priests.  Forming up a protective shield around them are a large group of religious followers, gnashing and screaming out litanies to the Emperor.";
    if (threat=2) then p2="are several squads of Adepta Sororitas.  A large pack of religious followers forms up a protective shield in front, backed up by numerous Acro-Flagellents.";
    if (threat=3) then p2="are more than four hundred Adepta Sororitas, thick clouds of incense and smoke heralding their advance.  An equally massive pack of religious followers are spread around, screaming and babbling hyms to the Emperor.  Many are already bleeding from self-inflicted wounds or flagellation.  Several Penitent Engines clank and advance in the forefront.";
    if (threat=4) then p2="are more than a thousand Adepta Sororitas, a large portion of an order, thick clouds of incense and smoke heralding their advance.  A massive pack of religious followers are spread among the force, screaming and babbling hyms to the Emperor.  Many are already bleeding from self-inflicted wounds or flagellation.  Their voices are drowned out by the rumble of Penitent Engines and the loud vox-casters of Excorcists, blasting out litanies and organ music even more deafening volumes.";
    if (threat>=5) then p2="is the entirety of an Adepta Sororitas order, the ground shaking beneath their combined thousands of footsteps.  Forming a shield around them in a massive, massive pack of religious followers, screaming out or babbling hyms to the Emperor.  All of the opposing army is a blurring, shifting mass of robes and ceremite, and sound, Ecclesiarchy Priests and Mistresses whipping the masses into more of a blood frenzy.  Organ music and litanies blast from the many Exorcists, the sound deafening to those too close.  Carried with the wind, and lingering in the air, is the heavy scent of promethium.";
}


if (enemy=6) and (dropping=0){
    // p1+=" Eldar";// Need a few random descriptors here
    rand=choose(1,2,3);
}
if (enemy=7) and (dropping=0){
    // p1+=" Orks";
    rand=choose(1,2,3);
    if (rand<4){
        p1="Howls and grunts ring from the surrounding terrain as the Orks announce their presence.  ";
        p2=string(enemy_dudes)+", the bloodthirsty horde advances toward your Marines, ecstatic in their anticipation of carnage.  ";
        p3=p2;p2=string_delete(p2,2,999);p3=string_delete(p3,1,1);p2=string_upper(p2);// Capitalize the ENEMY DUDES first letter
    }
}
if (enemy=7) and (dropping=1){
    p1="The "+string(enemy_dudes)+"-some Orks howl and roar at the oncoming marines.  Many of the beasts fire their weapons, more or less spraying rounds aimlessly into the sky.";
}

if (enemy=8) and (dropping=0){
    // p1+=" Tau";
    rand=choose(1,2,3);
}
if (enemy=9) and (dropping=0){
    // p1+=" Tyranids";
    rand=choose(1,2,3);
}
if (enemy=9) and (dropping=1){
    p1="The "+string(enemy_dudes)+"-some Tyranids hiss and chitter as your marines rain down.  Blasts of acid and spikes fill the sky, but none seem to quite find their mark.";
}

if (enemy=10) and (dropping=0){
    // p1+=" heretics";
    rand=choose(1,2,3);
}


if (enemy=10) and (threat=7){
    rand=choose(1,2);
    if (rand=1) then p1="Laying before them is a hellish landscape, fitting for nightmares.  Twisted, flesh-like spires reach for the sky, each containing a multitude of fanged maws or eyes.  Lightning crackles through the red sky.  ";
    if (rand=2) then p1="Waiting for your marines is a twisted landscape.  Mutated, fleshy spires reach for the sky.  The ground itself is made up of choking purple ash, kicked up with each footstep, blocking vision.  ";
    p1+="All that can be seen twists and shifts, as though looking through a massive, distorted lens.  ";
    p8="The enemy forces are made up of over 3000 lesser Daemons.  Their front and rear ranks are made up of Maulerfiends and Soulgrinders, backed up by nearly a dozen Greater Daemons.  Each of the four Chaos Gods are represented.";
}

if (enemy=11) and (dropping=0){
    // p1+=" Chaos Space Marines";
    rand=choose(1,2,3);
}

if (enemy=12) and (dropping=0){
    // Daemons
}

if (enemy=13) and (dropping=0){
    rand=choose(1,2,3);
    if (rand<4){
        p1="Dirt crunches beneath the feet of the Necrons as they make their silent advance.  ";
        p2=string(enemy_dudes)+", the souless xeno advance toward your Marines, silent and pulsing with green energy.  ";
        p3=p2;p2=string_delete(p2,2,999);p3=string_delete(p3,1,1);p2=string_upper(p2);// Capitalize the ENEMY DUDES first letter
    }
}


if (dropping=0){
    newline=p1+p2+p3+p4+p5+p6;
    scr_newtext();
    if (a1!=""){newline=a1;scr_newtext();}
    if (p8!=""){newline=p8;scr_newtext();}
}

if (dropping=1){
    newline=d1+p1;scr_newtext();
    if (lyman=0) then d7="After a brief descent all of the drop-pods smash down, followed quickly by your marines pouring free.  Their ranks are made up of ";
    if (lyman=1) then d7="After a brief descent all of the drop-pods smash down.  Your marines exit the vehicles, shaking off their vertigo and nausea with varying degrees of success.  Their ranks are made up of ";
    newline=d7+d2+d3+d4+d5+d6;scr_newtext();
    if (a1!=""){newline=a1;scr_newtext();}
    if (p8!=""){newline=p8;scr_newtext();}
}




if (occulobe=1) and (battle_special!="space_hulk"){
    if (time=5) or (time=6){
        newline="The morning light of dawn is blinding your marines!";newline_color="red";scr_newtext();
    }
}



if (fortified>1) and (dropping=0) and (enemy+threat!=17){
    if (fortified=2) then newline="An Aegis Defense Line protects your forces.";
    if (fortified=3) then newline="Thick plasteel walls protect your forces.";
    if (fortified=4) then newline="A series of thick plasteel walls protect your forces.";
    if (fortified>=5) then newline="A massive plasteel bastion protects your forces.";
    
    if (player_defenses>0) and (player_silos>0) then newline+="  The front of your Monastery also boasts "+string(player_defenses)+" Weapon Emplacements and "+string(player_silos)+" Missile Silos.";
    if (player_defenses=0) and (player_silos>0) then newline+="  Your Monastery also boasts "+string(player_silos)+" Missile Silos.";
    if (player_defenses>0) and (player_silos=0) then newline+="  The front of your Monastery also boasts "+string(player_defenses)+" Weapon Emplacements.";
        
    scr_newtext();
}












// Check for battlecry here
// if (temp>=100) and (threat>1) and (big_mofo!=10) and (dropping=0){
if (temp>=100) and (threat>1) and (big_mofo>0) and (big_mofo<10) and (dropping=0){
    p1="";p2="";p3="";p4="";p5="";p6="";
    temp4=0;temp5=0;
    
    if (big_mofo=1) then p1="You ";
    if (big_mofo=2) then p1="The Master of Sanctity ";
    if (big_mofo=3) then p1="Chief "+string(obj_ini.role[100,17])+" ";
    if (big_mofo=5) then p1="A Captain ";
    if (big_mofo=8) then p1="A Chaplain ";
    
    
    
    var standard_cry;standard_cry=0;
    if (global.chapter_name="Salamanders"){standard_cry=1;
        var rand;rand=choose(1,2,3,4,5);
        if (rand=1) and (big_mofo!=1){p2="breaks the silence, begining the Chapter Battlecry-";}if (rand=1) and (big_mofo=1){p2="break the silence, begining the Chapter Battlecry-";}
        if (rand=2) and (big_mofo!=1){p2="roars the first half of the Chapter Battlecry-";}if (rand=2) and (big_mofo=1){p2="roar the first half of the Chapter Battlecry-";}
        if (rand=3) and (big_mofo!=1){p2="shouts the start of the Chapter Battlecry-";}if (rand=3) and (big_mofo=1){p2="shout the start of the Chapter Battlecry-";}
        if (rand=4) and (big_mofo!=1){p2="calls out to your marines-";}if (rand=4) and (big_mofo=1){p2="call out to your marines-";}
        if (rand=5) and (big_mofo!=1){p2="roars to your marines-";}if (rand=5) and (big_mofo=1){p2="roar to your marines-";}
        p3="''Into the fires of battle!''";
        if (temp>=100) and (temp<200){p4="Over a hundred Astartes roar in return, their voice one-";}
        if (temp>=200) and (temp<400){p4="Several hundred Astartes roar in return, their voice one-";}
        if (temp>=500) and (temp<800){p4="Your battle brothers echoe the cry, a massive sound felt more than heard-";}
        if (temp>800){p4="The sound is deafening as the "+string(global.chapter_name)+" shout in unison-";}
        p5="''UNTO THE ANVIL OF WAR!''";
        newline=p1+p2;scr_newtext();
        newline=p3;scr_newtext();
        newline=p4;scr_newtext();
        newline=p5;scr_newtext();
    }
	if (obj_ini.battle_cry == "..."){standard_cry=1;
        var rand;rand=choose(1,2,3);
        if (rand=1) and (big_mofo!=1){p2="remains silent as the Chapter forms for battle-";}if (rand=1) and (big_mofo=1){p2="remain silent as the Chapter forms for battle-";}
        if (rand=2) and (big_mofo!=1){p2="remains silent and issues orders to the Chapter for battle-";}if (rand=2) and (big_mofo=1){p2="remain silent and issues orders to the Chapter for battle-";}
        if (rand=3) and (big_mofo!=1){p2="issues orders to the Chapter over Vox-";}if (rand=3) and (big_mofo=1){p2="whisper to your brothers the plans for initial deployment over vox-";}
        p3="''Sharp gestures and handsigns from officers direct the Marines''";
        if (temp>=100) and (temp<200){p4="Over a hundred Astartes nod in acknowledgement and move quickly-";}
        if (temp>=200) and (temp<400){p4="Several hundred Astartes nod in acknowledgement and move swiftly-";}
        if (temp>=500) and (temp<800){p4="Your battle brothers all nod in acknowledgement and move hastily-";}
        if (temp>800){p4="The fluidity is astounding as the "+string(global.chapter_name)+" move seamlessly into position ready for battle-";}
        p5="''They stand ready to engage the enemy''";
        newline=p1+p2;scr_newtext();
        newline=p3;scr_newtext();
        newline=p4;scr_newtext();
        newline=p5;scr_newtext();
	}
    
    // show_message(string(global.chapter_name)+"|"+string(global.custom)+"|"+string(standard_cry));
    
    if (global.chapter_name="Iron Warriors") and (global.custom=0){standard_cry=1;
        var rand;rand=choose(1,2,3,4,5);
        if (rand=1) and (big_mofo!=1){p2="breaks the silence, begining the Chapter Battlecry-";}if (rand=1) and (big_mofo=1){p2="break the silence, begining the Chapter Battlecry-";}
        if (rand=2) and (big_mofo!=1){p2="roars the first half of the Chapter Battlecry-";}if (rand=2) and (big_mofo=1){p2="roar the first half of the Chapter Battlecry-";}
        if (rand=3) and (big_mofo!=1){p2="shouts the start of the Chapter Battlecry-";}if (rand=3) and (big_mofo=1){p2="shout the start of the Chapter Battlecry-";}
        if (rand=4) and (big_mofo!=1){p2="calls out to your marines-";}if (rand=4) and (big_mofo=1){p2="call out to your marines-";}
        if (rand=5) and (big_mofo!=1){p2="roars to your marines-";}if (rand=5) and (big_mofo=1){p2="roar to your marines-";}
        p3="''Iron within!''";
        if (temp>=100) and (temp<200){p4="Over a hundred Astartes roar in return, their voice one-";}
        if (temp>=200) and (temp<400){p4="Several hundred Astartes roar in return, their voice one-";}
        if (temp>=500) and (temp<800){p4="Your battle brothers echoe the cry, a massive sound felt more than heard-";}
        if (temp>800){p4="The sound is deafening as the "+string(global.chapter_name)+" shout in unison-";}
        p5="''IRON WITHOUT!''";
        newline=p1+p2;scr_newtext();
        newline=p3;scr_newtext();
        newline=p4;scr_newtext();
        newline=p5;scr_newtext();
    }
    
    
    if (standard_cry=0){standard_cry=1;
        var rand;rand=choose(1,2,3,4);
        if (rand=1){if (big_mofo!=1) then p2="breaks ";if (big_mofo=1) then p2="break ";p2+="the silence, calling out the Chapter Battlecry-";}
        if (rand=2){if (big_mofo!=1) then p2="roars ";if (big_mofo=1) then p2="roar ";p2+="the Chapter Battlecry-";}
        if (rand=3){if (big_mofo!=1) then p2="shouts ";if (big_mofo=1) then p2="shout ";p2+="the Chapter Battlecry-";}
        if (rand=4){if (big_mofo!=1) then p2="roars ";if (big_mofo=1) then p2="roar ";p2+="to your marines-";}
        p3="''"+string(obj_ini.battle_cry)+"!''";
        if (temp>=100) and (temp<200){p4="Over a hundred Astartes echoe the cry or let out shouts of their own.";}
        if (temp>=200) and (temp<400){p4="Several hundred Astartes roar in return, echoing the cry.";}
        if (temp>=500) and (temp<800){p4="Your battle brothers echoe the cry, a massive sound felt more than heard.";}
        if (temp>800) and (rand>=3){p4="The sound is deafening as the "+string(global.chapter_name)+" add their voices.";}
        if (temp>800) and (rand<=2){p4="The sound is deafening as the "+string(global.chapter_name)+" return the cry and magnify it a thousand times.";}
        newline=p1+p2;scr_newtext();
        newline=p3;scr_newtext();
        newline=p4;scr_newtext();
    }
}

var line_break = "------------------------------------------------------------------------------";
newline = line_break;
scr_newtext();
newline = line_break;
scr_newtext();

/* */
/*  */
