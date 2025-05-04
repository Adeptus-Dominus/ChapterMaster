global.ship_weapons_stats = {
	"Lance Battery" : {
		range : 300,
		dam : 14, 
		facing : "front",
		firing_arc : 12.5,
		img : spr_ground_las,
	},
	"Plasma Cannon" : {
		img : spr_ground_plasma,
		draw_scale : 3,
		bullet_speed : 15,
	},
	"Nova Cannon": {
		range : 1500,
		dam : 34, 
		facing : "front",
		minrange : 300,
		cooldown : 120,	
		minrange : 300,
		draw_scale: 2,
	},
	"Weapons Battery" : {
		facing : "most",
		cooldown : 20,
		dam : 20,
		firing_arc : 5,
	},
	"Light Weapons Battery" : {
		facing : "most",
		range : 300,
		cooldown : 30,
		dam : 8,
		firing_arc : 8,
	},
	"Gunz Battery" : {
		facing : "front",
		range : 300,
		cooldown : 30,
		dam : 8,
		firing_arc : 15,
	},
	"Heavy Gunz" : {
		weapon_facing : "most",
		dam : 12,
		range : 200,
		cooldown : 40,
	},
	"Bombardment Cannon":{
		facing : "front",
		dam : 12,
		range : 2000,
		cooldown : 120,
		firing_arc : 4,
	},

	"Macro Bombardment Cannons" : {
		facing : "front",
		dam : 50,
		range : 600,
		cooldown : 2000,
		firing_arc : 3,		
	},

	"Torpedoes" :{
		dam : 12,
		range : 2000, 
		cooldown : 90,
		bullet_speed : 10,
		barrel_count : 1,
		img:spr_torpedo,
	},

	"Interceptor Launch Bays" : {
		facing : "special",
		weapon_range : 9999,
		ammo : 6,
		cooldown : 120,
	},
	"Thunderhawk Launch Bays" : {
		facing : "special",
		weapon_range : 9999,
		ammo : 6,
		cooldown : 120,		
	},
	"Fighta Bommerz":{
		facing : "special",
		weapon_range : 9999,
		ammo : 8,
		cooldown : 90,		
	},
	"Eldar Launch Bay" : {
		facing : "special",
		weapon_range : 9999,
		ammo : 4,
		cooldown: 90,
	},
	"Manta Launch Bay" : {
		facing : "special",
		weapon_range : 9999,
		ammo : 4,
		cooldown: 90,		
	},
	"Pulsar Lances":{
		facing : "most",
		dam : 10,
		weapon_cooldown : 10,
		img: spr_ground_las,
	},
	"Pyro-acid Battery" : {
		facing : "most",
		dam : 8,
		range : 300,
		img : spr_glob,
		draw_scale : 2,
	},
	"Feeder Tendrils" : {
		facing : "most",
		dam : 8,
		range : 100,
		firing_arc : 50,
		melee : true,
	},
	"Bio-Plasma Discharge":{
		range : 200,
		cooldown : 60,
		dam : 6,
	},
	"Massive Claws" : {
		facing :"most",
		dam : 20,
		range : 64,
		cooldown : 60,
		melee : true,
	},
	"Launch Glands" : {
		facing : "special",
		weapon_range : 9999,
		ammo : 20,
		cooldown: 120,	
		obj_en_in,	
	},
	"Gravitic launcher" : {
		dam : 12,
		range : 400,
		minrange : 200,
		cooldown:30,
		draw_scale:2,
	},
	"Railgun Battery": {
		facing : "most",
		dam :12,
		range : 450,
		cooldown:30,
		img : spr_railgun,
	},
	"Ion Cannons": {
		facing : "most",
		dam :8,
		range : 300,
		cooldown:15,
		img : spr_pulse,
	},
	"Lightning Arc" : {
		facing : "most",
		dam : 20,
		range : 300,
		cooldown : 15,
		damage_type:"shields"
	},
	"Star Pulse Generator": {
		dam : 0,
		range : 220,
		cooldown : 210,
		img : spr_pulse,
		speed : 20,
	},
	"Gauss Particle Whip":{
		dam : 30,
		range: 450,
		cooldown : 90,
		melee : true,
	}
}



function facing_weapon_angle(facing){
	var _direct_ = direction;
	switch (facing){
		case "right":
			_direct_+=90;
			break;
		case "left":
			_direct_-=90;
			break;
		case "rear":
			_direct_ -= 180;
			break;
		default:
			break;
	}

	return _direct_;
}


function assign_ship_stats(){
	if (class="Apocalypse Class Battleship"){
	    sprite_index=spr_ship_apoc;
	    ship_size=3;
	    name="";
	    hp=1200;
	    maxhp=1200;
	    conditions="";
	    shields=400;
	    maxshields=400;
	    leadership=90;
	    armour_front=6;
	    armour_other=5;
	    turrets=4;
	    capacity=150;
	    carrying=0;

	    add_weapon_to_ship("Lance Battery", {facing:"left"});
	    add_weapon_to_ship("Lance Battery", {facing:"right"});
	    add_weapon_to_ship("Nova Cannon");
	    add_weapon_to_ship("Weapons Battery");
	    
	}

	if (class="Nemesis Class Fleet Carrier"){
		sprite_index=spr_ship_nem;
	    ship_size=3;
	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=400;
	    maxshields=400;
	    leadership=85;
	    armour_front=5;
	    armour_other=5;
	    turrets=5;
	    capacity=100;
	    carrying=24;
	    add_weapon_to_ship("Interceptor Launch Bays");
	    add_weapon_to_ship("Interceptor Launch Bays");
	    add_weapon_to_ship("Lance Battery");
	    
	}

	if (class="Avenger Class Grand Cruiser"){
	    sprite_index=spr_ship_aven;
	    ship_size=2;
	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=300;
	    maxshields=300;
	    leadership=85;
	    armour_front=5;
	    armour_other=5;
	    turrets=3;
	    capacity=50;
	    add_weapon_to_ship("Lance Battery", {cooldown:30});
	    add_weapon_to_ship("Lance Battery", {cooldown:25, direction:"left"});
	    add_weapon_to_ship("Lance Battery", {cooldown:25, direction:"right"});
	    
	}

	if (class="Sword Class Frigate"){
	    sprite_index=spr_ship_sword;
	    ship_size=1;
	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=80;
	    armour_front=5;
	    armour_other=5;
	    turrets=2;
	    capacity=50;
	    carrying=0;
	    add_weapon_to_ship("Weapons Battery", {weapon_range:300});
	    
	}



	// Eldar

	if (class="Void Stalker"){
	    sprite_index=spr_ship_void;
	    ship_size=3;
	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=300;
	    maxshields=300;
	    leadership=100;
	    armour_front=5;
	    armour_other=4;
	    turrets=4;
	    capacity=150;

	    add_weapon_to_ship("Weapons Battery");
	    add_weapon_to_ship("Eldar Launch Bay");
	    add_weapon_to_ship("Pulsar Lances");
	    
	}

	if (class="Shadow Class"){sprite_index=spr_ship_shadow;
	    sprite_index=spr_ship_shadow;
	    ship_size=3;
	    name="";
	    hp=600;
	    maxhp=600;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=90;
	    armour_front=5;
	    armour_other=4;
	    turrets=3;
	    capacity=100;
	    carrying=0;
	    add_weapon_to_ship("Torpedoes");
	    add_weapon_to_ship("Light Weapons Battery", {range : 450});
	    
	}

	if (class="Hellebore"){sprite_index=spr_ship_hellebore;
	    sprite_index=spr_ship_hellebore;
	    ship_size=1;
	    name="";
	    hp=200;
	    maxhp=200;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=90;
	    armour_front=5;
	    armour_other=4;
	    turrets=2;
	    capacity=50;
	    carrying=0;

	    add_weapon_to_ship("Light Weapons Battery", {range : 450, cooldown :20, facing : "front"});

	    add_weapon_to_ship("Light Weapons Battery", {range : 450});
	    add_weapon_to_ship("Eldar Launch Bay", {ammo : 1});
	    
	}

	if (class="Aconite"){sprite_index=spr_ship_aconite;
	    sprite_index=spr_ship_aconite;
	    ship_size=1;
	    name="";
	    hp=200;
	    maxhp=200;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=90;
	    armour_front=5;
	    armour_other=4;
	    turrets=2;
	    capacity=50;
	    carrying=0;
	    add_weapon_to_ship("Light Weapons Battery", {range : 450});
	    
	}




	// Orks

	if (class="Dethdeala"){
	    sprite_index=spr_ship_deth;
	    ship_size=3;
	    name="";
	    hp=1200;
	    maxhp=1200;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    armour_front=6;
	    armour_other=5;
	    turrets=3;
	    capacity=250;
	    carrying=0;

	    add_weapon_to_ship("Gunz Battery", {facing:"left"});
	    add_weapon_to_ship("Gunz Battery", {facing:"right"});
	    add_weapon_to_ship("Bombardment Cannon");
	    add_weapon_to_ship("Heavy Gunz");
	    add_weapon_to_ship("Fighta Bommerz"); 
	        
	}

	if (class="Gorbag's Revenge"){
	    sprite_index=spr_ship_gorbag;
	    ship_size=3;
	    name="";
	    hp=1200;
	    maxhp=1200;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    armour_front=6;
	    armour_other=5;
	    turrets=3;
	    capacity=250;
	    carrying=0;
	    add_weapon_to_ship("Gunz Battery");
	    add_weapon_to_ship("Torpedoes", {dam:12, range:300, cooldown:120});
	    
	    add_weapon_to_ship("Fighta Bommerz", {ammo : 3});
	    add_weapon_to_ship("Fighta Bommerz", {ammo : 3});
	    
	}

	if (class=="Kroolboy") or (class=="Slamblasta"){
	    ship_size=3;
	    sprite_index=spr_ship_krool;
	    if (class=="Kroolboy") then sprite_index=spr_ship_krool;
	    if (class=="Slamblasta") then sprite_index=spr_ship_slam;
	    name="";
	    hp=1200;
	    maxhp=1200;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    armour_front=6;
	    armour_other=5;
	    turrets=3;
	    capacity=250;
	    carrying=0;

	    add_weapon_to_ship("Fighta Bommerz", {ammo : 3, cooldown : 120}); 
	    add_weapon_to_ship("Gunz Battery");
	    add_weapon_to_ship("Heavy Gunz"); 

	}else if (class=="Battlekroozer"){
	    sprite_index=spr_ship_kroozer;
	    ship_size=3;
	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    armour_front=6;
	    armour_other=5;
	    turrets=3;
	    capacity=250;
	    carrying=0;
	    add_weapon_to_ship("Gunz Battery" , {range : 450});
	    add_weapon_to_ship("Heavy Gunz" , {facing : "left"});
	    add_weapon_to_ship("Heavy Gunz" , {facing : "right"});
	    add_weapon_to_ship("Fighta Bommerz"); 
	    add_weapon_to_ship("Fighta Bommerz"); 
	}else 
	if (class=="Ravager"){
	    sprite_index=spr_ship_ravager;
	    ship_size=1;
	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=80;
	    armour_front=6;
	    armour_other=4;
	    turrets=2;
	    capacity=50;
	    carrying=0;
	    add_weapon_to_ship("Gunz Battery");
	    add_weapon_to_ship("Torpedoes", {range : 300, cooldown:120,barrel_count:2});
	}
	// ** Tau **
	if (class=="Custodian"){
	    sprite_index=spr_ship_custodian;
	    ship_size=3;
	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    armour_front=6;
	    armour_other=5;
	    turrets=5;
	    capacity=1000;
	    carrying=0;
	    add_weapon_to_ship("Gravitic launcher");
	    add_weapon_to_ship("Railgun Battery");
	    add_weapon_to_ship("Ion Cannons");
	    add_weapon_to_ship("Manta Launch Bay");

	}else 
	if (class=="Protector"){
	    sprite_index=spr_ship_protector;
	    ship_size=2;
	    name="";
	    hp=600;
	    maxhp=600;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=90;
	    armour_front=6;
	    armour_other=5;
	    turrets=3;
	    capacity=250;
	    carrying=0;
	    add_weapon_to_ship("Gravitic launcher");
	    add_weapon_to_ship("Railgun Battery");
	    add_weapon_to_ship("Ion Cannons");
	    add_weapon_to_ship("Manta Launch Bay", {ammo:2});
	}else 
	if (class=="Emissary"){
	    sprite_index=spr_ship_emissary;
	    ship_size=2;
	    name="";
	    hp=400;
	    maxhp=400;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=100;
	    armour_front=6;
	    armour_other=5;
	    turrets=2;
	    capacity=100;
	    carrying=0;
	    add_weapon_to_ship("Gravitic launcher");
	    add_weapon_to_ship("Railgun Battery");
	    add_weapon_to_ship("Ion Cannons");
	    add_weapon_to_ship("Manta Launch Bay", {ammo:1});
	}else 
	if (class=="Warden"){
	    sprite_index=spr_ship_warden;
	    ship_size=1;
	    name="";hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=80;
	    armour_front=5;
	    armour_other=4;
	    turrets=1;
	    capacity=50;
	    carrying=0;
	    add_weapon_to_ship("Ion Cannons", {cooldown:50});
	    add_weapon_to_ship("Railgun Battery", {cooldown:60, range:300});

	}else 
	if (class=="Castellan"){
	    sprite_index=spr_ship_castellan;
	    ship_size=1;
	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=80;
	    armour_front=5;
	    armour_other=4;
	    turrets=2;
	    capacity=50;
	    carrying=0;
	    add_weapon_to_ship("Gravitic launcher");
	    add_weapon_to_ship("Railgun Battery", {cooldown:40, range:300});
	}
	// ** Chaos **
	if (class=="Desecrator"){
	    sprite_index=spr_ship_dese;
	    ship_size=3;
	    name="";
	    hp=1200;
	    maxhp=1200;
	    conditions="";
	    shields=400;
	    maxshields=400;
	    leadership=90;
	    armour_front=7;
	    armour_other=5;
	    weapons=5;
	    turrets=4;
	    capacity=150;
	    carrying=0;
	    add_weapon_to_ship("Lance Battery", {facing:"left"});
	    add_weapon_to_ship("Lance Battery", {facing:"right"});
	    add_weapon_to_ship("Weapons Battery");
	    add_weapon_to_ship("Torpedoes", {cooldown:120});
	    add_weapon_to_ship("Fighta Bommerz");    
	}

	if (class="Avenger"){
	    sprite_index=spr_ship_veng;
	    ship_size=2;
	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=300;
	    maxshields=300;
	    leadership=85;
	    armour_front=5;
	    armour_other=5;
	    turrets=3;
	    capacity=50;
	    carrying=0;
	    add_weapon_to_ship("Lance Battery", {facing : "left"});
	    add_weapon_to_ship("Lance Battery", {facing : "right"});
	    
	}

	if (class="Carnage") or (class="Daemon"){
		sprite_index=spr_ship_carnage;
	    ship_size=2;
	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=300;
	    maxshields=300;
	    leadership=85;
	    armour_front=5;
	    armour_other=5;
	    turrets=3;
	    capacity=50;
	    carrying=0;

	    add_weapon_to_ship("Lance Battery");
	    add_weapon_to_ship("Light Weapons Battery", {dam : 12,facing : "left", cooldown : 45});
	    add_weapon_to_ship("Light Weapons Battery", {dam : 12,facing : "right", cooldown : 45});
	    if (class=="Daemon"){
	        sprite_index=spr_ship_daemon;
	        image_alpha=0.5;
	    }
	}
	

	if (class="Iconoclast"){
		sprite_index=spr_ship_icono;
	    sprite_index=spr_ship_icono;
	    ship_size=1;
	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=80;
	    armour_front=7;
	    armour_other=4;
	    turrets=2;
	    capacity=50;
	    carrying=0;
	    add_weapon_to_ship("Light Weapons Battery");
	    
	}

	// Tyranids
	if (owner = eFACTION.Tyranids){
	    set_nid_ships();
	}

	// Necrons
	if (class="Cairn Class"){
		sprite_index=spr_ship_cairn;
	    ship_size=3;

	    name="";
	    hp=1100;
	    maxhp=1100;
	    conditions="";
	    shields=550;
	    maxshields=550;
	    leadership=100;
	    
	    armour_front=5;
	    armour_other=5;
	    turrets=5;
	    capacity=800;
	    carrying=0;
	    
	    add_weapon_to_ship("Lightning Arc");
	    add_weapon_to_ship("Star Pulse Generator");
	    add_weapon_to_ship("Gauss Particle Whip");
	    
	    weapon[3]="Gauss Particle Whip";
	    weapon_facing[3]="front";
	    weapon_dam[3]=30;
	    weapon_range[3]=450;
	    weapon_cooldown[3]=90;
	     
	}

	if (class="Reaper Class"){sprite_index=spr_ship_reaper;
	    ship_size=3;

	    name="";
	    hp=900;
	    maxhp=900;
	    conditions="";
	    shields=450;
	    maxshields=450;
	    leadership=100;
	    
	    armour_front=5;
	    armour_other=5;
	    turrets=4;
	    capacity=500;
	    carrying=0;
	    
	    add_weapon_to_ship("Lightning Arc");
	    add_weapon_to_ship("Star Pulse Generator");
	    add_weapon_to_ship("Gauss Particle Whip");
	     
	}

	if (class="Shroud Class"){ship_size=2;
	    sprite_index=spr_ship_shroud;

	    name="";
	    hp=400;
	    maxhp=400;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    
	    armour_front=5;
	    armour_other=5;
	    turrets=2;
	    capacity=250;
	    carrying=0;
	    
	    add_weapon_to_ship("Lightning Arc", {dam : 10});
	    
	}

	if (class="Jackal Class"){
		ship_size=2;
	    sprite_index=spr_ship_jackal;

	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=100;
	    
	    armour_front=4;
	    armour_other=4;
	    turrets=2;
	    capacity=25;
	    carrying=0;
	    
	    add_weapon_to_ship("Lightning Arc", {dam : 10,range :250});
	    
	}

	if (class="Dirge Class"){
		ship_size=2;
	    sprite_index=spr_ship_dirge;

	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=100;
	    
	    armour_front=4;
	    armour_other=4;
	    turrets=2;
	    capacity=25;
	    carrying=0;
	    
	    add_weapon_to_ship("Lightning Arc",  {dam : 10,range :250});
	}







	if (owner == eFACTION.Tyranids){
	    for(var i=1; i<=2; i++){
	        if (obj_fleet.en_mutation[i]=="Spore Clouds") then shields=shields+100;
	        if (obj_fleet.en_mutation[i]=="Health"){
	            hp=floor(hp*1.1);
	            maxhp=hp;
	        }
	        if (obj_fleet.en_mutation[i]=="Armour") then armour_front+=1;
	        if (obj_fleet.en_mutation[i]=="Speed") then speed_bonus=speed_bonus*1.1;
	        if (obj_fleet.en_mutation[i]=="Turn") then turn_bonus=1.2;
	        if (obj_fleet.en_mutation[i]=="Turret") then turrets+=1;
	    }
	}

	if (owner != eFACTION.Eldar){
	    hp/=2;
	    maxhp=hp;
	    shields=shields/2;
	    maxshields=shields;
	}
	// if (obj_fleet.enemy=2){hp=hp*0.75;maxhp=hp;shields=shields*0.75;maxshields=shields;}
	// hp=1;shields=1;
	// if (obj_fleet.enemy="orks") then name=global.name_generator.generate_ork_ship_name();
	// show_message(string(class));


	bridge=maxhp;

	/* 
	if (obj_fleet.enemy == 2) {
		hp = hp * 0.75;
		maxhp = hp;
		shields = shields * 0.75;
		maxshields = shields;
	}
	 */
	// hp=1;
	shields=1;



	// if (obj_fleet.enemy="orks") then name=global.name_generator.generate_ork_ship_name();

	name="sdagdsagdasg";



	// show_message(string(class));	
}
