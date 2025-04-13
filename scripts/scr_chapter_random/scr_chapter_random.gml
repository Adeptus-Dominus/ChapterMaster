/// @mixin obj_creation
/// @description  Called when an empty custom chapter icon is picked, or the custom icon in bottom right is picked from the new game menu.
/// if "Create Custom" is picked, argument0 = 0, if "Create Random" is picked, argument0 = 1
/// @param {Real} argument0 0 if Blank Custom, 1 if Random
function scr_chapter_random(argument0) {

	// argument0 = 0 = create custom 
	// argument0 = 1 = create random

	// if argument0=0 then it just gives a name
	var i;i=-1;
	world = array_create(21, "");
	world_type = array_create(21, "");
	world_feature = array_create(21, "");
	company_title = array_create(11, "");
	adv = array_create(9, "");
	dis = array_create(9, "");
	adv_num = array_create(9, 0);
	dis_num = array_create(9, 0);


	var ran1, ran2, phrase1, phrase2, main, secondary, lens, weapon, found_secret;
	phrase1="";phrase2="";

	chapter_name="Unnamed";chapter_string="Unnamed";
	icon=1;icon_name="da";
	founding=1;found_secret=0;
	points=0;maxpoints=100;
	fleet_type=1;strength=5;cooperation=5;purity=5;stability=5;
	homeworld="Temperate";homeworld_name=global.name_generator.generate_star_name();
	recruiting="Death";recruiting_name=global.name_generator.generate_star_name();
	flagship_name=global.name_generator.generate_imperial_ship_name();
	recruiting_exists=1;homeworld_exists=1;
	homeworld_rule=1;aspirant_trial=eTrials.BLOODDUEL;
	discipline="default";battle_cry="For the Emperor";

	main_color=1;secondary_color=1;main_trim=1;
	left_pauldron=1;right_pauldron=1;// Left/Right pauldron
	lens_color=1;weapon_color=1;col_special=choose(0,0,0,0,0,1,2,3);

	color_to_main="";
	color_to_secondary="";
	color_to_trim="";
	color_to_pauldron="";
	color_to_pauldron2="";
	color_to_lens="";
	color_to_weapon="";

	hapothecary=global.name_generator.generate_space_marine_name();
	hchaplain=global.name_generator.generate_space_marine_name();
	clibrarian=global.name_generator.generate_space_marine_name();
	fmaster=global.name_generator.generate_space_marine_name();
	recruiter=global.name_generator.generate_space_marine_name();
	admiral=global.name_generator.generate_space_marine_name();

	equal_specialists=0;load_to_ships=[2,0,0];successors=0;

	mutations=0;mutations_selected=0;
	preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	disposition = array_create(8, 0);
	// disposition[0]=0;
	// disposition[1]=0;// Prog
	// disposition[2]=0;// Imp
	// disposition[3]=0;// Mech
	// disposition[4]=0;// Inq
	// disposition[5]=0;// Ecclesiarchy
	// disposition[6]=0;// Astartes
	// disposition[7]=0;// Reserved
	chapter_master_name=global.name_generator.generate_space_marine_name();
	chapter_master_melee=1;
	chapter_master_ranged=1;
	chapter_master_specialty=choose(1,1,1,1,1,2,2,2,2,2,3);


	custom_roles = {};






	// create random
	if (argument0=1){
	    strength=choose(2,3,4,5,6,7,8);
	    purity=choose(2,3,4,5,6,7,8);if (strength<5) then purity+=2;
	    stability=choose(2,3,4,5,6,7,8);if (purity<5) then stability+=2;
	    cooperation=choose(2,3,4,5,6,7,8);if (stability<5) then cooperation+=2;
	    founding=10;found_secret=floor(random(10))+1;
    
	    custom=1;points=100;maxpoints=100;
	    battle_cry="For the Emperor";
    
	    discipline=choose("default","default","default","default","biomancy","pyromancy","telekinesis");
    
	    scr_icon("random");
	}


	ran1=floor(random(86))+1;
	ran2=floor(random(95))+1;
	ran3=floor(random(9))+1;

	//create random
	if (argument0=1){
	    mutations=0;mutations_selected=0;mutation="";
	    preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	    zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	    var mutat;mutat=0;
    
	    if (found_secret=1){adv[1]="Enemy: Fallen";dis[1]="Never Forgive";}
	    if (found_secret=2) then adv[1]="Lightning Warriors";
	    if (found_secret=3){adv[1]="Assault Doctrine";dis[1]="Suspicious";}
	    if (found_secret=4){adv[1]="Bolter Drilling";betchers=1;membrane=1;mutations_selected+=2;mutations+=2;mutat=2;}
	    if (found_secret=5){adv[1]="Assault Doctrine";dis[1]="Black Rage";disadvantage1=1;}
	    if (found_secret=6){adv[1]="Tech-Brothers";dis[1]="Psyker Intolerant";}
	    // if (found_secret=7) then founding="Ultramarines";
	    if (found_secret=8){adv[1]="Crafters";dis[1]="Tolerant";secretions=1;mutations+=1;mutations_selected+=1;mutat+=1;}
	    if (found_secret=9){adv[1]="Ambushers";}

	/*
	mutations=0;mutations_selected=0;mutation="";
	preomnor=0;voice=0;doomed=0;lyman=0;omophagea=0;ossmodula=0;membrane=0;
	zygote=0;betchers=0;catalepsean=0;secretions=0;occulobe=0;mucranoid=0;
	*/



	    mutations+=round(4-(purity/2.5))
    
	    repeat(50){
	        if (mutat<mutations){
	            if (preomnor=0) and (floor(random(12))+1=2){preomnor=1;mutat+=1;}
	            if (voice=0) and (floor(random(12))+1=2){voice=1;mutat+=1;}
	            if (doomed=0) and (floor(random(30))+1=2){doomed=1;mutat+=4;}
	            if (lyman=0) and (floor(random(12))+1=2){lyman=1;mutat+=1;}
	            if (omophagea=0) and (floor(random(12))+1=2){omophagea=1;mutat+=1;}
	            if (ossmodula=0) and (floor(random(12))+1=2){ossmodula=1;mutat+=1;}
	            if (membrane=0) and (floor(random(12))+1=2){membrane=1;mutat+=1;}
	            if (zygote=0) and (floor(random(12))+1=2){zygote=1;mutat+=2;}
	            if (betchers=0) and (floor(random(12))+1=2){betchers=1;mutat+=1;}
	            if (catalepsean=0) and (floor(random(12))+1=2){catalepsean=1;mutat+=1;}
	            if (secretions=0) and (floor(random(12))+1=2){secretions=1;mutat+=1;}
	            if (occulobe=0) and (floor(random(12))+1=2){occulobe=1;mutat+=1;}
	            if (mucranoid=0) and (floor(random(12))+1=2){mucranoid=1;mutat+=1;}
	        }
	    }
    
	    mutations_selected=mutat;
    
	    homeworld="Temperate";recruiting="Death";

	}

	var col_main,col_second,col_lens,col_trim,col_weapon;
	col_main="";col_second="";col_lens="";col_trim="";col_weapon="";



	if (ran1=1){phrase1="Android";col_main="Silver";}
	if (ran1=2){phrase1="Alpha";col_main="Black";}
	if (ran1=3){phrase1="Amethyst";col_main="Purple";}
	if (ran1=4){phrase1="Arctic";col_main="White";homeworld="Ice";}
	if (ran1=5){phrase1="Astral";col_main="White";}
	if (ran1=6){phrase1="Atomic";col_main="Blue";}
	if (ran1=7){phrase1="Azure";col_main="Blue";}
	if (ran1=8){phrase1="Battle";col_main="Yellow";}
	if (ran1=9){phrase1="Black";col_main="Black";}
	if (ran1=10){phrase1="Blood";col_main="Red";}
	if (ran1=11){phrase1="Blue";col_main="Blue";}
	if (ran1=12){phrase1="Brawling";col_main="Orange";}
	if (ran1=13){phrase1="Brazen";col_main="Yellow";}
	if (ran1=14){phrase1="Crimson";col_main="Dark Red";}
	if (ran1=15){phrase1="Cryptic";col_main="Black";}
	if (ran1=16){phrase1="Dancing";col_main="Pink";}
	if (ran1=17){phrase1="Dark";col_main="Dark Green";}
	if (ran1=18){phrase1="Death";col_main="Black";homeworld="Lava";}
	if (ran1=19){phrase1="Delta";col_main="Green";}
	if (ran1=20){phrase1="Desert";col_main="Dark Gold";homeworld="Desert";}
	if (ran1=21){phrase1="Desolation";col_main="Black";}
	if (ran1=22){phrase1="Diamond";col_main="White";}
	if (ran1=23){phrase1="Doom";col_main="Red";}
	if (ran1=24){phrase1="Emerald";col_main="Green";}
	if (ran1=25){phrase1="Fighting";col_main="Yellow";}
	if (ran1=26){phrase1="Fire";col_main="Orange";}
	if (ran1=27){phrase1="Flying";col_main="White";fleet_type=1;}
	if (ran1=28){phrase1="Frenzied";col_main="Red";}
	if (ran1=29){phrase1="Furious";col_main="Dark Red";}
	if (ran1=30){phrase1="Golden";col_main="Dark Gold";}
	if (ran1=31){phrase1="Gore";col_main="Red";}
	if (ran1=32){phrase1="Grail";col_main="Yellow";}
	if (ran1=33){phrase1="Green";col_main="Green";}
	if (ran1=34){phrase1="Grey";col_main="Silver";}
	if (ran1=35){phrase1="Horned";col_main="Dark Green";}
	if (ran1=36){phrase1="Howling";col_main="Light Blue";}
	if (ran1=37){phrase1="Ice";col_main="Light Blue";homeworld="Ice";}
	if (ran1=38){phrase1="Imperial";col_main="Yellow";}
	if (ran1=39){phrase1="Iron";col_main="Silver";}
	if (ran1=40){phrase1="Light";col_main="White";}
	if (ran1=41){phrase1="Maleficent";col_main="Purple";}
	if (ran1=42){phrase1="Malevolent";col_main="Black";}
	if (ran1=43){phrase1="Nova";col_main="White";}
	if (ran1=44){phrase1="Omega";col_main="Dark Gold";}
	if (ran1=45){phrase1="Orange";col_main="Orange";}
	if (ran1=46){phrase1="Ozone";col_main="Light Blue";}
	if (ran1=47){phrase1="Penitent";col_main="Black";fleet_type=3;}
	if (ran1=48){phrase1="Polar";col_main="White";homeworld="Ice";}
	if (ran1=49){phrase1="Psi";col_main="Blue";}
	if (ran1=50){phrase1="Purple";col_main="Purple";}
	if (ran1=51){phrase1="Raging";col_main="Red";}
	if (ran1=52){phrase1="Regal";col_main="Purple";}
	if (ran1=53){phrase1="Royal";col_main="Purple";}
	if (ran1=54){phrase1="Rainbow";col_main="Pink";}
	if (ran1=55){phrase1="Red";col_main="Red";}
	if (ran1=56){phrase1="Repentant";col_main="Black";}
	if (ran1=57){phrase1="Ruby";col_main="Red";}
	if (ran1=58){phrase1="Sanguine";col_main="Sanguine Red";}
	if (ran1=59){phrase1="Sapphire";col_main="Blue";}
	if (ran1=60){phrase1="Savage";col_main="Dark Red";}
	if (ran1=61){phrase1="Screaming";col_main="White";}
	if (ran1=62){phrase1="Screeching";col_main="Blue";}
	if (ran1=63){phrase1="Shrieking";col_main="Black";}
	if (ran1=64){phrase1="Shadow";col_main="Black";}
	if (ran1=65){phrase1="Siege";col_main="Silver";homeworld="Hive";}
	if (ran1=66){phrase1="Silver";col_main="Silver";}
	if (ran1=67){phrase1="Skulking";col_main="Black";fleet_type=3;}
	if (ran1=68){phrase1="Snapping";col_main="Orange";}
	if (ran1=69){phrase1="Snarling";col_main="Dark Red";}
	if (ran1=70){phrase1="Space";col_main="Light Blue";}
	if (ran1=71){phrase1="Star";col_main="Black";}
	if (ran1=72){phrase1="Stealth";col_main="Black";}
	if (ran1=73){phrase1="Storm";col_main="Yellow";}
	if (ran1=74){phrase1="Striking";col_main="Green";}
	if (ran1=75){phrase1="Thunder";col_main="Yellow";}
	if (ran1=76){phrase1="Topaz";col_main="Yellow";}
	if (ran1=77){phrase1="Tundra";col_main="Green";homeworld="Ice";}
	if (ran1=78){phrase1="Vermilion";col_main="Orange";}
	if (ran1=79){phrase1="Vigilant";col_main="White";}
	if (ran1=80){phrase1="Ultra";col_main="Blue";fleet_type=2;}
	if (ran1=81){phrase1="Umbrageous";col_main="White";}
	if (ran1=82){phrase1="War";col_main="Red";}
	if (ran1=83){phrase1="White";col_main="White";}
	if (ran1=84){phrase1="Wicked";col_main="Dark Green";}
	if (ran1=85){phrase1="Wild";col_main="Light Blue";}
	if (ran1=86){phrase1="Zeta";col_main="White";}

	col_second="";col_lens="Red";col_trim=col_main;col_weapon="Black";
	if (ran2=1){phrase2="Acolytes";col_second="Red";}
	if (ran2=2){phrase2="Adders";col_second="Black";}
	if (ran2=3){phrase2="Amazons";col_second="Orange";}
	if (ran2=4){phrase2="Angels";col_second="Silver";}
	if (ran2=5){phrase2="Archangels";col_second="Silver";}
	if (ran2=6){phrase2="Avengers";col_second="Black";}
	if (ran2=7){phrase2="Barracudas";}
	if (ran2=8){phrase2="Bees";col_second="Black";}
	if (ran2=9){phrase2="Bringers";}
	if (ran2=10){phrase2="Brothers";}
	if (ran2=11){phrase2="Cats";}
	if (ran2=12){phrase2="Champions";}
	if (ran2=13){phrase2="Chameleons";}
	if (ran2=14){phrase2="Claws";col_second="White";}
	if (ran2=15){phrase2="Cobras";}
	if (ran2=16){phrase2="Company";}
	if (ran2=17){phrase2="Consuls";}
	if (ran2=18){phrase2="Corsairs";col_second="Dark Red";}
	if (ran2=19){phrase2="Crusaders";}
	if (ran2=20){phrase2="Destroyers";}
	if (ran2=21){phrase2="Devils";col_second="Red";}
	if (ran2=22){phrase2="Dogs";}
	if (ran2=23){phrase2="Dragons";col_second="Red";}
	if (ran2=24){phrase2="Eagles";col_second="White";}
	if (ran2=25){phrase2="Eaters";col_second="Red";}
	if (ran2=26){phrase2="Enforcers";}
	if (ran2=27){phrase2="Falcons";}
	if (ran2=28){phrase2="Fists";}
	if (ran2=29){phrase2="Foxes";}
	if (ran2=30){phrase2="Gators";col_second="Green";}
	if (ran2=31){phrase2="Giants";}
	if (ran2=32){phrase2="Golems";col_second="Silver";}
	if (ran2=33){phrase2="Gorillas";col_second="Black";}
	if (ran2=34){phrase2="Griffons";}
	if (ran2=35){phrase2="Guard";}
	if (ran2=36){phrase2="Guardians";}
	if (ran2=37){phrase2="Hands";}
	if (ran2=38){phrase2="Hawks";col_second="Blue";}
	if (ran2=39){phrase2="Hippos";}
	if (ran2=40){phrase2="Hornets";col_second="Yellow";}
	if (ran2=41){phrase2="Hounds";}
	if (ran2=42){phrase2="Hunters";}
	if (ran2=43){phrase2="Inculpators";}
	if (ran2=44){phrase2="Jaguars";col_second="Dark Green";}
	if (ran2=45){phrase2="Justiciars";col_second="Black";}
	if (ran2=46){phrase2="Knights";col_second="Silver";}
	if (ran2=47){phrase2="Krakens";col_second="Green";fleet_type=1;}
	if (ran2=48){phrase2="Lamenters";seconary_color="Yellow";fleet_type=3;}
	if (ran2=49){phrase2="Lions";col_second="Orange";}
	if (ran2=50){phrase2="Liberators";}
	if (ran2=51){phrase2="Lords";}
	if (ran2=52){phrase2="Marauders";col_second="Black";}
	if (ran2=53){phrase2="Marines";}
	if (ran2=54){phrase2="Medusas";}
	if (ran2=55){phrase2="Mentors";col_second="Black";}
	if (ran2=56){phrase2="Monitors";}
	if (ran2=57){phrase2="Owls";}
	if (ran2=58){phrase2="Paladins";col_second="Silver";}
	if (ran2=59){phrase2="Panthers";col_second="Black";}
	if (ran2=60){phrase2="Patriarchs";}
	if (ran2=61){phrase2="Phantoms";col_second="Black";}
	if (ran2=62){phrase2="Purgators";}
	if (ran2=63){phrase2="Raiders";}
	if (ran2=64){phrase2="Rampagers";col_second="Black";}
	if (ran2=65){phrase2="Raptors";}
	if (ran2=66){phrase2="Ravens";}
	if (ran2=67){phrase2="Redeemers";}
	if (ran2=68){phrase2="Revilers";}
	if (ran2=69){phrase2="Saints";col_second="White";}
	if (ran2=70){phrase2="Salamanders";col_second="Green";}
	if (ran2=71){phrase2="Scars";col_second="White";}
	if (ran2=72){phrase2="Scions";col_second="Purple";}
	if (ran2=73){phrase2="Scorpians";col_second="Orange";}
	if (ran2=74){phrase2="Scythes";}
	if (ran2=75){phrase2="Shades";}
	if (ran2=76){phrase2="Sharks";col_second="Light Blue";}
	if (ran2=77){phrase2="Sisters";}
	if (ran2=78){phrase2="Skulls";col_second="White";}
	if (ran2=79){phrase2="Sons";}
	if (ran2=80){phrase2="Spectres";}
	if (ran2=81){phrase2="Slayers";}
	if (ran2=82){phrase2="Stalkers";}
	if (ran2=83){phrase2="Swords";col_second="Silver";}
	if (ran2=84){phrase2="Talons";}
	if (ran2=85){phrase2="Templars";col_second="White";}
	if (ran2=86){phrase2="Tigers";col_second="Black";}
	if (ran2=87){phrase2="Turtles";col_second="Dark Green";}
	if (ran2=88){phrase2="Vindicators";}
	if (ran2=89){phrase2="Vipers";}
	if (ran2=90){phrase2="Vultures";col_second="Black";}
	if (ran2=91){phrase2="Warriors";}
	if (ran2=92){phrase2="Wasps";col_second="Yellow";}
	if (ran2=93){phrase2="Wizards";col_second="Purple";name[100,17]="Wizard";master_specialty=3;}
	if (ran2=94){phrase2="Wolves";col_second="White";}
	if (ran2=95){phrase2="Wyerns";}

	color_to_main=col_main;
	color_to_secondary=col_second;
	color_to_trim=col_trim;
	color_to_pauldron=col_second;
	color_to_pauldron2=col_second;
	color_to_lens=col_lens;
	color_to_weapon=col_weapon;
	trim=choose(0,1);

    if (color_to_main!=""){
        main_color = max(array_find_value(col,color_to_main),0);
        color_to_main = "";
    }
    if (color_to_secondary!=""){
        secondary_color = max(array_find_value(col,color_to_secondary),0);
        color_to_secondary = "";
    }
    if (color_to_trim!=""){
        main_trim = max(array_find_value(col,color_to_trim),0);
        color_to_trim = "";
    }
    if (color_to_pauldron!=""){
        right_pauldron = max(array_find_value(col,color_to_pauldron),0);
        color_to_pauldron = "";  
    }
    if (color_to_pauldron2!=""){
        left_pauldron = max(array_find_value(col,color_to_pauldron2),0);
        color_to_pauldron2 = "";
    }
    if (color_to_lens!=""){
        lens_color = max(array_find_value(col,color_to_lens),0);
        color_to_lens = ""; 
    }
    if (color_to_weapon!=""){
        weapon_color = max(array_find_value(col,color_to_weapon),0);
        color_to_weapon = "";
    }

    //TODO add some funcky stuff for custom random complex livery
    var struct_cols = {
        main_color :main_color,
        secondary_color:secondary_color,
        main_trim:main_trim,
        right_pauldron:right_pauldron,
        left_pauldron:left_pauldron,
        lens_color:lens_color,
        weapon_color:weapon_color
    }
    obj_creation.livery_picker = new ColourItem(100,230);
    obj_creation.livery_picker.scr_unit_draw_data();
    obj_creation.livery_picker.set_default_armour(struct_cols,col_special);
    obj_creation.full_liveries = array_create(21,DeepCloneStruct(obj_creation.livery_picker.map_colour)); 			    
    obj_creation.full_liveries[eROLE.Librarian] = obj_creation.livery_picker.set_default_librarian(struct_cols);

    obj_creation.full_liveries[eROLE.Chaplain] = obj_creation.livery_picker.set_default_chaplain(struct_cols);

    obj_creation.full_liveries[eROLE.Apothecary] = obj_creation.livery_picker.set_default_apothecary(struct_cols);

    obj_creation.full_liveries[eROLE.Techmarine] = obj_creation.livery_picker.set_default_techmarines(struct_cols);
    obj_creation.livery_picker.scr_unit_draw_data();
    obj_creation.livery_picker.set_default_armour(struct_cols,col_special); 			

	obj_creation.livery_picker.map_colour = full_liveries[0];
	obj_creation.livery_picker.role_set = 0; 
	chapter_name=string(phrase1)+" "+string(phrase2);chapter_string=chapter_name;

	monastery_name = "";
	if (argument0=1){
	    homeworld_rule=choose(1,1,1,2,2,3,3);
	    chapter_name=string(phrase1)+" "+string(phrase2);
	    chapter_string=chapter_name;
	    fleet_type=choose(1,2,3);
    
	    // if (fleet_type=2) then monastery_name=string(phrase1)+" Hold";
	    if (fleet_type!=2){
	        var rando;rando=choose(1,2,3,4,5);
	        if (rando=1) then monastery_name=string(phrase2)+"' Ship";
	        if (rando=2) then monastery_name="Crown "+string_delete(phrase2,string_length(phrase2),1);
	        if (rando=3) then monastery_name="Head "+string_delete(phrase2,string_length(phrase2),1);
	        if (rando=4) then monastery_name=string(phrase2)+"' Fist";
	        if (rando=5) then monastery_name=string(phrase2)+"' Gaze";
	    }
	}



	if (argument0=1) then other1=founding;
	if (argument0=0) then fleet_type=choose(1,2);

	
	cooldown=8000;


}
