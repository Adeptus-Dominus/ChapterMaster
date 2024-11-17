function scr_start_allow(role_id, equip_area, equipment) {

	var specialist,allow;
	specialist=0;allow=false;
	if (role_id=2) then specialist=1;
	if (role_id=3) then specialist=1;
	if (role_id=4) then specialist=2;
	if (role_id=5) then specialist=2;
	if (role_id=6) then specialist=2;
	if (role_id>=14) then specialist=2;


	if (specialist>=0){
	    if (equipment="Combat Knife") then allow=true;
	    if (equipment="Chainsword") then allow=true;
	    if (equipment="Chainaxe") then allow=true;
	    if (equipment="Boarding Shield") then allow=true;
	    if (equipment="Bolt Pistol") then allow=true;
	    if (equipment="Bolter") then allow=true;
	    if (equipment="Flamer") then allow=true;
	    if (equipment="Sniper Rifle") then allow=true;
    
	    if (role_id!=8) and (role_id!=9) and (role_id!=4) and (role_id!=6){
	        if (equipment="Jump Pack") then allow=true;
	    }
	}
	if (specialist>=1){
	    if (equipment="Storm Bolter") then allow=true;
	    if (equipment="Meltagun") then allow=true;
	    if (equipment="Power Fist") then allow=true;
	    if (equipment="Power Sword") then allow=true;
	    if (equipment="Power Axe") then allow=true;
	    if (equipment="Narthecium") then allow=true;
    
	    if (role_id!=8) and (role_id!=9) and (role_id!=4) and (role_id!=6){
	        if (equipment="Bike") then allow=true;
	    }
	}
	if (specialist>=2){if (equip_area!="mobi") and (equip_area!="gear") then allow=true;
	    if (equipment="Plasma Gun") then allow=false;
	    if (role_id=14) and (equipment="Rosarius") then allow=true;
	    if (role_id=16) and (equipment="Servo-arm") then allow=true;
		if (role_id=16) and (equipment="Servo-harness") then allow=true;
	    if (role_id=17) and (equipment="Psychic Hood") then allow=true;
	}

	if (allow=true){
	    if (equip_area="wep1") then wep1[101,role_id]=equipment;
	    if (equip_area="wep2") then wep2[101,role_id]=equipment;
	    if (equip_area="gear") then gear[101,role_id]=equipment;
	    if (equip_area="mobi") then mobi[101,role_id]=equipment;
	}


}
