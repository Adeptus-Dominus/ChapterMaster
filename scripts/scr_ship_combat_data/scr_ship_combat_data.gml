global.ship_weapons_stats = {
	"Lance Battery" : {
		range : 1200,
		dam : 18,
		cooldown : 60,
		facing : "front",
		firing_arc : 20,
		bullet_speed : 40,
		accuracy : 85,
		img : spr_ground_las,
		explosion_sprite : spr_explosion3,
	},
	"Plasma Cannon" : {
		img : spr_ground_plasma,
		draw_scale : 3,
		bullet_speed : 15,
		dam : 30,
		firing_arc : 3,
		bombard_value :4,
		explosion_sprite : spr_explosion_plas,
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
	"Macro Cannon" : {
		facing : "front",
		dam  : 4.5,
		firing_arc : 5,
		accuracy : 70,
		explosion_sprite : spr_explosion2,
		range : 450,
	},
	"Weapons Battery" : {
		facing : "front",
		cooldown : 20,
		dam : 18,
		firing_arc : 5,
		explosion_sprite : spr_explosion2,
	},
	"Light Weapons Battery" : {
		facing : "front",
		range : 300,
		cooldown : 30,
		dam : 8,
		firing_arc : 8,
		explosion_sprite : spr_explosion2,
	},
	"Gunz Battery" : {
		facing : "front",
		range : 300,
		cooldown : 30,
		dam : 8,
		firing_arc : 15,
		explosion_sprite : spr_explosion2,
	},
	"Heavy Gunz" : {
		weapon_facing : "front",
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
		bombard_value :1,	
	},

	"Macro Bombardment Cannons" : {
		facing : "front",
		dam : 50,
		range : 600,
		cooldown : 2000,
		firing_arc : 3,	
		bombard_value :2,	
	},

	"Torpedoes" :{
		dam : 12,
		range : 2000, 
		cooldown : 90,
		ammo : 3,
		bullet_speed : 10,
		barrel_count : 1,
		img:spr_torpedo,
		draw_scale : 3,
		bombard_value :1,	
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
		facing : "front",
		dam : 10,
		weapon_range : 800,
		weapon_cooldown : 10,
		img: spr_ground_las,
		explosion_sprite :spr_explosion_plas,
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
		explosion_sprite :spr_explosion3,
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
		facing : "front",
		dam :12,
		range : 450,
		cooldown:30,
		img : spr_railgun,
		explosion_sprite :spr_explosion_plas,
	},
	"Ion Cannons": {
		facing : "front",
		dam :8,
		range : 300,
		cooldown:15,
		img : spr_pulse,
		explosion_sprite :spr_explosion_plas,
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
		explosion_sprite :spr_explosion_plas,
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
			_direct_ += 90;
			break;
		case "left":
			_direct_ -= 90;
			break;
		case "rear":
			_direct_ -= 180;
			break;
		default:
			break;
	}
	if (_direct_ > 360){
		_direct_-=360;
	} else if (_direct_< 0){
		_direct_ +=360;
	}

	return _direct_;
}


function assign_ship_stats(){
	rear_armour = 1;
	shields_recharge_rate = 0.2;
	shields_reboot_time = 20;
	max_speed = 20;
	speed_up = 0.008;
	speed_down = 0.004;
	turning_speed = 0.2;
	if (class="Apocalypse Class Battleship"){
	    sprite_index=spr_ship_apoc;
	    size=3;
	    name="";
	    hp=1200;
	    maxhp=1200;
	    conditions="";
	    shields=400;
	    maxshields=400;
	    leadership=90;
	    armour_front=6;
	    side_armour=5;
	    turrets=4;
	    capacity=150;
	    carrying=0;
	    max_speed = 20;
	    turning_speed = 0.23;
	    add_weapon_to_ship("Lance Battery", {facing:"left"});
	    add_weapon_to_ship("Lance Battery", {facing:"right"});
	    add_weapon_to_ship("Nova Cannon");
	    add_weapon_to_ship("Weapons Battery");
	    
	}

	if (class="Nemesis Class Fleet Carrier"){
		sprite_index=spr_ship_nem;
	    size=3;
	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=400;
	    maxshields=400;
	    leadership=85;
	    armour_front=5;
	    side_armour=5;
	    turrets=5;
	    capacity=100;
	    carrying=24;
	    add_weapon_to_ship("Interceptor Launch Bays");
	    add_weapon_to_ship("Interceptor Launch Bays");
	    add_weapon_to_ship("Lance Battery");
	    max_speed = 20;
	    
	}

	if (class="Avenger Class Grand Cruiser"){
	    sprite_index=spr_ship_aven;
	    size=2;
	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=300;
	    maxshields=300;
	    leadership=85;
	    armour_front=5;
	    side_armour=5;
	    turrets=3;
	    capacity=50;
	    add_weapon_to_ship("Lance Battery", {cooldown:30});
	    add_weapon_to_ship("Lance Battery", {cooldown:25, direction:"left"});
	    add_weapon_to_ship("Lance Battery", {cooldown:25, direction:"right"});
	    
	}

	if (class="Sword Class Frigate"){
	    sprite_index=spr_ship_sword;
	    size=1;
	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=80;
	    armour_front=5;
	    side_armour=5;
	    turrets=2;
	    capacity=50;
	    carrying=0;
	    add_weapon_to_ship("Weapons Battery", {weapon_range:300});
	    
	}



	// Eldar

	if (class="Void Stalker"){
	    sprite_index=spr_ship_void;
	    size=3;
	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=300;
	    maxshields=300;
	    leadership=100;
	    armour_front=5;
	    side_armour=4;
	    turrets=4;
	    capacity=150;

	    add_weapon_to_ship("Weapons Battery");
	    add_weapon_to_ship("Eldar Launch Bay");
	    add_weapon_to_ship("Pulsar Lances");
	    
	}

	if (class="Shadow Class"){
	    sprite_index=spr_ship_shadow;
	    size=3;
	    name="";
	    hp=600;
	    maxhp=600;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=90;
	    armour_front=5;
	    side_armour=4;
	    turrets=3;
	    capacity=100;
	    carrying=0;
	    add_weapon_to_ship("Torpedoes");
	    add_weapon_to_ship("Light Weapons Battery", {range : 450});
	    
	}

	if (class="Hellebore"){
	    sprite_index=spr_ship_hellebore;
	    size=1;
	    name="";
	    hp=200;
	    maxhp=200;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=90;
	    armour_front=5;
	    side_armour=4;
	    turrets=2;
	    capacity=50;
	    carrying=0;

	    add_weapon_to_ship("Light Weapons Battery", {range : 450, cooldown :20, facing : "front"});

	    add_weapon_to_ship("Light Weapons Battery", {range : 450});
	    add_weapon_to_ship("Eldar Launch Bay", {ammo : 1});
	    
	}

	if (class="Aconite"){sprite_index=spr_ship_aconite;
	    sprite_index=spr_ship_aconite;
	    size=1;
	    name="";
	    hp=200;
	    maxhp=200;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=90;
	    armour_front=5;
	    side_armour=4;
	    turrets=2;
	    capacity=50;
	    carrying=0;
	    add_weapon_to_ship("Light Weapons Battery", {range : 450});
	    
	}




	// Orks

	if (class="Dethdeala"){
	    sprite_index=spr_ship_deth;
	    size=3;
	    name="";
	    hp=1200;
	    maxhp=1200;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    armour_front=6;
	    side_armour=5;
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
	    size=3;
	    name="";
	    hp=1200;
	    maxhp=1200;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    armour_front=6;
	    side_armour=5;
	    turrets=3;
	    capacity=250;
	    carrying=0;
	    add_weapon_to_ship("Gunz Battery");
	    add_weapon_to_ship("Torpedoes", {dam:12, range:300, cooldown:120});
	    
	    add_weapon_to_ship("Fighta Bommerz", {ammo : 3});
	    add_weapon_to_ship("Fighta Bommerz", {ammo : 3});
	    
	}

	if (class=="Kroolboy") or (class=="Slamblasta"){
	    size=3;
	    sprite_index=spr_ship_krool;
	    if (class=="Kroolboy"){
	    	sprite_index=spr_ship_krool;
	    } else if (class=="Slamblasta"){
	    	sprite_index=spr_ship_slam;
	    }
	    name="";
	    hp=1200;
	    maxhp=1200;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    armour_front=6;
	    side_armour=5;
	    turrets=3;
	    capacity=250;
	    carrying=0;

	    add_weapon_to_ship("Fighta Bommerz", {ammo : 12, cooldown : 120}); 
	    add_weapon_to_ship("Gunz Battery");
	    add_weapon_to_ship("Heavy Gunz"); 

	}else if (class=="Battlekroozer"){
	    sprite_index=spr_ship_kroozer;
	    size=2;
	    name="";
	    hp=800;
	    maxhp=800;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    armour_front=5;
	    side_armour=5;
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
	    size=1;
	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=80;
	    armour_front=3;
	    side_armour=3;
	    turrets=2;
	    capacity=50;
	    carrying=0;
	    add_weapon_to_ship("Gunz Battery");
	    add_weapon_to_ship("Torpedoes", {range : 300, cooldown:120,barrel_count:2});
	}
	// ** Tau **
	if (class=="Custodian"){
	    sprite_index=spr_ship_custodian;
	    size=3;
	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    armour_front=6;
	    side_armour=5;
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
	    size=2;
	    name="";
	    hp=600;
	    maxhp=600;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=90;
	    armour_front=6;
	    side_armour=5;
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
	    size=2;
	    name="";
	    hp=400;
	    maxhp=400;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=100;
	    armour_front=6;
	    side_armour=5;
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
	    size=1;
	    name="";hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=80;
	    armour_front=5;
	    side_armour=4;
	    turrets=1;
	    capacity=50;
	    carrying=0;
	    add_weapon_to_ship("Ion Cannons", {cooldown:50});
	    add_weapon_to_ship("Railgun Battery", {cooldown:60, range:300});

	}else 
	if (class=="Castellan"){
	    sprite_index=spr_ship_castellan;
	    size=1;
	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=80;
	    armour_front=5;
	    side_armour=4;
	    turrets=2;
	    capacity=50;
	    carrying=0;
	    add_weapon_to_ship("Gravitic launcher");
	    add_weapon_to_ship("Railgun Battery", {cooldown:40, range:300});
	}
	// ** Chaos **
	if (class=="Desecrator"){
	    sprite_index=spr_ship_dese;
	    size=3;
	    name="";
	    hp=1200;
	    maxhp=1200;
	    conditions="";
	    shields=400;
	    maxshields=400;
	    leadership=90;
	    armour_front=7;
	    side_armour=5;
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
	    size=2;
	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=300;
	    maxshields=300;
	    leadership=85;
	    armour_front=5;
	    side_armour=5;
	    turrets=3;
	    capacity=50;
	    carrying=0;
	    add_weapon_to_ship("Lance Battery", {facing : "left"});
	    add_weapon_to_ship("Lance Battery", {facing : "right"});
	    
	}

	if (class="Carnage") or (class="Daemon"){
		sprite_index=spr_ship_carnage;
	    size=2;
	    name="";
	    hp=1000;
	    maxhp=1000;
	    conditions="";
	    shields=300;
	    maxshields=300;
	    leadership=85;
	    armour_front=5;
	    side_armour=5;
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
	    size=1;
	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=80;
	    armour_front=7;
	    side_armour=4;
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
	    size=3;

	    name="";
	    hp=1100;
	    maxhp=1100;
	    conditions="";
	    shields=550;
	    maxshields=550;
	    leadership=100;
	    
	    armour_front=5;
	    side_armour=5;
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
	    size=3;

	    name="";
	    hp=900;
	    maxhp=900;
	    conditions="";
	    shields=450;
	    maxshields=450;
	    leadership=100;
	    
	    armour_front=5;
	    side_armour=5;
	    turrets=4;
	    capacity=500;
	    carrying=0;
	    
	    add_weapon_to_ship("Lightning Arc");
	    add_weapon_to_ship("Star Pulse Generator");
	    add_weapon_to_ship("Gauss Particle Whip");
	     
	}

	if (class="Shroud Class"){size=2;
	    sprite_index=spr_ship_shroud;

	    name="";
	    hp=400;
	    maxhp=400;
	    conditions="";
	    shields=200;
	    maxshields=200;
	    leadership=100;
	    
	    armour_front=5;
	    side_armour=5;
	    turrets=2;
	    capacity=250;
	    carrying=0;
	    
	    add_weapon_to_ship("Lightning Arc", {dam : 10});
	    
	}

	if (class="Jackal Class"){
		size=2;
	    sprite_index=spr_ship_jackal;

	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=100;
	    
	    armour_front=4;
	    side_armour=4;
	    turrets=2;
	    capacity=25;
	    carrying=0;
	    
	    add_weapon_to_ship("Lightning Arc", {dam : 10,range :250});
	    
	}

	if (class="Dirge Class"){
		size=2;
	    sprite_index=spr_ship_dirge;

	    name="";
	    hp=100;
	    maxhp=100;
	    conditions="";
	    shields=100;
	    maxshields=100;
	    leadership=100;
	    
	    armour_front=4;
	    side_armour=4;
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
	shields = new ShipShieldGenerator({shields, maxshields, recharge_rate:shields_recharge_rate, shields_reboot:shields_reboot_time, ship:id});

	// if (obj_fleet.enemy=2){hp=hp*0.75;maxhp=hp;shields=shields*0.75;maxshields=shields;}
	// hp=1;shields=1;
	// if (obj_fleet.enemy="orks") then name=global.name_generator.generate_ork_ship_name();
	// show_message(string(class));


	bridge=maxhp;

	// if (obj_fleet.enemy="orks") then name=global.name_generator.generate_ork_ship_name();

	name="sdagdsagdasg";



	// show_message(string(class));	
}


function draw_ship_heathshields(){
	shields.draw();
	if (maxhp!=0){
	    var zoom_modifier = obj_controller.zoomed?2:1;
	    if (!shields.active()){
	        var hp_percent = $"{(hp/maxhp)*100}%"
	        
	        draw_text_transformed(x,y-sprite_height,hp_percent,zoom_modifier,zoom_modifier,0);
	    }
	}
}
